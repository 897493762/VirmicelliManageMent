//
//  JHArticleModel.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/19.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHArticleModel.h"
#import "NSAttributedString+YYText.h"

@implementation JHArticleModel
-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"image_versions2"]) {
        image_versions2 *imags = [[image_versions2 alloc] initWithObject:value];
        self.image_versions2 = imags;
//        if (imags.candidates.count>0) {
//            carousel_media *media = [[carousel_media alloc] init];
//            media.media_type = 1;
//            media.image_versions2 = imags;
//            NSMutableArray *list = [NSMutableArray arrayWithObject:media];
//            self.media = list;
//        }

    }else if ([key isEqualToString:@"user"]){
        self.user = [[JHUserModel alloc] initWithObject:value];
    }else if ([key isEqualToString:@"caption"]){
        self.preview = [[preview_comments alloc] initWithObject:value];
    }else if ([key isEqualToString:@"carousel_media"]){
        NSMutableArray *list = [NSMutableArray array];
        for (NSDictionary *dic in value) {
            carousel_media *media = [[carousel_media alloc] initWithObject:dic];
            [list addObject:media];
        }
        self.media = list;
    }else if ([key isEqualToString:@"video_versions"]){
        NSMutableArray *arry = [NSMutableArray array];
        for (NSDictionary *dic in value) {
            video_versions *video = [[video_versions alloc] initWithObject:dic];
            [arry addObject:video];
        }
        self.video = arry;
//        if (arry.count>0) {
//            carousel_media *media = [[carousel_media alloc] init];
//            media.videos = arry;
//            media.media_type = 2;
//            NSMutableArray *list = [NSMutableArray arrayWithObject:media];
//            self.media = list;
//        }
      
    }
    else{
        [super setValue:value forKey:key];
    }
}
-(NSArray *)media{
    if (_media.count==0) {
        carousel_media *media = [[carousel_media alloc] init];
        media.videos = self.video;
        media.media_type = self.media_type;
        media.image_versions2 = self.image_versions2;
        NSMutableArray *list = [NSMutableArray arrayWithObject:media];
        _media = list;
    }
    return _media;
}
-(NSString *)timeStr{
    if (_timeStr == nil) {
        NSString *time = [NSString time_timestampToString:self.device_timestamp];
        _timeStr = [NSString compareCurrentTime:time];
    }
    return _timeStr;
}
-(NSString *)profile_pic_url{
    if (_profile_pic_url == nil) {
        if (self.media.count>0) {
            carousel_media *medias = self.media[0];
            candidates *can= medias.image_versions2.candidates[0];
            _profile_pic_url = can.url;
        }
    }
    return _profile_pic_url;
}
-(NSString *)pkStr{
    if (_pkStr == nil) {
        _pkStr = [NSString stringWithFormat:@"%ld",self.pk];
    }
    return _pkStr;
}
-(CGSize)photoSize{
    if (_photoSize.height ==0) {
        candidates *can;
        if (self.media.count>0) {
            carousel_media *medias = self.media[0];
            can= medias.image_versions2.candidates[0];
        }
        if (can.width > 0 && can.height > 0) {
            CGFloat ed = can.width/M_RATIO_SIZE(268);
            CGSize size = CGSizeMake(M_RATIO_SIZE(268), can.height/ed);
            _photoSize = size;
        }
    }
    
    return _photoSize;
}
-(CGFloat)getCellHeight:(BOOL)isSelectMore{
    CGFloat cellHeight = M_RATIO_SIZE(73)+self.photoSize.height;
    if (self.preview.textHeight >32) {
        self.isMore = isSelectMore;
        if (self.isMore) {
            cellHeight += self.preview.textHeight;
        }else{
            cellHeight += 34;
        }
    }else{
        self.isMore = YES;
        cellHeight += self.preview.textHeight;
    }
    self.cellHeight = cellHeight;
    return cellHeight;
}
-(CGFloat)cellHeight{
    if (_cellHeight == 0) {
        _cellHeight = [self getCellHeight:self.isMore];
    }
    return _cellHeight;
}
-(CGFloat)cellTwoHeight{
    if (_cellTwoHeight == 0) {
       _cellTwoHeight = [self getCellTwoHeight:self.isMore];
    }
    return _cellTwoHeight;
}
-(CGFloat)getCellTwoHeight:(BOOL)isSelectMore{
    CGFloat cellHeight = M_RATIO_SIZE(73)+self.photoSize.height;
    if (self.preview.textHeight >32) {
        self.isMore = isSelectMore;
        if (self.isMore) {
            cellHeight = M_RATIO_SIZE(71)+cellHeight+self.preview.textTwoHeight;
        }else{
            cellHeight = M_RATIO_SIZE(71)+cellHeight+34;
        }
    }else{
        self.isMore = YES;
        cellHeight = M_RATIO_SIZE(71)+cellHeight;
    }
    self.cellTwoHeight = cellHeight;
    return cellHeight;
}
//-----ins
-(CGFloat)inscellHeight{
    if (_inscellHeight == 0) {
        CGFloat cellHeight = M_RATIO_SIZE(182)+self.insPhotoSize.height+self.preview.textTwoHeight;
        _inscellHeight = cellHeight;
    }
    return _inscellHeight;
}
-(CGSize)insPhotoSize{
    if (_insPhotoSize.height ==0) {
        candidates *can;
        if (self.media.count >0) {
            carousel_media *medias = self.media[0];
            can= medias.image_versions2.candidates[0];
        }
        if (can.width > 0 && can.height > 0) {
            CGFloat ed = can.width/M_RATIO_SIZE(375);
            CGSize size = CGSizeMake(M_RATIO_SIZE(375), can.height/ed);
            _insPhotoSize = size;
        }
    }
    
    return _insPhotoSize;
}
@end
@implementation carousel_media
-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"image_versions2"]) {
        self.image_versions2 = [[image_versions2 alloc] initWithObject:value];
    }else if ([key isEqualToString:@"video_versions"]){
        NSMutableArray *arry = [NSMutableArray array];
        for (NSDictionary *dic in value) {
            video_versions *video = [[video_versions alloc] initWithObject:dic];
            [arry addObject:video];
        }
        self.videos = arry;
    }
    else{
        [super setValue:value forKey:key];
    }
}
@end
@implementation video_versions
-(CGSize)photoSize{
    if (_photoSize.height ==0) {
        if (self.width>0) {
            CGFloat ed = self.width/kScreenWidth;
            CGSize size = CGSizeMake(kScreenWidth, self.height/ed);
            _photoSize = size;
        }
    }
    
    return _photoSize;
}
@end
@implementation image_versions2
-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"candidates"]) {
        NSArray *arry = value;
        NSMutableArray *list = [NSMutableArray array];
        for (NSDictionary *dic in arry) {
            candidates *can = [[candidates alloc] initWithObject:dic];
            [list addObject:can];
        }
        self.candidates = list;
    }else{
        [super setValue:value forKey:key];
    }
}

