//
//  JHTagTitleModel.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/12.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHBaseModel.h"

@interface JHTagTitleModel : JHBaseModel
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *selectIconname;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSArray *typeList;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) CGFloat tagTopHeight;
@property (nonatomic, assign) BOOL isRefresh;

@end
