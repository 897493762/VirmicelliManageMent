//
//  JHPurchaseView.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/30.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHPurchaseView.h"

@implementation JHPurchaseView
- (id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame])
    {
        [self loadSubViews];
    }
    
    return self;
}

-(void)showInView:(UIView *)view{
    if (!view)
    {
        return;
    }
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [view addSubview:self];
}
#pragma mark - IBAction
-(void)cancelButtonOnclicked:(UIButton *)sender{
    [self hiddenView];
}
-(void)buyButtonOnclicked:(UIButton *)sender{
    __weak typeof(self) weakself = self;
    if (weakself.returnValueBlock) {
        weakself.returnValueBlock(1);
    }
}
-(void)nextButtonOnclicked:(UIButton *)sender{
    __weak typeof(self) weakself = self;
    if (weakself.returnValueBlock) {
        weakself.returnValueBlock(2);
    }
}
-(void)hiddenView{
    [UIView animateWithDuration:0.1f
                     animations:^{
                         self.bottomView.alpha = 0;
                         self.scrollView.alpha = 0;
                         self.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         [self.scrollView removeFromSuperview];
                         [self.bottomView removeFromSuperview];
                         [self removeFromSuperview];
                     }];
}
#pragma mark - ui
-(void)loadSubViews{
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.containerView];
    [self.containerView addSubview:self.bgImageView];
    [self.containerView addSubview:self.cancelButton];
    [self.containerView addSubview:self.contentOne];
    [self.containerView addSubview:self.contentTwo];
    [self.containerView addSubview:self.contentTwo];
    [self.containerView addSubview:self.buyButton];
    [self.containerView addSubview:self.contentThree];
    [self.contentThree addSubview:self.lableOne];
    [self.contentThree addSubview:self.lableTwo];
    [self addSubview:self.bottomView];
    [self insertTransparentGradient];

    [self addSubview:self.nextButton];
    [self addSubview:self.lableFour];
    [self.bottomView addSubview:self.lableThreeScrollV];
    [self.bottomView addSubview:self.lableThreeScrollV];
    [self.lableThreeScrollV addSubview:self.lableThreeView];
    [self.lableThreeView addSubview:self.lableThree];
    self.backgroundColor = c25210642;

    [self setUpsubViews];
    self.bottomView.backgroundColor = [UIColor whiteColor];
}
-(void)setUpsubViews{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.trailing.equalTo(self);
    }];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.containerView);
        make.width.height.equalTo(K_RATIO_SIZE(40));
        if (KIsiPhoneX) {
            make.top.equalTo(@40);
        }else{
            make.top.equalTo(@20);
        }
    }];
    [self.contentOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cancelButton.mas_top).offset(M_RATIO_SIZE(15));
        make.leading.equalTo(K_RATIO_SIZE(20));
        make.trailing.equalTo(K_RATIO_SIZE(-20));
        make.height.equalTo(K_RATIO_SIZE(122));
    }];
    [self.contentTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentOne.mas_bottom).offset(M_RATIO_SIZE(8));
        make.leading.equalTo(K_RATIO_SIZE(10));
        make.trailing.equalTo(K_RATIO_SIZE(-10));
        make.height.equalTo(K_RATIO_SIZE(1053));
    }];
    [self.buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentTwo.mas_bottom).offset(M_RATIO_SIZE(16));
        make.centerX.equalTo(self.containerView);
    }];
    [self.contentThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buyButton.mas_bottom).offset(M_RATIO_SIZE(13));
        make.leading.trailing.equalTo(self.contentTwo);
        make.bottom.equalTo(self.lableTwo.mas_bottom).offset(M_RATIO_SIZE(20));
    }];
    [self.lableOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(K_RATIO_SIZE(21));
        make.leading.equalTo(K_RATIO_SIZE(20));
    }];
    [self.lableTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lableOne.mas_bottom).offset(M_RATIO_SIZE(10));
        make.leading.equalTo(self.lableOne);
        make.trailing.equalTo(K_RATIO_SIZE(-20));
    }];
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentThree.mas_bottom).offset(M_RATIO_SIZE(172));
    }];
    [self setUpBottomView];
    if([[self currentLanguage] containsString:@"en"]){
        NSLog(@"current Language == English");
        self.contentOne.image= [UIImage imageNamed:@"pay_content_top_en"];
        self.contentTwo.image = [UIImage imageNamed:@"pay_content_en"];
    }else{
        NSLog(@"current Language == jp %@",[self currentLanguage]);
        self.contentOne.image= [UIImage imageNamed:@"pay_content_top_jp"];
        self.contentTwo.image = [UIImage imageNamed:@"pay_content_jp"];
        
    }
}
-(void)setUpBottomView{
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self);
        make.height.equalTo(K_RATIO_SIZE(86));
    }];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView.mas_top);
        make.leading.equalTo(K_RATIO_SIZE(35));
        make.trailing.equalTo(K_RATIO_SIZE(-35));
        make.height.equalTo(K_RATIO_SIZE(52));
    }];
    [self.lableFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.nextButton.mas_bottom).offset(M_RATIO_SIZE(5));
        make.width.equalTo(K_RATIO_SIZE(344));
    }];
    [self.lableThreeScrollV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomView);
        make.top.equalTo(self.lableFour.mas_bottom).offset(M_RATIO_SIZE(10));
        make.width.equalTo(K_RATIO_SIZE(344));
        make.bottom.equalTo(K_RATIO_SIZE(-9));
    }];
    [self.lableThreeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.lableThreeScrollV);
        make.width.equalTo(self.lableThreeScrollV);
    }];
    [self.lableThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.width.equalTo(self.lableThreeView);
    }];
    [self.lableThreeView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.lableThree.mas_bottom).offset(M_RATIO_SIZE(34));
    }];

}

