//
//  NSObject+JHDataList.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/13.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "NSObject+JHDataList.h"
#import "JHAnalysisModel.h"
#import "JHTestModel.h"
#import "JHUserinfosModel.h"
#import "JHPurseProductModel.h"
#import "JHArticleModel.h"
#import "JHTagTitleModel.h"
@implementation NSObject (JHDataList)
/*
 *用户信息
 */
- (void)bg_saveMyinfo:(JHUserInfoModel *)value{
    JHUserinfosModel *users = [JHUserinfosModel unarchive];
    if (users.users >0) {
        NSMutableArray *arry = [NSMutableArray array];
        [arry addObjectsFromArray:users.users];
        BOOL isCurrent = false;
        for (int i=0; i<users.users.count; i++) {
            JHUserInfoModel *model = users.users[i];
            if (model.pk == [JHUserInfoModel unarchive].pk) {
                model =[JHUserInfoModel unarchive];
            }
            if (model.pk == value.pk) {
                value.specialFllows = model.specialFllows;
                value.cancelFllowers = model.cancelFllowers;
                value.followerList = model.followerList;
                value.token = model.token;
                [value archive];
                model = value;
                [arry replaceObjectAtIndex:i withObject:model];
                isCurrent = YES;
            }
        }
        if (!isCurrent) {
            [arry addObject:value];
        }
        users.users = arry;
    }else{
        [value archive];
        users = [[JHUserinfosModel alloc] init];
        users.users = [NSArray arrayWithObject:value];
    }
    [users archive];
    NSLog(@"%ld------pk",[JHUserInfoModel unarchive].pk);
}
/*
 *普通分析列表数据
 */
-(NSArray *)getBasicAnylysisDataList{
    NSMutableArray *dataList = [NSMutableArray array];
    NSArray *arryOne = @[@"index_attention_me_default",@"index_attention_me_default",@"index_focus_on_each_other_default",@"index_my_thumb_default",@"index_give_me_thumb_default",@"index_delete_default",@"index_special_care_default"];
    NSArray *arryTwo = @[@"index_my_attention",@"index_attention_me",@"index_focus_on_each_other",@"index_my_thumb",@"index_give_me_thumb",@"index_delete",@"index_special_care"];
    NSMutableArray *arryThree = [NSMutableArray array];
    for (int i=2001; i<2009; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",i];
        [arryThree addObject:NSLocalizedString(str, nil)];
    }
    for (int i=0; i<7; i++) {
        JHTagTitleModel *model = [[JHTagTitleModel alloc] init];
        model.iconName = arryOne[i];
        model.selectIconname = arryTwo[i];
        model.title = arryThree[i];
        [dataList addObject:model];
    }
    return dataList;
}
/*
 *普通分析列表数据
 */
-(NSArray *)getAnylysisDataList{
    NSMutableArray *dataList = [NSMutableArray array];
    NSArray *arryOne = @[@"index_my_attention",@"index_attention_me",@"index_focus_on_eachother",@"index_my_thumb",@"index_give_me_thumb",@"index_delete",@"index_special_care",@"index_search"];
    NSMutableArray *arryTwo = [NSMutableArray array];
    for (int i=2001; i<2009; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",i];
        [arryTwo addObject:NSLocalizedString(str, nil)];
    }
    NSMutableArray *arryThree =[NSMutableArray array];
    for (int i=2700; i<2708; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",i];
        [arryThree addObject:NSLocalizedString(str, nil)];
    }
    
    for (int i=0; i<arryOne.count; i++) {
        JHTestModel *testModel = [[JHTestModel alloc]init];
        testModel.imagestr = arryOne[i];
        testModel.title = arryTwo[i];
        testModel.desc = arryThree[i];
        [dataList addObject:testModel];
    }
    return dataList;
}
/*
 *投稿分析列表数据
 */
- (NSArray *)getContributionAnylysisDataList{
    NSMutableArray *dataList = [NSMutableArray array];
    NSArray *arryOne = @[@"index_post_mostpopular_default",@"index_post_notpopular_default",@"index_post_video_default"];
    NSArray *arryTwo = @[@"index_post_mostpopular",@"index_post_notpopular",@"index_post_video"];
    NSArray *arryThree = @[NSLocalizedString(@"2054", nil),NSLocalizedString(@"2058", nil),NSLocalizedString(@"2093", nil)];

    for (int i=0; i<arryOne.count; i++) {
        JHTagTitleModel *model = [[JHTagTitleModel alloc] init];
        model.iconName = arryOne[i];
        model.selectIconname = arryTwo[i];
        model.title = arryThree[i];
        model.type = 1;
        NSMutableArray *noteArry = [NSMutableArray array];
        NSArray *noteTitles;
        if (i==0) {
            noteTitles = @[NSLocalizedString(@"2055", nil),NSLocalizedString(@"2056", nil),NSLocalizedString(@"2057", nil)];
        }else if (i==1){
            noteTitles = @[NSLocalizedString(@"2059", nil),NSLocalizedString(@"2060", nil),NSLocalizedString(@"2061", nil)];
        }else{
            noteTitles = @[NSLocalizedString(@"2105", nil),NSLocalizedString(@"2094", nil),NSLocalizedString(@"2095", nil),NSLocalizedString(@"2096", nil)];
        }
        for (int b=0; b<noteTitles.count; b++) {
            JHNoteModel *note = [[JHNoteModel alloc] init];
            note.title =noteTitles[b];
            note.type = 1;
            [noteArry addObject:note];
        }
        model.typeList =noteArry;
        [dataList addObject:model];
    }
    return dataList;
}
/*
 *粉丝分析列表数据
 */
