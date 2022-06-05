//
//  CardScannerVision.swift
//  CardScanner
//
//  Created by Howl on 04/06/2022.
//  Copyright © 2022 Facebook. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

@objc(CardScannerVision)
@available(iOS 13, *)
class CardScannerVision : UIView, CameraViewDelegate {
    private var cameraViewMaskLayerColor: UIColor = .black
    private var cameraViewMaskAlpha: CGFloat = 0.6
    
    private lazy var cameraView: CameraView = CameraView(
        delegate: self,
        maskLayerColor: self.cameraViewMaskLayerColor,
        maskLayerAlpha: self.cameraViewMaskAlpha
    )
    
    /// Analyzes text data for credit card info
    private lazy var analyzer = ImageAnalyzer(delegate: self)
    
    @objc var onDidScanCard: RCTDirectEventBlock?
    
    @objc var frameColor: String = "#007aff" {
        didSet {
            print(UIColor(hexString: frameColor))
            frameImageView.tintColor = UIColor(hexString: frameColor)
        }
    }
    
    let frameImageView: UIImageView = {
        let theImageView = UIImageView()
        theImageView.contentMode = .center
        return theImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(cameraView)
        self.addSubview(frameImageView)
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        let isVisible = (self.superview != nil) && (self.window != nil)
        if(isVisible) {
            AVCaptureDevice.authorize { [weak self] authoriazed in
                guard let strongSelf = self else {
                    return
                }
                guard authoriazed else {
                    return
                }
                strongSelf.cameraView.setupCamera()
            }
        }else {
            self.cameraView.stopSession()
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cameraView.frame = self.bounds
        cameraView.setupRegionOfInterest()
        frameImageView.frame = self.bounds
        let bundle = Bundle(path: Bundle.main.path(forResource: "PortraitFrame", ofType: "bundle")!)
        let portraitFrame = UIImage(named: "PortraitFrame",
                                    in: bundle,
                                    compatibleWith: nil)
        let cuttedWidth: CGFloat = self.bounds.width - 35.0
        let cuttedHeight: CGFloat = cuttedWidth * CreditCard.heightRatioAgainstWidth
        let newImageSize = CGSize(width: cuttedWidth, height: cuttedHeight)
        frameImageView.image = portraitFrame?.resizeImageTo(size: newImageSize)?.withRenderingMode(.alwaysTemplate)
    }
    
    public func toggleFlash() {
        self.cameraView.toggleFlash()
    }
    
    public func resetResult() {
        self.cameraView.stopSession()
        self.cameraView.startSession()
    }
    
    public func stopCamera() {
        self.cameraView.stopSession()
    }
    
    public func startCamera() {
        if(self.cameraView.isRunning()){
            return;
        }
        self.cameraView.startSession()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError( "init(coder:) has not been implemented" )
    }
    
}

@available(iOS 13, *)
extension CardScannerVision: CameraViewDelegate {
    internal func didCapture(image: CGImage) {
        analyzer.analyze(image: image)
    }
    
    internal func didError(with error: CreditCardScannerError) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.cameraView.stopSession()
        }
    }
}

@available(iOS 13, *)
extension CardScannerVision: ImageAnalyzerProtocol {
    internal func didFinishAnalyzation(with result: Result<CreditCard, CreditCardScannerError>) {
        switch result {
        case let .success(creditCard):
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.cameraView.stopSession()
                if((strongSelf.onDidScanCard) != nil) {
                    var yearStr = ""
                    var monthStr = ""
                    if(creditCard.expireDate != nil) {
                        let date = Calendar.current.date(from: creditCard.expireDate!)
                        let formatter = DateFormatter()
                        formatter.dateFormat = "MM"
                        monthStr = formatter.string(from: date!)
                        formatter.dateFormat = "yy"
                        yearStr = formatter.string(from: date!)
                    }
                    let cardData: [AnyHashable: Any] = [
                        "cardNumber": creditCard.number ?? "",
                        "expiryMonth":monthStr,
                        "expiryYear": yearStr,
                        "holderName": creditCard.name ?? ""
                    ]
                    strongSelf.onDidScanCard!(cardData)
                }
            }
            
        case .failure(_):
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.cameraView.stopSession()
            }
        }
    }
}

@available(iOS 13, *)
extension AVCaptureDevice {
    static func authorize(authorizedHandler: @escaping ((Bool) -> Void)) {
        let mainThreadHandler: ((Bool) -> Void) = { isAuthorized in
            DispatchQueue.main.async {
                authorizedHandler(isAuthorized)
            }
        }
        
        switch authorizationStatus(for: .video) {
        case .authorized:
            mainThreadHandler(true)
        case .notDetermined:
            requestAccess(for: .video, completionHandler: { granted in
                mainThreadHandler(granted)
            })
        default:
            mainThreadHandler(false)
        }
    }
}

extension UIImage {
    func resizeImageTo(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
}
