//
//  MXGoogleManager.m
//  GoogleAD
//
//  Created by Mr.Xiao on 2018/1/2.
//  Copyright © 2018年 Mr.Xiao. All rights reserved.
//

#import "MXGoogleManager.h"

@implementation MXGoogleManager

+ (instancetype)shareInstance{
    static MXGoogleManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MXGoogleManager alloc] init];
    });
    return manager;
}



@end
