//
//  JHNotesListTableViewCell.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/21.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHBaseTableViewCell.h"
#import "JHCustomButton.h"
#import "YYTextAttribute.h"
#import "NSAttributedString+YYText.h"
#import "YYText.h"
#import "JHArticleModel.h"

@class JHNotesListTableViewCell;
@protocol JHNotesListCellDelegate <NSObject>
-(void)NoteListCell:(JHNotesListTableViewCell *)cell isSelectedMoreIndex:(NSInteger)index;
@end
@interface JHNotesListTableViewCell : JHBaseTableViewCell
@property (nonatomic, strong)UIImageView *photo;
@property (nonatomic, strong)UIImageView *signIcon;
@property (nonatomic, strong) UILabel *signLable;
@property (nonatomic, strong)JHCustomButton *buttonOne;
@property (nonatomic, strong)JHCustomButton *buttonTwo;
@property (nonatomic, strong) YYLabel *contentLable;
@property (nonatomic, strong) UILabel *contentLableT;
@property (nonatomic, strong)UIView *lineView;
@property (nonatomic, strong) JHArticleModel *model;
@property (nonatomic, strong) UIVisualEffectView *HUDView;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, weak)id<JHNotesListCellDelegate>delegate;

-(void)setContentWithNotesModel:(JHArticleModel *)model wwithIndex:(NSInteger)index;
@end