@end
@implementation candidates
-(CGSize)photoSize{
    if (_photoSize.height ==0) {
        if (self.url !=nil) {
            CGFloat ed = self.width/kScreenWidth;
            CGSize size = CGSizeMake(kScreenWidth, self.height/ed);
            _photoSize = size;
            NSLog(@"%f------hh---%f",_photoSize.width,_photoSize.height);
        }
    }
    
    return _photoSize;
}
@end

@implementation preview_comments


-(CGFloat)textHeight{
    if (_textHeight ==0) {
        _textHeight = [self.text calcTextSizeWith:[UIFont systemFontOfSize:12] totalSize:CGSizeMake(M_RATIO_SIZE(270), CGFLOAT_MAX)];
        if (_textHeight >15) {
            _textHeight+=((int)ceil(_textHeight/15)-1)*M_RATIO_SIZE(2);
        }
    }
    return _textHeight;
}
-(CGFloat)textTwoHeight{
    if (_textTwoHeight ==0) {
        _textTwoHeight = [self.text calcTextSizeWith:[UIFont systemFontOfSize:12] totalSize:CGSizeMake(M_RATIO_SIZE(355), CGFLOAT_MAX)];
        if (_textTwoHeight >15) {
            _textTwoHeight+=((int)ceil(_textHeight/15)-1)*M_RATIO_SIZE(2);
        }
    }
    return _textTwoHeight;
}
#pragma mark - accessors

-(NSMutableAttributedString *)textAttributedString{
    if (_textAttributedString == nil) {
        if (isEmptyString(self.text)) {
        }else{
            NSMutableAttributedString *attrituteString = [[NSMutableAttributedString alloc] initWithString:self.text];
            attrituteString.yy_font = [UIFont systemFontOfSize:12];
            attrituteString.yy_lineSpacing = M_RATIO_SIZE(2);
            _textAttributedString =  attrituteString;
        }
    
    }
    return _textAttributedString;
}

-(NSArray *)insTagArry{
    if (_insTagArry == nil) {
        if (isEmptyString(self.text)) {
        }else{
            NSArray *array = [self.text componentsSeparatedByString:@"#"]; //字符串按照【分隔成数组
            _insTagArry = array;
        }
    }
    return _insTagArry;
}
@end
