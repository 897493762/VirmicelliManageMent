//
//  JHSSearchViewController.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/27.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHSSearchViewController.h"
#import "JHImageCollectionViewCell.h"
#import "JHSearchTitleView.h"
#import "JHMediaViewController.h"
#import "JHSSearchDetailViewController.h"
#import "JHNoteListContainerView.h"
@interface JHSSearchViewController ()
@property (nonatomic, strong) JHSearchTitleView *headerView;
@property (nonatomic, strong) JHNoteListContainerView *contanerView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSString *next_max_id;
@end

@implementation JHSSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self downloadRDiscoverData:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarClickNotification:) name:kSelectTabBarItemNotification object:nil];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.titleView  = self.headerView;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStylePlain target:self action:nil];
}
/*
 搜索带有标签的帖子
 */
- (void)downloadRDiscoverData:(NSString *)next_max_id{
    [[JHNetworkManager shareInstance] POST:KUserDiscover dict:nil succeed:^(id data) {
        JHResultResponseModel *response = [[JHResultResponseModel alloc] initWithObject:data];
        if ([response.status isEqualToString:@"ok"]) {
            NSArray *arry = [self getsearchItemDataList:response.users];
            [self.dataList addObjectsFromArray:arry];
            [self.contanerView setContentWithDataList:self.dataList withMore:response.next_max_id];
        }else{
            [self showAlertViewWithText:response.status afterDelay:1];
        }
    } failure:^(NSError *error) {
        [self showAlertNetworkError];
    }];
}

-(void)tapAction:(id)tap{
    JHSSearchDetailViewController *detail = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"JHSSearchDetailViewController"];
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
}
-(void)tabBarClickNotification:(NSNotification *)ano{
    NSInteger selectIndex = [[ano.userInfo valueForKey:@"selectedIndex"] integerValue];
    if (selectIndex == 2) {
        [self.contanerView.collectionView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }
}
#pragma mark - ui
-(void)loadSubViews{
    [self.view addSubview:self.contanerView];
    [self.contanerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    __weak typeof(self) weakself = self;
    self.contanerView.block = ^(NSInteger status, NSString *next_max_id) {
        if (status == 0) {
            weakself.dataList = nil;
            [weakself downloadRDiscoverData:nil];
        }else{
            [weakself downloadRDiscoverData:next_max_id];
        }
    };
}

#pragma mark - custom accessors
-(JHSearchTitleView *)headerView{
    if (_headerView == nil) {
        _headerView = [[JHSearchTitleView alloc] init];
        _headerView.frame =CGRectMake(0, 0, M_RATIO_SIZE(300), self.naviHeight-M_RATIO_SIZE(14));
        _headerView.intrinsicContentSize = CGSizeMake(M_RATIO_SIZE(300), self.naviHeight-M_RATIO_SIZE(14));
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [_headerView.contanerView addGestureRecognizer:tapGesturRecognizer];
        _headerView.backgroundColor = [UIColor colorWithR:247 g:247 b:247 alpha:1];
    }
    return _headerView;
}
-(JHNoteListContainerView *)contanerView{
    if (_contanerView == nil) {
        _contanerView = [[JHNoteListContainerView alloc] init];
    }
    return _contanerView;
}
-(NSMutableArray *)dataList{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}
@end
