//
//  JHBaseOneViewController.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/10/11.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHBaseOneViewController.h"
#import "JHChooseUserMaskView.h"
#import "JHPurchase.h"

#import "JHSearchViewController.h"
#import "JHSetViewController.h"
@interface JHBaseOneViewController ()
@property (nonatomic , assign) BOOL isSelect;
@property (nonatomic , strong) JHChooseUserMaskView *chooseView;

@end

@implementation JHBaseOneViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
   self.navigationController.navigationBar.translucent = NO;//导航栏毛玻璃效果
    self.navigationController.navigationBar.barTintColor = c25510642;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView  = self.titleView;
  
}
#pragma mark - Event
-(void)searchButtonOnclicked:(UIButton *)sender{
    JHSearchViewController *seach = [self.storyboard instantiateViewControllerWithIdentifier:@"JHSearchViewController"];
    seach.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:seach animated:YES];
}
-(void)setButtonOnclicked:(UIButton *)sender{
    JHSetViewController *set = [self.storyboard instantiateViewControllerWithIdentifier:@"JHSetViewController"];
    set.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:set animated:YES];
}
-(void)tapAction:(id)tap
{
    if ([JHAppStatusModel unarchive].isPurchase) {
        if (!self.chooseView.isShow) {
            self.chooseView = [[JHChooseUserMaskView alloc]init];
            self.chooseView.frame =CGRectMake(0, self.navigationBarHight, kScreenWidth, kScreenHeight-self.tabBarHeight);
            [self.chooseView showInView: [UIApplication sharedApplication].keyWindow];
            __weak typeof(self) weakSelf = self;
            self.chooseView.block = ^(NSInteger index) {
                [weakSelf updateUserInfo:index];
            };
        }else{
            [self.chooseView hiddenView];
        }
    }else{
        [self creatPurChaseView];
    }
}
-(void)updateUserInfo:(NSInteger)index{
    if (index == 100) {
        [[JHControllerManager ShareManager] postNotification:ControllerManagerChangeToLoginNotification userInfo:nil];
    }else{
        if (index+1 >0) {
            JHUserInfoModel *currentUser = self.chooseView.dataList[index];
            [currentUser archive];
            [UIView animateWithDuration:0.1 animations:^{
                [self.titleView setContenWithUserName:currentUser.username withIconUrlStr:currentUser.profile_pic_url withNameStrWidth:currentUser.usernameWidth];
            } completion:^(BOOL finished) {
                [self.chooseView hiddenView];
                [[JHControllerManager ShareManager] postNotification:ControllerManagerChangeToHomeNotification userInfo:nil];
            }];

            
        }
    }
}


-(void)creatPurChaseView{
    JHPurchaseView *pur = [[JHPurchaseView alloc] init];
    [pur showInView:[UIApplication sharedApplication].keyWindow];
    __weak JHPurchaseView *weakPur = pur;
    __weak typeof(self) weakself = self;
    pur.returnValueBlock = ^(int value) {
        [weakself showLoadToView:weakPur];
        [[JHPurchase shareInstance] clickPhures:value succeed:^(BOOL data) {
            if (data) {
                [weakself updateMyUserPurseData:^(BOOL data) {
                    [weakself hiddenLoding];
                    [weakPur hiddenView];
                    if (value == 1) {
                        [weakself showAlertViewWithText:NSLocalizedString(@"2084", nil) afterDelay:1];
                    }
                }];
               
            }else{
                [weakself hiddenLoding];
                
                if (value == 1) {
                    [weakself showAlertViewWithText:NSLocalizedString(@"2091", nil) afterDelay:1];
                }else{
                    [weakself showAlertViewWithText:NSLocalizedString(@"2085", nil) afterDelay:1];
                }
            }
        }];
    };
}
#pragma mark -- custom accessors
-(JHUserInfoView *)titleView{
    if (_titleView == nil) {
        _titleView = [[JHUserInfoView alloc] init];
        _titleView.frame =CGRectMake(0, 0, kScreenWidth, 44);
        _titleView.intrinsicContentSize = CGSizeMake(kScreenWidth, 44);
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [_titleView.contanerView addGestureRecognizer:tapGesturRecognizer];
//        [_titleView.searchButton addTarget:self action:@selector(searchButtonOnclicked:) forControlEvents:UIControlEventTouchUpInside];
        [_titleView.setButton addTarget:self action:@selector(setButtonOnclicked:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _titleView;
}
@end
