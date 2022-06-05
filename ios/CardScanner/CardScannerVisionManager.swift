//
//  CardScannerVisionManager.swift
//  CardScanner
//
//  Created by Howl on 04/06/2022.
//  Copyright © 2022 Facebook. All rights reserved.
//

import Foundation

@objc(CardScannerVisionManager)
class CardScannerVisionManager: RCTViewManager {

    override func view() -> UIView! {
        if #available(iOS 13.0, *) {
            return CardScannerVision(frame: CGRect.init())
        } else {
            return UIView(frame: CGRect.init())
        }
    }
    
    @objc func toggleFlash(_ reactTag: NSNumber) {
        self.bridge!.uiManager.addUIBlock { (_: RCTUIManager?, viewRegistry: [NSNumber: UIView]?) in
            if #available(iOS 13, *) {
                let view = viewRegistry![reactTag] as! CardScannerVision
                view.toggleFlash()
            }
        }
    }
    
    @objc func resetResult(_ reactTag: NSNumber) {
        self.bridge!.uiManager.addUIBlock { (_: RCTUIManager?, viewRegistry: [NSNumber: UIView]?) in
            if #available(iOS 13, *) {
                let view = viewRegistry![reactTag] as! CardScannerVision
                view.resetResult()
            }
        }
    }
    
    @objc func startScanCard(_ reactTag: NSNumber) {
        self.bridge!.uiManager.addUIBlock { (_: RCTUIManager?, viewRegistry: [NSNumber: UIView]?) in
            if #available(iOS 13, *) {
                let view = viewRegistry![reactTag] as! CardScannerVision
                view.startCamera()
            }
        }
    }
    
    @objc func stopScanCard(_ reactTag: NSNumber) {
        self.bridge!.uiManager.addUIBlock { (_: RCTUIManager?, viewRegistry: [NSNumber: UIView]?) in
            if #available(iOS 13, *) {
                let view = viewRegistry![reactTag] as! CardScannerVision
                view.stopCamera()
            }
        }
    }
    
    override static func requiresMainQueueSetup() -> Bool {
        return true
    }
}
