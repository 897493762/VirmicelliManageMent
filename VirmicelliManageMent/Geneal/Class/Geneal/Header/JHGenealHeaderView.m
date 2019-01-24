//
//  JHGenealHeaderView.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/29.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHGenealHeaderView.h"
#import "JHCustomButton.h"
#import "YYTextAttribute.h"
#import "NSAttributedString+YYText.h"
#import "YYText.h"
#import "JHGenealViewController.h"
#import "JHUsersListViewController.h"
#import "JHAEditorViewController.h"
#import "JHCollectModel.h"
#import "JHPurchase.h"
@interface JHGenealHeaderView ()
@property (nonatomic, strong) UIImageView *userIcon;
@property (nonatomic, strong) UILabel *lableOne;
@property (nonatomic, strong) YYLabel *lableTwo;

@property (nonatomic, strong) JHCustomButton *postButton;
@property (nonatomic, strong) JHCustomButton *followButton;
@property (nonatomic, strong) JHCustomButton *followingButton;


@property (nonatomic, strong) UIButton *upButton;
@property (nonatomic, strong) JHUserInfoModel *myModel;

@property (nonatomic, strong) UIView *followView;
@property (nonatomic, strong) UIButton *followedButton;
@property (nonatomic, strong) UIButton *favoriteButton;

