//
//  JHNoteListCollectionViewCell.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2019/1/7.
//  Copyright © 2019年 Satoshi Nakamoto. All rights reserved.
//

#import "JHNoteListCollectionViewCell.h"

@implementation JHNoteListCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadSubViews];
    }
    return self;
}
-(void)setContentWithNotesModel:(JHArticleModel *)model wwithIndex:(NSInteger)index{
    if (self.model ==model) {
        return;
    }
    self.model = model;
    [self.picture sd_setImageWithURL:[NSURL URLWithString:self.model.profile_pic_url] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
    self.likeButton.titleLabe.text = [NSString stringWithFormat:@"%d",self.model.like_count];
    self.msgButton.titleLabe.text= [NSString stringWithFormat:@"%d",self.model.comment_count];
    CGFloat wid1 =[self.likeButton.titleLabe.text calcTextSizeWithWidth:[UIFont systemFontOfSize:14] totalSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)]+M_RATIO_SIZE(22);
    CGFloat wid2 =[self.msgButton.titleLabe.text calcTextSizeWithWidth:[UIFont systemFontOfSize:14] totalSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)]+M_RATIO_SIZE(22);
    [self.likeButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(wid1));
    }];
    [self.msgButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(wid2));
    }];
    [self.indexButton setTitle:[NSString stringWithFormat:@"%ld",index] forState:UIControlStateNormal];
    if (self.model.media_type == 8) {
        self.signButton.hidden = NO;
        [self.signButton setBackgroundImage:[UIImage imageNamed:@"btn_pictures"] forState:UIControlStateNormal];
    }else if (self.model.media_type == 2){
        self.signButton.hidden = NO;
        [self.signButton setBackgroundImage:[UIImage imageNamed:@"btn_play"] forState:UIControlStateNormal];
    }else{
        self.signButton.hidden = YES;
    }

}
#pragma mark - UI
-(void)loadSubViews{
    [self.contentView addSubview:self.picture];
    [self.contentView addSubview:self.indexButton];
    [self.contentView addSubview:self.likeButton];
    [self.contentView addSubview:self.msgButton];
    [self.contentView addSubview:self.signButton];

    [self setUpSubViews];
}
-(void)setUpSubViews{
    [self.picture mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(K_RATIO_SIZE(7));
        make.centerX.equalTo(self.contentView);
        make.width.height.equalTo(K_RATIO_SIZE(150));
    }];
    [self.indexButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(self.picture);
        make.width.equalTo(K_RATIO_SIZE(30));
        make.height.equalTo(K_RATIO_SIZE(20));
    }];
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.picture.mas_bottom).offset(M_RATIO_SIZE(15));
        make.leading.equalTo(K_RATIO_SIZE(12));
        make.height.equalTo(K_RATIO_SIZE(18));
    }];
    [self.msgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.picture.mas_bottom).offset(M_RATIO_SIZE(15));
        make.leading.equalTo(K_RATIO_SIZE(83));
        make.height.equalTo(K_RATIO_SIZE(18));
    }];
    [self.signButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.picture);
        make.width.height.equalTo(K_RATIO_SIZE(32));
    }];
    [self.likeButton setUpLeftImgWithWid:M_RATIO_SIZE(18) WithHeight:M_RATIO_SIZE(18) WithSpan:0];
    [self.msgButton setUpLeftImgWithWid:M_RATIO_SIZE(18) WithHeight:M_RATIO_SIZE(18) WithSpan:0];
}
#pragma mark - custom accessors
-(UIImageView *)picture{
    if (_picture == nil) {
        _picture = [[UIImageView alloc] init];
        _picture.layer.masksToBounds = YES;
        _picture.layer.cornerRadius = M_RATIO_SIZE(2);
    }
    return _picture;
}
-(UIButton *)signButton{
    if (_signButton == nil) {
        _signButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _signButton.userInteractionEnabled = NO;
    }
    return _signButton;
}
-(UIButton *)indexButton{
    if (_indexButton == nil) {
        _indexButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _indexButton.userInteractionEnabled =NO;
        _indexButton.layer.masksToBounds = YES;
        _indexButton.layer.cornerRadius = M_RATIO_SIZE(2);
        _indexButton.backgroundColor = c25210642;
        [_indexButton setTitleColor:c255255255 forState:UIControlStateNormal];
        _indexButton.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _indexButton;
}
-(JHCustomButton *)likeButton{
    if (_likeButton == nil) {
        _likeButton = [JHCustomButton createButton];
        [_likeButton setContentIconStr:@"icon_like" withTextStr:@"0" withTextFont:[UIFont systemFontOfSize:14] WithTextColor:[UIColor colorWithHexString:@"#A1AAB5"]];
//        [_likeButton addTarget:self action:@selector(buttonsOnclicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _likeButton;
}
-(JHCustomButton *)msgButton{
    if (_msgButton == nil) {
        _msgButton = [JHCustomButton createButton];
        [_msgButton setContentIconStr:@"icon_comment" withTextStr:@"0" withTextFont:[UIFont systemFontOfSize:14] WithTextColor:[UIColor colorWithHexString:@"#A1AAB5"]];
//        [_msgButton addTarget:self action:@selector(buttonsOnclicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _msgButton;
}
@end
