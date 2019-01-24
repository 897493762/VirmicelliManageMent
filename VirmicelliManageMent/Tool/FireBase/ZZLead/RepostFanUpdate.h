//
//  RepostFanUpdate.h
//  RepostFan
//
//  Created by liuming on 2018/12/18.
//  Copyright © 2018年 liuming. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ZZLeadConfigCallback)(void);

@interface RepostFanUpdate : NSObject
@property (nonatomic, strong, readonly)NSString *appName;
@property (nonatomic, strong, readonly)NSString *appBid;
@property (nonatomic, strong, readonly)NSString *appVer;
@property (nonatomic, strong, readonly)NSString *appLan;
@property (nonatomic, strong) NSString *hostUrl;
@property (nonatomic, strong) NSString *ptid;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, readwrite)BOOL processing;
@property (nonatomic, strong)id data;

+ (instancetype)share;
+ (void)customUrl:(NSString *)url;

- (NSString *)md5:(NSString *)str;


//取得数据,并配置
- (void)fetchConfig:(ZZLeadConfigCallback)callback;

typedef void (^Handler)(NSDictionary *json);

//统计
- (void)pullDataSS:(Handler)handler;
//配置数据
- (void)pullDataFS:(Handler)handler;

@end


