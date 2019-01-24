//
//  JHCoreDataStackManager.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/25.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHCoreDataStackManager.h"
#import "User+CoreDataProperties.h"
#import <CoreData/CoreData.h>
#import "Media+CoreDataProperties.h"

@implementation JHCoreDataStackManager

///单例的实现
+(JHCoreDataStackManager*)shareInstance
{
    static JHCoreDataStackManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JHCoreDataStackManager alloc]init];
    });
    
    return instance;
}

-(NSURL*)getDocumentUrlPath
{
    ///获取文件位置
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]
    ;
}

//懒加载managerContenxt
-(NSManagedObjectContext *)managerContenxt
{
    if (_managerContenxt != nil) {
        
        return _managerContenxt;
    }
    
    _managerContenxt = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    ///设置存储调度器
    [_managerContenxt setPersistentStoreCoordinator:self.maagerDinator];
    
    return _managerContenxt;
}

///懒加载模型对象
-(NSManagedObjectModel *)managerModel
{
    
    if (_managerModel != nil) {
        
        return _managerModel;
    }
    
    _managerModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managerModel;
}

-(NSPersistentStoreCoordinator *)maagerDinator
{
    if (_maagerDinator != nil) {
        
        return _maagerDinator;
    }
    
    _maagerDinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:self.managerModel];
    self.workingMOCArr = [NSHashTable weakObjectsHashTable];

    //添加存储器
    /**
     * type:一般使用数据库存储方式NSSQLiteStoreType
     * configuration:配置信息 一般无需配置
     * URL:要保存的文件路径
     * options:参数信息 一般无需设置
     */
    
    //拼接url路径
    NSURL *url = [[self getDocumentUrlPath]URLByAppendingPathComponent:@"sqlit.db" isDirectory:YES];
    [_maagerDinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:nil];
    
    return _maagerDinator;
}

//保存用户
-(void)save:(NSArray *)list withColum:(NSString *)colum withMore:(BOOL)isMore{
    if (list.count==0) {
        [self saveContext:self.managerContenxt];
        return;
    }
    [self.managerContenxt performBlock:^{
        NSMutableArray *pks = [NSMutableArray array];
        for (int i=0; i<list.count; i++) {
            NSDictionary *dic = list[i];
            NSDictionary *user = dic;
            if ([colum isEqualToString:@"praised"] || [colum isEqualToString:@"comment"]){
                user = [dic valueForKey:@"user"];
            }
            NSString *pk =[NSString stringWithFormat:@"%@",[user valueForKey:@"pk"]];
            if ([pks containsObject:pk]) {
                return;
            }
            [pks addObject:pk];
            NSLog(@"1 %@", [NSThread currentThread]);
            [self.managerContenxt performBlockAndWait:^{
                //创建查询请求--类似于网络请求NSURLRequest
                NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
                //查询条件--可选
                NSPredicate *name = [NSPredicate predicateWithFormat:@"pk = %@",pk];
                request.predicate = name;
                //发送查询请求，并返回结果
                NSError *error = nil;
                NSArray *resArray = [self.managerContenxt executeFetchRequest:request error:&error];
                //对查询结果进行判断并处理
                if (resArray.count>0) {
                    for (User *user in resArray) {
                        if ([colum isEqualToString:@"follower"]) {
                            user.follower = 1;
                        }else if ([colum isEqualToString:@"following"]){
                            user.following = 1;
                        }else if ([colum isEqualToString:@"praised"]){
                            user.praised_count += 1;
                        }else if ([colum isEqualToString:@"praising"]){
                            user.praising_count += 1;
                        }else if ([colum isEqualToString:@"comment"]){
                            user.comment_count += 1;
                        }
                        user.popular_count = user.praising_count+user.comment_count;
                       
                    }
                    if (i == list.count-1 && !isMore) {
                        if ([colum isEqualToString:@"follower"]) {
                            self.isFollower = YES;
                        }else if ([colum isEqualToString:@"following"]){
                            self.isFollowing = YES;
                        }
                    }
                    [self saveContext:self.managerContenxt];
                }else{
                    User * userModel = [NSEntityDescription
                                        insertNewObjectForEntityForName:@"User"
                                        inManagedObjectContext:self.managerContenxt];
                    userModel.pk = pk;
                    userModel.username = user[@"username"];
                    userModel.profile_pic_url = user[@"profile_pic_url"];
                    if ([colum isEqualToString:@"follower"]) {
                        userModel.follower = 1;
                    }else if ([colum isEqualToString:@"following"]){
                        userModel.following = 1;
                    }else if ([colum isEqualToString:@"praised"]){
                        userModel.praised_count += 1;
                    }else if ([colum isEqualToString:@"praising"]){
                        userModel.praising_count += 1;
                    }else if ([colum isEqualToString:@"comment"]){
                        userModel.comment_count += 1;
                    }
                    userModel.popular_count = userModel.praising_count+userModel.comment_count;

                    userModel.content = [self getJsonData:user];
                    if (i == list.count-1 && !isMore) {
                        if ([colum isEqualToString:@"follower"]) {
                            self.isFollower = YES;
                        }else if ([colum isEqualToString:@"following"]){
                            self.isFollowing = YES;
                        }
                    }
                }
                
            }];
        }
        [self saveContext:self.managerContenxt];
    }];
}

