//
//  JHPurchase.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/10/25.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JHPurchase;

@interface JHPurchase : NSObject
/**
 *  创建并返回一个单例对象
 */
+ (instancetype)shareInstance;
/**
 *  内购
 *  type:1(恢复购买) 2（购买）
 */
- (void)clickPhures:(int)type succeed:(void (^)(BOOL data))succeed;

- (void)repursesucceed:(void (^)(BOOL data))succeed;

@end
