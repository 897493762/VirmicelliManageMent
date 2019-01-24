//
//  JHArticleModel.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/19.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHBaseModel.h"
@class image_versions2;
@class candidates;
@class preview_comments;
@class carousel_media;
@class video_versions;
#import "JHUserModel.h"
@interface JHArticleModel : JHBaseModel
@property (nonatomic, assign) long pk;
@property (nonatomic, assign) int like_count;
@property (nonatomic, assign) int comment_count;
@property (nonatomic, assign) NSInteger device_timestamp;
@property (nonatomic, assign) NSInteger media_type;

@property (nonatomic, strong) image_versions2 *image_versions2;
@property (nonatomic, strong) JHUserModel *user;
@property (nonatomic, strong) preview_comments *preview;
@property (nonatomic, strong) NSArray *video;

@property (nonatomic, strong) NSString *timeStr;
@property (nonatomic, strong) NSString *profile_pic_url;
@property (nonatomic, strong) NSString *pkStr;
@property (nonatomic, assign) BOOL has_liked;

@property (nonatomic, assign) int carousel_media_count;
@property (nonatomic, strong) NSArray *media;
@property (nonatomic, strong) carousel_media *mmd;

@property (nonatomic, assign) CGSize photoSize;

@property (nonatomic, assign) BOOL isMore;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat cellTwoHeight;
-(CGFloat)getCellHeight:(BOOL)isSelectMore;
-(CGFloat)getCellTwoHeight:(BOOL)isSelectMore;

//ins帖子
@property (nonatomic, assign) CGFloat inscellHeight;
@property (nonatomic, assign) CGSize insPhotoSize;

@end
@interface carousel_media : JHBaseModel
@property (nonatomic, copy) NSString *idstr;
@property (nonatomic, assign) long media_type;
@property (nonatomic, strong) image_versions2 *image_versions2;
@property (nonatomic, strong) NSArray *videos;

@end
@interface video_versions : JHBaseModel
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) long width;
@property (nonatomic, assign) long height;
@property (nonatomic, assign) CGSize photoSize;

@end
@interface image_versions2 : JHBaseModel
@property (nonatomic, strong) NSArray *candidates;
@end

@interface candidates : JHBaseModel
@property (nonatomic, assign) long width;
@property (nonatomic, assign) long height;
@property (nonatomic, assign) CGSize photoSize;
@property (nonatomic, copy) NSString *url;

@end
@interface preview_comments : JHBaseModel
@property (nonatomic, assign) int pk;
@property (nonatomic, assign) int user_id;
@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong) NSMutableAttributedString *textAttributedString;
@property (nonatomic, assign) CGFloat textHeight;
@property (nonatomic, assign) CGFloat textTwoHeight;
@property (nonatomic, strong) NSArray *insTagArry;


@end

