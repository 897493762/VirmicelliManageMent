//
//  JHCommentModel.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/3.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHBaseModel.h"

@interface JHCommentModel : JHBaseModel
@property (nonatomic, strong) JHUserModel *user;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) long created_at;
@property (nonatomic, strong) NSMutableAttributedString *contentAttribute;

@end
