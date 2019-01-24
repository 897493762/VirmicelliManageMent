//
//  JHUserModel.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/11/16.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHUserModel.h"

@implementation JHUserModel

-(NSString *)pkStr{
    if (_pkStr == nil) {
        _pkStr = [NSString stringWithFormat:@"%ld",self.pk];
    }
    return _pkStr;
}

-(NSInteger)popular_count{
    if (_popular_count == 0) {
        _popular_count = self.praised_count+self.comment_count;
    }
    return _popular_count;
}
-(NSInteger)followEach{
    if (self.following == 1 && self.follower == 1) {
        _followEach = 1;
    }
    return _followEach;
}
@end
