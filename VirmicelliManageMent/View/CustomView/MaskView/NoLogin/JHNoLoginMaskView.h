//
//  JHNoLoginMaskView.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/7.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^NologinBlock) (int value);
@interface JHNoLoginMaskView : UIView
@property (nonatomic, strong)UIImageView *backgrandView;
@property (nonatomic, strong)UILabel *lableOne;
@property (nonatomic, strong)UILabel *lableTwo;
@property (nonatomic, strong)UIButton *loginButton;
@property (nonatomic, strong)UIView *rootView;
@property(nonatomic, copy) NologinBlock block;

-(void)showInView:(UIView *)view;
-(void)hiddenView;
@end
