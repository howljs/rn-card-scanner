//
//  CardScannerView.m
//  CardScanner
//
//  Created by Howl on 01/06/2022.
//  Copyright © 2022 Facebook. All rights reserved.
//

#import "CardScannerView.h"

@implementation CardScannerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"CardScannerView was initialized in init with Frame");
        [self initializeRecognizer];
    }
    return self;
}

- (void) initializeRecognizer {
    UIColor *defaultColor = [UIColor colorWithRed: 0.00 green: 0.48 blue: 1.00 alpha: 1.00];
    _recognizer = [[PayCardsRecognizer alloc] initWithDelegate:self recognizerMode:PayCardsRecognizerDataModeNumber | PayCardsRecognizerDataModeDate | PayCardsRecognizerDataModeName resultMode:PayCardsRecognizerResultModeAsync container:self frameColor:defaultColor isShowLayer:true];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_recognizer startCamera];
}

- (void)setFrameColor:(UIColor *)frameColor
{
    if (frameColor != nil) {
        const CGFloat *components = CGColorGetComponents(frameColor.CGColor);
        CGFloat r = components[1];
        CGFloat g = components[2];
        CGFloat b = components[3];
        CGFloat a = components[0];
        UIColor *convertedColor = [UIColor colorWithRed:r green:g blue:b alpha:a];
        [_recognizer updateFrameColor:convertedColor];
    }else {
        [_recognizer updateFrameColor:[UIColor colorWithRed: 0.00 green: 0.48 blue: 1.00 alpha: 1.00]];
    }
}

- (void)toggleFlash {
    [_recognizer toggleFlash];
}

- (void)resetResult {
    [_recognizer resetResult];
}

#pragma mark PayCardsRecognizerPlatformDelegate

- (void)payCardsRecognizer:(PayCardsRecognizer * _Nonnull)payCardsRecognizer didRecognize:(PayCardsRecognizerResult * _Nonnull)result {
    if(result.isCompleted && self.onDidScanCard) {
        self.onDidScanCard(@{
            @"cardNumber": result.recognizedNumber ?: @"",
            @"expiryMonth": result.recognizedExpireDateMonth ?: @"",
            @"expiryYear": result.recognizedExpireDateYear ?: @"",
            @"holderName": result.recognizedHolderName ?: @"",
        });
    }
}

@end
