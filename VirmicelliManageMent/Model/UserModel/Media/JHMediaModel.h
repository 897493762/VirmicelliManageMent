//
//  JHMediaModel.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/11/16.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHBaseModel.h"

@interface JHMediaModel : JHBaseModel
@property (nonatomic, copy) NSString *pk;
@property (nonatomic, assign) int like_count;
@property (nonatomic, assign) int comment_count;
@property (nonatomic, assign) int popular_count;
@property (nonatomic, assign) int media_type;
@property (nonatomic, assign) long device_timestamp;
@property (nonatomic, strong) NSString *image_url;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *profile_pic_url;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *timeStr;
@property (nonatomic, assign) BOOL big_list;

@property (nonatomic, assign) long width;
@property (nonatomic, assign) long height;

@end
