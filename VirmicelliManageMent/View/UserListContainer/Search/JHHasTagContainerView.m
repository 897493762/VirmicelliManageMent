//
//  JHHasTagContainerView.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2019/1/3.
//  Copyright © 2019年 Satoshi Nakamoto. All rights reserved.
//

#import "JHHasTagContainerView.h"
#import "JHUsersListTableViewCell.h"
#import "JHTitleTableViewCell.h"
#import "JHTagUserViewController.h"
#import "JHGenealViewController.h"
@interface JHHasTagContainerView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSString *next_max_id;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, assign) NSInteger type;

@end
@implementation JHHasTagContainerView
-(void)awakeFromNib{
    [super awakeFromNib];
    [self loadSubViews];
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self loadSubViews];
    }
    return self;
}
-(void)setContentWithDataList:(NSMutableArray *)dataList withType:(NSInteger)type{
    self.type = type;
    if (self.dataList == dataList) {
        return;
    }
    self.dataList = dataList;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate && UITableViewDetaSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 0) {
        JHUsersListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHUsersListTableViewCell" forIndexPath:indexPath];
        [cell setContentWithUserModel:self.dataList[indexPath.row]];
        return cell;
    }else{
        JHTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHTitleTableViewCell" forIndexPath:indexPath];
        cell.nameLable.text = [NSString stringWithFormat:@"#%@",self.dataList[indexPath.row]];
        return cell;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 0) {
        return M_RATIO_SIZE(96);

    }else{
        return M_RATIO_SIZE(48);

    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 0) {
        JHGenealViewController *user = [self.viewcontroller.storyboard instantiateViewControllerWithIdentifier:@"JHGenealViewController"];
        JHUserModel *model = self.dataList[indexPath.row];
        [user setContentWithPkStr:model.pkStr];
        [self.viewcontroller.navigationController pushViewController:user animated:YES];
    }else{
        JHTagUserViewController *user = [self.viewcontroller.storyboard instantiateViewControllerWithIdentifier:@"JHTagUserViewController"];
        [user setContentWithNameText:self.dataList[indexPath.row]];
        [self.viewcontroller.navigationController pushViewController:user animated:YES];
    }
    
}
#pragma mark - ui
-(void)loadSubViews{
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.tableView registerClass:[JHUsersListTableViewCell class] forCellReuseIdentifier:@"JHUsersListTableViewCell"];
    [self.tableView registerClass:[JHTitleTableViewCell class] forCellReuseIdentifier:@"JHTitleTableViewCell"];
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
        _tableView.backgroundColor = [UIColor colorWithR:245 g:245 b:245 alpha:1];
    }
    return _tableView;
}

-(NSMutableArray *)dataList{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}
@end
