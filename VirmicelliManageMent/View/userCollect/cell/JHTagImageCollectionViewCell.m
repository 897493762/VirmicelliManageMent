//
//  JHTagImageCollectionViewCell.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/12.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHTagImageCollectionViewCell.h"

@implementation JHTagImageCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}
-(void)setContentWithUserModel:(JHUserModel *)model{
    if (self.uModel == model) {
        return;
    }
    self.uModel = model;
    self.nameLable.text = self.uModel.username;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:self.uModel.profile_pic_url] placeholderImage:[UIImage imageNamed:@"img_posts_s"] options:SDWebImageAllowInvalidSSLCertificates];
}
-(void)setContentWithTitleStr:(NSString *)title{
    self.nameLable.text = title;
}
-(void)initSubViews{
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.nameLable];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.width.height.equalTo(K_RATIO_SIZE(54));
        make.top.equalTo(K_RATIO_SIZE(6));
    }];
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self.contentView);
        make.top.equalTo(self.icon.mas_bottom).offset(M_RATIO_SIZE(1));
    }];
    self.icon.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = M_RATIO_SIZE(27);

}

#pragma mark - Custom Accessors
-(UIImageView *)icon{
    if (_icon == nil) {
        _icon = [[UIImageView alloc] init];
    }
    return _icon;
}
-(UILabel *)nameLable{
    if (_nameLable == nil) {
        _nameLable = [UILabel createLableTextColor:[UIColor colorWithR:161 g:170 b:181 alpha:1] font:13 numberOfLines:1];
        _nameLable.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLable;
}
@end
