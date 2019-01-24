//
//  JHAppStatusModel.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/11/2.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHBaseModel.h"

@interface JHAppStatusModel : JHBaseModel
@property (nonatomic, assign)BOOL isLogin;
@property (nonatomic, assign)BOOL isFirst;
@property (nonatomic, assign)BOOL isPurchase;
@property (nonatomic, assign)BOOL isComment;
@property (nonatomic, copy) NSString *products;
@end
