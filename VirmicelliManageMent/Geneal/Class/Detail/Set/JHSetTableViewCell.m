//
//  JHSetTableViewCell.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/10/11.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHSetTableViewCell.h"

@implementation JHSetTableViewCell
-(void)cellWillLoadSubView{
    [self.contentView addSubview:self.titleLable];
}
- (void)cellWillLoadAutoLayout{
    [self loadSubViews];
}
-(void)setContentText:(NSString *)text tectColor:(UIColor *)color textFont:(UIFont *)font withBackgroundColor:(UIColor *)bgColor{
    self.titleLable.text = text;
    self.titleLable.textColor = color;
    self.titleLable.font = font;
    self.contentView.backgroundColor =bgColor;
}
-(void)loadSubViews{
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(K_RATIO_SIZE(10));
        make.centerY.equalTo(self.contentView);
    }];
}
-(UILabel *)titleLable{
    if (_titleLable == nil) {
        _titleLable = [[UILabel alloc] init];
    }
    return _titleLable;
}
@end
