//
//  CardScannerViewManager.h
//  CardScanner
//
//  Created by Howl on 01/06/2022.
//  Copyright © 2022 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTViewManager.h>

@interface RCT_EXTERN_MODULE(CardScannerViewManager, RCTViewManager)
RCT_EXPORT_VIEW_PROPERTY(onDidScanCard, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(frameColor, NSString)
RCT_EXTERN_METHOD(stopScanCard:(nonnull NSNumber *) reactTag)
RCT_EXTERN_METHOD(startScanCard:(nonnull NSNumber *) reactTag)
RCT_EXTERN_METHOD(toggleFlash:(nonnull NSNumber *) reactTag)
RCT_EXTERN_METHOD(resetResult:(nonnull NSNumber *) reactTag)
@end
