//
//  JHImageCollectionViewCell.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/27.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHArticleModel.h"
@interface JHImageCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UIButton *signButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signButtonHeight;

@property (nonatomic, strong) JHArticleModel *model;
-(void)setContentWithArticleModel:(JHArticleModel *)model;
-(void)setContentWithGenealArticleModel:(JHArticleModel *)model;

@end
