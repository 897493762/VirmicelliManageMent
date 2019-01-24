//
//  JHImageCollectionViewCell.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/27.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHImageCollectionViewCell.h"

@implementation JHImageCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"JHImageCollectionViewCell" owner:self options:nil].lastObject;
        self.photo.contentMode =UIViewContentModeScaleAspectFill;
        self.signButtonWidth.constant = M_RATIO_SIZE(32);
        self.signButtonHeight.constant = M_RATIO_SIZE(32);
        self.signButton.userInteractionEnabled = NO;
    }
    return self;
}
-(void)setContentWithArticleModel:(JHArticleModel *)model{
    if (self.model == model) {
        return;
    }
    self.model = model;
    [self.photo sd_setImageWithURL:[NSURL URLWithString:self.model.profile_pic_url] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
   
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
-(void)setContentWithGenealArticleModel:(JHArticleModel *)model{
    if (self.model == model) {
        return;
    }
    self.model = model;
    [self.photo sd_setImageWithURL:[NSURL URLWithString:self.model.profile_pic_url] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
    self.signButton.hidden = YES;
    self.photo.layer.masksToBounds = YES;
    self.photo.layer.cornerRadius = M_RATIO_SIZE(54)/2;
}
@end
