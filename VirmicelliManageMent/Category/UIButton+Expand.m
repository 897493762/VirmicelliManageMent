//
//  UIButton+Expand.m
//  InstaSecrets
//
//  Created by liuming on 2018/3/8.
//  Copyright © 2018年 liuming. All rights reserved.
//

#import "UIButton+Expand.h"

@implementation UIButton (Expand)
+(UIButton *)addBtnImage:(NSString *)img  WithTitle:(NSString *)title AndTitleColor:(UIColor *)color AndTitleFont:(CGFloat)font AndImgInsets:(UIEdgeInsets)edgeInset Target:(id)traget AndAction:(SEL)selector
{
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setImageEdgeInsets:edgeInset];
    btn.titleLabel.font =[UIFont systemFontOfSize:font];
    UIImage *image = [[UIImage imageNamed:img] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:traget action:selector forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
+(UIButton *)addBtnWithImage:(NSString *)img Title:(NSString *)title AndTitleColor:(UIColor *)color AndTitleFont:(CGFloat)font Target:(id)traget AndAction:(SEL)selector
{
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font =[UIFont systemFontOfSize:font];
    UIImage *image = [[UIImage imageNamed:img] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:traget action:selector forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
+ (UIButton *)addBtnImage:(NSString *)imgName WithTarget:(id)target action:(SEL)action
{
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}
+(UIButton *)addBtnWithTitle:(NSString *)title  WithFont:(CGFloat)font WithTitleColor:(UIColor *)color Target:(id)traget Action:(SEL)action
{
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font =[UIFont boldSystemFontOfSize:font];
    [btn addTarget:traget action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

+(UIButton *)addBgBtnWithBGClor:(UIColor  *)color  Target:(id)traget Action:(SEL)action
{
    UIButton *bgBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    
    bgBtn.backgroundColor =color;
    
    [bgBtn  addTarget:traget action:action forControlEvents:UIControlEventTouchUpInside];
    
    return bgBtn;
    
}
@end
