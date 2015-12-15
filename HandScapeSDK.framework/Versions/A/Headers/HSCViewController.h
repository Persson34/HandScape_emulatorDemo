//
//  HSCViewController.h
//  HandScapeTest
//
//  Created by Olie on 7/1/14.
//  Copyright (c) 2014 HandScape, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HSCTouch.h"
#import "HSCEventManager.h"


@interface HSCViewController : UIViewController
    <HSCEventManagerDelegate>

- (IBAction) backAction: (id) sender;

@end
