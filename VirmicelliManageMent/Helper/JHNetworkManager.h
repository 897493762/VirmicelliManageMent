//
//  JHNetworkManager.h
//  WineLine
//
//  Created by Wuxiaolian on 17/2/20.
//  Copyright © 2017年 Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface JHNetworkManager : NSObject
/**
 *  创建并返回一个单例对象
 */
+ (instancetype)shareInstance;
/**
 *  GET加载数据
 *
 */
- (void)GET:(NSString *)URLString dict:(id)dict succeed:(void (^)(id data))succeed failure:(void (^)(NSError *error))failure;
/**
 *  POST加载数据
 *
 */
- (void)POSTHash:(NSString *)URLString dict:(id)dict succeed:(void (^)(id data))succeed failure:(void (^)(NSError *error))failure;

- (void)POST:(NSString *)URLString dict:(id)dict succeed:(void (^)(id data))succeed failure:(void (^)(NSError *error))failure;
/*
 *关注相关
 */
- (void)getFollowersucceed:(void (^)(id data))result;
/*
 *点赞我
 */
- (void)getLikersucceed:(void (^)(NSInteger data))result;

/*
 *登录
 */
-(void)postUserLoginName:(NSString *)userName passWord:(NSString *)passWord isRemember:(BOOL)isRemember succeed:(void (^)(id data))succeed failure:(void (^)(NSError *error))failure;
/*
 *网络请求取消
 */
- (void)cancelRequest;
/*
 *关注、取消关注
 */
-(void)postFollow:(BOOL)isFollow withUserModel:(JHUserModel *)model succeed:(void (^)(id data))succeed failure:(void (^)(NSError *error))failure;
-(void)postTofollow:(BOOL)isFollow withPk:(long)pk succeed:(void (^)(BOOL data))succeed failure:(void (^)(NSError *error))failure;

/*
 *点赞、取消  0
 *收藏、取消。 1
 */
- (void)postStatus:(NSInteger)tag isSelected:(BOOL)select withPk:(NSString *)pk succeed:(void (^)(BOOL data))succeed failure:(void (^)(NSString *error))failure;
@end
