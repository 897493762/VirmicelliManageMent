//
//  JHMediaModel.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/11/16.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHMediaModel.h"

@implementation JHMediaModel


-(NSString *)timeStr{
    if (_timeStr == nil) {
        NSString *time = [NSString time_timestampToString:self.device_timestamp];
        _timeStr = [NSString compareCurrentTime:time];
    }
    return _timeStr;
}
@end
