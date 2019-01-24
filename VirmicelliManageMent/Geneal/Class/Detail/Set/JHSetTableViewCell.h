//
//  JHSetTableViewCell.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/10/11.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHBaseTableViewCell.h"

@interface JHSetTableViewCell : JHBaseTableViewCell
@property (nonatomic, strong) UILabel *titleLable;

-(void)setContentText:(NSString *)text tectColor:(UIColor *)color textFont:(UIFont *)font withBackgroundColor:(UIColor *)bgColor;
@end
