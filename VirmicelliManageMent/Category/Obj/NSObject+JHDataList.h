//
//  NSObject+JHDataList.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/13.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHUserInfoModel.h"
#import "JHAnalysisModel.h"
#import "JHUserModel.h"
#import "JHMediaModel.h"
#import "JHTagTitleModel.h"
#import "JHCollectModel.h"

@interface NSObject (JHDataList)
/*
 *用户信息
 */
- (void)bg_saveMyinfo:(JHUserInfoModel *)value;

/*
 *高级分析列表数据
 */
- (NSArray *)getHeightAnylysisDataList:(BOOL)refresh;
//
/*
 *普通分析列表数据
 */
- (NSArray *)getBasicAnylysisDataList;
/*
 *投稿分析列表数据
 */
- (NSArray *)getContributionAnylysisDataList;
/*
 *粉丝分析列表数据
 */
- (NSArray *)getFollowersAnylysisDataList;
//
/*
 *帖子model
 */
- (JHMediaModel *)getNotesDataList:(NSDictionary *)value;

/*
 * 关注相关
 */
-(void)updateFllower:(BOOL)isAttention withFollowEach:(BOOL)each withModel:(JHUserModel *)obj;
/*
 * 收藏
 */
-(void)updateApecalFllow:(BOOL)isAttention withModel:(JHUserModel *)obj;

/*
 * 内购发生变化时
 */
-(void)updateMyUserPurseData:(void (^)(BOOL data))succeed;

/*
 * 获取用户列表
 * title 类型描述
 */

-(void)getAnylysisUserData:(NSString *)title withTopTitle:(NSString *)topTitle succeed:(void (^)(id data))succeed;

/*
 * 获取附近用户
 */
-(void)getSearchPlacesUsers:(CGFloat)latitude longitude:(CGFloat)longitude succeed:(void (^)(id data))succeed;
/*!
 @brief 打开instagram个人信息页面
 */
- (void)openInstagram:(NSString* _Nonnull)userName success:(void (^ _Nullable)(void))success failure:(BOOL (^ _Nullable)(NSError * _Nonnull error))failure;
/*
 * 跳转到详情页统计
 */
-(void)statisticsUserEvent:(NSString *)title;
/**
 *   重置取消关注数据
 */
-(void)clearCancelFollow:(void (^)(id data))succeed;

-(NSArray *)getUserModelList:(NSArray *)users columns:(NSString *)name;

/*
 *首页关注model
 */
- (NSArray *)getTrayDataList:(NSArray *)value;

/*
 *首页帖子model
 */
- (NSArray *)getFeedItemsDataList:(NSArray *)value;
/*
 *搜索帖子model
 */
- (NSArray *)getsearchItemDataList:(NSArray *)value;
/*
 *likedf帖子model
 */
- (NSArray *)getUserMediaDataList:(NSArray *)value;
/*
 *favorite帖子model
 */
- (NSArray *)getFavoriteMediaDataList:(NSArray *)value;
/*
 *普通分析列表数据
 */
- (NSArray *)getAnylysisDataList;
/*
 *故事列表数据
 */
//- (NSArray *)getStoryDataList:(NSDictionary *)value;

/*
 *分析title
 */
- (void)getAnylysisDatas:(NSString *)title succeed:(void (^)(NSArray *titles, NSArray *dataList))succeed;
- (NSArray *)getAnylysisTitles:(NSString *)title;
/*
 *收藏用户
 */
-(BOOL)getFavorite:(long)pk;

-(void)insertOrdeletCollectUsers:(BOOL)select withDatas:(JHCollectModel *)model succeed:(void (^)(BOOL data))succeed;
/*
 *收藏tag
 */
-(BOOL)getFavoriteTag:(NSString *)name;

-(void)insertOrdeletCollectTags:(BOOL)select withDatas:(JHCollectModel *)model succeed:(void (^)(BOOL data))succeed;

/*
 *更新Basic数据
 */
-(NSArray *)updateBasicTagData:(NSArray *)datas withName:(NSString *)name withCount:(NSInteger)count;
//关注相关
-(void)getCommentFollowersCount:(NSArray *)fllowers withFllowings:(NSArray *)flloings succeed:(void (^)(NSInteger data))succeed;

//失去的粉丝
-(void)getCancelFollow:(void (^)(id data))succeed;

//从数据库获取user
-(NSArray *)getAnylysisUserList:(NSString *)title;
//收藏的用户
-(NSArray *)getAnylysisCollectUser;

@end