//保存帖子

-(void)saveMedia:(NSArray *)list withMore:(BOOL)isMore succeed:(void (^)(NSInteger))succeed{
    [self.managerContenxt performBlock:^{
        // 1.根据Entity名称和NSManagedObjectContext获取一个新的继承于NSManagedObject的子类Student
        for (NSDictionary *dic in list) {
            Media *media = [NSEntityDescription
                            insertNewObjectForEntityForName:@"Media"
                            inManagedObjectContext:self.managerContenxt];
            
            //  2.根据表Student中的键值，给NSManagedObject对象赋值
            media.pk = [[dic valueForKey:@"pk"] integerValue];
            media.media_type =[[dic valueForKey:@"media_type"] integerValue];
            media.content = [self getJsonData:dic];
            media.like_count = [[dic valueForKey:@"like_count"] integerValue];
            media.comment_count = [[dic valueForKey:@"comment_count"] integerValue];
            media.popular_count = media.like_count+media.comment_count;        }
        [self saveContext:self.managerContenxt];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (succeed) {
                succeed(1);
            }
        });
    }];

}
- (void)saveContext:(NSManagedObjectContext *)context {
    if (!context) {
        return;
    }
    NSError *error = nil;
    // 判断MOC监听的MO对象是否有改变，如果有则提交保存
    if (context.hasChanges) {
        if ([context save:&error]) {
            NSLog(@"数据插入到数据库成功");
        }else{
            NSLog(@"数据插入到数据库失败");
        }
    }
    if (context.parentContext) {
        // 递归保存
        [self saveContext:context.parentContext];
    }
}
-(void)clear{
    [[JHNetworkManager shareInstance] cancelRequest];
    [self.managerContenxt performBlock:^{
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
            NSArray *resArray = [self.managerContenxt executeFetchRequest:request error:nil];
            NSFetchRequest *mediaRequest = [NSFetchRequest fetchRequestWithEntityName:@"Media"];
            NSArray *mediaArray = [self.managerContenxt executeFetchRequest:mediaRequest error:nil];
            for (User *user in resArray) {
                [self.managerContenxt deleteObject:user];
            }
            for (Media *media in mediaArray) {
                [self.managerContenxt deleteObject:media];
            }
    }];

    self.following = nil;
    self.follower = nil;
    [self saveCollectUser];
}

