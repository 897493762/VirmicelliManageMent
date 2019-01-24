//
//  JHBaseTwoViewController.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/10/11.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHBaseTwoViewController.h"
#import "JHSearchViewController.h"
#import "JHSetViewController.h"
@interface JHBaseTwoViewController ()

@end

@implementation JHBaseTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:NO];
    self.navigationController.navigationBar.barTintColor =[UIColor whiteColor];
    UIColor *color = [UIColor blackColor];

    NSDictionary *dic = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dic;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:color}];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"top_icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftItemOnClicked)];
    self.navigationItem.leftBarButtonItem.tintColor =color;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

}
- (void)leftItemOnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initHomeNaviItem{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"index_footer_setting_default"] style:UIBarButtonItemStylePlain target:self action:@selector(homeLeftItemOnclicked)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"index_search"] style:UIBarButtonItemStylePlain target:self action:@selector(homeRightItemOnclicked)];
    UIColor *color = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem.tintColor =color;
    self.navigationItem.rightBarButtonItem.tintColor =color;
    self.navigationController.navigationBar.translucent = NO;//导航栏毛玻璃效果
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

-(void)homeLeftItemOnclicked{
    JHSetViewController *set = [self.storyboard instantiateViewControllerWithIdentifier:@"JHSetViewController"];
    set.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:set animated:YES];
}
-(void)homeRightItemOnclicked{
    JHSearchViewController *seach = [self.storyboard instantiateViewControllerWithIdentifier:@"JHSearchViewController"];
    seach.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:seach animated:YES];
}
@end