- (NSArray *)getFollowersAnylysisDataList{
    NSMutableArray *dataList = [NSMutableArray array];
    NSArray *arryOne = @[@"index_follower_followers_default",@"index_follower_special_members_default",@"index_follower_uninterested_default",@"index_follower_ghost_default",@"index_follower_others_default"];
    NSArray *arryTwo = @[@"index_follower_followers",@"index_follower_special_members",@"index_follower_uninterested",@"index_follower_ghost",@"index_follower_others"];
    NSArray *arryThree = @[NSLocalizedString(@"2062", nil),NSLocalizedString(@"2070", nil),NSLocalizedString(@"2066", nil),NSLocalizedString(@"2092", nil),NSLocalizedString(@"2017", nil)];

    for (int i=0; i<arryOne.count; i++) {
        JHTagTitleModel *model = [[JHTagTitleModel alloc] init];
        model.iconName = arryOne[i];
        model.selectIconname = arryTwo[i];
        model.title = arryThree[i];
        model.type = 2;
        NSMutableArray *noteArry = [NSMutableArray array];
        NSArray *noteTitles;
        if (i==0) {
            noteTitles = @[NSLocalizedString(@"2063", nil),NSLocalizedString(@"2064", nil),NSLocalizedString(@"2065", nil)];
            
        }else if (i==1){
            noteTitles = @[NSLocalizedString(@"2071", nil),NSLocalizedString(@"2072", nil),NSLocalizedString(@"2073", nil)];
            
        }else if(i == 2){
            noteTitles = @[NSLocalizedString(@"2067", nil),NSLocalizedString(@"2068", nil),NSLocalizedString(@"2069", nil)];
            
        }else if(i==3){
            noteTitles = @[NSLocalizedString(@"2106", nil),NSLocalizedString(@"2107", nil),NSLocalizedString(@"2108", nil)];
        }else{
            noteTitles = @[NSLocalizedString(@"2097", nil),NSLocalizedString(@"2098", nil),NSLocalizedString(@"2099", nil),NSLocalizedString(@"2100", nil),NSLocalizedString(@"2101", nil)];
        }
        for (int b=0; b<noteTitles.count; b++) {
            JHNoteModel *note = [[JHNoteModel alloc] init];
            note.title =noteTitles[b];
            note.type = 2;
            [noteArry addObject:note];
        }
        model.typeList =noteArry;
        [dataList addObject:model];
    }
    return dataList;
}
/*
 *高级分析列表数据
 */
-(NSArray *)getHeightAnylysisDataList:(BOOL)refresh{
    NSMutableArray *dataList = [NSMutableArray array];
    NSArray *list=@[NSLocalizedString(@"2117", nil),NSLocalizedString(@"2142", nil),NSLocalizedString(@"2017", nil)];

    for (int i=0; i<list.count; i++) {
        JHAnalysisModel *model = [[JHAnalysisModel alloc] init];
        model.title = list[i];
        NSMutableArray *typeArry = [NSMutableArray array];
        if (i==0) {
            NSArray *typeTitles = @[NSLocalizedString(@"2054", nil),NSLocalizedString(@"2058", nil),NSLocalizedString(@"2093", nil)];
            for (int a=0; a<typeTitles.count; a++) {
                JHTypeModel *types = [[JHTypeModel alloc] init];
                types.title = typeTitles[a];
                types.tag = 1;
                NSMutableArray *noteArry = [NSMutableArray array];
                NSArray *noteTitles;
                static NSArray *users;
                if (a==0) {
                    noteTitles = @[NSLocalizedString(@"2055", nil),NSLocalizedString(@"2056", nil),NSLocalizedString(@"2057", nil)];
                }else if (a==1){
                    noteTitles = @[NSLocalizedString(@"2059", nil),NSLocalizedString(@"2060", nil),NSLocalizedString(@"2061", nil)];
                }else{
                    noteTitles = @[NSLocalizedString(@"2105", nil),NSLocalizedString(@"2094", nil),NSLocalizedString(@"2095", nil),NSLocalizedString(@"2096", nil)];
                }
                
                for (int b=0; b<noteTitles.count; b++) {
                    NSArray *items = users[b];
                    JHNoteModel *note = [[JHNoteModel alloc] init];
                    note.title =noteTitles[b];
                    note.users = items;
                    note.type = 1;
                    [noteArry addObject:note];
                }
                types.notes =noteArry;
                [typeArry addObject:types];
            }
        }else if (i == 1){
             NSArray *typeTitles = @[NSLocalizedString(@"2062", nil),NSLocalizedString(@"2070", nil),NSLocalizedString(@"2066", nil),NSLocalizedString(@"2092", nil)];
            for (int a=0; a<typeTitles.count; a++) {
                JHTypeModel *types = [[JHTypeModel alloc] init];
                types.title = typeTitles[a];
                types.tag = 2;
                NSMutableArray *noteArry = [NSMutableArray array];
                NSArray *noteTitles;
                static NSArray *users;
                
                if (a==0) {
                    noteTitles = @[NSLocalizedString(@"2063", nil),NSLocalizedString(@"2064", nil),NSLocalizedString(@"2065", nil)];
                   
                }else if (a==1){
                    noteTitles = @[NSLocalizedString(@"2071", nil),NSLocalizedString(@"2072", nil),NSLocalizedString(@"2073", nil)];

                }else if(a == 2){
                    noteTitles = @[NSLocalizedString(@"2067", nil),NSLocalizedString(@"2068", nil),NSLocalizedString(@"2069", nil)];
                   
                }else{
                    noteTitles = @[NSLocalizedString(@"2106", nil),NSLocalizedString(@"2107", nil),NSLocalizedString(@"2108", nil)];
                }
                for (int b=0; b<noteTitles.count; b++) {
                    NSArray *items = users[b];
                    JHNoteModel *note = [[JHNoteModel alloc] init];
                    note.title =noteTitles[b];
                    note.users = items;
                    note.type = a+2;
                    [noteArry addObject:note];
                }
                types.notes =noteArry;
                [typeArry addObject:types];
            }
        }else if (i==2){
            JHTypeModel *types = [[JHTypeModel alloc] init];
            types.title = NSLocalizedString(@"2017", nil);
            types.tag = 3;
            NSArray *noteTitles = @[NSLocalizedString(@"2097", nil),NSLocalizedString(@"2098", nil),NSLocalizedString(@"2099", nil),NSLocalizedString(@"2100", nil),NSLocalizedString(@"2101", nil)];

            NSMutableArray *noteArry = [NSMutableArray array];
            for (int b=0; b<noteTitles.count; b++) {
                JHNoteModel *note = [[JHNoteModel alloc] init];
                note.title =noteTitles[b];
                note.type = 10;
                [noteArry addObject:note];
            }
            types.notes =noteArry;
            [typeArry addObject:types];

        }
        model.types = typeArry;
        [dataList addObject:model];

    }
    return dataList;
}
/*
 * 跳转到详情页统计
 */