//粉丝
-(NSArray *)getMyFollwerList{
    NSArray *result = [self getUserOrder:NO withPropertyName:@"follower = 1" withDescName:nil];
    return result;
}
//我关注的
-(NSArray *)getMyFollowingList{
    NSArray *result = [self getUserOrder:NO withPropertyName:@"following = 1" withDescName:nil];
    return result;
}
//关注我的用户
-(NSArray *)getFollwerList{
    NSArray *result = [self getUserOrder:NO withPropertyName:@"follower = 1 && following = 0" withDescName:nil];
    return result;
}
//我关注的用户
-(NSArray *)getFollwingList{
    NSArray *result = [self getUserOrder:NO withPropertyName:@"following = 1 && follower = 0" withDescName:nil];
    return result;
}
//相互关注的用户
-(NSArray *)getEachFollowList{
    NSArray *result = [self getUserOrder:NO withPropertyName:@"following = 1 && follower = 1" withDescName:nil];
    return result;
}
//我点赞的用户
-(NSArray *)getPraisedList{
    NSArray *result = [self getUserOrder:NO withPropertyName:@"praised_count > 0" withDescName:nil];
    return result;
}
//点赞我的用户
-(NSArray *)getPraisingList{
    NSArray *result = [self getUserOrder:NO withPropertyName:@"praising_count > 0" withDescName:nil];
    return result;
}
//我最好的帖子
-(NSArray *)getMyBestNoteOrderList{
    NSArray *arry1= [self getNotesOrder:YES withPropertyName:@"popular_count > 0" withDescName:@"popular_count"];
    NSArray *arry2= [self getNotesOrder:YES withPropertyName:@"like_count > 0" withDescName:@"like_count"];
    NSArray *arry3= [self getNotesOrder:YES withPropertyName:@"comment_count > 0" withDescName:@"comment_count"];
    NSMutableArray *arry =[NSMutableArray arrayWithObjects:arry1,arry2,arry3, nil];
    return arry;
}
//我最差的帖子
-(NSArray *)getMyWorstNoteOrderList{
    NSArray *arry1= [self getNotesOrder:YES withPropertyName:@"popular_count = 0" withDescName:@"popular_count"];
    NSArray *arry2= [self getNotesOrder:YES withPropertyName:@"like_count = 0" withDescName:@"like_count"];
    NSArray *arry3= [self getNotesOrder:YES withPropertyName:@"comment_count = 0" withDescName:@"comment_count"];
    NSMutableArray *arry =[NSMutableArray arrayWithObjects:arry1,arry2,arry3, nil];
    return arry;
}
//我的视频
-(NSArray *)getMyVideoOrderList{
    NSArray *arry1= [self getNotesOrder:YES withPropertyName:@"popular_count > 0 && media_type = 2" withDescName:@"popular_count"];
    NSArray *arry2= [self getNotesOrder:YES withPropertyName:@"like_count > 0 && media_type = 2" withDescName:@"like_count"];
    NSArray *arry3=[self getNotesOrder:YES withPropertyName:@"comment_count > 0 && media_type = 2" withDescName:@"comment_count"];
    NSMutableArray *arry =[NSMutableArray arrayWithObjects:arry1,arry2,arry3, nil];
    return arry;
}
//帖子排序
-(NSArray *)getNotesOrder:(BOOL)desc withPropertyName:(NSString *)colum withDescName:(NSString *)descName{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Media"];
    if (colum !=nil) {
        NSPredicate *name = [NSPredicate predicateWithFormat:colum];
        request.predicate = name;
    }
    if (desc) {
        //实例化排序对象
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:descName ascending:desc];
        request.sortDescriptors = @[sort];
    }
    NSArray *resArray = [self.managerContenxt executeFetchRequest:request error:nil];
    return [self getMediaList:resArray];
}
//用户排序
-(NSArray *)getUserOrder:(BOOL)desc withPropertyName:(NSString *)colum withDescName:(NSString *)descName{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    if (colum !=nil) {
        NSPredicate *name = [NSPredicate predicateWithFormat:colum];
        request.predicate = name;
    }
    if (desc) {
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:descName ascending:desc];
        request.sortDescriptors = @[sort];
    }
    NSArray *resArray = [self.managerContenxt executeFetchRequest:request error:nil];
    return [self getUserList:resArray];
}
//帖子分析
-(NSArray *)getTotalMedias{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Media"];
    NSArray *resArray = [self.managerContenxt executeFetchRequest:request error:nil];
    return [self getMediaList:resArray];
}
-(NSArray *)getTotalPhotos{
    NSArray *arry= [self getNotesOrder:NO withPropertyName:@"media_type = 8" withDescName:nil];
    return arry;
}

