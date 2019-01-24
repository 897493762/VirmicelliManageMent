//
//  JHVerificationView.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/11/19.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHVerificationView.h"
#import "CustomTextField.h"
@interface JHVerificationView()
@property (nonatomic, strong) CustomTextField *textfield;
@end
@implementation JHVerificationView
#pragma mark -- public
-(void)showVerificationView{
    
}
-(void)hiddenView{
    [UIView animateWithDuration:0.1f
                     animations:^{
                         self.containerView.alpha = 0;
                         self.contentView.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                     }];
}
#pragma mark - ui
-(void)initView{
    [self addSubview:self.containerView];
    [self addSubview:self.contentView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.equalTo(@(M_RATIO_SIZE(336)));
        make.width.equalTo(@(M_RATIO_SIZE(265)));
    }];
}
-(void)initContentView{
    UILabel *lableOne = [UILabel labelWithText:@"Instagram" Font:17 Color:[UIColor colorWithR:51 g:51 b:51 alpha:1] Alignment:NSTextAlignmentCenter];
    [self.contentView addSubview:lableOne];
    [lableOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(K_RATIO_SIZE(19));
        make.centerX.equalTo(self.contentView);
    }];
}
#pragma mark - IBAction
-(void)tapAction:(id)tap
{
    [self hiddenView];
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
-(CustomTextField *)textfield{
    if (_textfield == nil) {
        _textfield = [[CustomTextField alloc] init];
    }
    return _textfield;
}
@end
