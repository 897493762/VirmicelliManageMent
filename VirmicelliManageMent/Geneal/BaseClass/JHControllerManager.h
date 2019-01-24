//
//  JHControllerManager.h
//  TestDemo
//
//  Created by Satoshi Nakamoto on 2018/9/3.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHControllerManager : NSObject

+ (instancetype)ShareManager;

- (void)postNotification:(NSString *)name userInfo:(NSDictionary * )info;


@end
