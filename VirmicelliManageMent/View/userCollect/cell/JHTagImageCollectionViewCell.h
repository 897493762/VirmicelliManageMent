//
//  JHTagImageCollectionViewCell.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/12.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHTagImageCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong) UIImageView *icon;
@property(nonatomic, strong) UILabel *nameLable;
@property(nonatomic, strong) JHUserModel *uModel;

-(void)setContentWithUserModel:(JHUserModel *)model;
@end
