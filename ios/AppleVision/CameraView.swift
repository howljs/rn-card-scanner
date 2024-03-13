//
//  CameraView.swift
//  CreditCardScannerPackageDescription
//
//  Created by josh on 2020/07/23.
//
#if canImport(UIKit)
#if canImport(AVFoundation)

import AVFoundation
import UIKit
import VideoToolbox

protocol CameraViewDelegate: AnyObject {
    func didCapture(image: CGImage)
    func didError(with: CreditCardScannerError)
}

@available(iOS 13, *)
final class CameraView: UIView {
    weak var delegate: CameraViewDelegate?
    private let maskLayerColor: UIColor
    private let maskLayerAlpha: CGFloat
    private var currentLayer: CALayer!
    private var vDevice: AVCaptureDevice!
    
    // MARK: - Capture related
    
    private let captureSessionQueue = DispatchQueue(
        label: "com.yhkaplan.credit-card-scanner.captureSessionQueue"
    )
    
    // MARK: - Capture related
    
    private let sampleBufferQueue = DispatchQueue(
        label: "com.yhkaplan.credit-card-scanner.sampleBufferQueue"
    )
    
    init(
        delegate: CameraViewDelegate,
        maskLayerColor: UIColor,
        maskLayerAlpha: CGFloat
    ) {
        self.delegate = delegate
        self.maskLayerColor = maskLayerColor
        self.maskLayerAlpha = maskLayerAlpha
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let imageRatio: ImageRatio = .vga640x480
    
    // MARK: - Region of interest and text orientation
    
    /// Region of video data output buffer that recognition should be run on.
    /// Gets recalculated once the bounds of the preview layer are known.
    private var regionOfInterest: CGRect?
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        guard let layer = layer as? AVCaptureVideoPreviewLayer else {
            fatalError("Expected `AVCaptureVideoPreviewLayer` type for layer. Check PreviewView.layerClass implementation.")
        }
        
        return layer
    }
    
    private var videoSession: AVCaptureSession? {
        get {
            videoPreviewLayer.session
        }
        set {
            videoPreviewLayer.session = newValue
        }
    }
    
