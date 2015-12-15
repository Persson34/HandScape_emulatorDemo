//
//  HSCHandView.h
//  HandScapeSDK
//
//  Created by Olie on 7/16/14.
//  Copyright (c) 2014 HandScape, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HSCHandBaseView.h"


#define HSC_HAND_TOUCH_ALPHA         1.
#define HSC_HAND_AWAY_ALPHA          0.33


@interface HSCHandView : HSCHandBaseView

@property(strong, readonly, nonatomic) NSMutableArray *fingers;
@property(readonly, nonatomic) BOOL isLeft;
@property(strong, readonly, nonatomic) UIImageView *palmView;
@property(readwrite, nonatomic) BOOL useThumb;

+ (NSString*) fingerNameForIndex: (int) index;
+ (HSCHandView*) handViewWithName: (NSString*) name isLeft: (BOOL) isLeft;

- (id) initWithName: (NSString*) name isLeft: (BOOL) isLeft;

- (CGPoint) centroidWithPalm: (BOOL) includePalm
                   withThumb: (BOOL) includeThumb
               includeHovers: (BOOL) includeHovers;

@end
