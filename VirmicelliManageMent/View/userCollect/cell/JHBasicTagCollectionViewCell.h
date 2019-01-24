//
//  JHBasicTagCollectionViewCell.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/28.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHTagTitleModel.h"
@interface JHBasicTagCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong) UIView *maskView;
@property(nonatomic, strong) UIView *containerView;
@property(nonatomic, strong) UILabel *lableOne;
@property(nonatomic, strong) UILabel *lableTwo;
@property(nonatomic, strong) UIImageView *signIcon;
@property(nonatomic, strong) UILabel *countLable;
@property(nonatomic, strong) JHTagTitleModel *model;
@property(nonatomic, strong) UIImageView *loadView;

-(void)setContentWithTagModel:(JHTagTitleModel *)model;
@end
