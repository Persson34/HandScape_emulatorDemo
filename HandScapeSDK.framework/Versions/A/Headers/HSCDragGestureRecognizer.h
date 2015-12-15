//
//  HSCDragGestureRecognizer.h
//  HandScapeSDK
//
//  Created by John Brewer on 12/5/14.
//  Copyright (c) 2014 HandScape, Inc. All rights reserved.
//

#import "HSCTouch.h"
#import "HSCGestureRecognizer.h"

@interface HSCDragGestureRecognizer : HSCGestureRecognizer

-(void)handleTouch:(HSCTouch*)touch view:(UIView*)view callback:(void (^)(HSCGestureState state, CGPoint change))callback;

@end