    let semaphore = DispatchSemaphore(value: 1)
    
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }
    
    func stopSession() {
        setTorchOn(mode: .off)
        videoSession?.stopRunning()
    }
    
    func startSession() {
        videoSession?.startRunning()
    }
    
    func isRunning() -> Bool {
        return videoSession?.isRunning ?? false
    }
    
    func setupCamera() {
        captureSessionQueue.async { [weak self] in
            self?._setupCamera()
        }
    }
    
    func setTorchOn(mode: AVCaptureDevice.TorchMode) {
        if(vDevice.hasTorch && vDevice.hasFlash) {
            do {
                try vDevice.lockForConfiguration()
                vDevice.torchMode = mode
                vDevice.unlockForConfiguration()
            } catch {
            }
        }
    }
    
    func toggleFlash() {
        if(vDevice.hasTorch && vDevice.hasFlash) {
            do {
                try vDevice.lockForConfiguration()
                if(vDevice.torchMode == .on) {
                    vDevice.torchMode = .off
                }else {
                    vDevice.torchMode = .on
                }
                vDevice.unlockForConfiguration()
            } catch {
            }
        }
    }
    
    private func _setupCamera() {
        let session = AVCaptureSession()
        session.beginConfiguration()
        session.sessionPreset = imageRatio.preset
        
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                        for: .video,
                                                        position: .back) else {
            delegate?.didError(with: CreditCardScannerError(kind: .cameraSetup))
            return
        }
        vDevice = videoDevice
        try? videoDevice.lockForConfiguration()
        if videoDevice.isAutoFocusRangeRestrictionSupported {
            videoDevice.autoFocusRangeRestriction = .near
        }
        if videoDevice.isFocusModeSupported(.continuousAutoFocus) {
            videoDevice.focusMode = .continuousAutoFocus
        }
        if videoDevice.isFocusPointOfInterestSupported {
            videoDevice.focusPointOfInterest = CGPoint(x: 0.5, y: 0.5)
        }
        if videoDevice.isExposureModeSupported(.continuousAutoExposure) {
            videoDevice.exposureMode = .continuousAutoExposure
        }
        if videoDevice.isLowLightBoostSupported {
            videoDevice.automaticallyEnablesLowLightBoostWhenAvailable = true
        }
        if videoDevice.isTorchModeSupported(.auto) {
            videoDevice.torchMode = .auto
        }
        videoDevice.unlockForConfiguration()
        do {
            let deviceInput = try AVCaptureDeviceInput(device: videoDevice)
            session.canAddInput(deviceInput)
            session.addInput(deviceInput)
        } catch {
            delegate?.didError(with: CreditCardScannerError(kind: .cameraSetup, underlyingError: error))
        }
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.setSampleBufferDelegate(self, queue: sampleBufferQueue)
        
        guard session.canAddOutput(videoOutput) else {
            delegate?.didError(with: CreditCardScannerError(kind: .cameraSetup))
            return
        }
        session.addOutput(videoOutput)
        session.connections.forEach {
            $0.videoOrientation = .portrait
        }
        session.commitConfiguration()
        
        DispatchQueue.main.async { [weak self] in
            self?.videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            self?.videoSession = session
            self?.startSession()
        }
    }
    
    func setupRegionOfInterest() {
        
        /// Mask layer that covering area around camera view
        let backLayer = CALayer()
        backLayer.frame = bounds
        backLayer.backgroundColor = maskLayerColor.withAlphaComponent(maskLayerAlpha).cgColor
        
        //  culcurate cutoutted frame
        let cuttedWidth: CGFloat = bounds.width - 40.0
        let cuttedHeight: CGFloat = cuttedWidth * CreditCard.heightRatioAgainstWidth
        
        let centerVertical = (bounds.height / 2.0)
        let cuttedY: CGFloat = centerVertical - (cuttedHeight / 2.0)
        let cuttedX: CGFloat = 20.0
        
        let cuttedRect = CGRect(x: cuttedX,
                                y: cuttedY,
                                width: cuttedWidth,
                                height: cuttedHeight)
        
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath(roundedRect: cuttedRect, cornerRadius: 12.0)
        
        path.append(UIBezierPath(rect: bounds))
        maskLayer.path = path.cgPath
        maskLayer.fillRule = .evenOdd
        backLayer.mask = maskLayer
        if(currentLayer == nil) {
            layer.addSublayer(backLayer)
        }else {
            layer.replaceSublayer(currentLayer, with: backLayer)
        }
        currentLayer = backLayer
        
        let imageHeight: CGFloat = imageRatio.imageHeight
        let imageWidth: CGFloat = imageRatio.imageWidth
        
        let acutualImageRatioAgainstVisibleSize = imageWidth / bounds.width
        let interestX = cuttedRect.origin.x * acutualImageRatioAgainstVisibleSize
        let interestWidth = cuttedRect.width * acutualImageRatioAgainstVisibleSize
        let interestHeight = interestWidth * CreditCard.heightRatioAgainstWidth
        let interestY = (imageHeight / 2.0) - (interestHeight / 2.0)
        regionOfInterest = CGRect(x: interestX,
                                  y: interestY,
                                  width: interestWidth,
                                  height: interestHeight)
    }
}

@available(iOS 13, *)
extension CameraView: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        semaphore.wait()
        defer { semaphore.signal() }
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            delegate?.didError(with: CreditCardScannerError(kind: .capture))
            delegate = nil
            return
        }
        
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(pixelBuffer, options: nil, imageOut: &cgImage)
        
        guard let regionOfInterest = regionOfInterest else {
            return
        }
        
        guard let fullCameraImage = cgImage,
              let croppedImage = fullCameraImage.cropping(to: regionOfInterest) else {
            delegate?.didError(with: CreditCardScannerError(kind: .capture))
            delegate = nil
            return
        }
        
        delegate?.didCapture(image: croppedImage)
    }
}
#endif
#endif

extension CreditCard {
    // The aspect ratio of credit-card is Golden-ratio
    static let heightRatioAgainstWidth: CGFloat = 0.6328358209 //0.6180469716
}
