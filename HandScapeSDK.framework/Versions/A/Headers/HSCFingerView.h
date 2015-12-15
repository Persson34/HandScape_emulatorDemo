//
//  HSCFingerView.h
//  HandScapeSDK
//
//  Created by Olie on 7/16/14.
//  Copyright (c) 2014 HandScape, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HSCHandView.h"


@interface HSCFingerView : HSCHandBaseView

@property(readonly, nonatomic) BOOL isLeft;
@property(readwrite, nonatomic) BOOL showBack;
@property(readonly, nonatomic) CGSize size;
@property(readwrite, nonatomic) CGPoint touchPoint;
@property(strong, readonly, nonatomic) UIView *touchView;

+ (HSCFingerView*) fingerViewWithName: (NSString*) name onHand: (HSCHandView*) hand;

- (id)initWithName: (NSString*) name onHand: (HSCHandView*) hand;

- (CGPoint) currentFingertipLocation;
- (BOOL) inUse;

@end
