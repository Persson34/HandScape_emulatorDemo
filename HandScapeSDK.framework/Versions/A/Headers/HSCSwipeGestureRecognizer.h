//
//  HSCSwipeGestureRecoginzer.h
//  HandScapeSDK
//
//  Created by John Brewer on 12/8/14.
//  Copyright (c) 2014 HandScape, Inc. All rights reserved.
//

#import <HandScapeSDK/HandScapeSDK.h>

typedef enum {
    HSC_SwipeDirectionRight,
    HSC_SwipeDirectionLeft,
    HSC_SwipeDirectionUp,
    HSC_SwipeDirectionDown
} HSCSwipeDirection;

@interface HSCSwipeGestureRecognizer : HSCGestureRecognizer

-(void)handleTouch:(HSCTouch*)touch view:(UIView*)view callback:(void (^)(HSCGestureState state))callback;

-(instancetype)initWithDirection:(HSCSwipeDirection)direction;

@end
