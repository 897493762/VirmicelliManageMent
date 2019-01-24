//
//  JHUserinfosModel.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/12.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHBaseModel.h"
#import "JHUserInfoModel.h"
@interface JHUserinfosModel : JHBaseModel
@property (nonatomic, copy) NSString *pk;
@property (nonatomic, strong) NSArray *users;
@end
