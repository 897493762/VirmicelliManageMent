//
//  WaitingDialog.h
//  Instagram-fans
//
//  Created by 李敏 on 2016/09/08.
//  Copyright © 2016年 wanglong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaitingView : NSObject

@property (strong, nonatomic) NSString *message;

+ (instancetype)createView;

- (void)show;
- (void)showMessage:(NSString *)message;
- (void)showInView:(UIView *)view;
- (void)showInView:(UIView *)view message:(NSString *)message;
- (void)hide;

@end
