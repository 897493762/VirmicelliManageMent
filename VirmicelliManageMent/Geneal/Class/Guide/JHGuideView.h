//
//  JHGuideView.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/14.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnBlock)(NSInteger nextIndex);

@interface JHGuideView : UIView
@property (nonatomic, assign) NSInteger index;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phtoTop;

@property (weak, nonatomic) IBOutlet UILabel *textLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textLableLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textLableBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textLableRight;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextButtonBottom;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *skipWidth;
@property (weak, nonatomic) IBOutlet UIButton *skipTwoButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *skipHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *skipLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextRight;

@property (nonatomic, copy) ReturnBlock block;
@property (nonatomic, assign) BOOL isPush;

+(instancetype)initView;
- (IBAction)nextButtonOnclicked:(UIButton *)sender;

- (IBAction)skipButtonOnclicked:(UIButton *)sender;
@end
