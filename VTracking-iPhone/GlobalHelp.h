//
//  GlobalHelp.h
//  VTracking-iPhone
//
//  Created by WangYZ on 22/7/15.
//  Copyright (c) 2015 WangYZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GlobalHelp : NSObject
{
    
}

+ (GlobalHelp *)sharedInstance;

//System
- (NSString *)getVersion;

//Screen
- (CGFloat)getScreenWidth;
- (CGFloat)getScreenHeight;


- (UIColor *)colorWithHexString:(NSString*)hex;

@end
