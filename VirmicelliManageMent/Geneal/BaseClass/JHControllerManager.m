//
//  JHControllerManager.m
//  TestDemo
//
//  Created by Satoshi Nakamoto on 2018/9/3.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHControllerManager.h"
#import "JHMainTabViewController.h"
#import "JHLoginViewController.h"
#import "InsCheckPointViewController.h"
#import "JHGuideViewController.h"

@implementation JHControllerManager
+ (instancetype)ShareManager {
    
    
    
    static JHControllerManager *controllerManager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        controllerManager = [[JHControllerManager alloc] initManager];
        
    });
    
    
    
    return controllerManager;
    
    
    
}

- (instancetype)initManager {
    
    
    
    self = [super init];
    
    if (self) {
        
        //     注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recevieNoticatGuide:) name:ControllerManagerChangeGuideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotificatHome:) name:ControllerManagerChangeToHomeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recevieNoticatLogin:) name:ControllerManagerChangeToLoginNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recevieNoticatIns:) name:ControllerManagerChangeInsCheckNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recevieNoticatPush:) name:ControllerManagerChangePushNotification object:nil];

    }
    
    return self;
    
}
- (void)postNotification:(NSString *)name userInfo:(NSDictionary * )info {
    NSLog(@"%@-------",name );
    //  发布通知

    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:info];
    
    
    
}
- (void)recevieNoticatPush:(NSNotification *)notification{
    if ([[notification name] isEqualToString:ControllerManagerChangePushNotification]){
        UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        JHGuideViewController *login =[storyBoard instantiateViewControllerWithIdentifier:@"JHGuideViewController"];
        login.isPush = YES;
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:login];
        kMainDelegate.window.rootViewController = navi;
        navi.navigationBar.backgroundColor = [UIColor whiteColor];
        kMainDelegate.window.backgroundColor = [UIColor whiteColor];
        [kMainDelegate.window makeKeyAndVisible];
    }
}
//如果为登录状态，则keywindow为你的主控制器

- (void)receiveNotificatHome:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:ControllerManagerChangeToHomeNotification]) {
        UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        kMainDelegate.window.rootViewController = [storyBoard instantiateInitialViewController];
        kMainDelegate.window.backgroundColor = [UIColor whiteColor];
        [kMainDelegate.window makeKeyAndVisible];
        [MobClick event:@"SwitchMainTab"];
    }
}

//如果不为登录状态则，则到登录界面，keywindow为登录界面，或者你需要让他去的界面
-(void)recevieNoticatLogin:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:ControllerManagerChangeToLoginNotification]) {
        UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        JHLoginViewController *login =[storyBoard instantiateViewControllerWithIdentifier:@"JHLogin"];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:login];
        kMainDelegate.window.rootViewController = navi;
        navi.navigationBar.backgroundColor = [UIColor whiteColor];
        kMainDelegate.window.backgroundColor = [UIColor whiteColor];
        [kMainDelegate.window makeKeyAndVisible];
        [MobClick event:@"SwitchLogin"];

    }
}
-(void)recevieNoticatGuide:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:ControllerManagerChangeGuideNotification]) {
        UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        JHGuideViewController *login =[storyBoard instantiateViewControllerWithIdentifier:@"JHGuideViewController"];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:login];
        kMainDelegate.window.rootViewController = navi;
        navi.navigationBar.backgroundColor = [UIColor whiteColor];
        kMainDelegate.window.backgroundColor = [UIColor whiteColor];
        [kMainDelegate.window makeKeyAndVisible];
   }
    
}
-(void)recevieNoticatIns:(NSNotification *)notification
{   if ([[notification name] isEqualToString:ControllerManagerChangeInsCheckNotification]) {
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    InsCheckPointViewController *login =[storyBoard instantiateViewControllerWithIdentifier:@"InsCheckPointViewController"];
    NSDictionary *dic = notification.userInfo;
    login.checkPointUrl = [dic objectForKey:@"checkpoint_url"];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:login];
    kMainDelegate.window.rootViewController = navi;
    navi.navigationBar.backgroundColor = [UIColor whiteColor];
    kMainDelegate.window.backgroundColor = [UIColor whiteColor];
    [kMainDelegate.window makeKeyAndVisible];
    [MobClick event:@"SwitchInsCheckPoint"];
}
    
}

- (void)dealloc

{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end
