//
//  JHUserInfoModel.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/5.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHBaseModel.h"
@interface JHUserInfoModel : JHBaseModel
@property (nonatomic, assign) long pk;
@property (nonatomic, assign) BOOL isPrint;

@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *profile_pic_url;
@property (nonatomic, copy) NSString *full_name;

@property (nonatomic, copy) NSString *sign;

@property (nonatomic, assign) BOOL isRemember;//是否记住密码
@property (nonatomic, assign) CGFloat usernameWidth;
@property (nonatomic, copy) NSString *dateTime;
@property (nonatomic, copy) NSString *pkStr;
@property (strong, nonatomic) NSString *rank_token;
@property (strong, nonatomic) NSString *strCSRFToken;
@property (copy, nonatomic) NSString *token;

@property (nonatomic, strong)NSArray *specialFllows;
@property (nonatomic, strong)NSArray *cancelFllowers;
@property (nonatomic, strong)NSArray *followerList;
@property (nonatomic, strong)NSArray *otherFollowerList;

@property (nonatomic, assign) NSInteger follower_count;
@property (nonatomic, assign) NSInteger following_count;
@property (nonatomic, assign) NSInteger media_count;
@property (copy, nonatomic) NSString *biography;
@property (copy, nonatomic) NSString *external_url;
@property (strong, nonatomic) NSString *descCont;
@property (strong, nonatomic) NSMutableAttributedString *descAttribut;
@property (nonatomic, assign) BOOL is_favorite;
@property (nonatomic, assign) BOOL is_following;
@property (nonatomic, assign) BOOL is_verified;

@property (nonatomic, assign) NSInteger account_type;
@property (nonatomic, strong) NSArray *collectUsers;
@property (nonatomic, strong) NSArray *collectTags;

@end
