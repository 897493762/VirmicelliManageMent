//
//  JHGenealOtherHeader.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2019/1/7.
//  Copyright © 2019年 Satoshi Nakamoto. All rights reserved.
//

#import "JHGenealOtherHeader.h"
#import "JHCustomButton.h"
#import "JHGenealViewController.h"
#import "JHUsersListViewController.h"
@interface JHGenealOtherHeader ()
@property (nonatomic, strong) UIImageView *userIcon;
@property (nonatomic, strong) UILabel *lableOne;
@property (nonatomic, strong) UILabel *lableTwo;
@property (nonatomic, strong) UIButton *upButton;

@property (nonatomic, strong) JHCustomButton *postButton;
@property (nonatomic, strong) JHCustomButton *followButton;
@property (nonatomic, strong) JHCustomButton *followingButton;
@property (nonatomic, strong) JHUserInfoModel *myModel;

@end

@implementation JHGenealOtherHeader
-(void)awakeFromNib{
    [super awakeFromNib];
    [self loadSubViews];
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self loadSubViews];
    }
    return self;
}
-(void)setContentWithUserInfo:(JHUserInfoModel *)model{
    if (self.myModel == model) {
        return;
    }
    self.myModel = model;
    self.lableOne.text = self.myModel.username;
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:self.myModel.profile_pic_url] placeholderImage:[UIImage imageNamed:@"img_posts_s"] options:SDWebImageAllowInvalidSSLCertificates];
    self.followButton.titleLabe.text = [NSString stringWithFormat:@"%ld",(long)self.myModel.follower_count];
    self.followingButton.titleLabe.text = [NSString stringWithFormat:@"%ld",(long)self.myModel.following_count];
    self.postButton.titleLabe.text = [NSString stringWithFormat:@"%ld",(long)self.myModel.media_count];
    self.lableTwo.text = self.myModel.full_name;

}
-(void)setContentWithFollow:(BOOL)isFollow{
    self.upButton.selected =isFollow;
    [self changeButtonStatus:self.upButton];
}

#pragma mark - IBAction
-(void)buttonOnclicked:(UIButton *)sender{
    sender.selected = !sender.selected;
    [self friendshipStatusChange:sender.selected];
}
-(void)statusButtonOnclicked:(UIButton *)sender{
    if (sender.tag !=0) {
        JHUsersListViewController *list = [self.viewcontroller.storyboard instantiateViewControllerWithIdentifier:@"JHUsersListViewController"];
        if (sender.tag == 1) {
            [list setContentWithPk:self.myModel.pkStr withTitle:@"followers" withUsername:self.myModel.username];
        }else{
            [list setContentWithPk:self.myModel.pkStr withTitle:@"following" withUsername:self.myModel.username];
        }
        list.hidesBottomBarWhenPushed = YES;
        [self.viewcontroller.navigationController pushViewController:list animated:YES];
    }
    
}
-(void)friendshipStatusChange:(BOOL)isFllow{
    [self.viewcontroller showLoding];
    [[JHNetworkManager shareInstance] postTofollow:isFllow withPk:self.myModel.pk succeed:^(BOOL data) {
        [self.viewcontroller hiddenLoding];
        if (isFllow) {
            if (data) {
                [self.viewcontroller showAlertViewWithText:@"フォロー成功" afterDelay:2];
                [self changeButtonStatus:self.upButton];
            }else{
                
            }
        }else{
            if (data) {
                [self.viewcontroller showAlertViewWithText:@"フォロー解除しました" afterDelay:2];
                [self changeButtonStatus:self.upButton];
            }else{
                
            }
        }
    } failure:^(NSError *error) {
        [self.viewcontroller hiddenLoding];
        [self.viewcontroller showAlertNetworkError];
    }];
    
}
#pragma mark - ui
-(void)loadSubViews{
    [self addSubview:self.userIcon];
    [self addSubview:self.lableOne];
    [self addSubview:self.lableTwo];
    [self addSubview:self.upButton];
    
    [self setUpSubViews];
    [self initStatusSubViews];
    
}
-(void)setUpSubViews{
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(K_RATIO_SIZE(12));
        make.width.height.equalTo(K_RATIO_SIZE(56));
        make.leading.equalTo(K_RATIO_SIZE(10));
    }];
    [self.lableOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.userIcon.mas_trailing).offset(M_RATIO_SIZE(20));
        make.top.equalTo(self.userIcon.mas_top).offset(M_RATIO_SIZE(11));
    }];
    [self.lableTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.lableOne);
        make.top.equalTo(self.lableOne.mas_bottom).offset(M_RATIO_SIZE(5));
        make.trailing.equalTo(K_RATIO_SIZE(-10));
    }];
    [self.upButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.userIcon);
        make.trailing.equalTo(self.lableTwo);
        make.top.equalTo(self.userIcon.mas_bottom).offset(M_RATIO_SIZE(10));
        make.height.equalTo(K_RATIO_SIZE(32));
    }];
    
}

