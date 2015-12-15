//
//  HSCHandBaseView.h
//  HandScapeSDK
//
//  Created by Olie on 7/17/14.
//  Copyright (c) 2014 HandScape, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HSCTouch.h"


@interface HSCHandBaseView : UIView

#define HSC_THUMB_RESTING_ROTATION_DEGREES       55
#define HSC_THUMB_RESTING_ROTATION_RADIANS       (HSC_THUMB_RESTING_ROTATION_DEGREES * M_PI / 180.)

enum {
    hscFingerThumb = 0,
    hscFingerIndex,
    hscFingerMiddle,
    hscFingerRing,
    hscFingerPinky,
    hscFingerCount
};

@property(readwrite, nonatomic) float rotation;                                 // radians
@property(readwrite, nonatomic) float scale;

@end
