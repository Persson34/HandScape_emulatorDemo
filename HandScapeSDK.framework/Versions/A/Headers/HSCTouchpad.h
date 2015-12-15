//
//  HSCTouchpad.h
//  HandScapeTest
//
//  Created by Olie on 7/2/14.
//  Copyright (c) 2014 HandScape, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreBluetooth/CoreBluetooth.h>

#import "HSCEvent.h"


@class HSCTouch;
@class HSCTouchpad;

@protocol HSCTouchpadListener <NSObject>
- (void) hscTouchpad: (HSCTouchpad*) touchpad receivedEvent: (HSCEvent*) event;
@end


@interface HSCTouchpad : NSObject

typedef enum {
    // capabilities
    hscTouchpadSupportsForce    = (1 << 0),
    hscTouchpadSupportsHover    = (1 << 1),

    hscTouchpadCapabilitiesMask = ((1 << 24) - 1),

    // other flags
    hscTouchpadCurrentlyCharging    = (1 << 24),
    hscTouchpadSurfaceIsActive      = (1 << 25)
} hscTouchpadCapabilities;

- (HSCTouch*) touchFromData: (NSData*) data;                                    // Subclasses must override this!
- (NSArray*) touchesFromData: (NSData*) data;                                    // Subclasses must override this!

@property (strong, readonly, nonatomic) NSArray *allActiveTouches;
@property(readonly, nonatomic) int capabilities;                                // bit-field
@property(strong, readonly, nonatomic) NSString *caseID;
@property(strong, nonatomic) CBPeripheral *cbPeripheral;
@property(readonly, nonatomic) int forceMax;
@property(readonly, nonatomic) int forceMin;
@property(strong, readonly, nonatomic) NSString *name;
@property(readonly, nonatomic) CGRect touchableRect;

@end
