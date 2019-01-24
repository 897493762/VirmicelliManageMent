//
//  UIButton+Expand.h
//  InstaSecrets
//
//  Created by liuming on 2018/3/8.
//  Copyright © 2018年 liuming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Expand)

+(UIButton *)addBtnImage:(NSString *)img  WithTitle:(NSString *)title AndTitleColor:(UIColor *)color AndTitleFont:(CGFloat)font AndImgInsets:(UIEdgeInsets)edgeInset Target:(id)traget AndAction:(SEL)selector;
+(UIButton *)addBtnWithImage:(NSString *)img Title:(NSString *)title AndTitleColor:(UIColor *)color AndTitleFont:(CGFloat)font Target:(id)traget AndAction:(SEL)selector;

+ (UIButton *)addBtnImage:(NSString *)imgName WithTarget:(id)target action:(SEL)action;
+(UIButton *)addBtnWithTitle:(NSString *)title  WithFont:(CGFloat)font WithTitleColor:(UIColor *)color Target:(id)traget Action:(SEL)action;
+(UIButton *)addBgBtnWithBGClor:(UIColor  *)color  Target:(id)traget Action:(SEL)action;

@end
