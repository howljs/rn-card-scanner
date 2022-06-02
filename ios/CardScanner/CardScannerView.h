//
//  CardScannerView.h
//  CardScanner
//
//  Created by Howl on 01/06/2022.
//  Copyright © 2022 Facebook. All rights reserved.
//

#import <React/RCTView.h>
#import <React/UIView+React.h>
#import <UIKit/UIKit.h>
#import <PayCardsRecognizer/PayCardsRecognizer.h>

@interface CardScannerView : RCTView<PayCardsRecognizerPlatformDelegate>

@property (nonatomic, weak) id<PayCardsRecognizerPlatformDelegate> delegate;

@property (nonatomic, strong) PayCardsRecognizer *recognizer;

@property (nonatomic, copy) RCTBubblingEventBlock onDidScanCard;

- (void)toggleFlash;

- (void)resetResult;

@end

