//
//  JHNoLoginMaskView.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/7.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHNoLoginMaskView.h"

@implementation JHNoLoginMaskView
- (id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame])
    {
        [self loadSubViews];
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

-(void)showInView:(UIView *)view{
    if (!view)
    {
        return;
    }
    [view addSubview:self];
    self.rootView = view;

}
-(void)hiddenView{
    [UIView animateWithDuration:0.1f
                     animations:^{
                         self.backgrandView.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                     }];
    
}
#pragma mark - IBAction
-(void)buttonONclicked:(UIButton *)sender{
    __weak typeof(self) weakself = self;
    if (weakself.block) {
        weakself.block(1);
    }
}

-(void)loadSubViews{
    self.frame = CGRectMake(0, 0, kScreenWidth, M_RATIO_SIZE(164));
    [self addSubview:self.backgrandView];
    [self.backgrandView addSubview:self.lableOne];
    [self.backgrandView addSubview:self.lableTwo];
    [self.backgrandView addSubview:self.loginButton];
    
    [self.backgrandView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.lableOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(K_RATIO_SIZE(20));
        make.centerX.equalTo(self.backgrandView);
    }];
    [self.lableTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backgrandView);
        make.width.equalTo(K_RATIO_SIZE(345));
        make.top.equalTo(self.lableOne.mas_bottom).offset(M_RATIO_SIZE(14));
    }];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lableTwo.mas_bottom).offset(M_RATIO_SIZE(15));
        make.centerX.equalTo(self.backgrandView);
        make.width.equalTo(K_RATIO_SIZE(118));
        make.height.equalTo(K_RATIO_SIZE(45));
    }];
    self.backgrandView.userInteractionEnabled = YES;
}
#pragma mark - custom accessor
-(UIImageView *)backgrandView{
    if (_backgrandView == nil) {
        _backgrandView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_vip_bg"]];
    }
    return _backgrandView;
}
-(UILabel *)lableOne{
    if (_lableOne == nil) {
        _lableOne = [UILabel createLableTextColor:[UIColor colorWithR:255 g:255 b:255 alpha:1] font:17 numberOfLines:1];
        _lableOne.text = NSLocalizedString(@"2503", nil);
    }
    return _lableOne;
}
-(UILabel *)lableTwo{
    if (_lableTwo == nil) {
        _lableTwo = [UILabel createLableTextColor:[UIColor colorWithR:255 g:255 b:255 alpha:1] font:14 numberOfLines:12];
        _lableTwo.textAlignment = NSTextAlignmentCenter;
        _lableTwo.text = NSLocalizedString(@"2504", nil);
    }
    return _lableTwo;
}
-(UIButton *)loginButton{
    if (_loginButton == nil) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setBackgroundImage:[UIImage imageNamed:@"vip_btn"] forState:UIControlStateNormal];
        [_loginButton setTitle:NSLocalizedString(@"2505", nil) forState:UIControlStateNormal];
        [_loginButton setTitleColor:c255255255 forState:UIControlStateNormal];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:M_RATIO_SIZE(17)];
        _loginButton.userInteractionEnabled = YES;
        [_loginButton addTarget:self action:@selector(buttonONclicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}
@end
