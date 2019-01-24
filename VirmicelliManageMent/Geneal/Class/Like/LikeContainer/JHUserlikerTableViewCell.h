//
//  JHUserlikerTableViewCell.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2019/1/7.
//  Copyright © 2019年 Satoshi Nakamoto. All rights reserved.
//

#import "JHBaseTableViewCell.h"
#import "JHCollectModel.h"
@interface JHUserlikerTableViewCell : JHBaseTableViewCell
@property (nonatomic, strong) UIImageView *userIcon;
@property (nonatomic, strong) UILabel *lableOne;
@property (nonatomic, strong) UILabel *lableTwo;
@property (nonatomic, strong) UIView *photoView;
@property (nonatomic, strong) JHCollectModel *model;

-(void)setContentWithCollectModel:(JHCollectModel *)model withTile:(NSString *)title;
-(void)updateSubViewsInTags;

@end