-(void)statisticsUserEvent:(NSString *)title{
    if ([title isEqualToString:NSLocalizedString(@"2001", nil)]) {
        if ([FiveStarUtil fiveStarEnabled]) {
            [MobClick event:@"follower"];
        }
    }else if ([title isEqualToString:NSLocalizedString(@"2002", nil)]){
        if ([FiveStarUtil fiveStarEnabled]) {
            [MobClick event:@"following"];
        }
    }else if ([title isEqualToString:NSLocalizedString(@"2003", nil)]){
        if ([FiveStarUtil fiveStarEnabled]) {
            [MobClick event:@"follow_each"];
        }
    }else if ([title isEqualToString:NSLocalizedString(@"2004", nil)]){
        if ([FiveStarUtil fiveStarEnabled]) {
            [MobClick event:@"praising"];
        }
    }else if ([title isEqualToString:NSLocalizedString(@"2005", nil)]){
        if ([FiveStarUtil fiveStarEnabled]) {
            [MobClick event:@"praiser"];
        }
    }else if ([title isEqualToString:NSLocalizedString(@"2006", nil)]){
        if ([FiveStarUtil fiveStarEnabled]) {
            [MobClick event:@"care"];
        }
    }else if ([title isEqualToString:NSLocalizedString(@"2007", nil)]){
        if ([FiveStarUtil fiveStarEnabled]) {
            [MobClick event:@"unfollow"];
        }
    }else if ([title isEqualToString:NSLocalizedString(@"2008", nil)]){
        if ([FiveStarUtil fiveStarEnabled]) {
            [MobClick event:@"search"];
        }
    }
}
#pragma mark -- model
-(JHMediaModel *)getNotesDataList:(NSDictionary *)value{
    JHMediaModel *model = [[JHMediaModel alloc] initWithObject:value];
    NSDictionary *image_versions2 = value[@"image_versions2"];
    NSDictionary *candidates;
    if (image_versions2 !=nil) {
        NSArray *images = image_versions2[@"candidates"];
        candidates = images[0];
    }else{
        NSArray *video_versions = value[@"carousel_media"];
        NSDictionary *image_versions = video_versions[0][@"image_versions2"];
        NSArray *ayyy = image_versions[@"candidates"];
        candidates = ayyy[0];
    }
    model.image_url = candidates[@"url"];
    model.width = [[candidates valueForKey:@"width"] floatValue];
    model.height =[[candidates valueForKey:@"height"] floatValue];
    model.username = value[@"user"][@"username"];
    model.profile_pic_url = value[@"user"][@"profile_pic_url"];
    model.userId = value[@"user"][@"pk"];
    model.popular_count = (int)(model.comment_count +model.like_count);
    return model;
}
/*
 * 关注相关
 */
-(void)updateFllower:(BOOL)isAttention withFollowEach:(BOOL)each withModel:(JHUserModel *)obj{
    [[JHCoreDataStackManager shareInstance] updateUser:obj succeed:nil];
    NSString *type = @"";
    if (each) {
        type = @"followEach";
    }
    NSDictionary *dic = @{@"type":type,@"isAttention":[NSString stringWithFormat:@"%d",isAttention]};
    [[NSNotificationCenter defaultCenter] postNotificationName:kFollowStatusChangeNotification object:obj userInfo:dic];
}
/*
 * 收藏
 */
-(void)updateApecalFllow:(BOOL)isAttention withModel:(JHUserModel *)obj{
    if (isAttention) {
        obj.care = 1;
    }else{
        obj.care = 0;
    }
    JHUserInfoModel *infoModel = [JHUserInfoModel unarchive];
    NSMutableArray *collect = [NSMutableArray arrayWithArray:infoModel.specialFllows];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pk == %ld" ,obj.pk];
    NSArray *result = [infoModel.specialFllows filteredArrayUsingPredicate:predicate];
    if (result.count>0) {
        [collect removeObjectsInArray:result];
    }
    if (isAttention) {
        [collect addObject:obj];
    }
    infoModel.specialFllows = collect;
    [infoModel archive];
    [[NSNotificationCenter defaultCenter] postNotificationName:kCollectChangeNotification object:obj];

}
/*
 * 内购发生变化时
 */
