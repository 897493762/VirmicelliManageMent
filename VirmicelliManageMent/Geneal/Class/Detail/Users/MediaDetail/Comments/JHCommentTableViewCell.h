//
//  JHCommentTableViewCell.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/3.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHBaseTableViewCell.h"
#import "JHCommentModel.h"
@interface JHCommentTableViewCell : JHBaseTableViewCell
@property (strong, nonatomic) UIImageView *userIcon;
@property (strong, nonatomic) UILabel *contentLable;
@property (strong, nonatomic) JHCommentModel *model;

@end