-(void)initStatusSubViews{
    NSArray *titles = @[NSLocalizedString(@"2075", nil),NSLocalizedString(@"2763", nil),NSLocalizedString(@"2764", nil)];
    for (int i=0; i<titles.count; i++) {
        JHCustomButton *button = [JHCustomButton createTextButton];
        [button setContentTitleFont:16 titleColor:c25510642 withDescFont:14 descColor:c161170181];
        [button updateTextView];
        button.titleLabe.textAlignment = NSTextAlignmentCenter;
        button.descLable.textAlignment = NSTextAlignmentCenter;
        button.tag = i;
        CGFloat left = M_RATIO_SIZE(126);
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@(left*i));
            make.top.equalTo(self.upButton.mas_bottom).offset(M_RATIO_SIZE(18));;
            make.width.equalTo(K_RATIO_SIZE(123));
            make.height.equalTo(@(30+M_RATIO_SIZE(9)));
        }];
        button.titleLabe.text = @"0";
        button.descLable.text = titles[i];
        if (i==0) {
            self.postButton = button;
        }else if (i==1){
            self.followButton = button;
        }else{
            self.followingButton = button;
        }
        button.tag =i;
        [button addTarget:self action:@selector(statusButtonOnclicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)changeButtonStatus:(UIButton *)sender{
    if (sender.selected) {
        sender.backgroundColor = c25210642;
        [sender setTitleColor:c255255255 forState:UIControlStateNormal];
    }else{
        [sender setTitleColor:c25210642 forState:UIControlStateNormal];
        sender.backgroundColor = c255255255;
    }
}
#pragma mark - custom sccessors

-(UIImageView *)userIcon{
    if (_userIcon == nil) {
        _userIcon = [[UIImageView alloc] init];
        _userIcon.layer.masksToBounds = YES;
        _userIcon.layer.cornerRadius = M_RATIO_SIZE(56)/2;
    }
    return _userIcon;
}
-(UILabel *)lableOne{
    if (_lableOne == nil) {
        _lableOne = [UILabel createLableTextColor:[UIColor colorWithR:66 g:75 b:87 alpha:1] font:15 numberOfLines:1];
    }
    return _lableOne;
}
-(UILabel *)lableTwo{
    if (_lableTwo == nil) {
        _lableTwo = [UILabel createLableTextColor:[UIColor colorWithR:161 g:170 b:181 alpha:1] font:13 numberOfLines:0];
    }
    return _lableTwo;
}
-(UIButton *)upButton{
    if (_upButton == nil) {
        _upButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _upButton.backgroundColor = c25510642;
        [_upButton setTitleColor:c255225225 forState:UIControlStateNormal];
        [_upButton setTitle:NSLocalizedString(@"2140", nil) forState:UIControlStateNormal];
        [_upButton addTarget:self action:@selector(buttonOnclicked:) forControlEvents:UIControlEventTouchUpInside];
        _upButton.layer.borderColor = [UIColor colorWithHexString:@"#FC6A2A"].CGColor;
        _upButton.layer.borderWidth=1;
        _upButton.layer.masksToBounds = YES;
        _upButton.layer.cornerRadius = M_RATIO_SIZE(2);
    }
    return _upButton;
}


@end
