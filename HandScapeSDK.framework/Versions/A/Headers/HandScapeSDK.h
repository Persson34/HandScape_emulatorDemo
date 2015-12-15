//
//  HandScapeSDK.h
//  HandScapeSDK
//
//  Created by Olie on 7/3/14.
//  Copyright (c) 2014 HandScape, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "HSCEvent.h"
#import "HSCTouchpad.h"
#import "HSCTouchpadSim.h"
#import "HSCTouchpadManager.h"
#import "HSCTouch.h"
#import "HSCUtils.h"
#import "HSCHandsView.h"
#import "HSCGestureRecognizer.h"
#import "HSCPinchGestureRecognizer.h"
#import "HSCDragGestureRecognizer.h"
#import "HSCSwipeGestureRecognizer.h"
#import "HSCTapGestureRecognizer.h"

@interface HandScapeSDK : NSObject

+ (NSString*) longVersion;
+ (NSString*) version;

@end
