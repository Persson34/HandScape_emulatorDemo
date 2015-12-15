//
//  HSCEvent.h
//  HandScapeTest
//
//  Created by Olie on 7/2/14.
//  Copyright (c) 2014 HandScape, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HSCEvent : NSObject

typedef enum {
    hscEventTypeTouch    = 0x100,
    // There currently aren't any other event types, but there might some-
    // day be accelerometer events, location events, etc.
} HSCEventType;


@property (readonly) HSCEventType eventType;

- (id) initWithEventType: (HSCEventType) eType;

@end
