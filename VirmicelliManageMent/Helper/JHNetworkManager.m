//
//  JHNetworkManager.m
//  WineLine
//
//  Created by Wuxiaolian on 17/2/20.
//  Copyright © 2017年 Wu. All rights reserved.
//

#import "JHNetworkManager.h"
#import "AFNetworking.h"

static JHNetworkManager *networkManager;
static AFHTTPSessionManager *manager;
static NSString *strCSRFToken;

@implementation JHNetworkManager
#pragma mark - single Instance

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!networkManager) {
            networkManager = [[JHNetworkManager alloc] init];
            [networkManager initManager];
        }
    });
    return networkManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!networkManager) {
            networkManager = [super allocWithZone:zone];
            [networkManager initManager];
        }
    });
    return networkManager;
}

- (id)copy {
    return networkManager;
}
-(void)initManager{
    manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:20];
    [self setManagerHeaderFiled:manager];
    
    //允许不进行证书验证
    AFSecurityPolicy *security = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    security.allowInvalidCertificates = YES;
    [security setAllowInvalidCertificates:YES];
    [security setValidatesDomainName:NO];
    manager.securityPolicy = security;
    
}

#pragma mark - Private

/**
 *  封装AFN的GET请求
 *
 *  @param URLString 网络请求地址
 *  @param dict      参数(可以是字典或者nil)
 *  @param succeed   成功后执行success block
 *  @param failure   失败后执行failure block
 */
