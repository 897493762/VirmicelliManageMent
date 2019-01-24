//
//  UIView+JHFrame.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/6.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JHFrame)
@property (assign, nonatomic) CGFloat left;
@property (assign, nonatomic) CGFloat right;
@property (assign, nonatomic) CGFloat top;
@property (assign, nonatomic) CGFloat bottom;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;

- (UIViewController *)viewcontroller;

@end
