//
//  CardScannerModule.h
//  CardScanner
//
//  Created by Howl on 01/06/2022.
//  Copyright © 2022 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCTBridgeModule.h"

@interface RCT_EXTERN_MODULE(CardScanner, NSObject)

RCT_EXTERN_METHOD(requestPermission: (RCTPromiseResolveBlock)resolve
                                  rejecter:(RCTPromiseRejectBlock)reject)

@end
