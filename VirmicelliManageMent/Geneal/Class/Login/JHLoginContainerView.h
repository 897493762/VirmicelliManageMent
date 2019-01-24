//
//  JHLoginContainerView.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/4.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JHLoginContainerView;
@protocol JHLoginContainerViewDelegate <NSObject>
-(void)loginView:(JHLoginContainerView *)view isRemember:(BOOL)remember withUserName:(NSString *)userName withPassWord:(NSString *)password;
@end
@interface JHLoginContainerView : UIView

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconTop;

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconWidth;

@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerViewLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerViewRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerViewTop;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginButtonLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginButtonRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginButtonBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginButtonHeight;

@property (nonatomic, strong) UIButton *rememberButton;
@property(weak, nonatomic)id<JHLoginContainerViewDelegate>delegate;
+(instancetype)initView;
-(void)isRemenber:(BOOL)remember;
- (IBAction)loginButtonOnclicked:(UIButton *)sender;


@end
