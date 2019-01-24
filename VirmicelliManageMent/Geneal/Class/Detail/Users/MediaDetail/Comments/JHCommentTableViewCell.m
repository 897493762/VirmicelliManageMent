//
//  JHCommentTableViewCell.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/3.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHCommentTableViewCell.h"
#import "SDAutoLayout.h"
@implementation JHCommentTableViewCell

-(void)setModel:(JHCommentModel *)model{
    if (_model == model) {
        return;
    }
    _model= model;
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:_model.user.profile_pic_url] placeholderImage:[UIImage imageNamed:@"img_posts_s"] options:SDWebImageAllowInvalidSSLCertificates];
    self.contentLable.attributedText = _model.contentAttribute;
    [self.contentLable updateLayout];
    [self setupAutoHeightWithBottomViewsArray:@[self.contentLable,self.userIcon] bottomMargin:M_RATIO_SIZE(21)];

}
-(void)cellWillLoadSubView{
    [self.contentView addSubview:self.userIcon];
    [self.contentView addSubview:self.contentLable];
}
-(void)cellWillLoadAutoLayout{
    self.userIcon.sd_layout
    .topSpaceToView(self.contentView, M_RATIO_SIZE(11))
    .leftSpaceToView(self.contentView, M_RATIO_SIZE(21))
    .widthIs(M_RATIO_SIZE(34))
    .heightIs(M_RATIO_SIZE(34));
    
    self.contentLable.sd_layout
    .leftSpaceToView(self.userIcon, M_RATIO_SIZE(21))
    .rightSpaceToView(self.contentView, M_RATIO_SIZE(21))
    .topSpaceToView(self.contentView, M_RATIO_SIZE(11))
    .autoHeightRatio(0);

    [self setupAutoHeightWithBottomViewsArray:@[self.contentLable,self.userIcon] bottomMargin:M_RATIO_SIZE(21)];
    self.contentLable.isAttributedContent = YES;
}
#pragma mark - custom Accessors
-(UIImageView *)userIcon{
    if (_userIcon == nil) {
        _userIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_posts_s"]];
        _userIcon.layer.masksToBounds = YES;
        _userIcon.layer.cornerRadius = M_RATIO_SIZE(34)/2;
    }
    return _userIcon;
}
-(UILabel *)contentLable{
    if (_contentLable == nil) {
        _contentLable = [[UILabel alloc] init];
        _contentLable.numberOfLines = 0;
    }
    return _contentLable;
}
@end