- (void) insertTransparentGradient {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-M_RATIO_SIZE(172), kScreenWidth, M_RATIO_SIZE(91))];
    [self addSubview:view];
    UIColor *colorOne = [UIColor colorWithR:255 g:106 b:42 alpha:0.0];
    UIColor *colorTwo = [UIColor colorWithR:255 g:106 b:42 alpha:0.5];
    UIColor *colorThree = [UIColor colorWithR:255 g:255 b:255 alpha:1.0];

    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor,colorThree.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:0.5];
    NSNumber *stopThree = [NSNumber numberWithFloat:1.0];
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo,stopThree, nil];

    //crate gradient layer
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    headerLayer.frame = view.bounds;
    [view.layer insertSublayer:headerLayer atIndex:0];
}

#pragma mark - custom Accessors

-(UIView *)containerView{
    if (_containerView ==nil) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollEnabled = YES;
    }
    return _scrollView;
}

-(UIImageView *)bgImageView{
    if (_bgImageView == nil) {
        _bgImageView =[[UIImageView alloc] init];
        _bgImageView.backgroundColor = c25210642;
    }
    return _bgImageView;
}
-(UIImageView *)contentOne{
    if (_contentOne == nil) {
        _contentOne= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pay_content_top_jp"]];
    }
    return _contentOne;
}
-(UIImageView *)contentTwo{
    if (_contentTwo == nil) {
        _contentTwo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pay_content_jp"]];
    }
    return _contentTwo;
}
-(UIButton *)cancelButton{
    if (_cancelButton == nil) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonOnclicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}