-(void)updateMyUserPurseData:(void (^)(BOOL))succeed{
    JHAppStatusModel *status = [JHAppStatusModel unarchive];
    BOOL isPurse = [JHPurseProductModel unarchive].isVipState;
    status.products = [MXGoogleManager shareInstance].productID;
    if (isPurse != status.isPurchase) {
        status.isPurchase = isPurse;
        [status archive];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPurchaseStatusChangeNotification object:nil];
    }else{
        status.isPurchase = isPurse;
        [status archive];
    }
    if (succeed) {
        succeed(status.isPurchase);
    }
}

-(void)getAnylysisUserData:(NSString *)title withTopTitle:(NSString *)topTitle succeed:(void (^)(id))succeed{
    static NSArray *users;
    CLLocation *location = kMainDelegate.location;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if ([topTitle isEqualToString:NSLocalizedString(@"2054", nil)]) {
            if([title isEqualToString:NSLocalizedString(@"2055", nil)]){
                users= [[JHCoreDataStackManager shareInstance] getNotesOrder:YES withPropertyName:@"popular_count > 0" withDescName:@"popular_count"];
                
            }else if ([title isEqualToString:NSLocalizedString(@"2056", nil)]){
                users= [[JHCoreDataStackManager shareInstance] getNotesOrder:YES withPropertyName:@"like_count > 0" withDescName:@"like_count"];
                
            }else if ([title isEqualToString:NSLocalizedString(@"2057", nil)]){
                users= [[JHCoreDataStackManager shareInstance] getNotesOrder:YES withPropertyName:@"comment_count > 0" withDescName:@"comment_count"];
            }
        }else if ([topTitle isEqualToString:NSLocalizedString(@"2058", nil)]){
            if ([title isEqualToString:NSLocalizedString(@"2059", nil)]){
                users= [[JHCoreDataStackManager shareInstance] getNotesOrder:NO withPropertyName:@"popular_count = 0" withDescName:nil];
                
            }else if ([title isEqualToString:NSLocalizedString(@"2060", nil)]){
                users= [[JHCoreDataStackManager shareInstance] getNotesOrder:NO withPropertyName:@"like_count = 0" withDescName:nil];
                
            }else if ([title isEqualToString:NSLocalizedString(@"2061", nil)]){
                users= [[JHCoreDataStackManager shareInstance] getNotesOrder:NO withPropertyName:@"comment_count = 0" withDescName:nil];
                
            }
        }else if ([topTitle isEqualToString:NSLocalizedString(@"2093", nil)]){
            if ([title isEqualToString:NSLocalizedString(@"2094", nil)]){
                users= [[JHCoreDataStackManager shareInstance] getNotesOrder:YES withPropertyName:@"media_type = 2" withDescName:@"popular_count"];
                
            }else if ([title isEqualToString:NSLocalizedString(@"2095", nil)]){
                users= [[JHCoreDataStackManager shareInstance] getNotesOrder:YES withPropertyName:@"media_type = 2" withDescName:@"like_count"];
                
            }else if ([title isEqualToString:NSLocalizedString(@"2096", nil)]){
                users= [[JHCoreDataStackManager shareInstance] getNotesOrder:YES withPropertyName:@"media_type = 2" withDescName:@"comment_count"];
                
            }
        }else if ([topTitle isEqualToString:NSLocalizedString(@"2062", nil)]){
            if ([title isEqualToString:NSLocalizedString(@"2063", nil)]){
                users= [[JHCoreDataStackManager shareInstance] getUserOrder:YES withPropertyName:@"follower = 1 && popular_count > 0" withDescName:@"popular_count"];
                
            }else if ([title isEqualToString:NSLocalizedString(@"2064", nil)]){
                users= [[JHCoreDataStackManager shareInstance] getUserOrder:YES withPropertyName:@"follower = 1 && comment_count >0" withDescName:@"comment_count"];
            }else if ([title isEqualToString:NSLocalizedString(@"2065", nil)]){
                users= [[JHCoreDataStackManager shareInstance] getUserOrder:YES withPropertyName:@"follower = 1 && praising_count >0" withDescName:@"praising_count"];
            }
        }else if ([topTitle isEqualToString:NSLocalizedString(@"2066", nil)]){
            if ([title isEqualToString:NSLocalizedString(@"2067", nil)]){
                users= [[JHCoreDataStackManager shareInstance] getUserOrder:NO withPropertyName:@"follower = 1 && popular_count = 0" withDescName:nil];
                
            }else if ([title isEqualToString:NSLocalizedString(@"2068", nil)]){
                users= [[JHCoreDataStackManager shareInstance] getUserOrder:NO withPropertyName:@"follower = 1 && comment_count = 0" withDescName:nil];
                
            }else if ([title isEqualToString:NSLocalizedString(@"2069", nil)]){
                users= [[JHCoreDataStackManager shareInstance] getUserOrder:NO withPropertyName:@"follower = 1 && praising_count = 0" withDescName:nil];
                
            }
        }else if ([topTitle isEqualToString:NSLocalizedString(@"2070", nil)]){
            if ([title isEqualToString:NSLocalizedString(@"2071", nil)]){
                users= [[JHCoreDataStackManager shareInstance] getUserOrder:YES withPropertyName:@"care = 1 && popular_count > 0" withDescName:@"popular_count"];
                
            }else if ([title isEqualToString:NSLocalizedString(@"2072", nil)]){
                users= [[JHCoreDataStackManager shareInstance] getUserOrder:YES withPropertyName:@"care = 1 && comment_count > 0" withDescName:@"comment_count"];
            }else if ([title isEqualToString:NSLocalizedString(@"2073", nil)]){
                users= [[JHCoreDataStackManager shareInstance] getUserOrder:YES withPropertyName:@"care = 1 && praising_count > 0" withDescName:@"praising_count"];
            }
        }else{
            if ([title isEqualToString:NSLocalizedString(@"2106", nil)]){
                users= [[JHCoreDataStackManager shareInstance] getUserOrder:YES withPropertyName:@"follower = 0 && popular_count > 0" withDescName:@"popular_count"];
                
            }else if ([title isEqualToString:NSLocalizedString(@"2107", nil)]){
                users= [[JHCoreDataStackManager shareInstance] getUserOrder:YES withPropertyName:@"follower = 0 && praising_count >0" withDescName:@"praising_count"];
                
            }else if ([title isEqualToString:NSLocalizedString(@"2108", nil)]){
                users= [[JHCoreDataStackManager shareInstance] getUserOrder:YES withPropertyName:@"follower = 0 && comment_count > 0" withDescName:@"comment_count"];
                
            }else{
                if ([title isEqualToString:NSLocalizedString(@"2097", nil)]){
                    users =[[JHCoreDataStackManager shareInstance] getMyFollwerList];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        succeed(users);
                    });
                }else if ([title isEqualToString:NSLocalizedString(@"2098", nil)]){
                }else if ([title isEqualToString:NSLocalizedString(@"2099", nil)]){
                    [self getUserBlokedDatasucceed:^(id data) {
                        users = data;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            succeed(users);
                        });
                    }];
                }else if ([title isEqualToString:NSLocalizedString(@"2100", nil)]){
                    [self getUserDiscoverDatasucceed:^(id data) {
                        users = data;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            succeed(users);
                        });
                    }];
                    
                }else if ([title isEqualToString:NSLocalizedString(@"2101", nil)]){
                    if (location !=nil) {
                        [self getSearchPlacesUsers:location.coordinate.latitude longitude:location.coordinate.longitude succeed:^(id data) {
                            users = data;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                succeed(users);
                            });
                        }];
                    }
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            succeed(users);
        });
        
    });
}
#pragma mark --- dowloadData
/*
 *我屏蔽了谁
 */
