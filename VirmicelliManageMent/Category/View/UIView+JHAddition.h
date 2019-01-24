//
//  UIView+JHAddition.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/4.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JHAddition)
/*
 * 添加圆角
 */
-(void)addCornerRadiusToView:(UIView *)view cornerRadius:(CGFloat)cornerRadius;

/*
 * 添加阴影、圆角
 */
- (void)addShadowInView:(UIView *)superView
            ToView:(UIView *)view
            withOpacity:(float)shadowOpacity
           shadowRadius:(CGFloat)shadowRadius
           shadowOffset:(CGSize)shadowOffset
        andCornerRadius:(CGFloat)cornerRadius;

/*
 * 添加阴影
 */
- (void)addShadowView:(UIView *)view
            withOpacity:(float)shadowOpacity
           shadowRadius:(CGFloat)shadowRadius
           shadowOffset:(CGSize)shadowOffset
        andBackgroundColor:(UIColor *)backgroundColor
          shadowColor:(UIColor *)shadowColor;

/**
 *  显示网络加载框
 */
- (void)showGifToView:(UIView *)view;
/**
 *  隐藏网络加载框
 */
- (void)hiddenLoding;

/**
 *  显示网络加载框
 */
- (void)showLodingInView:(UIView *)view;
@end
