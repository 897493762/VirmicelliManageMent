//
//  JHFootprintViewController.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/7.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHAnalysisViewController.h"
#import "JHUsersListTableViewCell.h"
#import "JHNoLoginMaskView.h"
#import "JHPurseProductModel.h"
#import "JHPurchase.h"
#import "JHTitleTableViewCell.h"
#import "JHUsersListViewController.h"
#import "JHNotesListViewController.h"
#import "JHGenealViewController.h"
@interface JHAnalysisViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIVisualEffectView *HUDView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) UILabel *headerLable;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) JHNoLoginMaskView *noLoginView;
@property (nonatomic, strong) NSArray *titles;

@end

@implementation JHAnalysisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self showNologin];
    if ([self.titleStr isEqualToString:NSLocalizedString(@"2141", nil)]) {
        [self showLoding];
        [self updateDataListsucceed:^(BOOL data) {
            [self hiddenLoding];
        }];
    }else if([self.titleStr isEqualToString:NSLocalizedString(@"2117", nil)] || ([self.titleStr isEqualToString:NSLocalizedString(@"2113", nil)]&& self.frameVC == 1)){
        self.frameVC = 1;
        [self getAnylysisDatas:self.titleStr succeed:^(NSArray *titles, NSArray *dataList) {
            self.titles = titles;
            self.dataList = [dataList copy];
            [self.tableView reloadData];
        }];
      
    }else{
        self.frameVC = 0;
        self.dataList = [[self getAnylysisTitles:self.titleStr] copy];
        [self.tableView reloadData];
    }
    
}
-(void)setContentWithTitle:(NSString *)title{
    self.navigationItem.title = title;
    self.titleStr = title;
}
#pragma mark - UITableViewDelegate && UITableViewDetaSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.titleStr isEqualToString:NSLocalizedString(@"2141", nil)]) {
        return 1;
    }else{
        if (self.frameVC == 1) {
            return self.titles.count;
        }else{
            return 1;
        }
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.titleStr isEqualToString:NSLocalizedString(@"2141", nil)]) {
        return self.dataList.count;
    }else{
        if (self.frameVC == 1) {
            NSArray *arry = self.dataList[section];
            return arry.count;
        }else{
            return self.dataList.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.titleStr isEqualToString:NSLocalizedString(@"2141", nil)]) {
        JHUsersListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHUsersListTableViewCell" forIndexPath:indexPath];
        [cell setContentWithFllowing:self.dataList[indexPath.row]];
        return cell;
    }else{
        JHTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHTitleTableViewCell" forIndexPath:indexPath];
        if (self.frameVC == 1) {
            [cell showRightIcon:self.dataList[indexPath.section][indexPath.row]];
        }else{
            [cell showRightIcon:self.dataList[indexPath.row]];
        }
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.titleStr isEqualToString:NSLocalizedString(@"2141", nil)]) {
        return M_RATIO_SIZE(100);
    }else{
        return M_RATIO_SIZE(50);
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.titleStr isEqualToString:NSLocalizedString(@"2141", nil)]) {
        JHGenealViewController *user = [self.storyboard instantiateViewControllerWithIdentifier:@"JHGenealViewController"];
        JHUserModel *model = self.dataList[indexPath.row];
        [user setContentWithPkStr:model.pkStr];
        user.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:user animated:YES];
        [MobClick event:@"SwitchUserDetail"];
    }else if([self.titleStr isEqualToString:NSLocalizedString(@"2142", nil)]&& self.frameVC ==0){
        JHAnalysisViewController *sis = [self.storyboard instantiateViewControllerWithIdentifier:@"JHAnalysisViewController"];
        sis.frameVC = 1;
        [sis setContentWithTitle:self.dataList[indexPath.row]];
        [self.navigationController pushViewController:sis animated:YES];
    }else{
        if ([JHAppStatusModel unarchive].isPurchase) {
            if ([self.titleStr isEqualToString:NSLocalizedString(@"2117", nil)]) {
                JHNotesListViewController *user = [self.storyboard instantiateViewControllerWithIdentifier:@"JHNotesListViewController"];
                user.hidesBottomBarWhenPushed = YES;
                [user setContentWithAnaTitle:self.dataList[indexPath.section][indexPath.row] withTopTitle:self.titles[indexPath.section]];
                [self.navigationController pushViewController:user animated:YES];
            }else{
                JHUsersListViewController *foot = [self.storyboard instantiateViewControllerWithIdentifier:@"JHUsersListViewController"];
                if (self.frameVC == 1) {
                    [foot setContentWithAnaTitle:self.dataList[indexPath.section][indexPath.row] withTopTitle:self.titles[indexPath.section]];
                }else{
                    [foot setContentWithAnaTitle:self.dataList[indexPath.row] withTopTitle:self.titleStr];
                }
                [self.navigationController pushViewController:foot animated:YES];
            }
        }else{
            [self creatPurChaseView];

        }
       
      
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    if ([self.titleStr isEqualToString:NSLocalizedString(@"2141", nil)]) {
        return view;
    }else{
        if (self.frameVC == 1) {
            view.backgroundColor = [UIColor colorWithR:247 g:247 b:247 alpha:1];
            UILabel *lable = [UILabel labelWithText:self.titles[section] Font:13 Color:[UIColor colorWithHexString:@"#A1AAB5"] Alignment:NSTextAlignmentLeft];
            [view addSubview:lable];
            [lable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(K_RATIO_SIZE(10));
                make.centerY.equalTo(view);
            }];
            return view;
        }else{
            return view;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([self.titleStr isEqualToString:NSLocalizedString(@"2141", nil)]) {
        return 0;
    }else{
        if (self.frameVC == 1) {
            return M_RATIO_SIZE(20)+13;
        }else{
            return 0;
        }
    }
}

#pragma mark - ui
-(void)loadSubViews{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(@0);
    }];
    [self.tableView registerClass:[JHUsersListTableViewCell class] forCellReuseIdentifier:@"JHUsersListTableViewCell"];
    [self.tableView registerClass:[JHTitleTableViewCell class] forCellReuseIdentifier:@"JHTitleTableViewCell"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseStatusChangeNotification:) name:kPurchaseStatusChangeNotification object:nil];
}
#pragma mark -- 通知
-(void)purchaseStatusChangeNotification:(NSNotification *)ano{
    [self showNologin];
}

