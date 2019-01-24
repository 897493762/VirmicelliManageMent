//
//  JHMainTabViewController.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/4.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHMainTabViewController.h"
@interface JHMainTabViewController ()<UITabBarControllerDelegate>
@property (nonatomic, assign)NSInteger selectItem;
@end

@implementation JHMainTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.barTintColor = [UIColor whiteColor];
    self.tabBar.tintColor =c25510642;
    self.delegate = self;
     [[UITabBar appearance] setTranslucent:NO];
    JHAppStatusModel *myModel = [JHAppStatusModel unarchive];
//    if ([FiveStarUtil fiveStarEnabled] && !kMainDelegate.isFirst){
//        self.selectedIndex = 4;
//    }else{
//        if (myModel.isLogin) {
//            self.selectedIndex = 0;
//        }else{
//            if (kMainDelegate.isReture) {
//                self.selectedIndex = 4;
//            }else{
//                [[JHControllerManager ShareManager] postNotification:ControllerManagerChangeToLoginNotification userInfo:nil];
//            }
//        }
//    }
    
    for (UITabBarItem *item in self.tabBar.items) {
       item.imageInsets = UIEdgeInsetsMake(6, 0, -7, 0);
    }
    if (!myModel.isLogin){
        [[JHControllerManager ShareManager] postNotification:ControllerManagerChangeToLoginNotification userInfo:nil];
    }
    kMainDelegate.isFirst = YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if (self.selectItem != tabBarController.selectedIndex) {
        self.selectItem =tabBarController.selectedIndex;
    }else{
        NSDictionary *dic = @{@"selectedIndex":[NSString stringWithFormat:@"%ld",self.selectItem]};
        [[NSNotificationCenter defaultCenter] postNotificationName:kSelectTabBarItemNotification object:nil userInfo:dic];
    }
}
@end
