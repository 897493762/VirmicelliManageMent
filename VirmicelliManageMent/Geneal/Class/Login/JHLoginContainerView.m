//
//  JHLoginContainerView.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/4.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHLoginContainerView.h"
#import "CustomTextField.h"
#import "JHCustomButton.h"

@interface JHLoginContainerView (){
    UIImageView *_selectIcon;
    CustomTextField *_nameTextFiled;
    CustomTextField *_passWordTextFiled;
}
@end

@implementation JHLoginContainerView
-(void)awakeFromNib{
    [super awakeFromNib];
    if (KIsiPhoneX) {
        self.iconTop.constant = M_RATIO_SIZE(36)+88;
    }else{
        self.iconTop.constant = M_RATIO_SIZE(36)+64;
    }
    self.iconWidth.constant = M_RATIO_SIZE(100);
    self.iconHeight.constant = M_RATIO_SIZE(100);
    self.centerViewLeft.constant = M_RATIO_SIZE(10);
    self.centerViewRight.constant = M_RATIO_SIZE(10);
    self.centerViewBottom.constant = M_RATIO_SIZE(155);
    self.centerViewTop.constant = M_RATIO_SIZE(238);
    
    self.loginButtonLeft.constant = M_RATIO_SIZE(15);
    self.loginButtonRight.constant = M_RATIO_SIZE(15);
    self.loginButtonHeight.constant = M_RATIO_SIZE(50);
    self.loginButtonBottom.constant = M_RATIO_SIZE(130);
    
    self.loginButton.layer.masksToBounds = YES;
    self.loginButton.layer.cornerRadius = M_APAD_SIZE(2);
    [self loadCenterSubView];
    self.icon.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = M_RATIO_SIZE(50);
    self.icon.layer.borderWidth = M_RATIO_SIZE(1);
    self.icon.layer.borderColor  = [UIColor colorWithR:252 g:106 b:42 alpha:1].CGColor; //要设置的颜色
    self.icon.backgroundColor = [UIColor whiteColor];
    [self.loginButton setTitle:NSLocalizedString(@"2607", nil) forState:UIControlStateNormal];

}
//ipad适配
-(void)updateIpadViews{
    self.iconTop.constant = M_APAD_SIZE(66)+self.viewcontroller.navigationBarHight;
    self.iconWidth.constant = M_APAD_SIZE(100);
    self.iconHeight.constant = M_APAD_SIZE(100);
    self.centerViewLeft.constant = M_APAD_SIZE(10);
    self.centerViewRight.constant = M_APAD_SIZE(10);
    self.centerViewBottom.constant = M_APAD_SIZE(155);
    self.centerViewTop.constant = M_APAD_SIZE(238);
    self.loginButtonLeft.constant = M_APAD_SIZE(15);
    self.loginButtonRight.constant = M_APAD_SIZE(15);
    self.loginButtonHeight.constant = M_APAD_SIZE(50);
    self.loginButtonBottom.constant = M_APAD_SIZE(130);

    self.loginButton.layer.cornerRadius = M_APAD_SIZE(2);
    self.icon.layer.cornerRadius = M_APAD_SIZE(50);

}
-(void)isRemenber:(BOOL)remember{
    if (remember) {
        JHUserInfoModel *user = [JHUserInfoModel unarchive];
        _nameTextFiled.text = user.username;
        _passWordTextFiled.text = user.password;
    }else{
        _nameTextFiled.text = @"";
        _passWordTextFiled.text = @"";
    }
}
+(instancetype)initView{
    // 封装Xib的加载过程
    return [[NSBundle mainBundle] loadNibNamed:@"JHLoginContainerView" owner:nil options:nil].firstObject;
}
#pragma mark - IBAction

- (IBAction)loginButtonOnclicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(loginView:isRemember:withUserName:withPassWord:)]) {
        [self.delegate loginView:self isRemember:self.rememberButton.selected withUserName:_nameTextFiled.text withPassWord:_passWordTextFiled.text];
    }
}

-(void)signButtonOnclicked:(UIButton *)sender{
    if (sender.selected) {
        _selectIcon.hidden = YES;
    }else{
        _selectIcon.hidden = NO;
    }
    sender.selected =!sender.selected;
}

#pragma mark - custom subview
-(void)loadCenterSubView{
    for (int i=0; i<3; i++) {
        CustomTextField *textfield = [[CustomTextField alloc] init];
        textfield.font = [UIFont systemFontOfSize:16];
        textfield.textColor = [UIColor colorWithR:255 g:255 b:255 alpha:1];
        textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        UIView *view = [[UIView alloc] init];
        [self.centerView addSubview:view];
        [self.centerView addSubview:textfield];
        [textfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@(M_RATIO_SIZE(15)));
            make.trailing.equalTo(@(-M_RATIO_SIZE(15)));
            make.height.equalTo(@(M_RATIO_SIZE(50)));
            make.top.equalTo(@(M_RATIO_SIZE(80)*i));
        }];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(textfield);
        }];
        if (i<2) {
            UIImageView *icon = [[UIImageView alloc] init];
            [self.centerView addSubview:icon];
            [icon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(textfield.mas_leading).offset(M_APAD_SIZE(6));
                make.centerY.equalTo(textfield);
                if (i == 0) {
                    make.width.equalTo(@(M_RATIO_SIZE(20)));
                    make.height.equalTo(@(M_RATIO_SIZE(21)));
                }else{
                    make.width.equalTo(@(M_RATIO_SIZE(16)));
                    make.height.equalTo(@(M_RATIO_SIZE(20)));
                }
            }];
            view.layer.masksToBounds = YES;
            view.layer.cornerRadius = M_RATIO_SIZE(2);
            view.backgroundColor = [UIColor colorWithR:0 g:0 b:0 alpha:0.1];
            if (i==0) {
                textfield.placeholder = NSLocalizedString(@"2784", nil);
                icon.image =[UIImage imageNamed:@"icon_user"];
                _nameTextFiled = textfield;
            }else if (i==1){
                textfield.placeholder = NSLocalizedString(@"2609", nil);
                icon.image =[UIImage imageNamed:@"icon_lock"];
                _passWordTextFiled = textfield;
                _passWordTextFiled.secureTextEntry = YES;
            }
        }
        if (i==2){
            textfield.text = NSLocalizedString(@"2610", nil);
            textfield.userInteractionEnabled = NO;
            JHCustomButton *button = [JHCustomButton createButton];
            self.rememberButton = button;
            button.titleImage.image =[UIImage imageNamed:@"checkbox_bg"];
            button.selected = YES;
            [button addTarget:self action:@selector(signButtonOnclicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.centerView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(textfield);
                make.width.equalTo(@(M_RATIO_SIZE(40)));
                make.leading.equalTo(@(M_RATIO_SIZE(5)));
            }];
            if (IS_PAD) {
                [button setUpCenterImgWid:M_APAD_SIZE(20) WithHeight:M_APAD_SIZE(20)];
            }else{
                [button setUpCenterImgWid:M_RATIO_SIZE(20) WithHeight:M_RATIO_SIZE(20)];
            }
            UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_ccheck"]];
            [button addSubview:icon];
            [icon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(button);
            }];
            _selectIcon = icon;
        }
        textfield.DistanceLeft = M_RATIO_SIZE(40);
    }
}
@end
