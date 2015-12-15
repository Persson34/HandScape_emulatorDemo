//
//  HSCTapGestureRecognizer.h
//  HandScapeSDK
//
//  Created by John Brewer on 12/9/14.
//  Copyright (c) 2014 HandScape, Inc. All rights reserved.
//

#import <HandScapeSDK/HandScapeSDK.h>

@interface HSCTapGestureRecognizer : HSCGestureRecognizer

-(void)handleTouch:(HSCTouch*)touch view:(UIView*)view callback:(void (^)(CGPoint startPoint))callback;

@end
