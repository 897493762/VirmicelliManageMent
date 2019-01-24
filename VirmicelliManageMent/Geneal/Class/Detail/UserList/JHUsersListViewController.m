//
//  JHUsersListViewController.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/7.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHUsersListViewController.h"
#import "JHUsersListTableViewCell.h"
#import "JHPurchaseView.h"
#import "JHPurchase.h"
#import "JHGenealViewController.h"
@interface JHUsersListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSArray *dataArry;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *headerLable;

@property (nonatomic, strong) UIVisualEffectView *HUDView;
@property (nonatomic, assign) int tag;
@property (nonatomic, strong) NSString *columns;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *pk;

@end

@implementation JHUsersListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    if (self.tag == 1 && ![JHAppStatusModel unarchive].isPurchase) {
        self.HUDView.hidden = NO;
        [self creatPurChaseView];
        [MobClick event:@"showPurchase"];
    }
   
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)setContentWithDataList:(NSArray *)dataList withTitle:(NSString *)titleStr withTag:(int)tag{
    self.navigationItem.title = titleStr;
    if (dataList.count > 0) {
        self.dataList = [dataList copy];
    }else{
        self.dataList = [[self getAnylysisUserList:titleStr] copy];
    }
    [self.tableView reloadData];

}
-(void)setContentWithArticleModel:(JHArticleModel *)model{
    self.navigationItem.title = NSLocalizedString(@"2762", nil);
    [self getMediaLikersData:model.pkStr];
}
-(void)setContentWithPk:(NSString *)pk withTitle:(NSString *)title withUsername:(NSString *)username{
    self.navigationItem.title = title;
    if ([title isEqualToString:NSLocalizedString(@"2763", nil)]) {
        [self downloadData:KFollowers(pk)];
    }else if ([title isEqualToString:NSLocalizedString(@"2764", nil)]){
        [self downloadData:KFollowing(pk)];
    }else if ([title isEqualToString:NSLocalizedString(@"2762", nil)]){
        [self downloadData:KMediaLikers(pk)];
    }
}
-(void)getMediaLikersData:(NSString *)pkStr{
    [self showLoadToView:self.view];
    NSString *url = KMediaLikers(pkStr);
    [self downloadData:url];
   
}
-(void)setContentWithAnaTitle:(NSString *)titleStr withTopTitle:(NSString *)topTitle{
    self.tag = 1;
    self.titleStr = titleStr;
    self.navigationItem.title = titleStr;
    [self getAnylysisUserData:self.titleStr withTopTitle:topTitle succeed:^(id data) {
        [self hiddenLoding];
        [self.dataList addObjectsFromArray:data];
        [self.tableView reloadData];
        [self initHeaderView:self.titleStr withCount:self.dataList.count];
    }];

}
-(void)downloadData:(NSString *)url{
    [[JHNetworkManager shareInstance] POST:url dict:nil succeed:^(id data) {
        JHResultResponseModel *response = [[JHResultResponseModel alloc] initWithObject:data];
        if ([response.status isEqualToString:@"ok"]) {
            for (NSDictionary *dic in response.users) {
                JHUserModel *user = [[JHUserModel alloc] initWithObject:dic];
                [self.dataList addObject:user];
            }
            [self.tableView reloadData];
        }
        [self hiddenLoding];
    } failure:^(NSError *error) {
        [self hiddenLoding];
    }];
}
#pragma mark - UITableViewDelegate && UITableViewDetaSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JHUsersListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHUsersListTableViewCell" forIndexPath:indexPath];
    [cell setContentWithFllowing:self.dataList[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return M_RATIO_SIZE(79);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JHGenealViewController *user = [self.storyboard instantiateViewControllerWithIdentifier:@"JHGenealViewController"];
    JHUserModel *model = self.dataList[indexPath.row];
    user.frameVC = 1;
    [user setContentWithPkStr:model.pkStr];
    [self.navigationController pushViewController:user animated:YES];
}

#pragma mark - ui
-(void)loadSubViews{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        if (isEmptyString(self.titleStr)) {
            make.top.equalTo(@0);
        }else{
            make.top.equalTo(K_RATIO_SIZE(48));
        }
    }];
    [self.tableView registerClass:[JHUsersListTableViewCell class] forCellReuseIdentifier:@"JHUsersListTableViewCell"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(followStatusChangeNotification:) name:kFollowStatusChangeNotification object:nil];

}

-(void)followStatusChangeNotification:(NSNotification *)ano{
    self.switchVC = 3;
    [MXGoogleManager shareInstance].switchFollowVCShowAD +=1;
    NSInteger index =[MXGoogleManager shareInstance].switchFollowVCShowAD;
    if (self.isShowInsterstitial && index >=3) {
        [self showInterstitial];
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
        HUDView.frame = CGRectMake(0, M_RATIO_SIZE(100), kScreenWidth, kScreenHeight-M_RATIO_SIZE(100));
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
-(void)initHeaderView:(NSString *)title withCount:(NSInteger)count{
    NSString *countStr = [NSString stringWithFormat:@"%ld",count];
    UIView *view =[[UIView alloc] init];
    UILabel *lableOne = [UILabel labelWithText:title Font:15 Color:[UIColor colorWithHexString:@"#424B57"] Alignment:NSTextAlignmentLeft];
    UILabel *lableTwo = [UILabel labelWithText:countStr Font:15 Color:[UIColor colorWithHexString:@"#FB692A"] Alignment:NSTextAlignmentRight];
    [view addSubview:lableOne];
    [view addSubview:lableTwo];
    [lableOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(K_RATIO_SIZE(9));
        make.centerY.equalTo(view);
    }];
    [lableTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(K_RATIO_SIZE(-30));
        make.centerY.equalTo(view);
    }];
    view.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(K_RATIO_SIZE(48));
    }];
}
@end
