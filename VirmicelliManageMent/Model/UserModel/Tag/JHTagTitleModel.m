//
//  JHTagModel.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/12.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHTagTitleModel.h"

@implementation JHTagTitleModel
-(CGFloat)tagTopHeight{
    if (_tagTopHeight == 0) {
        CGFloat oneHeight = (M_RATIO_SIZE(80)-([self.title calcTextSizeWith:[UIFont systemFontOfSize:13] totalSize:CGSizeMake((kScreenWidth/3)-M_RATIO_SIZE(20), CGFLOAT_MAX)]+24+M_RATIO_SIZE(4)))/2;
        _tagTopHeight = oneHeight;
    }
    return _tagTopHeight;
}
@end
