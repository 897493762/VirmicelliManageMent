//
//  JHInsNoteTableViewCell.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/26.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHInsNoteTableViewCell.h"
#import "JHMediaViewController.h"
#import "JHRepostViewController.h"
#import "JHUsersListViewController.h"
#import "JHMediaCommentsViewController.h"
#import "JHGenealViewController.h"
#import "JHInsTagViewController.h"
@implementation JHInsNoteTableViewCell
-(void)setContentWitharticleModel:(JHArticleModel *)model{
    if (self.articleModel == model) {
        return;
    }
    self.articleModel = model;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:self.articleModel.user.profile_pic_url] placeholderImage:[UIImage imageNamed:@"img_posts_s"] options:SDWebImageAllowInvalidSSLCertificates];
    self.nameLable.text = self.articleModel.user.username;
    self.dateLable.text = self.articleModel.timeStr;
    [self.mediaView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.articleModel.insPhotoSize.height));
    }];
    [self setUpButtons];
    self.likeButton.titleLabe.text = [NSString stringWithFormat:@"%d",self.articleModel.like_count];
    self.msgButton.titleLabe.text= [NSString stringWithFormat:@"%d",self.articleModel.comment_count];
    [self updateButtons];
   self.lableOne.attributedText = [self getAttributedStr:self.articleModel.preview.text];
    [self setUpPhotos];
}

-(void)updateButtons{
    CGFloat wid1 =[self.likeButton.titleLabe.text calcTextSizeWithWidth:[UIFont systemFontOfSize:13] totalSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)]+M_RATIO_SIZE(21);
    CGFloat wid2 =[self.msgButton.titleLabe.text calcTextSizeWithWidth:[UIFont systemFontOfSize:13] totalSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)]+M_RATIO_SIZE(21);
    [self.likeButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(wid1));
    }];
    [self.msgButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(wid2));
    }];
}

-(NSMutableAttributedString *)getAttributedStr:(NSString *)text{
    if (isEmptyString(text)) {
        return nil;
    }
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc]initWithString:text];
    mutableString.yy_lineSpacing = 0;
    mutableString.yy_font = [UIFont systemFontOfSize:12];
    mutableString.yy_color =[UIColor colorWithR:66 g:75 b:87 alpha:1];
 
    for (NSString *str in self.articleModel.preview.insTagArry) {
        NSString *tagStr = [@"#"stringByAppendingString:str];
        if ([text containsString:tagStr]) {
            NSRange range = [text rangeOfString:tagStr];
            [mutableString yy_setTextHighlightRange:range color:[UIColor colorWithR:252 g:106 b:42 alpha:1] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                JHInsTagViewController *tag = [self.viewcontroller.storyboard instantiateViewControllerWithIdentifier:@"JHInsTagViewController"];
                tag.hidesBottomBarWhenPushed = YES;
                [tag setContentWithTagName:str];
                [self.viewcontroller.navigationController pushViewController:tag animated:YES];
            }];
        }
       
    }
    return mutableString;
}
-(void)setUpPhotos{
    [self.photo sd_setImageWithURL:[NSURL URLWithString:self.articleModel.profile_pic_url] placeholderImage:[UIImage imageNamed:@"img_posts_s"] options:SDWebImageAllowInvalidSSLCertificates];
}
-(void)setUpButtons{
    [self setContentLikeButton:self.articleModel.has_liked];
    if (self.articleModel.media_type == 8) {
        self.buttonFour.hidden = YES;
        [self.buttonThree setBackgroundImage:[UIImage imageNamed:@"icon_picture"] forState:UIControlStateNormal];
    }else{
        self.buttonFour.hidden = NO;
        [self.buttonThree setBackgroundImage:[UIImage imageNamed:@"icon_repost"] forState:UIControlStateNormal];
    }
}

