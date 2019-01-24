//
//  JHBasicTagCollectionViewCell.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/28.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHBasicTagCollectionViewCell.h"
#import <UIImage+GIF.h>

@implementation JHBasicTagCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        self.contentView.backgroundColor = c25510642;
    }
    return self;
}
-(void)setContentWithTagModel:(JHTagTitleModel *)model{
    if (self.model == model) {
        return;
    }
    self.model = model;
    self.lableOne.text = [NSString stringWithFormat:@"%ld",(long)self.model.count];
    self.lableTwo.text = self.model.title;
    [self.lableOne mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(self.model.tagTopHeight));
    }];
    [self.loadView stopAnimating];
    if (self.model.isRefresh) {
        self.loadView.hidden = YES;
        self.lableOne.hidden = NO;
    }else{
        self.loadView.hidden = NO;
        self.lableOne.hidden = YES;
        [self.loadView startAnimating];
    }
   
}
#pragma mark - ui
-(void)initSubViews{
    [self.contentView addSubview:self.maskView];
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.lableOne];
    [self.containerView addSubview:self.lableTwo];
    [self.containerView addSubview:self.countLable];
    [self.containerView addSubview:self.signIcon];
    [self.containerView addSubview:self.loadView];


    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.lableOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containerView);
    }];
    [self.lableTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lableOne.mas_bottom).offset(M_RATIO_SIZE(2));
        make.leading.equalTo(K_RATIO_SIZE(10));
        make.trailing.equalTo(K_RATIO_SIZE(-10));
    }];
    [self.countLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(K_RATIO_SIZE(-7));
        make.bottom.equalTo(self.lableOne);
    }];
    [self.signIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.countLable.mas_leading);
        make.bottom.equalTo(self.lableOne.mas_top);
        make.width.height.equalTo(K_RATIO_SIZE(13));
    }];
     CGFloat oneHeight = (M_RATIO_SIZE(80)-([@"0" calcTextSizeWith:[UIFont systemFontOfSize:13] totalSize:CGSizeMake((kScreenWidth/3)-M_RATIO_SIZE(20), CGFLOAT_MAX)]+24+M_RATIO_SIZE(4)))/2;
    [self.loadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containerView);
        make.top.equalTo(@(oneHeight));
        make.width.height.equalTo(K_RATIO_SIZE(13));
    }];
    self.countLable.hidden = YES;
    self.signIcon.hidden = YES;
}

#pragma mark - Custom Accessors
-(UIView *)containerView{
    if (_containerView == nil) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}
-(UIView *)maskView{
    if (_maskView == nil) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor colorWithHexString:@"#000000"];
        _maskView.alpha =0.2;
    }
    return _maskView;
}
-(UILabel *)lableOne{
    if (_lableOne == nil) {
        _lableOne = [UILabel createLableTextColor:c255255255 font:24 numberOfLines:1];
        _lableOne.text = @"0";
        _lableOne.textAlignment = NSTextAlignmentCenter;
    }
    return _lableOne;
}
-(UILabel *)lableTwo{
    if (_lableTwo == nil) {
        _lableTwo = [UILabel createLableTextColor:c255255255 font:13 numberOfLines:0];
        _lableTwo.textAlignment = NSTextAlignmentCenter;
    }
    return _lableTwo;
}
-(UILabel *)countLable{
    if (_countLable == nil) {
        _countLable = [UILabel createLableTextColor:c255255255 font:14 numberOfLines:1];
    }
    return _countLable;
}
-(UIImageView *)signIcon{
    if (_signIcon == nil) {
        _signIcon = [[UIImageView alloc] init];
    }
    return _signIcon;
}
-(UIImageView *)loadView{
    if (_loadView == nil) {
        _loadView = [[UIImageView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"refresh" ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        _loadView.image = [UIImage sd_animatedGIFWithData:data];
        _loadView.hidden = YES;
        
        NSMutableArray *animatedImages = [[NSMutableArray alloc] initWithCapacity:10];
        for (int i = 0; i < 11; i++) {
            NSString *animatedImageName = [NSString stringWithFormat:@"icon_loading_%d",i];
            UIImage *animatedImage = [UIImage imageNamed:animatedImageName];
            [animatedImages addObject:animatedImage];
        }
        _loadView.animationImages = animatedImages;
        _loadView.animationRepeatCount = MAXFLOAT;
        _loadView.animationDuration = 10*0.15;
    }
    return _loadView;
}
@end
