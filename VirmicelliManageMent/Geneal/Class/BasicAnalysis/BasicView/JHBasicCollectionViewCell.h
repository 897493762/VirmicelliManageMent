//
//  JHBasicCollectionViewCell.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/5.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHTestModel.h"
@interface JHBasicCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) UIView *containerView;
@property (nonatomic, strong) UILabel *lableOne;
@property (nonatomic, strong) UILabel *lableTwo;
@property (nonatomic, strong) UIImageView *signIcon;
@property (nonatomic, strong) JHTestModel *model;

-(void)setContentWithTestModel:(JHTestModel *)model;
-(void)setContentIsRefreshing:(BOOL)isRefreshing withCount:(NSInteger)count;

@end
