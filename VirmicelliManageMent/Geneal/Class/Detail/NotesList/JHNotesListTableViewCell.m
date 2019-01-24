//
//  JHNotesListTableViewCell.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/21.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHNotesListTableViewCell.h"

@implementation JHNotesListTableViewCell
-(void)setContentWithNotesModel:(JHArticleModel *)model wwithIndex:(NSInteger)index{
    if (self.model ==model) {
        return;
    }
    self.model = model;
    [self.photo sd_setImageWithURL:[NSURL URLWithString:self.model.profile_pic_url] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
    self.buttonOne.titleLabe.text = [NSString stringWithFormat:@"%d",self.model.like_count];
    self.buttonTwo.titleLabe.text= [NSString stringWithFormat:@"%d",self.model.comment_count];
    CGFloat wid1 =[self.buttonOne.titleLabe.text calcTextSizeWithWidth:[UIFont systemFontOfSize:14] totalSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)]+M_RATIO_SIZE(35);
    CGFloat wid2 =[self.buttonTwo.titleLabe.text calcTextSizeWithWidth:[UIFont systemFontOfSize:14] totalSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)]+M_RATIO_SIZE(35);
    [self.buttonOne mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(wid1));
    }];
    [self.buttonTwo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(wid2));
    }];
    self.signLable.text = [NSString stringWithFormat:@"%ld",index+1];
    if (index == 0) {
        self.HUDView.hidden = YES;
    }else{
        if (![JHAppStatusModel unarchive].isPurchase) {
            self.HUDView.hidden = NO;
        }else{
            self.HUDView.hidden = YES;
        }
    }
    if (!self.model.isMore) {
        self.contentLable.hidden = NO;
        self.contentLableT.hidden = YES;
        self.contentLable.attributedText = self.model.preview.textAttributedString;
        [self addSeeMoreButton];
    }else{
        self.contentLableT.hidden = NO;
        self.contentLable.hidden = YES;
        self.contentLableT.attributedText = self.model.preview.textAttributedString;
    }
}
#pragma mark -- 添加...more点击事件
- (void)addSeeMoreButton {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"...... 展开 "];
    text.yy_font =self.contentLable.font;
    text.yy_color =[UIColor colorWithHexString:@"#404447"];
    YYLabel *seeMore = [YYLabel new];
    
    [text yy_setTextHighlightRange:NSMakeRange(7, 2) color:[UIColor colorWithHexString:@"#FF6067"] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        if ([self.delegate respondsToSelector:@selector(NoteListCell:isSelectedMoreIndex:)]) {
            [self.delegate NoteListCell:self isSelectedMoreIndex:self.index];
        }
    }];
    seeMore.attributedText = text;
    seeMore.userInteractionEnabled = YES;
    [seeMore sizeToFit];
    NSAttributedString *truncationToken = [NSAttributedString yy_attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.frame.size alignToFont:text.yy_font alignment:YYTextVerticalAlignmentCenter];
    self.contentLable.truncationToken = truncationToken;
    
}
#pragma mark - UI
-(void)cellWillLoadSubView{
    [self.contentView addSubview:self.photo];

    [self.contentView addSubview:self.contentLable];
    [self.contentView addSubview:self.contentLableT];
    
    [self.contentView addSubview:self.buttonOne];
    [self.contentView addSubview:self.buttonTwo];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.HUDView];
    [self.contentView addSubview:self.signIcon];
    [self.contentView addSubview:self.signLable];

}
-(void)cellWillLoadAutoLayout{
    [self.photo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(K_RATIO_SIZE(10));
        make.leading.trailing.equalTo(self.contentView);
        make.height.equalTo(K_RATIO_SIZE(375));
    }];
    [self.signIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.equalTo(self.photo);
        make.width.height.equalTo(K_RATIO_SIZE(34));
    }];
    [self.signLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.signIcon.mas_top).offset(M_RATIO_SIZE(3));
        make.trailing.equalTo(K_RATIO_SIZE(-3));
    }];
    [self.buttonOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(K_RATIO_SIZE(100));
        make.top.equalTo(self.photo.mas_bottom);
        make.height.equalTo(K_RATIO_SIZE(28));
    }];
    [self.buttonTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(K_RATIO_SIZE(258));
        make.top.equalTo(self.photo.mas_bottom);
        make.height.equalTo(K_RATIO_SIZE(28));
    }];
    [self.contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.photo);
       make.top.equalTo(self.buttonOne.mas_bottom).offset(M_RATIO_SIZE(3));
        make.height.equalTo(@34);
    }];
    [self.contentLableT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self.contentLable);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(@1);
        make.leading.equalTo(K_RATIO_SIZE(10));
        make.trailing.equalTo(K_RATIO_SIZE(-10));
    }];
    [self.HUDView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.buttonOne setUpLeftImgWithWid:M_RATIO_SIZE(24) WithHeight:M_RATIO_SIZE(24) WithSpan:0];
    [self.buttonTwo setUpLeftImgWithWid:M_RATIO_SIZE(24) WithHeight:M_RATIO_SIZE(24) WithSpan:0];
}
#pragma mark - custom sccessors
-(UIImageView *)photo{
    if (_photo == nil) {
        _photo = [[UIImageView alloc] init];
        _photo.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _photo;
}
-(UIImageView *)signIcon{
    if (_signIcon == nil) {
        _signIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"posts_list_num_bg"]];
    }
    return _signIcon;
}
-(JHCustomButton *)buttonOne{
    if (_buttonOne == nil) {
        _buttonOne = [JHCustomButton createButton];
        [_buttonOne setContentIconStr:@"icon_posts_likes" withTextStr:@"0" withTextFont:[UIFont systemFontOfSize:14] WithTextColor:[UIColor colorWithR:145 g:145 b:145 alpha:1]];
    }
    return _buttonOne;
}
-(JHCustomButton *)buttonTwo{
    if (_buttonTwo == nil) {
        _buttonTwo = [JHCustomButton createButton];
        [_buttonTwo setContentIconStr:@"icon_posts_comments" withTextStr:@"0" withTextFont:[UIFont systemFontOfSize:14] WithTextColor:[UIColor colorWithR:145 g:145 b:145 alpha:1]];
    }
    return _buttonTwo;
}
-(YYLabel *)contentLable{
    if (_contentLable == nil) {
        _contentLable = [YYLabel new];
        _contentLable.numberOfLines =0;
        _contentLable.textVerticalAlignment =YYTextVerticalAlignmentTop;
        _contentLable.userInteractionEnabled = NO;
        _contentLable.textColor = [UIColor colorWithR:64 g:68 b:71 alpha:1];
    }
    return _contentLable;
}
-(UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    }
    return _lineView;
}
-(UILabel *)contentLableT{
    if (_contentLableT == nil) {
        _contentLableT = [UILabel createLableTextColor:[UIColor colorWithR:54 g:54 b:54 alpha:1] font:16 numberOfLines:0];
    }
    return _contentLableT;
}
-(UILabel *)signLable{
    if (_signLable == nil) {
        _signLable = [UILabel createLableTextColor:[UIColor colorWithR:56 g:56 b:56 alpha:1] font:15 numberOfLines:1];
    }
    return _signLable;
}
-(UIVisualEffectView *)HUDView{
    if (_HUDView == nil) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *HUDView = [[UIVisualEffectView alloc] initWithEffect:blur];
        HUDView.alpha = 1.0f;
        _HUDView = HUDView;
        _HUDView.hidden = YES;
    }
    return _HUDView;
}
@end