-(void)getUserBlokedDatasucceed:(void (^)(id data))succeed{
    [[JHNetworkManager shareInstance] POST:KBlockedList  dict:nil succeed:^(id data) {
        JHResultResponseModel *response = [[JHResultResponseModel alloc] initWithObject:data];
        if ([response.status isEqualToString:@"ok"]) {
            NSMutableArray *arry = [NSMutableArray array];
            for (NSDictionary *dic in response.blocked_list) {
                JHUserModel *person = [[JHUserModel alloc] initWithObject:dic];
                [arry addObject:person];
            }
            succeed(arry);
        }
    } failure:^(NSError *error) {
    }];
}
/*
 *推荐用户
 */
-(void)getUserDiscoverDatasucceed:(void (^)(id data))succeed{
    NSDictionary *paramas = @{@"module":@"discover_people",
                              @"paginate":@"true",
                              @"_uuid":phoneAdId,
                              @"_csrftoken":@"Cocwtg9VjCRs2mB8PMGNDcDNxz3O0lG6",
                              };
    [[JHNetworkManager shareInstance] POST:KDiscoverAyml  dict:paramas succeed:^(id data) {
        JHResultResponseModel *response = [[JHResultResponseModel alloc] initWithObject:data];
        if ([response.status isEqualToString:@"ok"]) {
            NSMutableArray *arry = [NSMutableArray array];
            NSArray *groups = data[@"groups"];
            if (groups.count >0) {
                NSArray *items = groups[0][@"items"];
                for (NSDictionary *dic in items) {
                    JHUserModel *person = [[JHUserModel alloc] initWithObject:dic[@"user"]];
                    [arry addObject:person];
                }
                succeed(arry);
            }
        }
    } failure:^(NSError *error) {
    }];
}
/*
 * 获取附近用户
 */
-(void)getSearchPlacesUsers:(CGFloat)latitude longitude:(CGFloat)longitude succeed:(void (^)(id data))succeed{
    [self getSearchPlacesData:latitude longitude:longitude withPk:nil succeed:^(id data) {
        for (JHUserModel *model in data) {
            if (kMainDelegate.locationPk != model.pk) {
                kMainDelegate.locationPk = model.pk;
                [self getSearchPlacesData:latitude longitude:longitude withPk:[NSString stringWithFormat:@"%ld",kMainDelegate.locationPk] succeed:^(id data) {
                    succeed(data);
                }];
            }
        }
    }];
}
/*
 *附近用户
 */
-(void)getSearchPlacesData:(CGFloat)latitude longitude:(CGFloat)longitude  withPk:(NSString *)pk succeed:(void (^)(id data))succeed{
    NSString *urlStr;
    if (isEmptyString(pk)) {
        JHUserRequestModel *request = [[JHUserRequestModel alloc] init];
        request.count = @"1";
        request.rank_token =KRank_token;
        request.lat = [NSString stringWithFormat:@"%f",latitude];
        request.lng = [NSString stringWithFormat:@"%f",longitude];
        urlStr =[KFbsearchPlaces stringByAppendingString:[request description]];
    }else{
        urlStr = KFbsearchLocation(pk);
    }
    [[JHNetworkManager shareInstance] POST:urlStr  dict:nil succeed:^(id data) {
        JHResultResponseModel *response = [[JHResultResponseModel alloc] initWithObject:data];
        if ([response.status isEqualToString:@"ok"]) {
            NSMutableArray *arry = [NSMutableArray array];
            if (isEmptyString(pk)) {
                for (NSDictionary *dic in response.users) {
                    JHUserModel *person = [[JHUserModel alloc] initWithObject:dic[@"location"]];
                    [arry addObject:person];
                }
            }else{
                for (NSDictionary *dic in response.users) {
                    JHUserModel *person = [[JHUserModel alloc] initWithObject:dic[@"user"]];
                    [arry addObject:person];
                }
            }
            succeed(arry);
        }
    } failure:^(NSError *error) {
    }];
}
/*!
 @brief 打开instagram个人信息页面
 */
