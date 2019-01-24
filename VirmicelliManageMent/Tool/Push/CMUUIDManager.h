//
//  CMUUIDManager.h
//  LMTest
//
//  Created by khj on 2017/9/24.
//  Copyright © 2017年 zeenc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMUUIDManager : NSObject

+(void)saveUUID:(NSString *)uuid;

+(id)readUUID;

+(void)deleteUUID;
////** VIP过期时间 */
+(void)saveExpireTime:(NSString *)expireTime;
+(NSString *)readExpireTime;
@end
