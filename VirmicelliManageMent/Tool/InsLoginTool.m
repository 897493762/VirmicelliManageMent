//
//  InsLoginTool.m
//  InstaSecrets
//
//  Created by liuming on 2018/3/8.
//  Copyright © 2018年 liuming. All rights reserved.
//

#import "InsLoginTool.h"
#import "InsAuthPopView.h"

@interface InsLoginTool()<UIAlertViewDelegate>
@end

static InsLoginTool *loginTool;

@implementation InsLoginTool
+(nonnull instancetype)createLoginTool
{
        if(!loginTool){
            loginTool = [[InsLoginTool alloc] init];

        }
    return loginTool;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    //只进行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loginTool = [super allocWithZone:zone];
    });
    return loginTool;
}

//初始化方法
- (instancetype)init
{
    // 只进行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loginTool = [super init];
    });
    return  loginTool;
}
//copy在底层 会调用copyWithZone:
- (id)copyWithZone:(NSZone *)zone{
    return  loginTool;
}
+ (id)copyWithZone:(struct _NSZone *)zone{
    return  loginTool;
}
+ (id)mutableCopyWithZone:(struct _NSZone *)zone{
    return loginTool;
}
- (id)mutableCopyWithZone:(NSZone *)zone{
    return loginTool;
}

-(void)showAlterViewWithTitle:(NSString *)title  WithLogin:(BOOL)login withCheckpoint_url:(NSString *)checkpoint_url
{
    InsAuthPopView *popView = [[InsAuthPopView alloc]initWithTitle:title];
    __weak typeof(self) weakSelf = self;
    popView.didClickBtn = ^{
        if (login&&![checkpoint_url containsString:@"dismiss"] && checkpoint_url!=nil)
        {//** 跳获取验证码界面  **/
            NSDictionary *dic =@{@"checkpoint_url":checkpoint_url};
            [[JHControllerManager ShareManager] postNotification:ControllerManagerChangeInsCheckNotification userInfo:dic];
        }
        else
        {
            [weakSelf GoToInstagram];
        }
    };
    [popView showPopAlertView];
}
//** 去Instagram */
-(void)GoToInstagram
{
    NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.instagram.com"]];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        [[UIApplication sharedApplication] openURL:instagramURL];
    }
}
-(void)checkPointAction
{

}

@end
