//
//  JHTagTitleCollectionViewCell.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/26.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHTagTitleCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong) UIImageView *icon;
@property(nonatomic, strong) UILabel *nameLable;
@property(nonatomic, strong) JHUserModel *uModel;

//-(void)setContentWithUserModel:(JHUserModel *)model;
-(void)setContentWithTitleStr:(NSString *)title;

@end
