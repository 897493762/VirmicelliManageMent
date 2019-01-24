//
//  JHPurchaseView.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/30.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYTextAttribute.h"
#import "NSAttributedString+YYText.h"
#import "YYText.h"
typedef void (^ReturnValueBlock) (int value);
@interface JHPurchaseView : UIView
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *containerView;

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIImageView *contentOne;
@property (nonatomic, strong) UIImageView *contentTwo;
@property (nonatomic, strong) UIButton *buyButton;
@property (nonatomic, strong) UIImageView *contentThree;
@property (nonatomic, strong) UILabel *lableOne;
@property (nonatomic, strong) YYLabel *lableTwo;

@property (strong, nonatomic) UIView *bottomView;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UILabel *lableFour;
@property (strong, nonatomic) UIScrollView *lableThreeScrollV;
@property (strong, nonatomic) UIView *lableThreeView;
@property (nonatomic, strong) YYLabel *lableThree;
@property(nonatomic, copy) ReturnValueBlock returnValueBlock;

-(void)showInView:(UIView *)view;
-(void)hiddenView;
@end