@end
@implementation JHGenealHeaderView

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
    if (self.myModel.pk != [JHUserInfoModel unarchive].pk) {
        self.followView.hidden = NO;
        self.upButton.hidden = YES;
    }else{
        self.followView.hidden = YES;
        self.upButton.hidden = NO;
    }
    self.lableTwo.attributedText = [self getDescAttribute];
    self.favoriteButton.selected = [self getFavorite:self.myModel.pk];
    [self changeButtonStatus:self.favoriteButton];

}
-(void)setContentWithFollow:(BOOL)isFollow{
    self.followedButton.selected =isFollow;
    [self changeButtonStatus:self.followedButton];
}
-(NSMutableAttributedString *)getDescAttribute{
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithString:self.myModel.descCont];
    NSRange range = [self.myModel.descCont rangeOfString:self.myModel.external_url];
    mutableString.yy_lineSpacing = 0;
    mutableString.yy_font = [UIFont systemFontOfSize:12];
    mutableString.yy_color =[UIColor colorWithHexString:@"#A1AAB5"];
    [mutableString yy_setTextHighlightRange:range color:c25210642 backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.myModel.external_url]];
    }];
    if ([self.myModel.descCont containsString:@"@"]) {
        NSArray *array = [self.myModel.descCont componentsSeparatedByString:@"@"]; //字符串按照【分隔成数组
        for (NSString *str in array) {
            NSString *content = [NSString stringWithFormat:@"@%@",str];
            if ([self.myModel.descCont containsString:content]) {
                NSRange startRange = [content rangeOfString:@"@"];
                NSRange range2;
                if ([content containsString:@" "]) {
                    NSRange endRange = [content rangeOfString:@" "];
                    range2 = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
                }else {
                    NSRange endRange = [content rangeOfString:@"\n"];
                    range2 = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
                }
                NSString *userName = [content substringWithRange:range2];
                NSString *result = [NSString stringWithFormat:@"@%@",userName];
                NSRange rr =[self.myModel.descCont rangeOfString:result];
                [mutableString yy_setTextHighlightRange:rr color:c25210642 backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                    JHGenealViewController *geneal = [self.viewcontroller.storyboard instantiateViewControllerWithIdentifier:@"JHGenealViewController"];
                    [geneal setContentWithUserName:userName];
                    [self.viewcontroller.navigationController pushViewController:geneal animated:YES];
                }];

            }
        }
       
        
    }

    return mutableString;

}
#pragma mark - IBAction
-(void)buttonOnclicked:(UIButton *)sender{
    if (sender.tag == 0) {
        if (![JHAppStatusModel unarchive].isPurchase) {
            [self creatPurChaseView];
        }else{
            JHAEditorViewController *edit = [[JHAEditorViewController alloc] init];
            [self.viewcontroller.navigationController pushViewController:edit animated:YES];
        }
       
    }else if (sender.tag == 1){
        sender.selected = !sender.selected;
        [self friendshipStatusChange:sender.selected];
    }else{
        [self.viewcontroller showLoding];
        self.favoriteButton.selected = !self.favoriteButton.selected;
        JHCollectModel *collect = [[JHCollectModel alloc]init];
        collect.user = self.myModel;
        collect.medias = self.medias;
        [self insertOrdeletCollectUsers:self.favoriteButton.selected withDatas:collect succeed:^(BOOL data) {
            [self.viewcontroller hiddenLoding];
            [self.viewcontroller showAlertViewWithText:@"收藏成功" afterDelay:2];
            [self changeButtonStatus:self.favoriteButton];
            
        }];
    }
}
-(void)statusButtonOnclicked:(UIButton *)sender{
    if (sender.tag !=2) {
        JHUsersListViewController *list = [self.viewcontroller.storyboard instantiateViewControllerWithIdentifier:@"JHUsersListViewController"];
        if (sender.tag == 1) {
            [list setContentWithPk:self.myModel.pkStr withTitle:NSLocalizedString(@"2763", nil) withUsername:self.myModel.username];
        }else{
            [list setContentWithPk:self.myModel.pkStr withTitle:NSLocalizedString(@"2764", nil) withUsername:self.myModel.username];
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
                [self changeButtonStatus:self.followedButton];
            }else{
                
            }
        }else{
            if (data) {
                [self.viewcontroller showAlertViewWithText:@"フォロー解除しました" afterDelay:2];
                [self changeButtonStatus:self.followedButton];
            }else{
                
            }
        }
    } failure:^(NSError *error) {
        [self.viewcontroller hiddenLoding];
        [self.viewcontroller showAlertNetworkError];
    }];
    
}
-(void)creatPurChaseView{
    JHPurchaseView *pur = [[JHPurchaseView alloc] init];
    [pur showInView:[UIApplication sharedApplication].keyWindow];
    __weak JHPurchaseView *weakPur = pur;
    __weak typeof(self) weakself = self;
    pur.returnValueBlock = ^(int value) {
        [weakself.viewcontroller showLoadToView:weakPur];
        [[JHPurchase shareInstance] clickPhures:value succeed:^(BOOL data) {
            if (data) {
                [weakself updateMyUserPurseData:^(BOOL data) {
                    [weakself.viewcontroller hiddenLoding];
                    [weakPur hiddenView];
                    if (value == 1) {
                        [weakself.viewcontroller showAlertViewWithText:NSLocalizedString(@"2084", nil) afterDelay:1];
                    }
                }];
                
            }else{
                [weakself.viewcontroller hiddenLoding];
                if (value == 1) {
                    [weakself.viewcontroller showAlertViewWithText:NSLocalizedString(@"2091", nil) afterDelay:1];
                }else{
                    [weakself.viewcontroller showAlertViewWithText:NSLocalizedString(@"2085", nil) afterDelay:1];
                }
            }
        }];
    };
}
#pragma mark - ui
-(void)loadSubViews{
    [self addSubview:self.userIcon];
    [self addSubview:self.lableOne];
    [self addSubview:self.lableTwo];
    [self addSubview:self.upButton];

    [self setUpSubViews];
    [self initStatusSubViews];
    [self initFollowView];
    self.followView.hidden = YES;
    self.upButton.hidden = YES;

}
-(void)setUpSubViews{
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(K_RATIO_SIZE(10));
        make.width.height.equalTo(K_RATIO_SIZE(72));
    }];
    [self.lableOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.userIcon);
        make.top.equalTo(self.userIcon.mas_bottom).offset(M_RATIO_SIZE(10));
    }];
    [self.lableTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.userIcon);
        make.top.equalTo(self.lableOne.mas_bottom).offset(M_RATIO_SIZE(5));
        make.trailing.equalTo(K_RATIO_SIZE(-10));
    }];
    CGFloat wid = [NSLocalizedString(@"2756", nil) calcTextSizeWithWidth:[UIFont systemFontOfSize:15] totalSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    [self.upButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(K_RATIO_SIZE(63));
        make.trailing.equalTo(K_RATIO_SIZE(-34));
        make.width.equalTo(@(wid+M_RATIO_SIZE(20)));
        make.height.equalTo(K_RATIO_SIZE(32));
    }];
}

