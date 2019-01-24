//
//  JHMediaCommentsViewController.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/3.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHMediaCommentsViewController.h"
#import "JHCommentModel.h"
#import "JHCommentTableViewCell.h"
#import "SDAutoLayout.h"

@interface JHMediaCommentsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@end

@implementation JHMediaCommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = NSLocalizedString(@"2761", nil);
}
-(void)setContentWithArticleModel:(JHArticleModel *)model{
    [self getMediaLikersData:model.pkStr];
}
-(void)getMediaLikersData:(NSString *)pkStr{
    [self showLoadToView:self.view];
    NSString *url = KMediaComments(pkStr);
    [[JHNetworkManager shareInstance] POST:url dict:nil succeed:^(id data) {
        JHResultResponseModel *response = [[JHResultResponseModel alloc] initWithObject:data];
        if ([response.status isEqualToString:@"ok"]) {
            for (NSDictionary *dic in response.users) {
                JHCommentModel *user = [[JHCommentModel alloc] initWithObject:dic];
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
    JHCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHCommentTableViewCell" forIndexPath:indexPath];
    cell.model = self.dataList[indexPath.row];
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    JHCommentModel *model = self.dataList[indexPath.row];

    return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[JHCommentTableViewCell class] contentViewWidth:kScreenWidth];
}

#pragma mark - ui
-(void)loadSubViews{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableView registerClass:[JHCommentTableViewCell class] forCellReuseIdentifier:@"JHCommentTableViewCell"];
    
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
