//
//  JHCoreDataStackManager.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/25.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHCoreDataStackManager : NSObject
///单例
+(JHCoreDataStackManager*)shareInstance;
///管理对象上下文
@property(strong,nonatomic)NSManagedObjectContext *managerContenxt;
@property(strong,nonatomic)NSManagedObjectContext *privateManagerContenxt;

// 创建私有队列MOC，用于执行其他耗时操作
@property(strong,nonatomic)NSManagedObjectContext *backgroundMOC;

///模型对象
@property(strong,nonatomic)NSManagedObjectModel *managerModel;

///存储调度器
@property(strong,nonatomic)NSPersistentStoreCoordinator *maagerDinator;
/**
 为了研究使用后的moc是否会被正常销毁。
 */
@property (nonatomic, strong) NSHashTable *workingMOCArr;
@property(assign,nonatomic)BOOL isFollower;
@property(assign,nonatomic)BOOL isFollowing;
@property (nonatomic, strong) NSMutableArray *follower;
@property (nonatomic, strong) NSMutableArray *following;
//清除数据库
-(void)clear;
//保存数据的方法
-(void)save:(NSArray *)list withColum:(NSString *)colum withMore:(BOOL)isMore;

//保存帖子
-(void)saveMedia:(NSArray *)list withMore:(BOOL)isMore succeed:(void (^)(NSInteger data))succeed;
//帖子分析
-(NSArray *)getTotalMedias;
-(NSArray *)getTotalPhotos;
-(NSArray *)getTotalVideos;
//关注我的用户
-(NSArray *)getFollwerList;
//粉丝
-(NSArray *)getMyFollwerList;
//我关注的
-(NSArray *)getMyFollowingList;
//我关注的用户
-(NSArray *)getFollwingList;
//相互关注的用户
-(NSArray *)getEachFollowList;
//我点赞的用户
-(NSArray *)getPraisedList;
//点赞我的用户
-(NSArray *)getPraisingList;
//我最好的帖子
-(NSArray *)getMyBestNoteOrderList;
//我最差的帖子
-(NSArray *)getMyWorstNoteOrderList;

//帖子排序
-(NSArray *)getNotesOrder:(BOOL)desc withPropertyName:(NSString *)colum withDescName:(NSString *)descName;

//用户排序
-(NSArray *)getUserOrder:(BOOL)desc withPropertyName:(NSString *)colum withDescName:(NSString *)descName;

//用户属性更改
-(void)updateUser:(JHUserModel *)user succeed:(void (^)(BOOL data))succeed;
//获取用户关注状态
-(void)getFollowerStatus:(JHUserModel *)user succeed:(void (^)(id))succeed;
@end
