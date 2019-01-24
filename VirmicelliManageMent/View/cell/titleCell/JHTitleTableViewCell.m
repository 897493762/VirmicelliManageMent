//
//  JHTitleTableViewCell.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2019/1/3.
//  Copyright © 2019年 Satoshi Nakamoto. All rights reserved.
//

#import "JHTitleTableViewCell.h"

@implementation JHTitleTableViewCell
-(void)cellWillLoadSubView{
    [self.contentView addSubview:self.nameLable];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.rightIcon];
    self.rightIcon.hidden = YES;

}
-(void)cellWillLoadAutoLayout{
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(K_RATIO_SIZE(10));
        make.centerY.equalTo(self.contentView);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLable);
        make.trailing.equalTo(K_RATIO_SIZE(-10));
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    [self.rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.lineView);
        make.centerY.equalTo(self.contentView);
    }];
}
-(void)showRightIcon:(NSString *)text{
    if ([self.nameLable.text isEqualToString:text]) {
        return;
    }
    self.nameLable.text = text;
    self.rightIcon.hidden = NO;
    self.nameLable.textColor = [UIColor colorWithHexString:@"#424B57"];

}
-(UILabel *)nameLable{
    if (_nameLable == nil) {
        _nameLable = [UILabel createLableTextColor:[UIColor colorWithHexString:@"#454E47"] font:15 numberOfLines:1];
    }
    return _nameLable;
}
-(UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    }
    return _lineView;
}
-(UIImageView *)rightIcon{
    if (_rightIcon == nil) {
        _rightIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_arrow_right"]];
    }
    return _rightIcon;
}
@end