-(void)updateDataListsucceed:(void (^)(BOOL data))succeed{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *arry = [[JHCoreDataStackManager shareInstance] getMyFollwerList];
        self.dataList = [arry copy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            succeed(YES);
        });
    });
}
-(void)showNologin{
    if (![JHAppStatusModel unarchive].isPurchase) {
        if ([self.titleStr isEqualToString:NSLocalizedString(@"2141", nil)]) {
            self.HUDView.hidden = NO;
        }
        if (!self.noLoginView) {
            self.noLoginView = [[JHNoLoginMaskView alloc] init];
            [self.noLoginView showInView:self.view];
            __weak typeof(self) weakself = self;
            self.noLoginView.block = ^(int value) {
                [weakself creatPurChaseView];
            };
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(K_RATIO_SIZE(164));
            }];
        }
        
    }else{
        self.HUDView.hidden = YES;
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
        }];
        if (self.noLoginView) {
            [self.noLoginView hiddenView];
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
#pragma mark - Custom Accessors
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
    }
    return _tableView;
}

-(UIVisualEffectView *)HUDView{
    if (_HUDView == nil) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *HUDView = [[UIVisualEffectView alloc] initWithEffect:blur];
        HUDView.alpha = 0.98f;
        HUDView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [self.view addSubview:HUDView];
        _HUDView = HUDView;
        _HUDView.hidden = YES;
    }
    return _HUDView;
}
-(NSMutableArray *)dataList{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}
@end
