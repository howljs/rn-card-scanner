//
//  CardScannerModule.swift
//
//  Created by Howl on 01/06/2022.
//  Copyright © 2022 Facebook. All rights reserved.
//
import AVFoundation

@objc(CardScanner)
class CardScanner: NSObject {
    
    @objc func requestPermission(_ resolve: @escaping RCTPromiseResolveBlock,
                                 rejecter reject: @escaping RCTPromiseRejectBlock ) -> Void {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            resolve(["status": "granted"])
            return
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                resolve(["status": granted ? "granted" : "blocked"])
            }
            
        case .denied, .restricted:
            resolve(["status": "blocked"])
            return

        @unknown default:
            resolve(["status": "unavailable"])
            return
        }
    }
    
    
    @objc
    static func requiresMainQueueSetup() -> Bool {
        return true
    }
}
