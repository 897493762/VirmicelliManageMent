//
//  JHCollectModel.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2019/1/8.
//  Copyright © 2019年 Satoshi Nakamoto. All rights reserved.
//

#import "JHBaseModel.h"
#import "JHUserInfoModel.h"
@interface JHCollectModel : JHBaseModel
@property (nonatomic, strong) NSArray *medias;
@property (nonatomic, strong) JHUserInfoModel *user;
@property (nonatomic, strong) NSString *tagName;

@end
