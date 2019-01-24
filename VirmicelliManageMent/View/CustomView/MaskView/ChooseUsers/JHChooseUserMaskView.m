//
//  JHChooseUserMaskView.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/6.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHChooseUserMaskView.h"
#import "JHUsersTableViewCell.h"
#import "JHUserinfosModel.h"
@interface JHChooseUserMaskView()
@property (nonatomic, strong) UIButton *footerButton;
@property (nonatomic, assign) NSInteger currentIndex;

@end
@implementation JHChooseUserMaskView

- (id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame])
    {
        [self loadSubView];
    }
    
    return self;
}

-(void)showInView:(UIView *)view{
    if (!view)
    {
        return;
    }
    [view addSubview:self];
    self.isShow = YES;
    
}
-(void)hiddenView{
    self.isShow = NO;
    [UIView animateWithDuration:0.1f
                     animations:^{
                         self.containerView.alpha = 0;
                         self.contentView.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                     }];
    
}
#pragma mark - UITableViewDelegate && UITableViewDetaSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JHUsersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHUsersTableViewCell" forIndexPath:indexPath];
    [cell setContentWithUserModel:self.dataList[indexPath.row] isSelect:NO];
    cell.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFEAE1"];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return M_RATIO_SIZE(44);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.currentIndex = indexPath.row;
    if (self.block) {
        self.block(self.currentIndex);
    }
}

#pragma mark - IBAction
-(void)tapAction:(id)tap
{
    self.currentIndex = -1;
    [self hiddenView];
}
-(void)footerButtonOnclicked:(UIButton *)sender{
    self.currentIndex = 100;
    if (self.block) {
        self.block(self.currentIndex);
    }
    [self hiddenView];
}
#pragma mark - ui
-(void)loadSubView{
    [self addSubview:self.containerView];
    [self addSubview:self.contentView];
    [self addSubview:self.tableView];

    [self setupSubView];
    [self.tableView registerClass:[JHUsersTableViewCell class] forCellReuseIdentifier:@"JHUsersTableViewCell"];
    if (self.dataList.count <=10) {
        self.footerButton.width = kScreenWidth;
        self.footerButton.height = M_RATIO_SIZE(44);
        self.tableView.tableFooterView = self.footerButton;
    }
    self.currentIndex = 100;
}
-(void)setupSubView{
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.width.equalTo(self);
        if (self.dataList.count <=10) {
            make.height.equalTo(@(M_RATIO_SIZE(44)*self.dataList.count+M_RATIO_SIZE(44)));
        }else{
            make.height.equalTo(@(M_RATIO_SIZE(44)*self.dataList.count));
        }
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}
#pragma mark - Custom accessors
-(UIView *)containerView{
    if (_containerView == nil) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor blackColor];
        _containerView.alpha = 0.3;
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [_containerView addGestureRecognizer:tapGesturRecognizer];
    }
    return _containerView;
}
-(UIView *)contentView{
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor colorWithR:245 g:245 b:245 alpha:1];
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
