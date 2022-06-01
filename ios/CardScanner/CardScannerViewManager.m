//
//  CardScannerViewManager.m
//  CardScanner
//
//  Created by Howl on 01/06/2022.
//  Copyright © 2022 Facebook. All rights reserved.
//

#import "React/RCTUIManager.h"
#import "React/RCTLog.h"
#import "CardScannerViewManager.h"
#import "CardScannerView.h"

@implementation CardScannerViewManager

RCT_EXPORT_MODULE(CardScannerView);

- (UIView *)view
{
    return [[CardScannerView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

RCT_EXPORT_METHOD(toggleFlash: (nonnull NSNumber *)viewTag)
{
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, CardScannerView *> *viewRegistry) {
        CardScannerView *view = viewRegistry[viewTag];
        [view toggleFlash];
    }];
}

RCT_EXPORT_METHOD(resetResult: (nonnull NSNumber *)viewTag)
{
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, CardScannerView *> *viewRegistry) {
        CardScannerView *view = viewRegistry[viewTag];
        [view resetResult];
    }];
}

RCT_EXPORT_VIEW_PROPERTY(frameColor, UIColor);

RCT_EXPORT_VIEW_PROPERTY(onDidScanCard, RCTBubblingEventBlock)

+ (BOOL)requiresMainQueueSetup {
    return YES;
}

@end
