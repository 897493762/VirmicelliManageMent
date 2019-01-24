//
//  JHAEditorViewController.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2019/1/8.
//  Copyright © 2019年 Satoshi Nakamoto. All rights reserved.
//

#import "JHAEditorViewController.h"
#import "JHUsersTableViewCell.h"
#import "JHUserinfosModel.h"
@interface JHAEditorViewController ()
<UITableViewDelegate,UITableViewDataSource,JHDeletUserDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) UIButton *footerButton;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) BOOL isEdit;

@end

@implementation JHAEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubView];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title  = NSLocalizedString(@"2757", nil);
    if (self.dataList.count>0) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"2758", nil) style:UIBarButtonItemStylePlain target:self action:@selector(rightItemOnclicked)];
        self.navigationItem.rightBarButtonItem.tintColor = c25210642;
    }
    // 某一控制器禁止滑动手势
     self.zf_interactivePopDisabled = YES;
}

#pragma mark - IBAction
-(void)rightItemOnclicked{
    self.isEdit = !self.isEdit;
    if (self.isEdit) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"2759", nil) style:UIBarButtonItemStylePlain target:self action:@selector(rightItemOnclicked)];

    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"2758", nil) style:UIBarButtonItemStylePlain target:self action:@selector(rightItemOnclicked)];

    }
    self.navigationItem.rightBarButtonItem.tintColor = c25210642;
    [self.tableView reloadData];
}
#pragma mark - UITableViewDelegate && UITableViewDetaSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JHUsersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHUsersTableViewCell" forIndexPath:indexPath];
    [cell setContentWithUserModel:self.dataList[indexPath.row] isSelect:NO];
    [cell updateViewIsSelect:self.isEdit];
    cell.row = indexPath.row;
    cell.delegate = self;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return M_RATIO_SIZE(44);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.currentIndex != indexPath.row) {
        self.currentIndex = indexPath.row;
        JHUserInfoModel *currentUser = self.dataList[self.currentIndex];
        [currentUser archive];
        [[JHControllerManager ShareManager] postNotification:ControllerManagerChangeToHomeNotification userInfo:nil];
    }
    [self.tableView reloadData];

}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self showDeletAlert:indexPath.row];
    }
  
}
#pragma mar k - JHDeletUserDelegate
-(void)userCell:(JHUsersTableViewCell *)cell withIndexRow:(NSInteger)row{
    [self showDeletAlert:row];
}
-(void)showDeletAlert:(NSInteger)row{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"2772", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"0001", nil) style:UIAlertActionStyleDefault handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"2774", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.dataList removeObject:self.dataList[row]];
        [self.tableView reloadData];
        [self updateDataList];
    }]];
    
    // 弹出对话框
    [self presentViewController:alert animated:true completion:nil];
}
#pragma mark - IBAction
-(void)footerButtonOnclicked:(UIButton *)sender{
    [[JHControllerManager ShareManager] postNotification:ControllerManagerChangeToLoginNotification userInfo:nil];
}
-(void)updateDataList{
    JHUserinfosModel *userModel = [JHUserinfosModel unarchive];
    [self.dataList addObject:[JHUserInfoModel unarchive]];
    userModel.users = [self.dataList copy];
}
#pragma mark - ui
-(void)loadSubView{
    [self.view addSubview:self.tableView];
    
    [self setupSubView];
    [self.tableView registerClass:[JHUsersTableViewCell class] forCellReuseIdentifier:@"JHUsersTableViewCell"];
    if (self.dataList.count <=10) {
        self.footerButton.width = kScreenWidth;
        self.footerButton.height = M_RATIO_SIZE(44);
        self.tableView.tableFooterView = self.footerButton;
    }
    self.currentIndex = 100;
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    [self.footerButton addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.footerButton);
        make.leading.equalTo(K_RATIO_SIZE(10));
        make.trailing.equalTo(K_RATIO_SIZE(-10));
        make.height.equalTo(@1);
    }];
}
-(void)setupSubView{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark - Custom accessors

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
    }
    return _tableView;
}
-(UIButton *)footerButton{
    if (_footerButton == nil) {
        _footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _footerButton.backgroundColor = [UIColor whiteColor];
        [_footerButton setTitleColor:[UIColor colorWithR:76 g:79 b:82 alpha:1] forState:UIControlStateNormal];
        _footerButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_footerButton setTitle:[NSString stringWithFormat:@"+%@",NSLocalizedString(@"2151", nil)] forState:UIControlStateNormal];
        [_footerButton addTarget:self action:@selector(footerButtonOnclicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerButton;
}
-(NSMutableArray *)dataList{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
        NSArray *arry = [JHUserinfosModel unarchive].users;
        JHUserInfoModel *userModel = [JHUserInfoModel unarchive];
        for (JHUserInfoModel *model in arry) {
            if (userModel.pk != model.pk) {
                [_dataList addObject:model];
            }
        }
        
    }
    return _dataList;
}
@end
