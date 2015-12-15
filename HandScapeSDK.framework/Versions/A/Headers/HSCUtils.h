//
//  HSCUtils.h
//  HandScapeTest
//
//  Created by Olie on 7/2/14.
//  Copyright (c) 2014 HandScape, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSCUtils : NSObject

+ (NSData*) dataByIntepretingHexString: (NSString*) hexString;
+ (NSString*) dateTimeStamp;
+ (NSString*) dateTimeStampWithFormat: (NSString*) format;

+ (CGFloat) distanceFrom: (CGPoint) point1 to: (CGPoint) point2;
+ (CGPoint) flipPoint: (CGPoint) point;
+ (CGSize) flipSize: (CGSize) size;
+ (UIView*) mainView;
+ (void) unimplementedFeature;

@end
