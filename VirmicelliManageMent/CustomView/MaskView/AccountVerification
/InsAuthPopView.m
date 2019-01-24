//
//  InsAuthPopView.m
//  InstaSecrets
//
//  Created by liuming on 2018/3/9.
//  Copyright © 2018年 liuming. All rights reserved.
//

#import "InsAuthPopView.h"
#import "UIButton+Expand.h"
#import "SDAutoLayout.h"
#define titleColor (ICRGBColor(255,255,255))

@interface InsAuthPopView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong)  UIView *white_view;
@property (nonatomic ,strong) UILabel *headTitleLabel;
@property (nonatomic ,strong) UIView *bottomView;
@property (nonatomic ,strong) UILabel *contentLabel;
@property (nonatomic ,strong) UIButton *authButton;

@end
@implementation InsAuthPopView

- (id)initWithTitle:(NSString *)contentTitle

{
    if (self = [super init]) {
        self.alpha = 1.0;
        self.backgroundColor = RGBColor(0, 0, 0, 0.5);
        self.frame=CGRectMake(0, 0,kScreenWidth, kScreenHeight);
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel)];
        tapGesture.delegate = self;
        [self addGestureRecognizer:tapGesture];
        
        [self configUIWithTitle:contentTitle];
        [self configFrame];
        
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if([touch.view isKindOfClass:[self class]]){
        return YES;
    }
    return NO;
}

- (void)showPopAlertView
{
    [UIView animateWithDuration:0.25 animations:^{
        
        UIWindow * window=[UIApplication sharedApplication].keyWindow;
        
        [window addSubview:self];
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)cancel
{
    [UIView animateWithDuration:0.25 animations:^{
        
        [self removeFromSuperview];
        
    } completion:^(BOOL finished) {
        
    }];
}


- (void)configUIWithTitle:(NSString *)title
{
    
    self.white_view = [[UIView alloc]init];
    self.white_view.backgroundColor= titleColor;
    self.white_view.layer.cornerRadius = px(10);
    self.white_view.clipsToBounds = YES;
    [self addSubview:self.white_view];
    
    
    self.headTitleLabel = [UILabel labelWithText:NSLocalizedString(@"5000", nil) Font:17*WidthRatio Color:titleColor Alignment:NSTextAlignmentCenter];
    self.headTitleLabel.layer.cornerRadius = px(10);
    self.headTitleLabel.clipsToBounds = YES;
    self.headTitleLabel.backgroundColor = c49167252;
    [self.white_view addSubview:self.headTitleLabel];
    
    self.bottomView = [[UIView alloc]init];
    self.bottomView.backgroundColor = c49167252;
    [self.white_view addSubview:self.bottomView];
    
    
    self.contentLabel = [UILabel labelWithText:title Font:14*WidthRatio  Color:c444444  Alignment:NSTextAlignmentCenter];
    self. contentLabel.numberOfLines =0;
    [self.white_view addSubview:self.contentLabel];
    
    
    self.authButton = [UIButton addBtnWithTitle:NSLocalizedString(@"2123", nil) WithFont:14*WidthRatio WithTitleColor:c49167252 Target:self Action:@selector(authAction)];
    self.authButton.layer.cornerRadius = px(4);
    self.authButton.clipsToBounds  =YES;
    self.authButton.layer.borderWidth = px(2);
    self.authButton.layer.borderColor = c49167252.CGColor;
    [self.white_view  addSubview:self.authButton];
    
    
    
}

-(void)authAction
{
    [self cancel];
    
    if (self.didClickBtn) {
        self.didClickBtn();
    }
}


- (void)configFrame
{
    
    self.headTitleLabel.sd_layout.leftSpaceToView(self.white_view, 0).rightSpaceToView(self.white_view, 0).topSpaceToView(self.white_view, 0).heightIs(px(68)*HeightRatio);
    
    self.bottomView.sd_layout.leftSpaceToView(self.white_view, 0).rightSpaceToView(self.white_view, 0).topSpaceToView(self.headTitleLabel,-5).heightIs(5*HeightRatio);
    
    NSDictionary *descDic = @{NSFontAttributeName:font(14*WidthRatio)};
    
    CGRect descFrame =  [self.contentLabel.text textRectWithSize:CGSizeMake(px(500)*WidthRatio, MAXFLOAT) attributes:descDic];
    self.contentLabel.sd_layout.widthIs(descFrame.size.width).heightIs(descFrame.size.height+30).centerXEqualToView(self.white_view).topSpaceToView(self.white_view, px(106)*HeightRatio);
    
    self.authButton.sd_layout.widthIs(px(460)*WidthRatio).heightIs(px(90)*HeightRatio).centerXEqualToView(self.white_view).bottomSpaceToView(self.white_view, px(40)*HeightRatio);
    
    self.white_view.sd_layout.widthIs(px(530)*WidthRatio).heightIs((px(106)+px(56)+px(100)+px(40))*HeightRatio+descFrame.size.height+30).centerXEqualToView(self).centerYEqualToView(self);
    
}

@end
