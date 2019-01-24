//
//  JHTitleTableViewCell.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2019/1/3.
//  Copyright © 2019年 Satoshi Nakamoto. All rights reserved.
//

#import "JHBaseTableViewCell.h"

@interface JHTitleTableViewCell : JHBaseTableViewCell
@property(nonatomic, strong) UILabel *nameLable;
@property(nonatomic, strong) UIView *lineView;
@property(nonatomic, strong) UIImageView *rightIcon;
-(void)showRightIcon:(NSString *)text;
@end
