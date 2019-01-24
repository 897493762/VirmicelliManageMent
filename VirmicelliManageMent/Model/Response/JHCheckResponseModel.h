//
//  JHCheckResponseModel.h
//  RumHeadLine
//
//  Created by Wuxiaolian on 17/4/7.
//  Copyright © 2017年 Wu. All rights reserved.
//

#import "JHBaseResponseModel.h"
@class JHStatus;
@interface JHCheckResponseModel : JHBaseResponseModel
@property (nonatomic, copy) NSString *status;
@property (nonatomic, assign) int TotalNum;
@property (nonatomic, assign) BOOL data;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) BOOL success;
@property (nonatomic, strong) JHStatus *friendStatus;
@property (nonatomic, assign) BOOL following;
@property (nonatomic, assign) BOOL is_private;
@property (nonatomic, assign) BOOL followed_by;
@property (nonatomic, assign) BOOL outgoing_request;

@end

@interface JHStatus : JHBaseResponseModel
@property (nonatomic, assign) BOOL followed_by;

@end
