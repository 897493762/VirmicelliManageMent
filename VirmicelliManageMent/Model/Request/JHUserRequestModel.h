//
//  JHUserRequestModel.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/12.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHBaseModel.h"

@interface JHFllowerRequest : JHBaseModel
//关注我
@property (nonatomic, copy) NSString *ig_sig_key_version;
@property (nonatomic, copy) NSString *rank_token;
@property (nonatomic, copy) NSString *max_id;

//我关注
@property (nonatomic, copy) NSString *rank_mutual;


@end

@interface JHUserRequestModel : JHBaseModel
//关注我
@property (nonatomic, copy) NSString *ig_sig_key_version;
@property (nonatomic, copy) NSString *rank_token;
@property (nonatomic, copy) NSString *max_id;
@property (nonatomic, copy) NSString *story_ranking_token;
//我关注
@property (nonatomic, copy) NSString *rank_mutual;
//获取照片
@property (nonatomic, copy) NSString *ranked_content;

//附近用户
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lng;

//搜索
@property (nonatomic, copy) NSString *is_typeahead;
@property (nonatomic, copy) NSString *query;
@property (nonatomic, copy) NSString *next_max_id;

@end
