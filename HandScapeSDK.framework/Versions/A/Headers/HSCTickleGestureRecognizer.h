//
//  HSCTickleGestureRecognizer.h
//  HandScapeSDK
//
//  Created by John Brewer on 2/13/15.
//  Copyright (c) 2015 HandScape, Inc. All rights reserved.
//

#import <HandScapeSDK/HandScapeSDK.h>

@interface HSCTickleGestureRecognizer : HSCGestureRecognizer

- (void)handleTouch:(HSCTouch*)hscTouch view:(UIView*)view tickleViews:(NSArray*)tickleViews callback:(void (^)(UIView *tickleView))callback;
@end
