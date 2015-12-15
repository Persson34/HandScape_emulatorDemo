//
//  HSCEventManager.h
//  HandScapeSDK
//
//  Created by Olie on 7/29/14.
//  Copyright (c) 2014 HandScape, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HSCTouchpad.h"
#import "HSCTouchpadManager.h"


@protocol HSCEventManagerDelegate <NSObject>

@optional
// Implement these to receive fwded HSCTouchpadManagerDelegate messages
- (void) connectionStatusDidChange: (HSCConnectionStatus) newStatus;
- (void) touchpadError: (NSError*) error;
- (void) touchpadTouchReceived: (HSCTouch*) touch;

// Implement this to receive "hover" events
- (void) touchesHovering: (NSSet*) touches;

@end


@interface HSCEventManager : NSObject
    <HSCTouchpadManagerDelegate>

typedef enum {
    hscBackTouchesAreFrontTouches = 0,                                          // default, if unset
    hscNormalTouchHandling,                                                     // (with "hover")
    hscForwardRawTouchHandling,                                                 // just forward raw HSCTouch-s, delegate will handle
} hscEventTouchHandling;

@property(weak, nonatomic) NSObject <HSCEventManagerDelegate> *delegate;
@property(readwrite, nonatomic) hscEventTouchHandling touchHandling;

+ (instancetype) eventManager;

@end
