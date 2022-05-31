//
//  CardScannerView.swift
//
//  Created by Howl on 01/06/2022.
//  Copyright © 2022 Facebook. All rights reserved.
//

@objc(CardScannerViewManager)
class CardScannerViewManager: RCTViewManager {
    
    override static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    override func view() -> UIView {
        return CardScannerView()
    }
    
    @objc func toggleFlash(_ node:NSNumber) {
        DispatchQueue.main.async {
            let view = self.bridge.uiManager.view(forReactTag: node) as! CardScannerView
            view.toggleFlash()
        }
    }
    
    @objc func resetResult(_ node:NSNumber) {
        DispatchQueue.main.async {
            let view = self.bridge.uiManager.view(forReactTag: node) as! CardScannerView
            view.resetResult()
        }
    }
}

class CardScannerView : UIView, PayCardsRecognizerPlatformDelegate {
    private let defaultColor = UIColor(hue: 0.5861, saturation: 1, brightness: 0.99, alpha: 1.0)
    
    private var recognizer : PayCardsRecognizer!
    
    @objc var onDidScanCard: RCTDirectEventBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        recognizer = PayCardsRecognizer(delegate: self, recognizerMode: [.number, .date, .name], resultMode: .async, container: self, frameColor: defaultColor, isShowLayer: true)
    }
    
    @objc func setFrameColor(_ val: UIColor?) {
        recognizer.updateFrameColor(val ?? defaultColor)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        recognizer.startCamera()
    }
    
    @objc func payCardsRecognizer(_ payCardsRecognizer: PayCardsRecognizer, didRecognize result: PayCardsRecognizerResult) {
        if result.isCompleted {
            if self.onDidScanCard != nil {
                self.onDidScanCard!(["cardNumber": result.recognizedNumber ?? "", "expiryMonth": result.recognizedExpireDateMonth ?? "","expiryYear": result.recognizedExpireDateYear ?? "", "holderName": result.recognizedHolderName ?? "", ])
            }
        }
    }
    
    public func toggleFlash() {
        recognizer.toggleFlash()
    }
    
    public func resetResult() {
        recognizer.resetResult()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError( "init(coder:) has not been implemented" )
    }
    
}
