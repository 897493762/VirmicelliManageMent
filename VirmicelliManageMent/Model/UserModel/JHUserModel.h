//
//  JHUserModel.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/11/16.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHBaseModel.h"

@interface JHUserModel : JHBaseModel
@property (nonatomic, assign) long pk;
@property (nonatomic, assign) BOOL isPrint;

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *profile_pic_url;
@property (nonatomic, copy) NSString *full_name;
@property (nonatomic, assign) long device_timestamp;
@property (nonatomic, strong) NSString *timeStr;
@property (nonatomic, strong) NSString *pkStr;

@property (assign,nonatomic) NSInteger media_count;
@property (assign,nonatomic) NSInteger follower_count;
@property (assign,nonatomic) NSInteger following_count;
@property (assign,nonatomic) NSInteger type;


@property (assign,nonatomic) NSInteger follower;//关注我的
@property (assign,nonatomic) NSInteger following;//我关注的
@property (assign,nonatomic) NSInteger followEach;//互相关注的
@property (assign,nonatomic) NSInteger care;//我特别关心的
@property (assign,nonatomic) NSInteger unfollow; //取消关注我的人数

@property (assign,nonatomic) NSInteger praising_count;//我赞的
@property (assign,nonatomic) NSInteger praised_count;//赞我的
@property (assign,nonatomic) NSInteger comment_count;//评论我的
@property (nonatomic, assign) NSInteger popular_count;

@end
