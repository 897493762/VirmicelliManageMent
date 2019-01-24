//
//  JHUserlikerTableViewCell.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2019/1/7.
//  Copyright © 2019年 Satoshi Nakamoto. All rights reserved.
//

#import "JHUserlikerTableViewCell.h"
#import "JHArticleModel.h"
@implementation JHUserlikerTableViewCell
-(void)setContentWithCollectModel:(JHCollectModel *)model withTile:(NSString *)title{
    if (self.model == model) {
        return;
    }
    self.model = model;
    if ([title isEqualToString:NSLocalizedString(@"2771", nil)]) {
        [self.userIcon sd_setImageWithURL:[NSURL URLWithString:self.model.user.profile_pic_url] placeholderImage:[UIImage imageNamed:@"img_posts_s"] options:SDWebImageAllowInvalidSSLCertificates];
        self.lableOne.text = self.model.user.username;
        self.lableTwo.text = self.model.user.full_name;
    
    }else{
        [self updateSubViewsInTags];
        self.lableOne.text =self.model.tagName;
        
    }
    if (self.model.medias.count>0) {
        [self initPhtos:self.model.medias];
        self.photoView.hidden  = NO;
    }else{
        self.photoView.hidden  = YES;
    }
}
-(void)cellWillLoadSubView{
    [self.contentView addSubview:self.userIcon];
    [self.contentView addSubview:self.lableOne];
    [self.contentView addSubview:self.lableTwo];
    [self.contentView addSubview:self.photoView];
    self.userIcon.backgroundColor = [UIColor redColor];
    self.lableOne.text = @"12333";
    self.lableTwo.text = @"34555";
    [self initPhtos:nil];
    
}
-(void)cellWillLoadAutoLayout{
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(K_RATIO_SIZE(11));
        make.width.height.equalTo(K_RATIO_SIZE(46));
        make.leading.equalTo(K_RATIO_SIZE(10));
    }];
    [self.lableOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.userIcon.mas_trailing).offset(M_RATIO_SIZE(10));
        make.top.equalTo(self.userIcon.mas_top).offset(M_RATIO_SIZE(5));
    }];
    [self.lableTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.lableOne);
        make.top.equalTo(self.lableOne.mas_bottom).offset(M_RATIO_SIZE(5));
        make.trailing.equalTo(K_RATIO_SIZE(-10));
    }];
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userIcon.mas_bottom).offset(M_RATIO_SIZE(11));
        make.leading.trailing.bottom.equalTo(self.contentView);
    }];
    
}
-(void)updateSubViewsInTags{
    self.userIcon.hidden = YES;
    self.lableTwo.hidden = YES;
    [self.lableOne mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(K_RATIO_SIZE(10));
        make.top.equalTo(K_RATIO_SIZE(15));
    }];
    [self.photoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lableOne.mas_bottom).offset(M_RATIO_SIZE(15));
        make.leading.trailing.equalTo(self.contentView);
        make.height.equalTo(K_RATIO_SIZE(123));
    }];
}
-(void)initPhtos:(NSArray *)data{
    if (data.count<=0) {
        return;
    }
    int a =3;
    if (data.count >0 && data.count<a) {
        a =(int)data.count;
    }
    for (int i=0; i<a; i++) {
        JHArticleModel *articleModel = data[i];
        UIImageView *pic = [[UIImageView alloc] init];
        [pic sd_setImageWithURL:[NSURL URLWithString:articleModel.profile_pic_url] placeholderImage:[UIImage imageNamed:@"img_posts_s"] options:SDWebImageAllowInvalidSSLCertificates];
        [self.photoView addSubview:pic];
        [pic mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@(M_RATIO_SIZE(126)*i));
            make.top.equalTo(self.photoView);
            make.width.height.equalTo(K_RATIO_SIZE(123));
        }];
        UIImageView *icon = [[UIImageView alloc] init];
        if (articleModel.media_type == 8 || articleModel.media_type == 2) {
            [self.photoView addSubview:icon];
            [icon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(pic);
                make.width.height.equalTo(K_RATIO_SIZE(32));
            }];
            if (articleModel.media_type == 8) {
                icon.image = [UIImage imageNamed:@"btn_pictures"];
            }else{
                icon.image = [UIImage imageNamed:@"btn_play"];
            }
        }
    }
}

#pragma mark - custom sccessors

-(UIImageView *)userIcon{
    if (_userIcon == nil) {
        _userIcon = [[UIImageView alloc] init];
        _userIcon.layer.masksToBounds = YES;
        _userIcon.layer.cornerRadius = M_RATIO_SIZE(46)/2;
    }
    return _userIcon;
}
-(UILabel *)lableOne{
    if (_lableOne == nil) {
        _lableOne = [UILabel createLableTextColor:[UIColor colorWithR:66 g:75 b:87 alpha:1] font:15 numberOfLines:1];
    }
    return _lableOne;
}
-(UILabel *)lableTwo{
    if (_lableTwo == nil) {
        _lableTwo = [UILabel createLableTextColor:[UIColor colorWithR:161 g:170 b:181 alpha:1] font:13 numberOfLines:0];
    }
    return _lableTwo;
}
-(UIView *)photoView{
    if (_photoView == nil) {
        _photoView = [[UIView alloc] init];
    }
    return _photoView;
}
@end
