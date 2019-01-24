//
//  JHLoginViewController.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/4.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHLoginViewController.h"
#import "JHBasicViewController.h"
#import "JHLoginContainerView.h"
#import "JHUserInfoModel.h"
#import <AdSupport/AdSupport.h>
#import "InsLoginTool.h"
@interface JHLoginViewController ()<JHLoginContainerViewDelegate>
@property (nonatomic, strong)JHLoginContainerView *containerView;
@property (nonatomic, strong)NSString *userName;
@property (nonatomic, strong)NSString *password;
@property (nonatomic, assign)int isRemember;
@property (nonatomic, assign)BOOL isCheck;
@property (nonatomic, strong)NSString *checkUser;
@property (nonatomic, strong)NSString *checkPass;
@end

@implementation JHLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    if ([JHAppStatusModel unarchive].isLogin) {
        [self creatCancelButton];
    }
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [MobClick beginLogPageView:@"login"];

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"login"];
}
-(void)showCancelButton{
    [self creatCancelButton];
    [_containerView isRemenber:NO];
}

#pragma mark - postData
-(void)postUserLogin{
    [self showLoding];
    [[JHNetworkManager shareInstance] postUserLoginName:self.userName passWord:self.password isRemember:self.isRemember succeed:^(id data) {
        JHAppStatusModel *status = [JHAppStatusModel unarchive];
        status.isLogin = YES;
        [status archive];
        [[JHControllerManager ShareManager] postNotification:ControllerManagerChangeToHomeNotification userInfo:nil];
        [self hiddenLoding];
        if (self.isCheck &&(self.password == self.checkPass) && (self.userName == self.checkUser)) {
            if ([FiveStarUtil fiveStarEnabled]) {
                [MobClick event:@"confirmsuccessed"];
            }
            self.isCheck = NO;
        }else{
            if ([FiveStarUtil fiveStarEnabled]) {
                [MobClick event:@"login"];
            }
        }
        if ([FiveStarUtil fiveStarEnabled]) {
            [MobClick event:@"login_oktimes"];
        }

    } failure:^(NSError *error) {
        [self hiddenLoding];
        self.checkPass = self.password;
        self.checkUser = self.userName;
        self.isCheck =[self getLoginErrorAlertContent:error withUserName:self.userName];
        if ([FiveStarUtil fiveStarEnabled]) {
            [MobClick event:@"confirm"];
        }
    }];

}
#pragma mark - JHLoginContainerViewDelegate{
-(void)loginView:(JHLoginContainerView *)view isRemember:(BOOL)remember withUserName:(NSString *)userName withPassWord:(NSString *)password{
    if (isEmptyString(userName)) {
        [self showAlertViewWithText:@"账号不能为空！" afterDelay:1];
    }else{
        if (isEmptyString(password)) {
            [self showAlertViewWithText:@"密码不能为空！" afterDelay:1];
        }else{
            self.userName = userName;
            self.password = password;
            self.isRemember = remember;
            if([self isUserName:userName]||[self validateEmail:userName]){
                [self postUserLogin];
            }else{
                [self showAlertViewWithText:NSLocalizedString(@"5002", nil) afterDelay:1];
            }
        }
    }
}
-(void)cancelButtonOnclicked:(UIButton *)sender{
    kMainDelegate.isReture = YES;
    [[JHControllerManager ShareManager] postNotification:ControllerManagerChangeToHomeNotification userInfo:nil];
}
-(void)loadSubViews{
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(void)creatCancelButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.equalTo(self.view);
        make.width.equalTo(K_RATIO_SIZE(66));
        make.height.equalTo(@(M_RATIO_SIZE(16)+self.navigationBarHight));
    }];
    [button addTarget:self action:@selector(cancelButtonOnclicked:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma  mark - custom accessorse
-(JHLoginContainerView *)containerView{
    if (_containerView == nil) {
        _containerView = [JHLoginContainerView initView];
        _containerView.delegate = self;
        [_containerView isRemenber:[JHUserInfoModel unarchive].isRemember];
    }
    return _containerView;
}
- (BOOL)isUserName:(NSString*)username{
    NSString *      regex = @"([A-Za-z0-9_.]+)";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:username];
}

-(BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[a-zA-Z0-9_]{3,12}@[a-zA-Z0-9]+(\\.[a-zA-Z]+){1,3}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
@end
