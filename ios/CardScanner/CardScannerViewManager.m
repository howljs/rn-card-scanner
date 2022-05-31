//
//  CardScannerViewManager.m
//
//  Created by Howl on 01/06/2022.
//  Copyright © 2022 Facebook. All rights reserved.
//

#import "RCTBridgeModule.h"
#import "RCTViewManager.h"

@interface RCT_EXTERN_MODULE(CardScannerViewManager, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(onDidScanCard, RCTDirectEventBlock)

RCT_EXPORT_VIEW_PROPERTY(frameColor, UIColor)

RCT_EXTERN_METHOD(toggleFlash:(nonnull NSNumber *)node)

RCT_EXTERN_METHOD(resetResult:(nonnull NSNumber *)node)

@end
