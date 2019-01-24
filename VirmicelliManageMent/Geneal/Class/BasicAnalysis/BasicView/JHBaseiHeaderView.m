//
//  JHBaseiHeaderView.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/28.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHBaseiHeaderView.h"
#import "JHTagContainerView.h"
#import "JHCustomButton.h"
@interface JHBaseiHeaderView ()
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *userInfoView;
@property (nonatomic, strong) UIImageView *userIcon;
@property (nonatomic, strong) JHCustomButton *followButton;
@property (nonatomic, strong) JHCustomButton *followingButton;

@property (nonatomic, strong) JHTagContainerView *tagView;

@property (nonatomic, strong) UIView *statusView;
@property (nonatomic, strong) NSArray *dataList;

@end
@implementation JHBaseiHeaderView

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
#pragma mark - model
-(void)setUserModel:(JHUserInfoModel *)userModel{
    _userModel = userModel;
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:_userModel.profile_pic_url] placeholderImage:[UIImage imageNamed:@"img_posts_s"] options:SDWebImageAllowInvalidSSLCertificates];
    self.followButton.titleLabe.text = [NSString stringWithFormat:@"%ld",(long)_userModel.follower_count];
    self.followingButton.titleLabe.text = [NSString stringWithFormat:@"%ld",(long)_userModel.following_count];
}
-(void)setContentWithDataList:(NSArray *)list{
    [self.tagView setContentWithBsicList:list];
    
}
#pragma mark - IBAction
-(void)buttonsOnclicked:(UIButton *)sender{
    if (self.block) {
        self.block(sender);
    }
}
#pragma mark - ui
-(void)loadSubViews{
    [self addSubview:self.topView];
    [self.topView addSubview:self.userInfoView];
    [self.topView addSubview:self.tagView];
    [self addSubview:self.statusView];
    [self setUpSubViews];
    [self initUserInfoView];
    [self initStatusSubViews];
}
-(void)setUpSubViews{
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.height.equalTo(K_RATIO_SIZE(224));
    }];
    [self.userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.topView);
        make.height.equalTo(K_RATIO_SIZE(138));
    }];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.topView);
        make.height.equalTo(K_RATIO_SIZE(80));
    }];
    [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.height.equalTo(K_RATIO_SIZE(70));
        make.bottom.equalTo(K_RATIO_SIZE(-10));
    }];
}
-(void)initUserInfoView{
    [self.userInfoView addSubview:self.userIcon];
    [self.userInfoView addSubview:self.followButton];
    [self.userInfoView addSubview:self.followingButton];

    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(K_RATIO_SIZE(10));
        make.centerY.equalTo(self.userInfoView);
        make.width.height.equalTo(K_RATIO_SIZE(110));
    }];
    [self.followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.userIcon.mas_trailing).offset(M_RATIO_SIZE(25));
        make.centerY.equalTo(self.userIcon);
        make.width.equalTo(K_RATIO_SIZE(90));
        make.height.equalTo(@(24+13+M_RATIO_SIZE(7)));
    }];
    [self.followingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.width.height.equalTo(self.followButton);
        make.leading.equalTo(self.followButton.mas_trailing).offset(M_RATIO_SIZE(20));
    }];
}
-(void)initStatusSubViews{
    NSArray *titles = @[NSLocalizedString(@"2775", nil),NSLocalizedString(@"2142", nil),NSLocalizedString(@"2117", nil)];
    NSArray *images = @[@"icon_index_stalker",@"icon_index_engineering_gauge",@"icon_index_insight"];

    for (int i=0; i<titles.count; i++) {
        JHCustomButton *button = [JHCustomButton createButton];
        [button setContentIconStr:images[i] withTextStr:titles[i] withTextFont:[UIFont systemFontOfSize:13] WithTextColor:c255255255];
        button.tag = i;
        CGFloat left = M_RATIO_SIZE(10)+M_RATIO_SIZE(120)*i;
        [self.statusView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@(left));
            make.centerY.height.equalTo(self.statusView);
            make.width.equalTo(K_RATIO_SIZE(115));
        }];
        button.width = M_RATIO_SIZE(115);
        button.height = M_RATIO_SIZE(70);
        [button updateTopImgWid:M_RATIO_SIZE(24) WithHeight:M_RATIO_SIZE(24) WithSpan:M_RATIO_SIZE(8)];
        button.backgroundColor = c25510642;
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = M_RATIO_SIZE(5);
        button.tag = i+2;
        [button addTarget:self action:@selector(buttonsOnclicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}
#pragma mark - custom sccessors
-(UIView *)topView{
    if (_topView == nil) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = c25510642;
    }
    return _topView;
}
-(UIView *)userInfoView{
    if (_userInfoView == nil) {
        _userInfoView = [[UIView alloc] init];
        _userInfoView.backgroundColor = c25510642;
    }
    return _userInfoView;
}
-(UIImageView *)userIcon{
    if (_userIcon == nil) {
        _userIcon = [[UIImageView alloc] init];
        _userIcon.layer.masksToBounds = YES;
        _userIcon.layer.cornerRadius = M_RATIO_SIZE(55);
        _userIcon.layer.borderWidth = M_RATIO_SIZE(5);
        _userIcon.layer.borderColor = c255255255.CGColor;
    }
    return _userIcon;
}
-(JHCustomButton *)followButton{
    if (_followButton == nil) {
        _followButton = [JHCustomButton createTextButton];
        [_followButton setContentTitleFont:24 titleColor:c255255255 withDescFont:13 descColor:c255255255];
        _followButton.titleLabe.text = @"0";
        _followButton.descLable.text = NSLocalizedString(@"2150", nil);
        [_followButton addTarget:self action:@selector(buttonsOnclicked:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _followButton;
}
-(JHCustomButton *)followingButton{
    if (_followingButton == nil) {
        _followingButton = [JHCustomButton createTextButton];
        [_followingButton setContentTitleFont:24 titleColor:c255255255 withDescFont:13 descColor:c255255255];
        _followingButton.titleLabe.text = @"0";
        _followingButton.descLable.text = NSLocalizedString(@"2140", nil);
        _followingButton.tag = 1;
        [_followingButton addTarget:self action:@selector(buttonsOnclicked:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _followingButton;
}
-(JHTagContainerView *)tagView{
    if (_tagView == nil) {
        _tagView = [[JHTagContainerView alloc] init];

    }
    return _tagView;
}
-(UIView *)statusView{
    if (_statusView == nil) {
        _statusView = [[UIView alloc] init];
        _statusView.backgroundColor = c255255255;
    }
    return _statusView;
}
@end
