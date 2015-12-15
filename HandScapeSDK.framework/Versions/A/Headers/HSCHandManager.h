//
//  HSCHandManager.h
//  HandScapeSDK
//
//  Created by Olie on 7/23/14.
//  Copyright (c) 2014 HandScape, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HSCHandView.h"
#import "HSCTouchpad.h"



#define HAND_SCALE      4.


@interface HSCHandManager : NSObject

@property(readwrite, nonatomic) BOOL autoRelax;
@property(readwrite, nonatomic) BOOL autoRotate;
@property(readwrite, nonatomic) BOOL autoScale;
@property(strong, nonatomic) HSCTouchpad *device;
@property(strong, nonatomic) HSCHandView *leftHand;
@property(strong, nonatomic) HSCHandView *rightHand;
@property(weak, nonatomic) UIView *view;

- (void) relaxBothHands;
- (void) relaxHand: (HSCHandView*) hand;
- (void) setFingersPerTouches: (NSDictionary*) allTouches;

@end
