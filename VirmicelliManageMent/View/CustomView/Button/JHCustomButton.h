//
//  JHCustomButton.h
//  Ganjiuhui
//
//  Created by Wuxiaolian on 16/8/23.
//  Copyright © 2016年 WXL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHCustomButton : UIButton
@property (nonatomic, strong) UIImageView *titleImage;
@property (nonatomic, strong) UILabel *titleLabe;
@property (nonatomic, strong) UILabel *descLable;

+ (instancetype) createButton;
+ (instancetype) createTextButton;
+ (instancetype) createImageButton;

-(void)setContentImage:(NSString *)image withTextStr:(NSString *)text withTextFont:(UIFont *)font WithTextColor:(UIColor *)color;
-(void)setContentIconStr:(NSString *)str withTextStr:(NSString *)text withTextFont:(UIFont *)font WithTextColor:(UIColor *)color;

-(void)setUpLeftImgWithWid:(CGFloat)wid WithHeight:(CGFloat)height WithSpan:(CGFloat)span;
- (void)setUpTopImgWid:(CGFloat )wid WithHeight:(CGFloat)height;
- (void)setUpCenterImgWid:(CGFloat )wid WithHeight:(CGFloat)height;

- (void)updateTopImgWid:(CGFloat )wid WithHeight:(CGFloat)height WithSpan:(CGFloat)span;
- (void)updateImgWid:(CGFloat )wid WithHeight:(CGFloat)height;

-(void)setUpLoginIcon;
-(void)setContentTitleFont:(int)titleFont titleColor:(UIColor *)titleColor withDescFont:(int)descFont descColor:(UIColor *)descColor;
-(void)updateTextView;
@end