-(UIButton *)buyButton{
    if (_buyButton == nil) {
        _buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        // 下划线
        NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:NSLocalizedString(@"2082", nil) attributes:attribtDic];
        [_buyButton setAttributedTitle:attribtStr forState:UIControlStateNormal];
        _buyButton.titleLabel.textColor = [UIColor colorWithHexString:@"#FEC885"];
        _buyButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_buyButton addTarget:self action:@selector(nextButtonOnclicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyButton;
}
- (UIImageView *)contentThree{
    if (_contentThree == nil) {
        _contentThree = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Mask"]];
        _contentThree.userInteractionEnabled = YES;

    }
    return _contentThree;
}
-(UILabel *)lableOne{
    if (_lableOne == nil) {
        _lableOne = [UILabel createLableTextColor:[UIColor colorWithR:143 g:148 b:168 alpha:1] font:15 numberOfLines:1];
        _lableOne.text = NSLocalizedString(@"2408", nil);
    }
    return _lableOne;
}
-(YYLabel *)lableTwo{
    if (_lableTwo == nil) {
        _lableTwo = [YYLabel new];
        NSString *text =NSLocalizedString(@"2420", nil);
        _lableTwo.numberOfLines = 0;  //设置多行显示
        _lableTwo.preferredMaxLayoutWidth = kScreenWidth-M_RATIO_SIZE(60); //设置最大的宽度
        _lableTwo.attributedText = [self getAttributedStr:text withColor:[UIColor colorWithR:143 g:148 b:168 alpha:1]];  //设置富文本
        _lableTwo.userInteractionEnabled = YES;
    }
    return _lableTwo;
}

-(UIButton *)nextButton{
    if (_nextButton == nil) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setBackgroundImage:[UIImage imageNamed:@"btn_pay"] forState:UIControlStateNormal];
        [_nextButton setTitle:NSLocalizedString(@"2507", nil) forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(nextButtonOnclicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}
-(UILabel *)lableFour{
    if (_lableFour == nil) {
        _lableFour = [UILabel createLableTextColor:[UIColor colorWithR:207 g:207 b:207 alpha:1] font:12 numberOfLines:0];
        _lableFour.textAlignment = NSTextAlignmentCenter;
        _lableFour.text = NSLocalizedString(@"2508", nil);
    }
    return _lableFour;
}
-(YYLabel *)lableThree{
    if (_lableThree ==nil) {
        _lableThree = [YYLabel new];
        NSString *text =NSLocalizedString(@"2405", nil);
        _lableThree.numberOfLines = 0;  //设置多行显示
        _lableThree.preferredMaxLayoutWidth = M_RATIO_SIZE(344); //设置最大的宽度
        _lableThree.attributedText = [self getAttributedStr:text withColor:[UIColor colorWithR:207 g:207 b:207 alpha:1]];  //设置富文本
    }
    return _lableThree;
}
-(UIView *)bottomView{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] init];
    }
    return _bottomView;
}
-(UIScrollView *)lableThreeScrollV{
    if (_lableThreeScrollV == nil) {
        _lableThreeScrollV = [[UIScrollView alloc] init];
        _lableThreeScrollV.pagingEnabled = YES;
        _lableThreeScrollV.showsHorizontalScrollIndicator = NO;
        _lableThreeScrollV.showsVerticalScrollIndicator = NO;
        _lableThreeScrollV.bounces = NO;
        _lableThreeScrollV.scrollEnabled = YES;
    }
    return _lableThreeScrollV;
}
-(UIView *)lableThreeView{
    if (_lableThreeView == nil) {
        _lableThreeView = [[UIView alloc] init];
    }
    return _lableThreeView;
}
-(NSString*)currentLanguage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLang = [languages objectAtIndex:0];
    return currentLang;
}
-(NSMutableAttributedString *)getAttributedStr:(NSString *)text withColor:(UIColor *)color{
    NSRange rangeOne = [text rangeOfString:NSLocalizedString(@"2406", nil)];
    NSRange rangeTwo = [text rangeOfString:NSLocalizedString(@"2407", nil)];
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc]initWithString:text];
    mutableString.yy_lineSpacing = 0;
    mutableString.yy_font = [UIFont systemFontOfSize:12];
    mutableString.yy_color =color;
    [mutableString yy_setTextHighlightRange:rangeOne color:[UIColor blueColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:termsURL]];
    }];
    [mutableString yy_setTextHighlightRange:rangeTwo color:[UIColor blueColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:privacyPolicyURL]];
    }];
    return mutableString;
}
@end
