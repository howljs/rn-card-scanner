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
    _recognizer = [[PayCardsRecognizer alloc] initWithDelegate:self recognizerMode:PayCardsRecognizerDataModeNumber | PayCardsRecognizerDataModeDate | PayCardsRecognizerDataModeName resultMode:PayCardsRecognizerResultModeAsync container:self frameColor:[UIColor whiteColor] isShowLayer:true];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_recognizer startCamera];
}

- (void)setFrameColor:(UIColor *)frameColor
{
    if (![frameColor isEqual:_frameColor]) {
        [_recognizer updateFrameColor:frameColor];
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
