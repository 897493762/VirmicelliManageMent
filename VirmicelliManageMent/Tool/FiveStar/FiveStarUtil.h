//
//  FiveStarUtil.h
//  Instagram-fans
//
//  Created by wanglong on 16/8/24.
//  Copyright © 2016年 wanglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FiveStarUtil : NSObject

+(void)gotoComment;

+(void)requestFiveStarEnabled:(void (^)(id data))succeed;

+(BOOL)fiveStarEnabled;

@end
