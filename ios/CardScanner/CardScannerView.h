//
//  CardScannerView.h
//  CardScanner
//
//  Created by Howl on 01/06/2022.
//  Copyright © 2022 Facebook. All rights reserved.
//

#import <React/RCTView.h>
#import "UIKit/UIKit.h"
#import "UIView+React.h"
#import "PayCardsRecognizer/PayCardsRecognizer.h"

@interface CardScannerView : UIView<PayCardsRecognizerPlatformDelegate>

@property (nonatomic, weak) id<PayCardsRecognizerPlatformDelegate> delegate;

@property (nonatomic, strong) PayCardsRecognizer *recognizer;

@property (nonatomic, assign) UIColor *frameColor;

@property (nonatomic, copy) RCTBubblingEventBlock onDidScanCard;

- (void)toggleFlash;

- (void)resetResult;

@end

