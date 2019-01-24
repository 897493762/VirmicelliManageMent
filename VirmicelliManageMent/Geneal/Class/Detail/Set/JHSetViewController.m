//
//  JHSetViewController.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/10/11.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHSetViewController.h"
#import "JHSetTableViewCell.h"
#import "JHHelpViewController.h"
#import "EmailUtil.h"
#import "JHPurchase.h"
#import "JHPurseProductModel.h"
#import "JHLoginViewController.h"
@interface JHSetViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataList;
@end

@implementation JHSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    [self.tableView registerClass:[JHSetTableViewCell class] forCellReuseIdentifier:@"JHSetTableViewCell"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseStatusChangeNotification:) name:kPurchaseStatusChangeNotification object:nil];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = NSLocalizedString(@"2016", nil);
    [MobClick beginLogPageView:@"set"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"set"];
}
#pragma mark - UITableViewDelegate && UITableViewDetaSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *list = self.dataList[section];
    return list.count+1;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JHSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHSetTableViewCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        NSString *text;
        if (indexPath.section == 0) {
            text =NSLocalizedString(@"2021", nil);
        }else if (indexPath.section == 1){
            text =NSLocalizedString(@"2126", nil);
        }else if (indexPath.section == 2){
            text =NSLocalizedString(@"2023", nil);
        }else{
            text =NSLocalizedString(@"2017", nil);
        }
        [cell setContentText:text tectColor:[UIColor colorWithR:143 g:143 b:143 alpha:1] textFont:[UIFont systemFontOfSize:13] withBackgroundColor:[UIColor whiteColor]];
    }else{
        NSArray *list = self.dataList[indexPath.section];
        NSString *str;
        if (indexPath.section == 1 && [JHAppStatusModel unarchive].isPurchase) {
            JHPurseProductModel *model = [JHPurseProductModel unarchive];
            str = [NSString stringWithFormat:NSLocalizedString(@"2128", nil),model.transactionDateStr];
        }else{
            str =list[indexPath.row-1];
        }
        [cell setContentText:str tectColor:[UIColor colorWithR:107 g:107 b:107 alpha:1] textFont:[UIFont systemFontOfSize:16] withBackgroundColor:[UIColor colorWithR:247 g:247 b:247 alpha:1]];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return M_RATIO_SIZE(49);
    }else{
        return M_RATIO_SIZE(50);
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row >0) {
        NSArray *list = self.dataList[indexPath.section];
        NSString *title = list[indexPath.row-1];
        if ([title isEqualToString:NSLocalizedString(@"2018", nil)]) {
            JHHelpViewController *help = [[JHHelpViewController alloc] init];
            [self.navigationController pushViewController:help animated:YES];
            [MobClick event:@"showAPPHelpInfo"];

        }else if ([title isEqualToString:NSLocalizedString(@"2022", nil)]){
            [self showAlertTitle:NSLocalizedString(@"2028", nil) message:NSLocalizedString(@"2037", nil) withDefaultTitle:NSLocalizedString(@"0001", nil) cancelTitle:NSLocalizedString(@"2029", nil) succeed:^(int tag) {
                if (tag == 2) {
                    JHAppStatusModel *status = [JHAppStatusModel unarchive];
                    status.isLogin = NO;
                    [status archive];
                    [[JHControllerManager ShareManager] postNotification:ControllerManagerChangeToLoginNotification userInfo:nil];
                }
            }];
            [MobClick event:@"logout"];
        }else if ([title isEqualToString:NSLocalizedString(@"2026", nil)]){
            [self showAlertTitle:NSLocalizedString(@"2025", nil) message:NSLocalizedString(@"2038", nil) withDefaultTitle:NSLocalizedString(@"0001", nil) cancelTitle:NSLocalizedString(@"2025", nil) succeed:^(int tag) {
                if (tag == 2) {
                    [self showLoding];
                    [self clearCancelFollow:^(id data) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:kClearCancelFollowChangeNotification object:nil];
                        [self hiddenLoding];
                        
                    }];
                    [MobClick event:@"clearCollectUsers"];
                }
            }];
        }else if ([title isEqualToString:NSLocalizedString(@"2019", nil)]){
            [[EmailUtil getInstance] sendEmail:self];
            [MobClick event:@"toEmail"];
        }else if ([title isEqualToString:NSLocalizedString(@"2082", nil)]){
            [self showLoding];
            [MobClick event:@"returnPurchase"];
            __weak typeof(self) weakself = self;
            [[JHPurchase shareInstance] clickPhures:1 succeed:^(BOOL data) {
                if (data) {
                    [weakself updateMyUserPurseData:^(BOOL data) {
                        [weakself hiddenLoding];
                        [weakself showAlertViewWithText:NSLocalizedString(@"2084", nil) afterDelay:1];
                        [weakself.tableView reloadData];
                    }];
                  
                }else{
                    [weakself hiddenLoding];
                    [weakself showAlertViewWithText:NSLocalizedString(@"2091", nil) afterDelay:1];
                    
                }
            }];
        }
    }
}
-(void)purchaseStatusChangeNotification:(NSNotification *)ano{
    [self.tableView reloadData];
}
-(NSMutableArray *)dataList{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
        for (int i=0; i<4; i++) {
            NSArray *one;
            if (i==0) {
                one = @[NSLocalizedString(@"2022", nil)];
            }else if (i==1){
                one = @[NSLocalizedString(@"2129", nil)];
            }else if (i==2){
                one = @[NSLocalizedString(@"2026", nil)];
            }else{
                one = @[NSLocalizedString(@"2018", nil),NSLocalizedString(@"2019", nil),NSLocalizedString(@"2082", nil)];
            }
            [_dataList addObject:one];
        }
     
    }
    return _dataList;
}
@end
