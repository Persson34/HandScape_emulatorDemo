//
//  HSCPinchGestureRecognizer.h
//  HandScapeSDK
//
//  Created by John Brewer on 12/1/14.
//  Copyright (c) 2014 HandScape, Inc. All rights reserved.
//

#import "HSCTouch.h"
#import "HSCGestureRecognizer.h"

@interface HSCPinchGestureRecognizer : HSCGestureRecognizer

-(void)handleTouch:(HSCTouch*)touch view:(UIView*)view callback:(void (^)(HSCGestureState state, CGFloat change))callback;

@end
