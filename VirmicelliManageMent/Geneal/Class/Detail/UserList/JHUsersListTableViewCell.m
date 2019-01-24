//
//  JHUsersListTableViewCell.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/7.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHUsersListTableViewCell.h"
#import "JHNetworkManager.h"

@implementation JHUsersListTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"JHUsersListTableViewCell" owner:nil options:nil] lastObject];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (IBAction)statusButtonOnclicked:(UIButton *)sender {
    if (self.model.following == 0){
        [self friendshipStatusChange:YES];
    }else{
        [self friendshipStatusChange:NO];
    }
}
-(void)friendshipStatusChange:(BOOL)isFllow{
    [self.viewcontroller showLoding];
    [[JHNetworkManager shareInstance] postFollow:isFllow withUserModel:self.model succeed:^(id data) {
        [self.viewcontroller hiddenLoding];
        self.model = data;
        [self updateStatus:self.model];
        if (isFllow) {
            [self.viewcontroller showAlertViewWithText:@"フォロー成功" afterDelay:2];
        }else{
            [self.viewcontroller showAlertViewWithText:@"フォロー解除しました" afterDelay:2];
        }
    } failure:^(NSError *error) {
        [self.viewcontroller hiddenLoding];
        [self.viewcontroller showAlertNetworkError];
    }];
 
}
#pragma mark - model
-(void)setContentWithFllowing:(JHUserModel *)model{
    if (self.model == model) {
        return;
    }
    self.model = model;
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:self.model.profile_pic_url] placeholderImage:[UIImage imageNamed:@"img_posts_s"] options:SDWebImageAllowInvalidSSLCertificates];
    self.lableOne.text = self.model.username;
    self.lableTwo.text = self.model.full_name;
    [self updateStatus:self.model];
    if (model.type == 0) {
        [[JHCoreDataStackManager shareInstance] getFollowerStatus:self.model succeed:^(id data) {
            self.model = data;
            [self updateStatus:self.model];
        }];
    }
}
-(void)setContentWithUserModel:(JHUserModel *)model{
    if (self.model == model) {
        return;
    }
    self.model = model;
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:self.model.profile_pic_url] placeholderImage:[UIImage imageNamed:@"img_posts_s"] options:SDWebImageAllowInvalidSSLCertificates];
    self.lableOne.text = self.model.username;
    self.lableTwo.text = self.model.full_name;
    [self updateStatus:self.model];
    if (model.type == 0) {
        [[JHCoreDataStackManager shareInstance] getFollowerStatus:self.model succeed:^(id data) {
            self.model = data;
            [self updateStatus:self.model];
        }];

    }
}
-(void)setContentWithPersonModel:(JHUserModel *)model{
    if (self.model == model) {
        return;
    }
    self.model = model;
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:self.model.profile_pic_url] placeholderImage:[UIImage imageNamed:@"img_posts_s"] options:SDWebImageAllowInvalidSSLCertificates];
    self.lableOne.text = self.model.username;
    self.lableTwo.text = self.model.full_name;
    self.postsButton.hidden = NO;
    self.followersButton.hidden = NO;
    self.followingButton.hidden = NO;
    [self.postsButton setContentWithLableOneStr:[NSString stringWithFormat:@"%ld",self.model.media_count] withLableTwoStr:@"Posts"];
    [self.followersButton setContentWithLableOneStr:[NSString stringWithFormat:@"%ld",self.model.follower_count] withLableTwoStr:@"Followers"];
    [self.followingButton setContentWithLableOneStr:[NSString stringWithFormat:@"%ld",self.model.following_count] withLableTwoStr:@"Following"];
    [self updateStatus:self.model];

}
-(void)updateStatus:(JHUserModel *)model{
    if (model.followEach ==1){
        [self.statusButton setImage:[UIImage imageNamed:@"attention_both"] forState:UIControlStateNormal];
    }else if(model.following == 1){
        [self.statusButton setImage:[UIImage imageNamed:@"attentioned"] forState:UIControlStateNormal];
    }else{
        [self.statusButton setImage:[UIImage imageNamed:@"attention"] forState:UIControlStateNormal];
    }
}

-(void)awakeFromNib{
    self.containerLeft.constant = M_RATIO_SIZE(10);
    self.cpntainerRight.constant = M_RATIO_SIZE(10);
    self.userIconWidth.constant = M_RATIO_SIZE(56);
    self.userIconHeight.constant = M_RATIO_SIZE(56);
    self.lableOneTop.constant = M_RATIO_SIZE(22);
    self.lableOneLeft.constant = M_RATIO_SIZE(10);
    self.lableTwoTop.constant = M_RATIO_SIZE(4);
    self.lableTwoRight.constant = M_RATIO_SIZE(87);
    self.userIcon.layer.masksToBounds = YES;
    self.userIcon.layer.cornerRadius = M_RATIO_SIZE(28);
    [self creatButtons];
    [super awakeFromNib];
    self.userIcon.contentMode = UIViewContentModeScaleAspectFill;
    [self.statusButton setImage:[UIImage imageNamed:@"attentioned_index"] forState:UIControlStateNormal];
}

-(void)creatButtons{
    [self.containerView addSubview:self.postsButton];
    [self.containerView addSubview:self.followersButton];
    [self.containerView addSubview:self.followingButton];

    [self.postsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.lableOne.mas_leading);
        make.top.equalTo(self.lableTwo.mas_bottom).offset(M_RATIO_SIZE(8));
        make.height.equalTo(@(M_RATIO_SIZE(4)+24));
        make.width.equalTo(@34);
    }];
    [self.followersButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.postsButton);
        make.width.equalTo(@59);
        make.centerX.equalTo(self.containerView);
    }];
    [self.followingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.postsButton);
        make.trailing.equalTo(K_RATIO_SIZE(-81));
    }];    
    [self.postsButton setContentWithLableOneStr:@"0" withLableTwoStr:@"Posts"];
    [self.followersButton setContentWithLableOneStr:@"0" withLableTwoStr:@"Followers"];
    [self.followingButton setContentWithLableOneStr:@"0" withLableTwoStr:@"Following"];
    
    self.postsButton.hidden = YES;
    self.followersButton.hidden = YES;
    self.followingButton.hidden = YES;

}

#pragma mark - custom sccessors
-(JHTitleButton *)postsButton{
    if (_postsButton == nil) {
        _postsButton = [JHTitleButton createButton];
    }
    return _postsButton;
}
-(JHTitleButton *)followersButton{
    if (_followersButton == nil) {
        _followersButton = [JHTitleButton createButton];
    }
    return _followersButton;
}
-(JHTitleButton *)followingButton{
    if (_followingButton == nil) {
        _followingButton = [JHTitleButton createButton];
    }
    return _followingButton;
}
@end
