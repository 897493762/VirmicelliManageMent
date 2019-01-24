//
//  JHTableViewContanerView.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2019/1/7.
//  Copyright © 2019年 Satoshi Nakamoto. All rights reserved.
//

#import "JHUserLikerContainerView.h"
#import "JHUserlikerTableViewCell.h"
#import "JHCollectModel.h"
#import "JHGenealViewController.h"
#import "JHInsTagViewController.h"
@interface JHUserLikerContainerView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSString *next_max_id;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, strong) NSString *title;

@end

@implementation JHUserLikerContainerView
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
-(void)setContentWithDataList:(NSArray *)dataList withTitle:(NSString *)title{
    if (self.dataList == dataList) {
        return;
    }
    self.dataList = [dataList copy];
    self.title = title;
    [self.tableView reloadData];
}
#pragma mark - UITableViewDelegate && UITableViewDetaSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JHUserlikerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHUserlikerTableViewCell" forIndexPath:indexPath];
    [cell setContentWithCollectModel:self.dataList[indexPath.row] withTile:self.title];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    JHCollectModel *model = self.dataList[indexPath.row];
    if (model.medias.count>0) {
        if ([self.title isEqualToString:NSLocalizedString(@"2771", nil)]) {
            return M_RATIO_SIZE(200);
        }else{
            return M_RATIO_SIZE(153)+17;
        }
    }else{
        if ([self.title isEqualToString:NSLocalizedString(@"2771", nil)]) {
            return M_RATIO_SIZE(67);
        }else{
            return M_RATIO_SIZE(153)+17;

        }
    }
  

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JHCollectModel *model = self.dataList[indexPath.row];
    if ([self.title isEqualToString:NSLocalizedString(@"2771", nil)]) {
        JHGenealViewController *geneal = [self.viewcontroller.storyboard instantiateViewControllerWithIdentifier:@"JHGenealViewController"];
        [geneal setContentWithPkStr:model.user.pkStr];
        [self.viewcontroller.navigationController pushViewController:geneal animated:YES];
    }else{
        JHInsTagViewController *tag = [self.viewcontroller.storyboard instantiateViewControllerWithIdentifier:@"JHInsTagViewController"];
        tag.hidesBottomBarWhenPushed = YES;
        [tag setContentWithTagName:model.tagName];
        [self.viewcontroller.navigationController pushViewController:tag animated:YES];
    }
}
#pragma mark - ui
-(void)loadSubViews{
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.tableView registerClass:[JHUserlikerTableViewCell class] forCellReuseIdentifier:@"JHUserlikerTableViewCell"];
    self.tableView.mj_header = [JHRefreshHeader headerWithRefreshingBlock:^{
        if ([self.title isEqualToString:NSLocalizedString(@"2771", nil)]) {
            self.dataList = [[JHUserInfoModel unarchive].collectUsers copy];
            [self.tableView reloadData];
        }else{
            self.dataList = [[JHUserInfoModel unarchive].collectTags copy];
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
    }];
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

-(NSMutableArray *)dataList{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}


@end
