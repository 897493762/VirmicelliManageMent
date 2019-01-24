//
//  CMKeyChain.h
//  LMTest
//
//  Created by khj on 2017/9/24.
//  Copyright © 2017年 zeenc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMKeyChain : NSObject

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service ;

+ (void)save:(NSString *)service data:(id)data;

+ (id)load:(NSString *)service;

+ (void)delete:(NSString *)service;

@end
