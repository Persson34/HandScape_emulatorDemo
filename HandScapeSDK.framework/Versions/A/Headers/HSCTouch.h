//
//  HSCTouch.h
//  HandScapeTest
//
//  Created by Olie on 7/2/14.
//  Copyright (c) 2014 HandScape, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HSCEvent.h"
#import "HSCTouchpad.h"


@interface HSCTouch : HSCEvent

#define HSC_TOUCH_HOVER_POINT                    CGPointMake(-1, -1)

enum {
    hscTouchStateBegan       = 0,
    hscTouchStateMoved       = 1,
    hscTouchStateEnded       = 2,

    // beyond HandScape
    hscTouchStateStationary  = 1000,
    hscTouchStateCancelled
};

@property(readonly) CGPoint beganPoint;
@property(strong, readonly, nonatomic) HSCTouchpad *device;
@property(readonly) int force;
@property(readonly) BOOL isActive;                                              // vice "hovering"
@property(strong, nonatomic, readonly) NSString *key;
@property(readonly) CGPoint rawPoint;
@property(readonly, nonatomic) int state;
@property(readonly) int tapCount;
@property(readonly) NSTimeInterval timeBegan;
@property(readonly) NSTimeInterval timestamp;                                   // uptime-based (like UITouch.)
@property(readonly) int touchID;
@property(readonly) double angle;
@property(readonly) double magnitude;

+ (HSCTouch*) hscTouchFromUITouch: (UITouch*) uiTouch;

- (void) cancelTouch;
- (CGPoint) locationInView: (UIView*) view;

@end
