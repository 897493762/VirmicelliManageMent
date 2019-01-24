//
//  UIViewController+TBAddition.h
//  TensWeibo
//
//  Created by MWeit on 16/3/30.
//  Copyright © 2016年 Weit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (TBAddition)
/**
 *  显示网络加载框
 */
- (void)showLoding;

/**
 *  隐藏网络加载框
 */
- (void)hiddenLoding;

/**
 *  显示弹出框
 *
 *  @param text 文字
 */
- (void)showAlertViewWithText:(NSString *)text afterDelay:(NSTimeInterval)delay;

/**
 *  显示弹出框
 *bshowGifToView
 *  @param text 文字
 */
- (void)showSuccessAlertViewWithText:(NSString *)text afterDelay:(NSTimeInterval)delay;
- (void)showAlertViewWithImage:(NSString *)imageName WithTitle:(NSString *)title afterDelay:(NSTimeInterval)delay;
- (void)showLoadToView:(UIView *)view;
- (void)showGifToView:(UIView *)view;

/**
 *  显示网络错误加载框
 */
- (void)showAlertNetworkError;
/**
 *  弹出选择框
 */
- (void)showAlertTitle:(NSString *)title message:(NSString *)message withDefaultTitle:(NSString *)defaultTitle cancelTitle:(NSString *)cancelTitle succeed:(void (^)(int tag))succeed;

-(BOOL)getLoginErrorAlertContent:(NSError *)error withUserName:(NSString *)userName;

@end
