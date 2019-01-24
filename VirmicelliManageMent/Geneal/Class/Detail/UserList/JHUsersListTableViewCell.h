//
//  JHUsersListTableViewCell.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/7.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHBaseTableViewCell.h"
#import "JHTitleButton.h"
@interface JHUsersListTableViewCell : JHBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cpntainerRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerLeft;

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userIconHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userIconWidth;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userIconTop;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusIconHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusIconWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusIconRight;
@property (weak, nonatomic) IBOutlet UILabel *lableOne;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lableOneTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lableOneLeft;
@property (weak, nonatomic) IBOutlet UILabel *lableTwo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lableTwoTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lableTwoRight;

@property (strong, nonatomic) JHTitleButton *postsButton;
@property (strong, nonatomic) JHTitleButton *followersButton;
@property (strong, nonatomic) JHTitleButton *followingButton;
@property (strong, nonatomic) JHUserModel *model;

- (IBAction)statusButtonOnclicked:(UIButton *)sender;

-(void)setContentWithFllowing:(JHUserModel *)model;
-(void)setContentWithPersonModel:(JHUserModel *)model;
-(void)setContentWithUserModel:(JHUserModel *)model;

@end
