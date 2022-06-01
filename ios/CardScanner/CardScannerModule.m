//
//  CardScannerModule.m
//  CardScanner
//
//  Created by Howl on 01/06/2022.
//  Copyright © 2022 Facebook. All rights reserved.
//

#import "CardScannerModule.h"
#import "AVFoundation/AVFoundation.h"

@implementation CardScanner

RCT_EXPORT_MODULE(CardScanner);

RCT_EXPORT_METHOD(requestPermission:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusNotDetermined)
    {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                resolve(@{@"status": @"granted"});
            } else {
                resolve(@{@"status": @"blocked"});
            }
        }];
    }
    else if(authStatus == AVAuthorizationStatusDenied)
    {
        resolve(@{@"status": @"blocked"});
    }
    else
    {
        resolve(@{@"status": @"granted"});
    }
}

@end
