//
//  JHUsersTableViewCell.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/6.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHUsersTableViewCell.h"

@implementation JHUsersTableViewCell
-(void)setContentWithUserModel:(JHUserInfoModel *)model isSelect:(BOOL)isSelect{
    if (self.model == model) {
        return;
    }
    self.model = model;
    [self.icon sd_setImageWithURL:[NSURL URLWithString: self.model.profile_pic_url] placeholderImage:[UIImage imageNamed:@"img_posts_s"] options:SDWebImageAllowInvalidSSLCertificates];
    self.nameLable.text = self.model.username;
}
-(void)updateViewIsSelect:(BOOL)isSelect{
    if (self.isSelect == isSelect) {
        return;
    }
    self.isSelect = isSelect;
    if (self.isSelect) {
        self.leftButton.hidden = NO;
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(K_RATIO_SIZE(50));
        }];
    }else{
        self.leftButton.hidden = YES;
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@0);
        }];
    }
}
-(void)cellWillLoadSubView{
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.icon];
    [self.containerView addSubview:self.nameLable];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.leftButton];

}
- (void)cellWillLoadAutoLayout{
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.bottom.equalTo(self.contentView);
        make.leading.equalTo(@0);
    }];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(K_RATIO_SIZE(10));
        make.centerY.equalTo(self.containerView);
        make.width.height.equalTo(K_RATIO_SIZE(24));
    }];
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.containerView);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(K_RATIO_SIZE(10));
        make.trailing.equalTo(K_RATIO_SIZE(10));
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.equalTo(self.contentView);
        make.width.equalTo(K_RATIO_SIZE(50));
    }];
}
-(void)leftButtonOnclicked{
    if ([self.delegate respondsToSelector:@selector(userCell:withIndexRow:)]) {
        [self.delegate userCell:self withIndexRow:self.row];
    }
}
#pragma mark - custom accessorse
-(UIView *)containerView{
    if (_containerView == nil) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}
-(UIImageView *)icon{
    if (_icon == nil) {
        _icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_posts_s"]];
        _icon.layer.masksToBounds = YES;
        _icon.layer.cornerRadius = M_RATIO_SIZE(12);
    }
    return _icon;
}
-(UIImageView *)rightIcon{
    if (_rightIcon == nil) {
        _rightIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_check"]];
        _rightIcon.hidden = YES;
    }
    return _rightIcon;
}

-(UIButton *)leftButton{
    if (_leftButton == nil) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setImage:[UIImage imageNamed:@"icon_list_del"] forState:UIControlStateNormal];
        _leftButton.hidden = YES;
        [_leftButton addTarget:self action:@selector(leftButtonOnclicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}
-(UILabel *)nameLable{
    if (_nameLable == nil) {
        _nameLable = [UILabel labelWithText:nil Font:17 Color:[UIColor colorWithR:76 g:79 b:82 alpha:1] Alignment:NSTextAlignmentCenter];
    }
    return _nameLable;
}
-(UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    }
    return _lineView;
}
@end