- (void)GET:(NSString *)URLString dict:(id)dict succeed:(void (^)(id data))succeed failure:(void (^)(NSError *error))failure
{
    NSLog(@"%@----",URLString);
    //创建网络请求管理对象
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:20];

    [manager GET:URLString parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        succeed(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
/**
 *  封装AFN的POST请求
 *
 *  @param URLString 网络请求地址
 *  @param dict      参数(可以是字典或者nil)
 *  @param succeed   成功后执行success block
 *  @param failure   失败后执行failure block
 */
- (void)POST:(NSString *)URLString dict:(id)dict succeed:(void (^)(id data))succeed failure:(void (^)(NSError *error))failure
{
    [self setManagerHeaderFiled:manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%ld", (unsigned long)URLString.length] forHTTPHeaderField:@"Content-Length"];

    //允许不进行证书验证
    AFSecurityPolicy *security = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [security setValidatesDomainName:NO];
    security.allowInvalidCertificates = YES;
    manager.securityPolicy = security;

    [manager POST:URLString parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        succeed(responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
-(void)POSTHash:(NSString *)URLString dict:(id)dict succeed:(void (^)(id))succeed failure:(void (^)(NSError *))failure{
    if (dict) {
        dict= [self makeSignedStringWithDictionary:dict];
    }
    [manager POST:URLString parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        succeed(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
/*
 *登录
 */
-(void)postUserLoginName:(NSString *)userName passWord:(NSString *)passWord isRemember:(BOOL)isRemember succeed:(void (^)(id data))succeed failure:(void (^)(NSError *error))failure{
    NSDictionary *  params = @{
                               @"username" :userName,
                               @"password" :passWord,
                               @"device_id" :[NSString stringWithFormat:@"android-%@",phoneAdId],
                               @"guid" :phoneAdId,
                               };
    if (params) {
        params= [self makeSignedStringWithDictionary:params];
    }
    [manager POST:KUserLogin parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *token;
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            //  从AFNetworking的post请求中获得请求头，该头的格式为NSDictionary
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            //其中operation是指AFHTTPRequestOperation *operation
            NSDictionary *allHeaderFieldDict = [r allHeaderFields];
            //用NSHTTPCookie直接将请求头中的setCookie转成键值对形式的数组，后面用到。另外说下NSHTTPCookie会自动过滤非setCookie的键值对。
            NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:allHeaderFieldDict forURL:[NSURL URLWithString:KUserLogin]];
            //用字符串的形式拿到set-Cookie对应的value
          NSString *setCookie = [allHeaderFieldDict objectForKey:@"Set-Cookie"];
           token =  [self quickLoginMakeCookieWithCookiesArray:cookies withCookieString:setCookie];
            NSLog(@"%@------token",token);
        }

        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        NSDictionary *dicHeaders = [httpResponse allHeaderFields];
        NSString *strResponseCookie = [dicHeaders objectForKey:@"Set-Cookie"];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"csrftoken=(.*)" options:NSRegularExpressionCaseInsensitive error:NULL];
        [regex enumerateMatchesInString:strResponseCookie options:0 range:NSMakeRange(0, [strResponseCookie length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
            NSString *insideString = [strResponseCookie substringWithRange:[match rangeAtIndex:1]];
            NSArray *arrSeparate = [insideString componentsSeparatedByString:@";"];
            strCSRFToken =[arrSeparate firstObject];
        }];

        JHResultResponseModel *response = [[JHResultResponseModel alloc] initWithObject:responseObject];
        if ([response.status isEqualToString:@"ok"]) {
            JHUserInfoModel *user = [[JHUserInfoModel alloc] initWithObject:response.logged_in_user];
            user.password = passWord;
            user.isRemember = isRemember;
            user.strCSRFToken = strCSRFToken;
            user.token = token;
            [user archive];
            [self bg_saveMyinfo:user];
            JHAppStatusModel *status = [JHAppStatusModel unarchive];
            status.isLogin = YES;
            [status archive];
            [MobClick profileSignInWithPUID:[NSString stringWithFormat:@"%ld",user.pk]];
            succeed(user);
        }else{
            NSError *error = [NSError errorWithDomain:response.status code:12 userInfo:nil];
            failure(error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}
/**
 *  其中的需要传入参数在本文第一段中有详细代码
 */
-(NSString *)quickLoginMakeCookieWithCookiesArray:(NSArray *)cookies withCookieString:(NSString *)setCookie {
    NSMutableArray *titleArray = [[NSMutableArray alloc] init];
    for (NSHTTPCookie *cookie in cookies) {
        [titleArray addObject:[NSString stringWithFormat:@"%@=",cookie.name]];
    }
    
    NSMutableString *lastString = [[NSMutableString alloc] init];
    for (NSString *str in titleArray) {
        NSRange tokenRange = [setCookie rangeOfString:str];
        NSInteger beginLoc = tokenRange.location+tokenRange.length;
        NSInteger count = 0;
        for (;;) {
            count++;
            NSString *emunStr = [setCookie substringWithRange:NSMakeRange(beginLoc++, 1)];
            if ([emunStr isEqualToString:@";"]) {
                break;
            }
        }
        NSString *valueString = [setCookie substringWithRange:NSMakeRange(tokenRange.location+tokenRange.length, --count)];
        NSString *resultString = [NSString stringWithFormat:@"%@%@",str,valueString];
        
        if ([str isEqualToString:@"id="]) {
            [lastString appendFormat:@"%@",resultString];
        }
        else {
            [lastString appendFormat:@"; %@",resultString];
        }
    }
    [lastString replaceCharactersInRange:NSMakeRange(0, 2) withString:@""];
    return lastString;
}


/*
 *关注相关
 */
- (void)getFollowersucceed:(void (^)(id data))result{
    static NSArray *follower;
    static NSArray *following;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    //创建全局并行
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group, queue, ^{
        [self getAllFollowerusers:nil withMaxId:nil result:^(id data) {
            follower = data;
            dispatch_semaphore_signal(semaphore);
        }];
    });
    dispatch_group_async(group, queue, ^{
        [self getAllFollowingusers:nil withMaxId:nil result:^(id data) {
            following = data;
            dispatch_semaphore_signal(semaphore);
        }];
    });
    dispatch_group_notify(group, queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        JHUserInfoModel *model = [JHUserInfoModel unarchive];
        model.otherFollowerList = follower;
        [model archive];
        
        
        [self getCommentFollowersCount:follower withFllowings:following succeed:^(NSInteger data) {
            result([NSString stringWithFormat:@"%ld",data]);
        }];
    
    });
}
/*
 *关注我
 */
-(void)getAllFollowerusers:(NSMutableArray *)users withMaxId:(NSString * _Nullable)maxid result:(void (^)(id data))result{
    JHUserRequestModel *request = [[JHUserRequestModel alloc] init];
    request.ig_sig_key_version = @"4";
    request.rank_token =KRank_token;
    request.max_id = maxid;
    NSString *urlStr = [KFollowers([JHUserInfoModel unarchive].pkStr) stringByAppendingString:[request description]];
    [self POST:urlStr dict:nil succeed:^(id data) {
        JHResultResponseModel *response = [[JHResultResponseModel alloc] initWithObject:data];
        NSMutableArray *userList = [NSMutableArray arrayWithArray:users];
        if ([response.status isEqualToString:@"ok"]) {
            [userList addObjectsFromArray:response.users];
            if (!response.more_available) {
                result(userList);
            }else{
                [self getAllFollowerusers:userList withMaxId:response.next_max_id result:^(id data) {
                    result(data);
                }];
            }
            [[JHCoreDataStackManager shareInstance] save:response.users withColum:@"follower" withMore:response.more_available];

        }else{
            result(nil);
        }
    } failure:^(NSError *error) {
        result(nil);
    }];
}
/*
 *我关注
 */
-(void)getAllFollowingusers:(NSMutableArray *)users withMaxId:(NSString * _Nullable)maxid result:(void (^)(id data))result{
    JHUserRequestModel *request = [[JHUserRequestModel alloc] init];
    request.ig_sig_key_version = @"4";
    request.rank_token =KRank_token;
    request.rank_mutual = @"0";
    request.max_id = maxid;
    NSString *urlStr = [KFollowing([JHUserInfoModel unarchive].pkStr) stringByAppendingString:[request description]];
    [self POST:urlStr dict:nil succeed:^(id data) {
        JHResultResponseModel *response = [[JHResultResponseModel alloc] initWithObject:data];
        NSMutableArray *userList = [NSMutableArray arrayWithArray:users];
        if ([response.status isEqualToString:@"ok"]) {
            [userList addObjectsFromArray:response.users];
            if (!response.more_available) {
                result(userList);
            }else{
                [self getAllFollowingusers:userList withMaxId:response.next_max_id result:^(id data) {
                    result(data);
                }];
            }
            [[JHCoreDataStackManager shareInstance] save:response.users withColum:@"following" withMore:response.more_available];

        }else{
            result(nil);
        }
    } failure:^(NSError *error) {
        result(nil);
    }];
}
/*
 *点赞我
 */
- (void)getLikersucceed:(void (^)(NSInteger data))result{
    [self getNoteMaxId:nil users:nil result:^(NSInteger dataCount) {
        result(dataCount);
    }];
}
/*
 *获取帖子
 */
- (void)getNoteMaxId:(NSString * _Nullable)maxid users:(NSMutableArray *)users result:(void (^)(NSInteger dataCount))result{
    JHUserRequestModel *request = [[JHUserRequestModel alloc] init];
    request.max_id = maxid;
    request.ranked_content = @"true";
     NSString *urlStr = [KFeeduser([JHUserInfoModel unarchive].pkStr) stringByAppendingString:[request description]];
    [self POST:urlStr dict:nil succeed:^(id data) {
        JHResultResponseModel *response = [[JHResultResponseModel alloc] initWithObject:data];
        if ([response.status isEqualToString:@"ok"]) {
            JHResultResponseModel *response = [[JHResultResponseModel alloc] initWithObject:data];
            if ([response.status isEqualToString:@"ok"]) {
                NSMutableArray *list = [NSMutableArray arrayWithArray:users];
                NSInteger likerCount = 0;
                for (NSDictionary *dic in response.users) {
                    JHMediaModel *note = [self getNotesDataList:dic];
                    likerCount += note.like_count;
                    [self getNotesCommentsOrLikerData:note];
                    note.big_list = response.more_available;
                    [list addObject:note];
                }
                if (likerCount >99 || !response.more_available) {
                    result(likerCount);
                }
                if (!response.more_available) {
                }else{
                    [self getNoteMaxId:response.next_max_id users:list result:^(NSInteger dataCount) {
                    }];
                }
            }else{
                result(0);
            }
        }
    } failure:^(NSError *error) {
        result(0);
    }];
}
-(void)getNotesCommentsOrLikerData:(JHMediaModel *)note{
    [self getNotesCommentsOrLikers:KMediaComments(note.pk) witthUsers:nil withType:6 withMaxId:nil succeed:^(id data) {
    }];
    [self getNotesCommentsOrLikers:KMediaLikers(note.pk) witthUsers:nil withType:5 withMaxId:nil succeed:^(id data) {
    }];
}
-(void)getNotesCommentsOrLikers:(NSString *)url witthUsers:(NSMutableArray *)users withType:(int)type withMaxId:(NSString *)next_max_id succeed:(void (^)(id data))succeed{
    [self POST:url dict:nil succeed:^(id data) {
        JHResultResponseModel *response = [[JHResultResponseModel alloc] initWithObject:data];
        NSMutableArray *userList = [NSMutableArray arrayWithArray:users];
        if ([response.status isEqualToString:@"ok"]) {
            [userList addObjectsFromArray:response.users];
            succeed(userList);
            
        }else{
            succeed(nil);
        }
      
    } failure:^(NSError *error) {
        succeed(nil);
    }];
}
/*
 *关注、取消关注
 */

-(void)postFollow:(BOOL)isFollow withUserModel:(JHUserModel *)model  succeed:(void (^)(id data))succeed failure:(void (^)(NSError *error))failure{
    NSString *urlStr;
    if (isFollow) {
        urlStr = KCreatFllow(model.pk);
    }else{
        urlStr = KDestroyFloow(model.pk);
    }
    NSDictionary *  params = @{
                               @"_uuid":UniqueIdentifier,
                               @"_uid": [JHUserInfoModel unarchive].pkStr ? [JHUserInfoModel unarchive].pkStr:@"",
                               @"user_id": model.pkStr ? model.pkStr:@"",
                               @"_csrftoken":[JHUserInfoModel unarchive].strCSRFToken ? [JHUserInfoModel unarchive].strCSRFToken:@"",
                               };
    [[JHNetworkManager shareInstance] POSTHash:urlStr dict:params succeed:^(id data) {
        JHCheckResponseModel *response = [[JHCheckResponseModel alloc] initWithObject:data];
        if ([response.status isEqualToString:@"ok"]) {
            BOOL isFollowEach = NO;
            if (model.followEach == 1) {
                isFollowEach = YES;
            }
            if (isFollow) {
                model.following = 1;
                if ([FiveStarUtil fiveStarEnabled]) {
                    [MobClick event:@"follow"];
                }
            }else{
                model.following = 0;
                if ([FiveStarUtil fiveStarEnabled]) {
                    [MobClick event:@"unfollow"];
                }
            }
            if (model.followEach == 1) {
                isFollowEach = YES;
                if ([FiveStarUtil fiveStarEnabled]) {
                    [MobClick event:@"follow_each"];
                }
            }
            [self updateFllower:isFollow withFollowEach:isFollowEach withModel:model];
            succeed(model);
        }else{
            NSError *error = [NSError errorWithDomain:response.status code:12 userInfo:nil];
            failure(error);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}
-(void)postTofollow:(BOOL)isFollow withPk:(long)pk succeed:(void (^)(BOOL data))succeed failure:(void (^)(NSError *error))failure{
    NSString *urlStr;
    if (isFollow) {
        urlStr = KCreatFllow(pk);
    }else{
        urlStr = KDestroyFloow(pk);
    }
    NSDictionary *  params = @{
                               @"_uuid":UniqueIdentifier,
                               @"_uid": [JHUserInfoModel unarchive].pkStr ? [JHUserInfoModel unarchive].pkStr:@"",
                               @"user_id": [NSString stringWithFormat:@"%ld",pk],
                               @"_csrftoken":[JHUserInfoModel unarchive].strCSRFToken ? [JHUserInfoModel unarchive].strCSRFToken:@"",
                               };
    [[JHNetworkManager shareInstance] POSTHash:urlStr dict:params succeed:^(id data) {
        JHCheckResponseModel *response = [[JHCheckResponseModel alloc] initWithObject:data];
        if ([response.status isEqualToString:@"ok"]) {
            succeed(YES);
        }else{
            succeed(NO);

        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}
/*
 *点赞、取消  0
 *收藏、取消。 1
 */
- (void)postStatus:(NSInteger)tag isSelected:(BOOL)select withPk:(NSString *)pk succeed:(void (^)(BOOL data))succeed failure:(void (^)(NSString *error))failure;{
    NSString *url;
    if (tag == 0) {
        if (select) {
            url = KMediaLike(pk);
        }else{
            url = KMediaUnlike(pk);
        }
    }else{
        if (select) {
            url = KMediasave(pk);
        }else{
            url = KMediaUnsave(pk);
        }
    }
   
    [self POST:url dict:nil succeed:^(id data) {
        JHCheckResponseModel *response = [[JHCheckResponseModel alloc] initWithObject:data];
        if ([response.status isEqualToString:@"ok"]) {
            succeed(YES);
        }else{
            succeed(NO);
        }
    } failure:^(NSError *error) {
        failure(error.description);
    }];
}
#pragma mark - Private
// header设置
-(void)setManagerHeaderFiled:(AFHTTPSessionManager *)manager{
    [manager.requestSerializer setTimeoutInterval:20];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"gzip, deflate, sdch" forHTTPHeaderField:@"Accept-Encoding"];
    [manager.requestSerializer setValue:@"3boBAA==" forHTTPHeaderField:@"X-IG-Capabilities"];
    [manager.requestSerializer setValue:@"WIFI" forHTTPHeaderField:@"X-IG-Connection-Type"];
    [manager.requestSerializer setValue:IG_USER_AGENT forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setValue:@"*/*" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"close" forHTTPHeaderField:@"Connection"];
    if ([JHUserInfoModel unarchive].token !=nil) {
        [manager.requestSerializer setValue:[JHUserInfoModel unarchive].token forHTTPHeaderField:@"Cookie"];
    }

}
// 参数加密
- (NSDictionary *)makeSignedStringWithDictionary:(NSDictionary* )dictionary
{
    NSString *strSignedBody = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil] encoding:NSUTF8StringEncoding];
    NSString *strHMAC = [self hmac:strSignedBody withKey:IG_SIG_KEY];
    NSDictionary *dicFinal = @{@"ig_sig_key_version" : IG_SIG_KEY_VERSION,
                               @"signed_body" : [NSString stringWithFormat:@"%@.%@", strHMAC, strSignedBody]};
    return dicFinal;
}

- (void)cancelRequest
{
    if ([manager.tasks count] > 0) {
        NSLog(@"返回时取消网络请求");
        [manager.tasks makeObjectsPerformSelector:@selector(cancel)];
        //NSLog(@"tasks = %@",manager.tasks);
    }
}
@end