- (void)openInstagram:(NSString* _Nonnull)userName success:(void (^ _Nullable)(void))success failure:(BOOL (^ _Nullable)(NSError * _Nonnull error))failure
{
    NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat:@"instagram://user?username=%@",userName]];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        [[UIApplication sharedApplication] openURL:instagramURL];
    }else{
        [self GoToInstagram];
    }
}
//** 去Instagram */
-(void)GoToInstagram
{
    NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.instagram.com"]];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        [[UIApplication sharedApplication] openURL:instagramURL];
    }
}
/**
 *   重置取消关注数据
 */
-(void)clearCancelFollow:(void (^)(id data))succeed{
    JHUserInfoModel *info = [JHUserInfoModel unarchive];
    info.cancelFllowers = nil;
    [info archive];
    succeed(nil);
}
-(NSArray *)getUserModelList:(NSArray *)users columns:(NSString *)name{
    NSMutableArray *models = [NSMutableArray array];
    NSMutableArray *pks = [NSMutableArray array];
    for (int i=0; i<users.count; i++) {
        NSDictionary *dic = users[i];
        if ([name isEqualToString:@"praising"] || [name isEqualToString:@"commenting"]){
            dic = [dic valueForKey:@"user"];
        }
        JHUserModel *userModel = [[JHUserModel alloc] initWithObject:dic];
        if (![pks containsObject:userModel.pkStr]) {
            if ([name isEqualToString:@"follower"]) {
                userModel.follower = 1;
            }else if ([name isEqualToString:@"following"]){
                userModel.following = 1;
            }else if ([name isEqualToString:@"praised"]){
                userModel.praised_count +=1;
            }else if ([name isEqualToString:@"commenting"]){
                userModel.comment_count +=1;
            }else if ([name isEqualToString:@"praising"]){
                userModel.praising_count +=1;
            }
            [models addObject:userModel];
            [pks addObject:userModel.pkStr];
        }
    }
    return models;
}
/*
 *首页关注model
 */
- (NSArray *)getTrayDataList:(NSArray *)value{
    NSMutableArray *list = [NSMutableArray array];
    for (NSDictionary *dic in value) {
        NSDictionary *userDic = [dic valueForKey:@"user"];
        JHUserModel *user = [[JHUserModel alloc] initWithObject:userDic];
        user.follower = 1;
        [list addObject:user];
    }
    return list;
}
/*
 *首页帖子model
 */
- (NSArray *)getFeedItemsDataList:(NSArray *)value{
    NSMutableArray *list = [NSMutableArray array];
    for (NSDictionary *dic in value) {
        NSArray *keys = [dic allKeys];
        NSString *firstKey = [keys objectAtIndex:0];
        if ([firstKey isEqualToString:@"media_or_ad"]) {
            NSDictionary *adDic = [dic valueForKey:firstKey];
            JHArticleModel *user = [[JHArticleModel alloc] initWithObject:adDic];
            [list addObject:user];
        }
    }
    return list;
}
/*
 *搜索帖子model
 */
- (NSArray *)getsearchItemDataList:(NSArray *)value{
    NSMutableArray *list = [NSMutableArray array];
    for (NSDictionary *dic in value) {
        NSDictionary *explore_item_info = [dic valueForKey:@"explore_item_info"];
        long aspect_ratio = [[explore_item_info valueForKey:@"aspect_ratio"] integerValue];
        NSDictionary *mediaDic;
        if (aspect_ratio == 1) {
            mediaDic = [dic valueForKey:@"media"];
        }else{
            NSDictionary *adDic = [dic valueForKey:@"channel"];
            mediaDic= [adDic valueForKey:@"media"];
        }
        if (mediaDic !=nil) {
            JHArticleModel *user = [[JHArticleModel alloc] initWithObject:mediaDic];
            [list addObject:user];
        }
    
    }
    return list;
}
/*
 *likedf帖子model
 */
- (NSArray *)getUserMediaDataList:(NSArray *)value{
    NSMutableArray *list = [NSMutableArray array];
    for (NSDictionary *dic in value) {
        JHArticleModel *user = [[JHArticleModel alloc] initWithObject:dic];
        if (user.media_type == 2) {
            
        }
        [list addObject:user];
    }
    return list;
}
/*
 *favorite帖子model
 */
- (NSArray *)getFavoriteMediaDataList:(NSArray *)value{
    NSMutableArray *list = [NSMutableArray array];
    for (NSDictionary *dic in value) {
        NSDictionary *mediaDic = [dic valueForKey:@"media"];
        JHArticleModel *user = [[JHArticleModel alloc] initWithObject:mediaDic];
        [list addObject:user];
    }
    return list;
}
/*
 *故事列表数据
 */
//- (NSArray *)getStoryDataList:(NSDictionary *)value{
//    NSArray *item = [value valueForKey:@"items"];
//    for (NSDictionary *dic in value) {
//        JHArticleModel *user = [[JHArticleModel alloc] initWithObject:dic];
//        [list addObject:user];
//    }
//}

/*
 *分析title
 */
