//
//  CardScannerView.swift
//
//  Created by Howl on 01/06/2022.
//  Copyright © 2022 Facebook. All rights reserved.
//

import Foundation
import UIKit
import PayCardsRecognizer

@objc(CardScannerView)
class CardScannerView : UIView, PayCardsRecognizerPlatformDelegate {
    private var recognizer : PayCardsRecognizer!
    
    @objc var onDidScanCard: RCTDirectEventBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        recognizer = PayCardsRecognizer(delegate: self, recognizerMode: [.number, .date, .name], resultMode: .async, container: self, frameColor: UIColor(hexString: "#007aff"), isShowLayer: true)
    }
    
    @objc func setFrameColor(_ colorValue: String?) {
        recognizer.updateFrameColor(UIColor(hexString: colorValue ?? "#007aff"))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        recognizer.startCamera()
    }
    
    @objc func payCardsRecognizer(_ payCardsRecognizer: PayCardsRecognizer, didRecognize result: PayCardsRecognizerResult) {
        if result.isCompleted && onDidScanCard != nil {
            let cardData: [AnyHashable: Any] = [
                "cardNumber": result.recognizedNumber ?? "",
                "expiryMonth": result.recognizedExpireDateMonth ?? "",
                "expiryYear": result.recognizedExpireDateYear ?? "",
                "holderName": result.recognizedHolderName ?? ""
            ]
            onDidScanCard!(cardData)
        }
    }
    
    public func toggleFlash() {
        recognizer.toggleFlash()
    }
    
    public func resetResult() {
        recognizer.resetResult()
    }
    
    public func startCamera() {
        recognizer.startCamera()
    }
    
    public func stopCamera() {
        recognizer.stopCamera()
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        let isVisible = (self.superview != nil) && (self.window != nil)
        if(!isVisible) {
            recognizer.stopCamera()
        }
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError( "init(coder:) has not been implemented" )
    }
    
}
