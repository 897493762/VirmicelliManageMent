//
//  JHTestModel.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/12.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHBaseModel.h"

@interface JHTestModel : JHBaseModel
@property (nonatomic, assign) int count;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *imagestr;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;

@property (nonatomic, strong) NSArray *likers;
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) NSArray *populars;
@property (nonatomic, strong) NSArray *users;
@property (nonatomic, assign) NSInteger userCount;


@end