- (void)getAnylysisDatas:(NSString *)title succeed:(void (^)(NSArray *, NSArray *))succeed{
    NSArray *titles;
    if([title isEqualToString:NSLocalizedString(@"2117", nil)]){
        titles = @[NSLocalizedString(@"2054", nil),NSLocalizedString(@"2058", nil),NSLocalizedString(@"2093", nil)];
    }else if([title isEqualToString:NSLocalizedString(@"2113", nil)]){
        titles = @[NSLocalizedString(@"2062", nil),NSLocalizedString(@"2066", nil),NSLocalizedString(@"2070", nil)];
    }
    NSMutableArray *list = [NSMutableArray array];
    for (int i=0; i<titles.count; i++) {
        [list addObject:[self getAnylysisTitles:titles[i]]];
    }
    succeed(titles,list);
}
- (NSArray *)getAnylysisTitles:(NSString *)title{
    NSMutableArray *titles = [NSMutableArray array];
    if ([title isEqualToString:NSLocalizedString(@"2142", nil)]){
       for (int i=2113; i<2116; i++) {
            NSString *str = [NSString stringWithFormat:@"%d",i];
            [titles addObject:NSLocalizedString(str, nil)];
        }
    }else if ([title isEqualToString:NSLocalizedString(@"2054", nil)]){
        for (int i=2055; i<2058; i++) {
            NSString *str = [NSString stringWithFormat:@"%d",i];
            [titles addObject:NSLocalizedString(str, nil)];
        }
    }else if ([title isEqualToString:NSLocalizedString(@"2058", nil)]){
        for (int i=2059; i<2062; i++) {
            NSString *str = [NSString stringWithFormat:@"%d",i];
            [titles addObject:NSLocalizedString(str, nil)];
        }
    }else if ([title isEqualToString:NSLocalizedString(@"2093", nil)]){
        for (int i=2094; i<2097; i++) {
            NSString *str = [NSString stringWithFormat:@"%d",i];
            [titles addObject:NSLocalizedString(str, nil)];
        }
    }else if ([title isEqualToString:NSLocalizedString(@"2062", nil)]){
        for (int i=2063; i<2066; i++) {
            NSString *str = [NSString stringWithFormat:@"%d",i];
            [titles addObject:NSLocalizedString(str, nil)];
        }
    }else if ([title isEqualToString:NSLocalizedString(@"2066", nil)]){
        for (int i=2067; i<2070; i++) {
            NSString *str = [NSString stringWithFormat:@"%d",i];
            [titles addObject:NSLocalizedString(str, nil)];
        }
    }else if ([title isEqualToString:NSLocalizedString(@"2070", nil)]){
        for (int i=2071; i<2074; i++) {
            NSString *str = [NSString stringWithFormat:@"%d",i];
            [titles addObject:NSLocalizedString(str, nil)];
        }
    }else if([title isEqualToString:NSLocalizedString(@"2114", nil)]){
        for (int i=2106; i<2109; i++) {
            NSString *str = [NSString stringWithFormat:@"%d",i];
            [titles addObject:NSLocalizedString(str, nil)];
        }
    }else if([title isEqualToString:NSLocalizedString(@"2115", nil)]){
        for (int i=2097; i<2102; i++) {
            NSString *str = [NSString stringWithFormat:@"%d",i];
            [titles addObject:NSLocalizedString(str, nil)];
        }
    }
    return [titles copy];
}
/*
 *收藏用户
 */
-(BOOL)getFavorite:(long)pk{
    JHUserInfoModel *myModel = [JHUserInfoModel unarchive];
    for (JHCollectModel *collect in myModel.collectUsers) {
        if (collect.user.pk == pk) {
            return YES;
        }
    }
    return NO;
}
-(void)insertOrdeletCollectUsers:(BOOL)select withDatas:(JHCollectModel *)model succeed:(void (^)(BOOL data))succeed{
    JHUserInfoModel *myModel = [JHUserInfoModel unarchive];
    NSMutableArray *list = [NSMutableArray arrayWithArray:myModel.collectUsers];
    if (select) {
        [list addObject:model];
    }else{
        for (JHCollectModel *collect in myModel.collectUsers) {
            if (collect.user.pk == model.user.pk) {
                if (!select) {
                    [list removeObject:collect];
                }
            }
        }
    }
    myModel.collectUsers = list;
    [myModel archive];
    succeed(YES);
}
/*
 *收藏tag
 */
-(BOOL)getFavoriteTag:(NSString *)name{
    JHUserInfoModel *myModel = [JHUserInfoModel unarchive];
    for (JHCollectModel *collect in myModel.collectTags) {
        if ([collect.tagName isEqualToString:name]) {
            return YES;
        }
    }
    return NO;
}

-(void)insertOrdeletCollectTags:(BOOL)select withDatas:(JHCollectModel *)model succeed:(void (^)(BOOL data))succeed{
    JHUserInfoModel *myModel = [JHUserInfoModel unarchive];
    NSMutableArray *list = [NSMutableArray arrayWithArray:myModel.collectTags];
    if (select) {
        [list addObject:model];
    }else{
        for (JHCollectModel *collect in myModel.collectTags) {
            if (collect.tagName == model.tagName) {
                if (!select) {
                    [list removeObject:collect];
                }
            }
        }
    }
    myModel.collectTags = list;
    [myModel archive];
    succeed(YES);
}
/*
 *更新Basic数据
 */
