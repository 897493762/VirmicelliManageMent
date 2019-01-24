//
//  JHTitleButton.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/7.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHTitleButton.h"

@implementation JHTitleButton

+ (instancetype)createButton
{
    JHTitleButton *btn = [self buttonWithType:UIButtonTypeCustom];
    [btn loadButton];
    return btn;
}
-(void)setContentWithLableOneStr:(NSString *)oneStr withLableTwoStr:(NSString *)twoStr{
    self.lableOne.text = oneStr;
    self.lableTwo.text = twoStr;
}
#pragma mark - UI
- (void)loadButton{
    [self addSubview:self.lableOne];
    [self addSubview:self.lableTwo];
    
    [self.lableTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.equalTo(self);
    }];
    [self.lableOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(self);
    }];
}
#pragma mark - Custom Access
-(UILabel *)lableOne{
    if (_lableOne == nil) {
        _lableOne = [UILabel createLableTextColor:[UIColor colorWithR:255 g:96 b:103 alpha:1] font:12 numberOfLines:1];
    }
    return _lableOne;
}
-(UILabel *)lableTwo{
    if (_lableTwo == nil) {
        _lableTwo = [UILabel createLableTextColor:[UIColor colorWithR:145 g:145 b:145 alpha:1] font:12 numberOfLines:1];
    }
    return _lableTwo;
}
@end
