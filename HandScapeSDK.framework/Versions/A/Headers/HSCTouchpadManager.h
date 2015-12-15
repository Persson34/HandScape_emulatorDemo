//
//  HSCTouchpadManager.h
//  HandScapeTestbed
//
//  Created by John Brewer on 7/24/14.
//  Copyright (c) 2014 HandScape, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HSCTouch;

typedef enum {
    HSC_ERROR = -1,
    HSC_IDLE = 0,
    HSC_TRY_RECONNECT = 1,
    HSC_SHORT_SEARCH = 2,
    HSC_LONG_SEARCH = 3,
    HSC_CONNECTING = 4,
    HSC_CONNECTED = 5
} HSCConnectionStatus;

typedef enum {
    hscErrorDeviceNotPoweredOn   = 1,
    hscErrorDeviceNotFound,
    hscErrorBluetoothNotSupported,
    hscErrorBluetoothNotAuthorized
} HSCDeviceErrors;

typedef enum {
    HSC_TOUCH_DATA_UNSPECIFIED = 0,
    HSC_TOUCH_DATA_SINGLE = 1,
    HSC_TOUCH_DATA_MULTIPLE = 2
} HSCTouchDataVersion;

#define HSC_ConnectionStatusDidChange_Notification  @"HSC_ConnectionStatusDidChange_Notification"
#define HSC_TouchpadError_Notification              @"HSC_TouchpadError_Notification"
#define HSC_TouchReceived_Notification              @"HSC_TouchReceived_Notification"
#define HSC_MultipleTouchesReceived_Notification            @"HSC_MultipleTouchesReceived_Notification"
#define HSC_TouchesHovering_Notification            @"HSC_TouchesHovering_Notification"
#define HSC_ClearTouches_Notification               @"HSC_ClearTouches_Notification"

// Notification data in userInfo dict keys
#define HSC_NotificationTouchDataKey                     @"HSC_NotificationTouchDataKey"
#define HSC_NotificationTouchDataMultipleKey             @"HSC_NotificationTouchDataMultipleKey"
#define HSC_NotificationErrorDataKey                     @"HSC_NotificationErrorDataKey"
#define HSC_NotificationStatusDataKey                    @"HSC_NotificationStatusDataKey"


@protocol HSCTouchpadManagerDelegate <NSObject>

@optional
- (void)connectionStatusDidChange:(HSCConnectionStatus)newStatus;
- (void)touchpadError:(NSError*)error;
- (void)touchpadTouchReceived:(HSCTouch*)touch;
- (void)touchpadMultipleTouchesReceived:(NSArray*)touches;
- (void)touchpadClearTouches;

@end


@interface HSCTouchpadManager : NSObject

@property (assign, nonatomic) BOOL autoReconnect;
@property (assign, nonatomic) HSCConnectionStatus connectionStatus;
@property (weak, nonatomic) id<HSCTouchpadManagerDelegate> delegate;
@property (readonly, assign, nonatomic) HSCTouchDataVersion touchDataVersion;
@property (strong, nonatomic) NSString *deviceName;

+ (void)setLogging:(BOOL)newValue;
+ (void)setTryLastDevice:(BOOL)newValue;
+ (void)setSelectHSDevice:(BOOL)newValue;
+ (instancetype)sharedManager;
+ (NSString*)textForStatus:(HSCConnectionStatus)status;

- (void)connect;
- (void)disconnect;

@end
