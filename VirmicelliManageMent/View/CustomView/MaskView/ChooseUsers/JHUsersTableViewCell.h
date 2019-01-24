//
//  JHUsersTableViewCell.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/6.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHBaseTableViewCell.h"
#import "JHCustomButton.h"
@class JHUsersTableViewCell;
@protocol JHDeletUserDelegate <NSObject>

- (void)userCell:(JHUsersTableViewCell *)cell withIndexRow:(NSInteger)row;

@end
@interface JHUsersTableViewCell : JHBaseTableViewCell
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic , strong) UIImageView *icon;
@property (nonatomic , strong) UILabel *nameLable;
@property (nonatomic, strong) JHUserInfoModel *model;

@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, strong) UIImageView *rightIcon;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) NSInteger row;

@property (weak,nonatomic) id<JHDeletUserDelegate>delegate;

-(void)setContentWithUserModel:(JHUserInfoModel *)model isSelect:(BOOL)isSelect;
-(void)updateViewIsSelect:(BOOL)isSelect;

@end
