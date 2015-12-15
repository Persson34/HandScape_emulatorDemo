/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
  The application's delegate.
  
 */

#import "AAPLAppDelegate.h"
#import <HandScapeSDK/HandScapeSDK.h>

@implementation AAPLAppDelegate

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[HSCTouchpadManager sharedManager] connect];
    
    return YES;
}

@end