-(void)initStatusSubViews{
    NSArray *titles = @[NSLocalizedString(@"2075", nil),NSLocalizedString(@"2763", nil),NSLocalizedString(@"2764", nil)];
    for (int i=0; i<titles.count; i++) {
        JHCustomButton *button = [JHCustomButton createTextButton];
        [button updateTextView];
        [button setContentTitleFont:15 titleColor:c25510642 withDescFont:13 descColor:c161170181];
        button.titleLabe.textAlignment = NSTextAlignmentCenter;
        button.descLable.textAlignment = NSTextAlignmentCenter;
        button.tag = i;
        CGFloat right = M_RATIO_SIZE(10)+M_RATIO_SIZE(72)*i;
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-right));
            make.top.equalTo(K_RATIO_SIZE(15));
            make.width.equalTo(@61);
            make.height.equalTo(@(28+M_RATIO_SIZE(6)));
        }];
        button.titleLabe.text = @"0";
        if (i==0) {
            button.descLable.text = titles[2];
            self.followButton = button;
        }else if (i==1){
            button.descLable.text = titles[1];
            self.followingButton = button;
        }else{
            button.descLable.text = titles[0];
            self.postButton = button;
        }
        button.tag =i;
        [button addTarget:self action:@selector(statusButtonOnclicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)initFollowView{
    [self addSubview:self.followView];
    [self.followView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.height.equalTo(self.upButton);
        make.width.equalTo(K_RATIO_SIZE(190));
    }];
    for (int i=0; i<2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.borderColor = [UIColor colorWithHexString:@"#FC6A2A"].CGColor;
        button.layer.borderWidth=1;
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = M_RATIO_SIZE(2);
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        if (i==0) {
            [button setTitle:NSLocalizedString(@"2764", nil) forState:UIControlStateNormal];
            [button setTitleColor:c25210642 forState:UIControlStateNormal];
            self.followedButton = button;
        }else if (i==1){
            [button setTitle:NSLocalizedString(@"2765", nil) forState:UIControlStateNormal];
            [button setTitleColor:c25210642 forState:UIControlStateNormal];
            self.favoriteButton = button;
        }
        [self.followView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@(M_RATIO_SIZE(100)*i));
            make.top.bottom.equalTo(self.followView);
            make.width.equalTo(K_RATIO_SIZE(90));
        }];
        button.tag =i+1;
        [button addTarget:self action:@selector(buttonOnclicked:) forControlEvents:UIControlEventTouchUpInside];

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
        _userIcon.layer.cornerRadius = M_RATIO_SIZE(36);
    }
    return _userIcon;
}
-(UILabel *)lableOne{
    if (_lableOne == nil) {
        _lableOne = [UILabel createLableTextColor:[UIColor colorWithR:66 g:75 b:87 alpha:1] font:15 numberOfLines:1];
    }
    return _lableOne;
}
-(YYLabel *)lableTwo{
    if (_lableTwo == nil) {
        _lableTwo = [YYLabel new];
        _lableTwo.numberOfLines = 0;  //设置多行显示
        _lableTwo.preferredMaxLayoutWidth = kScreenWidth-M_RATIO_SIZE(20); //设置最大的宽度
        _lableTwo.userInteractionEnabled = YES;
    }
    return _lableTwo;
}
-(UIButton *)upButton{
    if (_upButton == nil) {
        _upButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _upButton.backgroundColor = c25510642;
        [_upButton setTitleColor:c255225225 forState:UIControlStateNormal];
        [_upButton setTitle:NSLocalizedString(@"2756", nil) forState:UIControlStateNormal];
        _upButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_upButton addTarget:self action:@selector(buttonOnclicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _upButton;
}
-(UIView *)followView{
    if (_followView == nil) {
        _followView = [[UIView alloc] init];
    }
    return _followView;
}
@end
