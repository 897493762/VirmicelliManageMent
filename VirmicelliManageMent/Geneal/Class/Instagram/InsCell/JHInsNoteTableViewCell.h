//
//  JHInsNoteTableViewCell.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/26.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHBaseTableViewCell.h"
#import "JHCustomButton.h"
#import "JHArticleModel.h"

@interface JHInsNoteTableViewCell : JHBaseTableViewCell
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *nameLable;
@property (nonatomic, strong) UILabel *dateLable;
@property (nonatomic, strong) UIView *mediaView;
@property (nonatomic, strong) UIImageView *photo;

@property (nonatomic, strong) UIButton *buttonOne;
@property (nonatomic, strong) UIButton *buttonTwo;
@property (nonatomic, strong) UIButton *buttonThree;
@property (nonatomic, strong) UIButton *buttonFour;
@property (nonatomic, strong) UIButton *buttonUp;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) JHCustomButton *likeButton;
@property (nonatomic, strong) JHCustomButton *msgButton;
@property (nonatomic, strong) YYLabel *lableOne;
@property (nonatomic, strong) JHArticleModel *articleModel;
@property (nonatomic, strong) NSIndexPath *indexPath;

-(void)setContentWitharticleModel:(JHArticleModel *)model;

@end
