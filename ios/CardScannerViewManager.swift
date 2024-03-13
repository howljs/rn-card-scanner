//
//  CardScannerViewManager.swift
//  CardScanner
//
//  Created by Howl on 04/06/2022.
//  Copyright © 2022 Facebook. All rights reserved.
//
import Foundation

@objc(CardScannerViewManager)
class CardScannerViewManager: RCTViewManager {

    override func view() -> UIView! {
        return CardScannerView(frame: CGRect.init())
    }
    
    @objc func toggleFlash(_ reactTag: NSNumber) {
        self.bridge!.uiManager.addUIBlock { (_: RCTUIManager?, viewRegistry: [NSNumber: UIView]?) in
            let view: CardScannerView = (viewRegistry![reactTag] as? CardScannerView)!
            view.toggleFlash()
        }
    }
    
    @objc func resetResult(_ reactTag: NSNumber) {
        self.bridge!.uiManager.addUIBlock { (_: RCTUIManager?, viewRegistry: [NSNumber: UIView]?) in
            let view: CardScannerView = (viewRegistry![reactTag] as? CardScannerView)!
            view.resetResult()
        }
    }
    
    @objc func startScanCard(_ reactTag: NSNumber) {
        self.bridge!.uiManager.addUIBlock { (_: RCTUIManager?, viewRegistry: [NSNumber: UIView]?) in
            let view: CardScannerView = (viewRegistry![reactTag] as? CardScannerView)!
            view.startCamera()
        }
    }
    
    @objc func stopScanCard(_ reactTag: NSNumber) {
        self.bridge!.uiManager.addUIBlock { (_: RCTUIManager?, viewRegistry: [NSNumber: UIView]?) in
            let view: CardScannerView = (viewRegistry![reactTag] as? CardScannerView)!
            view.stopCamera()
        }
    }
    
    override static func requiresMainQueueSetup() -> Bool {
        return true
    }
}
