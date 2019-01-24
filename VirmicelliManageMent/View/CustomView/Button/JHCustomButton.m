//
//  JHCustomButton.m
//  Ganjiuhui
//
//  Created by Wuxiaolian on 16/8/23.
//  Copyright © 2016年 WXL. All rights reserved.
//

#import "JHCustomButton.h"
@implementation JHCustomButton

+ (instancetype)createButton
{
    JHCustomButton *btn = [self buttonWithType:UIButtonTypeCustom];
    [btn loadButton];
    return btn;
}
+(instancetype)createTextButton{
    JHCustomButton *btn = [self buttonWithType:UIButtonTypeCustom];
    [btn initTextButton];
    return btn;
}
+ (instancetype) createImageButton{
    JHCustomButton *btn = [self buttonWithType:UIButtonTypeCustom];
    [btn initImageButton];
    return btn;
}
#pragma mark -- 赋值
-(void)setContentImage:(NSString *)image withTextStr:(NSString *)text withTextFont:(UIFont *)font WithTextColor:(UIColor *)color{
    [self.titleImage sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"img_posts_s"] options:SDWebImageAllowInvalidSSLCertificates];
    self.titleLabe.textColor = color;
    self.titleLabe.font = font;
    self.titleLabe.text = text;
}
-(void)setContentIconStr:(NSString *)str withTextStr:(NSString *)text withTextFont:(UIFont *)font WithTextColor:(UIColor *)color{
    self.titleImage.image = [UIImage imageNamed:str];
    self.titleLabe.textColor = color;
    self.titleLabe.font = font;
    self.titleLabe.text = text;
}
-(void)setContentTitleFont:(int)titleFont titleColor:(UIColor *)titleColor withDescFont:(int)descFont descColor:(UIColor *)descColor{
    self.titleLabe.font = [UIFont systemFontOfSize:titleFont];
    self.titleLabe.textColor = titleColor;
    self.descLable.font = [UIFont systemFontOfSize:descFont];
    self.descLable.textColor = descColor;
}

#pragma mark - UI
- (void) loadButton
{
    [self addSubview:self.titleImage];
    [self addSubview:self.titleLabe];    
    [self.titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
    }];
    
    [self.titleLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
    }];
    
}
-(void)initTextButton{
    [self addSubview:self.titleLabe];
    [self addSubview:self.descLable];
    [self.titleLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self);
    }];
    
    [self.descLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.equalTo(self);
    }];
}
-(void)updateTextView{
    [self.titleLabe mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self);
    }];
    
    [self.descLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.centerX.equalTo(self);
    }];
}
-(void)initImageButton{
    [self addSubview:self.titleImage];
    [self.titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}
-(void)setUpLeftImgWithWid:(CGFloat)wid WithHeight:(CGFloat)height WithSpan:(CGFloat)span{
    CGFloat widd = [self.titleLabe.text calcTextSizeWithWidth:self.titleLabe.font totalSize:CGSizeMake(self.width, self.height)];
    CGFloat left =(self.width-wid-widd-span)/2;
    if (span <=0) {
        left = 0;
    }
    [self.titleImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.equalTo(@(wid));
        make.height.equalTo(@(height));
        make.leading.equalTo(@(left));
    }];
    [self.titleLabe mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.trailing.equalTo(@(-left));
    }];
}
-(void)setUpTopImgWid:(CGFloat)wid WithHeight:(CGFloat)height{
    [self.titleImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(self);
        make.width.equalTo(@(wid));
        make.height.equalTo(@(height));
    }];

    [self.titleLabe mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.equalTo(self);
    }];

}
-(void)updateTopImgWid:(CGFloat)wid WithHeight:(CGFloat)height WithSpan:(CGFloat)span{
    CGFloat hh = [self.titleLabe.text calcTextSizeWith:self.titleLabe.font totalSize:CGSizeMake(self.width, self.height)];
    CGFloat top =(self.height-height-hh-span)/2;
    if (span <=0) {
        top = 0;
    }
    [self.titleImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.equalTo(@(wid));
        make.height.equalTo(@(height));
        make.top.equalTo(@(top));
    }];
    [self.titleLabe mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(@(-top));
    }];
    self.titleLabe.textAlignment = NSTextAlignmentCenter;
}
-(void)setUpCenterImgWid:(CGFloat)wid WithHeight:(CGFloat)height{
    [self.titleImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(@(wid));
        make.height.equalTo(@(height));
    }];
}
- (void)updateImgWid:(CGFloat )wid WithHeight:(CGFloat)height{
    [self.titleImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(wid));
        make.height.equalTo(@(height));
    }];
}
-(void)setUpLoginIcon{
    [self.titleImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.equalTo(K_RATIO_SIZE(33));
        make.width.height.equalTo(K_RATIO_SIZE(24));
    }];
    
    [self.titleLabe mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.equalTo(self.titleImage.mas_trailing).offset(M_RATIO_SIZE(36));
    }];
}
#pragma mark - Custom Access
- (UIImageView *)titleImage
{
    if(!_titleImage)
    {
        _titleImage = [[UIImageView alloc] init];
    }
    return _titleImage;
}

- (UILabel *)titleLabe
{
    if(!_titleLabe)
    {
        _titleLabe = [[UILabel alloc] init];
        [_titleLabe sizeToFit];
        
    }
    return _titleLabe;
}
-(UILabel *)descLable{
    if (_descLable == nil) {
        _descLable = [UILabel createLableTextColor:c255255255 font:15 numberOfLines:1];
        _descLable.textAlignment = NSTextAlignmentCenter;
    }
    return _descLable;
}
@end
