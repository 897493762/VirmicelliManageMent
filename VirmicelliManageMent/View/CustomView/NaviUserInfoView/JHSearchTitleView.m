//
//  JHSearchTitleView.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/27.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHSearchTitleView.h"

@implementation JHSearchTitleView
-(id)initWithFrame:(CGRect)frame
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

#pragma mark - UI
-(void)loadSubViews{
    [self addSubview:self.contanerView];
    [self.contanerView addSubview:self.icon];
    [self.contanerView addSubview:self.lable];
    
    [self.contanerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(K_RATIO_SIZE(105));
        make.centerY.equalTo(self.contanerView);
        make.width.height.equalTo(K_RATIO_SIZE(22));
        
    }];
    [self.lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contanerView);
        make.leading.equalTo(self.icon.mas_trailing).offset(M_RATIO_SIZE(8));
    }];
}

#pragma mark - custom Accessors
-(UIView *)contanerView{
    if (_contanerView == nil) {
        _contanerView = [[UIView alloc] init];
    }
    return _contanerView;
}
-(UIImageView *)icon{
    if (_icon == nil) {
        _icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_search_search"]];
    }
    return _icon;
}
-(UILabel *)lable{
    if (_lable == nil) {
        _lable = [UILabel createLableTextColor:[UIColor colorWithR:161 g:170 b:181 alpha:1] font:15 numberOfLines:1];
        _lable.text = NSLocalizedString(@"2144", nil);

    }
    return _lable;
}

@end