#pragma mark - IBAction
-(void)buttonOnclicked:(UIButton *)sender{
    if (sender.tag == 2) {
        if (self.articleModel.media_type == 8) {
            JHMediaViewController *media = [self.viewcontroller.storyboard instantiateViewControllerWithIdentifier:@"JHMediaViewController"];
            media.title = self.viewcontroller.navigationItem.title;
            [media setContentWithArticleModel:self.articleModel];
            media.hidesBottomBarWhenPushed = YES;
            [self.viewcontroller.navigationController pushViewController:media animated:YES];
        }else{
            JHRepostViewController *repost = [self.viewcontroller.storyboard instantiateViewControllerWithIdentifier:@"JHRepostViewController"];
            repost.hidesBottomBarWhenPushed = YES;
            repost.model = self.articleModel;
            [self.viewcontroller.navigationController pushViewController:repost animated:YES];
        }
    }else if (sender.tag == 0){
        self.buttonOne.selected = !self.buttonOne.selected;
        [self postStatusTag:sender.tag isSlect:self.buttonOne.selected];
    }else if (sender.tag == 1){
        self.buttonTwo.selected = !self.buttonTwo.selected;
        [self postStatusTag:sender.tag isSlect:self.buttonTwo.selected];
    }else if (sender.tag == 3){
        if (self.articleModel.media_type== 2){
            carousel_media *media = self.articleModel.media[0];
            video_versions *video = media.videos[0];
            [self downloadVideoFinished:video.url succeed:^(BOOL data) {
                [self.viewcontroller showAlertViewWithText:NSLocalizedString(@"2412", nil) afterDelay:1];
            }];
        }else{
            [self showLodingInView:self.viewcontroller.view];
            [self loadImageFinished:self.photo.image succeed:^(BOOL data) {
                [self hiddenLoding];
                [self.viewcontroller showAlertViewWithText:NSLocalizedString(@"2753", nil) afterDelay:1];
            }];
        }
       
    }else{
        UIActivityViewController *activityVC = [self shareContentWithUserWithFeed:self.articleModel];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            activityVC.popoverPresentationController.sourceView = self.viewcontroller.view;
            [self.viewcontroller presentViewController:activityVC animated:YES completion:nil];
        } else {
            [self.viewcontroller presentViewController:activityVC animated:YES completion:nil];
        }
    }
 
}
-(void)likecommentButtonOnclicked:(UIButton *)sender{
    if (sender.tag == 1) {
        JHUsersListViewController *list = [self.viewcontroller.storyboard instantiateViewControllerWithIdentifier:@"JHUsersListViewController"];
        [list setContentWithPk:self.articleModel.pkStr withTitle:NSLocalizedString(@"2762", nil) withUsername:self.articleModel.user.username];
        list.hidesBottomBarWhenPushed = YES;
        [self.viewcontroller.navigationController pushViewController:list animated:YES];
    }else{
        JHMediaCommentsViewController *list = [self.viewcontroller.storyboard instantiateViewControllerWithIdentifier:@"JHMediaCommentsViewController"];
        list.hidesBottomBarWhenPushed = YES;
        [list setContentWithArticleModel:self.articleModel];
        [self.viewcontroller.navigationController pushViewController:list animated:YES];
    }
}
//点击事件
-(void)clickImage
{
    JHGenealViewController *geneal = [self.viewcontroller.storyboard instantiateViewControllerWithIdentifier:@"JHGenealViewController"];
    [geneal setContentWithPkStr:self.articleModel.user.pkStr];
    [self.viewcontroller.navigationController pushViewController:geneal animated:YES];
}
-(void)praidClicked{
    self.buttonOne.selected = !self.buttonOne.selected;
    [self postStatusTag:self.buttonOne.tag isSlect:self.buttonOne.selected];
}
-(void)postStatusTag:(NSInteger)tag isSlect:(BOOL)select{
//    [self.viewcontroller showLoding];
    [[JHNetworkManager shareInstance] postStatus:tag isSelected:select withPk:self.articleModel.pkStr succeed:^(BOOL data) {
//        [self.viewcontroller hiddenLoding];
        NSString *text;
        if (data) {
            if (tag == 0) {
                if (select) {
                    text =NSLocalizedString(@"2776", nil);
                    [self.viewcontroller showAlertViewWithImage:@"icon_like_default" WithTitle:text afterDelay:1];

                }else{
                    text =NSLocalizedString(@"2777", nil);
                    [self.viewcontroller showAlertViewWithImage:@"icon_like_pressed" WithTitle:text afterDelay:1];

                }
                [self setContentLikeButton:select];
            }else{
                if (select) {
                    text =NSLocalizedString(@"2780", nil);
                    [self.viewcontroller showAlertViewWithImage:@"icon_collected_pressed" WithTitle:text afterDelay:1];

                }else{
                    text =NSLocalizedString(@"2781", nil);
                    [self.viewcontroller showAlertViewWithImage:@"icon_collected_default" WithTitle:text afterDelay:1];

                }
                [self setContentCollectutton:select];
            }
        }else{
            if (tag == 0) {
                if (select) {
                    text =NSLocalizedString(@"2778", nil);
                }else{
                    text =NSLocalizedString(@"2779", nil);
                }
            }else{
                if (select) {
                    text =NSLocalizedString(@"2782", nil);
                }else{
                    text =NSLocalizedString(@"2783", nil);
                }
            }
            [self.viewcontroller showAlertViewWithText:text afterDelay:1];

        }

    } failure:^(NSString *error) {
        [self.viewcontroller hiddenLoding];
        [self.viewcontroller showAlertViewWithText:error afterDelay:1];
    }];
}
-(void)setContentLikeButton:(BOOL)select{
    if (select) {
        [self.buttonOne setBackgroundImage:[UIImage imageNamed:@"icon_like_default"] forState:UIControlStateNormal];
        self.buttonOne.selected = YES;
    }else{
        [self.buttonOne setBackgroundImage:[UIImage imageNamed:@"icon_like_pressed"] forState:UIControlStateNormal];
        self.buttonOne.selected = NO;
    }
}
-(void)setContentCollectutton:(BOOL)select{
    if (select) {
        [self.buttonTwo setBackgroundImage:[UIImage imageNamed:@"icon_collected_pressed"] forState:UIControlStateNormal];
        self.buttonTwo.selected = YES;
    }else{
        [self.buttonTwo setBackgroundImage:[UIImage imageNamed:@"icon_collected_default"] forState:UIControlStateNormal];
        self.buttonTwo.selected = NO;
    }
}
#pragma mark - UI
-(void)cellWillLoadSubView{
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.nameLable];
    [self.contentView addSubview:self.dateLable];
    [self.contentView addSubview:self.mediaView];
    [self.contentView addSubview:self.photo];
    [self creatButtons];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.likeButton];
    [self.contentView addSubview:self.msgButton];
    [self.contentView addSubview:self.lableOne];
}
-(void)cellWillLoadAutoLayout{
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(K_RATIO_SIZE(10));
        make.top.equalTo(K_RATIO_SIZE(11));
        make.width.height.equalTo(K_RATIO_SIZE(45));
    }];
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.icon.mas_trailing).offset(M_RATIO_SIZE(10));
        make.centerY.equalTo(self.icon);
    }];
    [self.dateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(K_RATIO_SIZE(-10));
        make.centerY.equalTo(self.icon);
    }];
    [self.mediaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.contentView);
        make.top.equalTo(self.icon.mas_bottom).offset(M_RATIO_SIZE(11));
    }];
    [self.photo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.mediaView);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.icon);
        make.trailing.equalTo(self.dateLable);
        make.top.equalTo(self.buttonOne.mas_bottom).offset(M_RATIO_SIZE(9));
        make.height.equalTo(@1);
    }];
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(M_RATIO_SIZE(10));
        make.leading.equalTo(self.icon);
        make.height.equalTo(K_RATIO_SIZE(18));
    }];
    [self.msgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.likeButton.mas_trailing).offset(M_RATIO_SIZE(12));
        make.height.top.equalTo(self.likeButton);
    }];
    [self.lableOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.likeButton.mas_bottom).offset(M_RATIO_SIZE(16));
        make.leading.equalTo(self.icon);
        make.trailing.equalTo(self.dateLable);
    }];
    [self.likeButton setUpLeftImgWithWid:M_RATIO_SIZE(18) WithHeight:M_RATIO_SIZE(18) WithSpan:0];
    [self.msgButton setUpLeftImgWithWid:M_RATIO_SIZE(18) WithHeight:M_RATIO_SIZE(18) WithSpan:0];
}
-(void)creatButtons{
    NSArray *iconStrList = @[@"icon_like_pressed",@"icon_collected_default",@"icon_repost",@"icon_saved",@"icon_share"];
    for (int i=0; i<iconStrList.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:iconStrList[i]] forState:UIControlStateNormal];
        [self.contentView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mediaView.mas_bottom).offset(M_RATIO_SIZE(8));
            make.width.height.equalTo(K_RATIO_SIZE(24));
            if (i == 4) {
                make.trailing.equalTo(K_RATIO_SIZE(-10));
            }else{
                CGFloat left = M_RATIO_SIZE(7)+M_RATIO_SIZE(40)*i;
                make.leading.equalTo(@(left));
            }
        }];
        if (i == 0) {
            self.buttonOne = button;
        }else if (i == 1){
            self.buttonTwo = button;
        }else if (i == 2){
            self.buttonThree = button;
        }else if (i == 3){
            self.buttonFour = button;
        }else if (i == 4){
            self.buttonUp = button;
        }
        button.tag = i;
        [button addTarget:self action:@selector(buttonOnclicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}
#pragma mark - custom sccessors
-(UIImageView *)icon{
    if (_icon == nil) {
        _icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_posts_s"]];
        _icon.layer.masksToBounds = YES;
        _icon.layer.cornerRadius = M_RATIO_SIZE(45)/2;
        _icon.contentMode = UIViewContentModeScaleAspectFill;
        _icon.userInteractionEnabled = YES;//打开用户交互
        //初始化一个手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
        //为图片添加手势
        [_icon addGestureRecognizer:tapGesture];
   
    }
    return _icon;
}
-(UILabel *)nameLable{
    if (_nameLable == nil) {
        _nameLable = [UILabel createLableTextColor:[UIColor colorWithR:66 g:75 b:87 alpha:1] font:15 numberOfLines:1];
    }
    return _nameLable;
}
-(UILabel *)dateLable{
    if (_dateLable == nil) {
        _dateLable = [UILabel createLableTextColor:[UIColor colorWithR:161 g:170 b:181 alpha:1] font:12 numberOfLines:1];
    }
    return _dateLable;
}

-(UIView *)mediaView{
    if (_mediaView == nil) {
        _mediaView = [[UIView alloc] init];
        _mediaView.tag = 100;
    }
    return _mediaView;
}
-(UIImageView *)photo{
    if (_photo == nil) {
        _photo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_posts_s"]];
        _photo.contentMode = UIViewContentModeScaleAspectFit;
        _photo.userInteractionEnabled = YES;//打开用户交互
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(praidClicked)];
        tapGesture.numberOfTapsRequired = 2;//点击次数
        [_photo addGestureRecognizer:tapGesture];
     
    }
    return _photo;
}
-(UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    }
    return _lineView;
}
-(JHCustomButton *)likeButton{
    if (_likeButton == nil) {
        _likeButton = [JHCustomButton createButton];
        [_likeButton setContentIconStr:@"icon_like" withTextStr:@"0" withTextFont:[UIFont systemFontOfSize:13] WithTextColor:[UIColor colorWithR:161 g:170 b:181 alpha:1]];
        [_likeButton addTarget:self action:@selector(likecommentButtonOnclicked:) forControlEvents:UIControlEventTouchUpInside];
        _likeButton.tag = 1;
    }
    return _likeButton;
}
-(JHCustomButton *)msgButton{
    if (_msgButton == nil) {
        _msgButton = [JHCustomButton createButton];
        [_msgButton setContentIconStr:@"icon_comment" withTextStr:@"0" withTextFont:[UIFont systemFontOfSize:13] WithTextColor:[UIColor colorWithR:161 g:170 b:181 alpha:1]];
        [_msgButton addTarget:self action:@selector(likecommentButtonOnclicked:) forControlEvents:UIControlEventTouchUpInside];
        _msgButton.tag = 2;
    }
    return _msgButton;
}
-(YYLabel *)lableOne{
    if (_lableOne == nil) {
        _lableOne = [YYLabel new];
        _lableOne.numberOfLines = 0;  //设置多行显示
        _lableOne.preferredMaxLayoutWidth = kScreenWidth-M_RATIO_SIZE(20); //设置最大的宽度
        _lableOne.userInteractionEnabled = YES;
    }
    return _lableOne;
}

@end
