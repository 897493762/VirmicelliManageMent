//
//  JHUserInfoView.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/6.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHUserInfoView.h"
#import "JHSearchViewController.h"
@implementation JHUserInfoView

- (id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame])
    {
        [self loadSubViews];
    }
    
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self loadSubViews];

}
-(void)setContenWithUserName:(NSString *)name withIconUrlStr:(NSString *)urlStr withNameStrWidth:(CGFloat)width{
//    [self.icon sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"img_posts_s"] options:SDWebImageAllowInvalidSSLCertificates];
    self.nameLable.text = name;
}
#pragma mark - UI
-(void)loadSubViews{
    [self addSubview:self.contanerView];
//    [self.contanerView addSubview:self.icon];
    [self addSubview:self.selectButton];
    [self addSubview:self.nameLable];
//    [self addSubview:self.searchButton];
    [self addSubview:self.setButton];
    
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.trailing.equalTo(K_RATIO_SIZE(-135));
        make.width.equalTo(K_RATIO_SIZE(12));
        make.height.equalTo(K_RATIO_SIZE(7));
    }];
    
    [self.contanerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.leading.equalTo(self.nameLable);
        make.trailing.equalTo(self.selectButton);
    }];
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.selectButton.mas_leading).offset(-M_RATIO_SIZE(9));
        make.centerY.equalTo(self);
    }];
//    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.contanerView);
//        make.width.height.equalTo(K_RATIO_SIZE(24));
//        make.trailing.equalTo(self.nameLable.mas_leading).offset(M_RATIO_SIZE(-24));
//    }];
  
  
    [self.setButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.centerY.equalTo(self);
        make.width.height.equalTo(K_RATIO_SIZE(47));
    }];

    JHUserInfoModel *model = [JHUserInfoModel unarchive];
    [self setContenWithUserName:model.username withIconUrlStr:model.profile_pic_url withNameStrWidth:model.usernameWidth];
}
-(void)updateSubViews{
    self.setButton.hidden = YES;
    
}
#pragma mark - custom Accessors
-(UIView *)contanerView{
    if (_contanerView == nil) {
        _contanerView = [[UIView alloc] init];
    }
    return _contanerView;
}
//-(UIImageView *)icon{
//    if (_icon == nil) {
//        _icon = [[UIImageView alloc] init];
//        _icon.layer.masksToBounds = YES;
//        _icon.layer.cornerRadius = M_RATIO_SIZE(12);
//    }
//    return _icon;
//}
-(UILabel *)nameLable{
    if (_nameLable == nil) {
        _nameLable = [UILabel labelWithText:nil Font:17 Color:[UIColor colorWithR:255 g:255 b:255 alpha:1] Alignment:NSTextAlignmentCenter];
    }
    return _nameLable;
}

-(UIButton *)selectButton{
    if (_selectButton == nil) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setImage:[UIImage imageNamed:@"index_more"] forState:UIControlStateNormal];
        _selectButton.userInteractionEnabled =NO;
    }
    return _selectButton;
}
//-(UIButton *)searchButton{
//    if (_searchButton == nil) {
//        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_searchButton setImage:[UIImage imageNamed:@"index_search"] forState:UIControlStateNormal];
//        _searchButton.userInteractionEnabled = YES;
//    }
//    return _searchButton;
//        
//}
-(UIButton *)setButton{
    if (_setButton == nil) {
        _setButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_setButton setImage:[UIImage imageNamed:@"icon_setting_white"] forState:UIControlStateNormal];
        _setButton.userInteractionEnabled = YES;

    }
    return _setButton;
}
@end
