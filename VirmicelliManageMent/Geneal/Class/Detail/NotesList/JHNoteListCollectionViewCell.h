//
//  JHNoteListCollectionViewCell.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2019/1/7.
//  Copyright © 2019年 Satoshi Nakamoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHCustomButton.h"
#import "JHArticleModel.h"
@interface JHNoteListCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong)UIImageView *picture;
@property (nonatomic, strong)JHCustomButton *likeButton;
@property (nonatomic, strong)JHCustomButton *msgButton;
@property (nonatomic, strong)UIButton *indexButton;
@property (nonatomic, strong)UIButton *signButton;
@property (nonatomic, strong) JHArticleModel *model;
-(void)setContentWithNotesModel:(JHArticleModel *)model wwithIndex:(NSInteger)index;

@end