-(NSArray *)updateBasicTagData:(NSArray *)datas withName:(NSString *)name withCount:(NSInteger)count{
    NSMutableArray *arry = [NSMutableArray arrayWithArray:datas];
    if ([name isEqualToString:@"Media"]) {
        NSArray *medias =[[JHCoreDataStackManager shareInstance] getTotalMedias];
        NSArray *photos =[[JHCoreDataStackManager shareInstance] getTotalPhotos];
        NSArray *videos =[[JHCoreDataStackManager shareInstance] getTotalVideos];

        for (int i=0; i<datas.count; i++) {
            JHTagTitleModel *tag = datas[i];
            tag.isRefresh = YES;
            if (i== 0 || i==1 ||i==2) {
                if (i==1){
                    tag.count = photos.count;
                }else if(i==2){
                    tag.count = videos.count;
                }else{
                    tag.count =medias.count;
                }
            }else if (i==3 || i==4){
                NSInteger mediaLike = 0;
                NSInteger mediaComment = 0;
                for (JHMediaModel *model in medias) {
                    mediaLike+=model.like_count;
                    mediaComment+=model.comment_count;
                }
                if(i==3){
                    tag.count =mediaLike;
                }else{
                    tag.count =mediaComment;
                }
            }
            else{
                NSArray *total= nil;
                NSInteger mediaLike = 0;
                NSInteger mediaComment = 0;
                if (i==5 || i==8) {
                    total = medias;
                }else if (i==6 || i==9){
                    total = photos;
                }else{
                    total = videos;
                }
                for (JHMediaModel *model in total) {
                    mediaLike+=model.like_count;
                    mediaComment+=model.comment_count;
                }
                if(i== 5 || i==6 ||i==7){
                    tag.count = (mediaLike/total.count);
                }else{
                    tag.count = (mediaComment/total.count);
                }
                NSLog(@"%ld--------coun--------%ld-------%ld",mediaLike,total.count,mediaComment);
            }
            [arry replaceObjectAtIndex:i withObject:tag];
        }
      
    }
    return arry;

}
-(float)roundFloat:(float)price{
    return (floorf(price*100 + 0.5))/100;
}
//关注相关
-(void)getCommentFollowersCount:(NSArray *)fllowers withFllowings:(NSArray *)flloings succeed:(void (^)(NSInteger data))succeed{
    static NSMutableArray *followerList;
    static NSMutableArray *followingList;
    followerList = [NSMutableArray array];
    followingList = [NSMutableArray array];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    //创建全局并行
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_async(group, queue, ^{
        [self getPkList:fllowers succeed:^(id data) {
            [followerList addObjectsFromArray:data];
            dispatch_semaphore_signal(semaphore);
        }];
    });
    dispatch_group_async(group, queue, ^{
        [self getPkList:flloings succeed:^(id data) {
            [followingList addObjectsFromArray:data];
            dispatch_semaphore_signal(semaphore);
        }];
    });
    dispatch_group_notify(group, queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSPredicate * filterPredicate_same = [NSPredicate predicateWithFormat:@"SELF IN %@",followerList];
        NSArray * filter_no = [followingList filteredArrayUsingPredicate:filterPredicate_same];
        dispatch_async(dispatch_get_main_queue(), ^{
            succeed(filter_no.count);
        });
        
    });
}
- (void)getPkList:(NSArray *)value succeed:(void (^)(id data))succeed{
    NSMutableArray *list = [NSMutableArray array];
    for (NSDictionary *dic in value) {
        long pk = [[dic valueForKey:@"pk"]integerValue];
        [list addObject:[NSString stringWithFormat:@"%ld",pk]];
    }
    succeed(list);
}
//失去的粉丝
-(void)getCancelFollow:(void (^)(id data))succeed{
    JHUserInfoModel *eModel = [JHUserInfoModel unarchive];
    NSArray *followers = eModel.otherFollowerList;
    if (followers.count==0) {
        succeed(nil);
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *follower = [NSMutableArray arrayWithArray:eModel.followerList];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.pk IN %@.pk",followers];
        NSArray *comments = [follower filteredArrayUsingPredicate:predicate];
        if (comments.count>0) {
            [follower removeObjectsInArray:comments];
            NSMutableArray *concel = [NSMutableArray arrayWithArray:eModel.cancelFllowers];
            [concel addObjectsFromArray:follower];
            NSMutableArray *concelModels = [NSMutableArray array];
            for (NSDictionary *dic in concel) {
                JHUserModel *user = [[JHUserModel alloc] initWithObject:dic];
                [concelModels addObject:user];
            }
            eModel.cancelFllowers = concelModels;
            eModel.followerList =followers;
            [eModel archive];
            dispatch_async(dispatch_get_main_queue(), ^{
                succeed(follower);
            });
        }else{
            eModel.followerList =followers;
            [eModel archive];
            dispatch_async(dispatch_get_main_queue(), ^{
                succeed(nil);
            });
        }
    });
    
}
//从数据库获取user
-(NSArray *)getAnylysisUserList:(NSString *)title{
    NSArray *result = [NSArray array];
    if ([title isEqualToString:NSLocalizedString(@"2001", nil)]){
        result = [[[JHCoreDataStackManager shareInstance] getFollwerList] copy];
    }else if ([title isEqualToString:NSLocalizedString(@"2002", nil)]){
        result = [[[JHCoreDataStackManager shareInstance] getFollwingList] copy];
    }else if ([title isEqualToString:NSLocalizedString(@"2003", nil)]){
        result = [[[JHCoreDataStackManager shareInstance] getEachFollowList] copy];
    }else if ([title isEqualToString:NSLocalizedString(@"2004", nil)]){
        result = [[[JHCoreDataStackManager shareInstance] getPraisedList] copy];
    }else if ([title isEqualToString:NSLocalizedString(@"2005", nil)]){
        result = [[[JHCoreDataStackManager shareInstance] getPraisingList] copy];
    }
    return result;
}
//收藏的用户
-(NSArray *)getAnylysisCollectUser{
    NSMutableArray *users = [NSMutableArray array];
    for (JHCollectModel *collect in [JHUserInfoModel unarchive].collectUsers) {
        JHUserModel *model = [[JHUserModel alloc] init];
        model.pk = collect.user.pk;
        model.username = collect.user.username;
        model.full_name = collect.user.full_name;
        model.profile_pic_url = collect.user.profile_pic_url;
        model.care = 1;
        [users addObject:model];
    }
    return users;
}
@end
