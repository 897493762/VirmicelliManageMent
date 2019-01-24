//
//  JHPurseProductModel.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/10/10.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHBaseModel.h"

@interface JHPurseProductModel : JHBaseModel
@property (nonatomic, assign)NSInteger productIdentifier;
@property (nonatomic, strong)NSDate *transactionDate;
@property (nonatomic, strong)NSString *transactionDateStr;
@property (nonatomic, assign)BOOL isVipState;

@end
