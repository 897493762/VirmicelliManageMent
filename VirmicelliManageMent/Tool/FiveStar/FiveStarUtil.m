//
//  FiveStarUtil.m
//  Instagram-fans
//
//  Created by wanglong on 16/8/24.
//  Copyright © 2016年 wanglong. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "NSData+Helper.h"
#import "FiveStarUtil.h"


@implementation FiveStarUtil

+ (void)requestFiveStarEnabled:(void (^)(id))succeed
{
    static BOOL isValid = NO;
    
    if(isValid) {
        if (succeed) {
            succeed(nil);
        }
    }
     NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?v=%d",kFiveASIRequestKey,100+arc4random()%1000]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (connectionError != nil) {//如果不是日语版403
            
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"language"];
            if (succeed) {
                succeed(nil);
            }
            
        }else
        {
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"language"];
            isValid = YES;
            NSDictionary* responseJosn = [[data preData] jsonObject];
            BOOL responseTag = NO;
            if ([responseJosn.allKeys containsObject:kAppVersion]) {
                responseTag = [responseJosn[kAppVersion] boolValue];
            }
            else
            {
                responseTag = [responseJosn[@"else"] boolValue];
            }
            if (responseTag) {
                [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:kEnableFiveStarCommentsKey];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LJNotiShowAd" object:nil];
                [[NSNotificationCenter defaultCenter] addObserver:[UIApplication sharedApplication].delegate selector:NSSelectorFromString(@"onFollowNotification:") name:@"Follow" object:nil];
                if (succeed) {
                    succeed(nil);
                }
                
            }else{
                [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kEnableFiveStarCommentsKey];
                if (succeed) {
                    succeed(nil);
                }
                
            }
        }
        
    }];
}

+(BOOL)fiveStarEnabled {
	return [[NSUserDefaults standardUserDefaults] boolForKey:kEnableFiveStarCommentsKey] == 1;
}

+(void)gotoComment{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreShortURL]];
    
    [[NSUserDefaults standardUserDefaults] setInteger:-2 forKey:kFiveStarCommentsKey];
    [MobClick event:@"review_frequency"];
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"hide"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
@end