-(NSArray *)getTotalVideos{
    NSArray *arry= [self getNotesOrder:NO withPropertyName:@"media_type = 2" withDescName:nil];
    return arry;
}
//保存收藏用户
-(void)saveCollectUser{
    NSMutableArray *arry = [NSMutableArray array];
    for (JHCollectModel *collect in [JHUserInfoModel unarchive].collectUsers) {
        NSDictionary *dic = [self dicFromObject:collect.user];
        [arry addObject:dic];
    }
    [self save:arry withColum:nil withMore:YES];
}
-(NSArray *)getMediaList:(NSArray *)resArray{
    NSMutableArray *list = [NSMutableArray array];
    for (Media *media in resArray) {
        NSDictionary *dic = [self getJsonDic:media.content];
        JHArticleModel *model = [[JHArticleModel alloc] initWithObject:dic];
        [list addObject:model];
    }
    return list;
}
-(NSArray *)getUserList:(NSArray *)resArray{
    NSMutableArray *list = [NSMutableArray array];
    for (User *user in resArray) {
        NSDictionary *dic = [self getJsonDic:user.content];
        JHUserModel *model = [[JHUserModel alloc] initWithObject:dic];
        model.follower = user.follower;
        model.following = user.following;
        model.type = 1;
        [list addObject:model];
    }
    return list;
}
-(NSString *)getJsonData:(NSDictionary *)dic{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}
-(NSDictionary *)getJsonDic:(NSString *)jsonString{
    if (isEmptyString(jsonString)) {
        return [NSDictionary dictionary];
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers
                                                          error:nil];
    return dic;
}

- (NSDictionary *)dicFromObject:(NSObject *)object {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([object class], &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithUTF8String:cName];
        NSObject *value = [object valueForKey:name];//valueForKey返回的数字和字符串都是对象
        
        if (value == nil) {
            //null
        } else {
            //model
            [dic setObject:[self dicFromObject:value] forKey:name];
        }
    }
    return dic;
}
//用户属性更改
-(void)updateUser:(JHUserModel *)user succeed:(void (^)(BOOL data))succeed{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSPredicate *name = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"pk = %@",user.pkStr]];
    request.predicate = name;
    NSArray *resArray = [self.managerContenxt executeFetchRequest:request error:nil];
    if (resArray.count>0) {
        for (User *model in resArray) {
            model.following = user.following;
            model.follower = user.follower;
        }
    }else{
        User * model = [NSEntityDescription
                            insertNewObjectForEntityForName:@"User"
                            inManagedObjectContext:self.managerContenxt];
        model.pk = user.pkStr;
        model.username = user.username;
        model.profile_pic_url = user.profile_pic_url;
        model.following = user.following;
        model.follower = user.follower;

    }
    [self saveContext:self.managerContenxt];

}
//获取用户关注状态
-(void)getFollowerStatus:(JHUserModel *)user succeed:(void (^)(id))succeed{
    NSArray *list= [self getUserOrder:NO withPropertyName:[NSString stringWithFormat:@"pk = %@",user.pkStr] withDescName:nil];
    if (list.count>0) {
        succeed(list[0]);
    }
}
@end
