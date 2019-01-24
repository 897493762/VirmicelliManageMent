//
//  CMUUIDManager.m
//  LMTest
//
//  Created by khj on 2017/9/24.
//  Copyright © 2017年 zeenc. All rights reserved.
//

#import "CMUUIDManager.h"

#import "CMKeyChain.h" 

@implementation CMUUIDManager

static NSString * const KEY_IN_KEYCHAIN = @"com.CarexRigescens.manager";
static NSString * const KEY_UUID = @"com.CarexRigescens.manager";
static NSString * const KEY_ExpireTime = @"com.CarexRigescens.manager.expireTime";

+(void)saveUUID:(NSString *)uuid
{
    NSMutableDictionary *usernameUuidPairs = [NSMutableDictionary dictionary];
    [usernameUuidPairs setObject:uuid forKey:KEY_UUID];
    [CMKeyChain save:KEY_IN_KEYCHAIN data:usernameUuidPairs];
}

+(id)readUUID
{
    NSMutableDictionary *usernameUuidPairs = (NSMutableDictionary *)[CMKeyChain load:KEY_IN_KEYCHAIN];
    return [usernameUuidPairs objectForKey:KEY_UUID];
}

+(void)deleteUUID
{
    [CMKeyChain delete:KEY_IN_KEYCHAIN];
}

+(void)saveExpireTime:(NSString *)expireTime
{
    NSMutableDictionary *usernameUuidPairs = (NSMutableDictionary *)[CMKeyChain load:KEY_IN_KEYCHAIN];
    [usernameUuidPairs setObject:expireTime forKey:KEY_ExpireTime];
    [CMKeyChain save:KEY_IN_KEYCHAIN data:usernameUuidPairs];
}

+(NSString *)readExpireTime
{
    NSMutableDictionary *usernameUuidPairs = (NSMutableDictionary *)[CMKeyChain load:KEY_IN_KEYCHAIN];
    return [usernameUuidPairs objectForKey:KEY_ExpireTime];
}
@end
