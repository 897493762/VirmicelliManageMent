//
//  JHSearchViewController.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/10/8.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHSearchViewController.h"
#import "JHUsersListTableViewCell.h"
#import "CustomTextField.h"
#import "JHGenealViewController.h"
@interface JHSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (strong, nonatomic)  UIView *searchView;
@property (strong, nonatomic)  CustomTextField *searchTextFiled;
@property (strong, nonatomic)  UIImageView *searchIcon;
//tableView
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic)  UIButton *nextButton;
@property (strong,nonatomic) UILabel  *lable;

@property (strong,nonatomic) NSMutableArray  *searchList;

@end

@implementation JHSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = NSLocalizedString(@"2008", nil);
}

/*
 *搜索
 */
-(void)getSerchData:(NSString *)searchText{
    NSString *urlStr = KSearchUser(searchText);
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self showLoding];
    self.searchList = nil;
    [[JHNetworkManager shareInstance] POST:urlStr dict:nil succeed:^(id data) {
        [self hiddenLoding];
        JHResultResponseModel *response = [[JHResultResponseModel alloc] initWithObject:data];
        if ([response.status isEqualToString:@"ok"]) {
            for (NSDictionary *dic in response.users) {
                JHUserModel *user = [[JHUserModel alloc] initWithObject:dic];
                [self.searchList addObject:user];
            }
            [self.tableView reloadData];
        }else{
            [self showAlertViewWithText:response.status afterDelay:1];
        }
    } failure:^(NSError *error) {
        [self hiddenLoding];
        [self showAlertNetworkError];
    }];

}

//设置区域的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.searchList count];
}
//返回单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JHUsersListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHUsersListTableViewCell" forIndexPath:indexPath];
    [cell setContentWithFllowing:self.searchList[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return M_RATIO_SIZE(96);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JHGenealViewController *user = [self.storyboard instantiateViewControllerWithIdentifier:@"JHGenealViewController"];
    JHUserModel *model = self.searchList[indexPath.row];
    user.frameVC = 1;
    [user setContentWithPkStr:model.pkStr];
    [self.navigationController pushViewController:user animated:YES];

}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    [self.nextButton mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.trailing.equalTo(K_RATIO_SIZE(-20));
//    }];
//    [self.searchTextFiled mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@(kScreenWidth-M_RATIO_SIZE(120)));
//    }];
    self.lable.hidden = YES;
    self.nextButton.hidden = NO;

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.searchTextFiled resignFirstResponder];
    NSString *searchString = self.searchTextFiled.text;
    if (isEmptyString(searchString)) {
    }else{
        [self getSerchData:searchString];
        [MobClick event:@"postSearchData"];
    }
    return YES;
}
-(void)cancelButtonOnclieckd{
    self.searchList = nil;
    [self.tableView reloadData];
    [self.searchTextFiled resignFirstResponder];
    self.searchTextFiled.text = @"";
    self.lable.hidden = NO;
    self.nextButton.hidden = YES;
//    [self.nextButton mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.trailing.equalTo(K_RATIO_SIZE(90));
//    }];
//    [self.searchTextFiled mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@(kScreenWidth-M_RATIO_SIZE(40)));
//    }];
}
#pragma mark - ui
-(void)loadSubViews{
    [self.view addSubview:self.searchView];

    [self.searchView addSubview:self.searchTextFiled];
    [self.view addSubview:self.searchIcon];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.nextButton];
    [self.view addSubview:self.lable];

    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self.view);
        make.trailing.equalTo(@0);
        make.height.equalTo(K_RATIO_SIZE(42));
    }];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(K_RATIO_SIZE(-10));
        make.centerY.equalTo(self.searchView);
        make.width.equalTo(K_RATIO_SIZE(62));
        make.height.equalTo(K_RATIO_SIZE(30));
    }];
    [self.searchTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.equalTo(self.searchView);
        make.trailing.equalTo(self.nextButton.mas_leading).offset(M_RATIO_SIZE(-10));
    }];
    [self.searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
       make.leading.equalTo(self.searchTextFiled.mas_leading).offset(M_RATIO_SIZE(9));
        make.centerY.equalTo(self.searchTextFiled);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.searchTextFiled.mas_bottom);
    }];
    [self.lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.searchView);
        make.top.equalTo(self.searchView.mas_bottom).offset(M_RATIO_SIZE(5));
    }];
    self.searchTextFiled.DistanceLeft = M_RATIO_SIZE(44);
    [self.tableView registerClass:[JHUsersListTableViewCell class] forCellReuseIdentifier:@"JHUsersListTableViewCell"];
    self.lable.hidden = YES;
    self.nextButton.hidden = YES;

}

#pragma mark - Custom Accessors
-(UIView *)searchView{
    if (_searchView == nil) {
        _searchView = [[UIView alloc] init];
        _searchView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    }
    return _searchView;
}
-(CustomTextField *)searchTextFiled{
    if (_searchTextFiled == nil) {
        _searchTextFiled = [[CustomTextField alloc] init];
        _searchTextFiled.delegate = self;
        _searchTextFiled.placeholder = NSLocalizedString(@"2144", nil);
        _searchTextFiled.returnKeyType = UIReturnKeySearch;
        _searchTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _searchTextFiled;
}
-(UIImageView *)searchIcon{
    if (_searchIcon == nil) {
        _searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"index_search"]];
    }
    return _searchIcon;
}
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.bounces = NO;
    }
    return _tableView;
}
-(UIButton *)nextButton{
    if (_nextButton == nil) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setTitle:NSLocalizedString(@"0001", nil) forState:UIControlStateNormal];
        _nextButton.titleLabel.font = [UIFont systemFontOfSize:M_RATIO_SIZE(10)];
        [_nextButton setTitleColor:c255255255 forState:UIControlStateNormal];
        _nextButton.backgroundColor = c25210642;
        _nextButton.layer.masksToBounds = YES;
        _nextButton.layer.cornerRadius = M_RATIO_SIZE(2);
        [_nextButton addTarget:self action:@selector(cancelButtonOnclieckd) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}
-(NSMutableArray *)searchList{
    if (_searchList == nil) {
        _searchList = [NSMutableArray array];
    }
    return _searchList;
}
-(UILabel *)lable{
    if (_lable== nil) {
        _lable = [UILabel createLableTextColor:[UIColor colorWithR:107 g:107 b:107 alpha:1] font:20 numberOfLines:0];
        _lable.text = NSLocalizedString(@"2052", nil);
        _lable.textAlignment = NSTextAlignmentCenter;
    }
    return _lable;
}
@end
