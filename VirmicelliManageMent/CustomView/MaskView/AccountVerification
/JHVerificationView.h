//
//  JHVerificationView.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/11/19.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHVerificationView : UIView
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *containerView;
-(void)showVerificationView;
-(void)hiddenView;

@end
