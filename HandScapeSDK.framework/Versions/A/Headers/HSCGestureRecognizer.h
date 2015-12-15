//
//  HSCGestureRecognizer.h
//  HandScapeSDK
//
//  Created by John Brewer on 12/5/14.
//  Copyright (c) 2014 HandScape, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HSCTouch.h"

#define HSC_LEFT_SIDE 1
#define HSC_RIGHT_SIDE 2

typedef enum {
    HSC_GESTURE_STATE_BEGAN = 0,
    HSC_GESTURE_STATE_CHANGED = 1,
    HSC_GESTURE_STATE_ENDED = 2,
    HSC_GESTURE_STATE_CANCELLED = 3
} HSCGestureState;

@interface HSCGestureRecognizer : NSObject

// for subclasses only

@property (nonatomic, strong) NSMutableDictionary *activeTouches;
@property (nonatomic, strong) NSMutableArray *leftTouches;
@property (nonatomic, strong) NSMutableArray *rightTouches;

-(void)updateActiveTouchesWithTouch:(HSCTouch*)touch;
-(void)separateHandsInView:(UIView*)view;
-(CGPoint)leftFingerAverageInView:(UIView*)view;
-(CGPoint)rightFingerAverageInView:(UIView*)view;

@end
