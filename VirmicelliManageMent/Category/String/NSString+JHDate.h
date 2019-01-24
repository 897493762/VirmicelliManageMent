//
//  NSString+JHDate.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/20.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JHDate)

/*
 *时间戳转字符串
 */
+ (NSString *)time_timestampToString:(NSInteger)timestamp;
/**
 * 计算指定时间与当前的时间差
 * @param compareDateStr   某一指定时间
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */
+(NSString *)compareCurrentTime:(NSString *)compareDateStr;
/*
 *是否是最后一周点赞
 */
+(BOOL)isDianzCompareTime:(NSString *)timeStr;
+ (NSDate *)postDataTimeStr:(NSString *)timeStr;
+(NSString *)isEqualToNil:(NSString *)str;
@end
