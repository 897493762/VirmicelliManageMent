//
//  NSString+JHDate.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/20.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "NSString+JHDate.h"

@implementation NSString (JHDate)

//时间戳
+ (NSString *)time_timestampToString:(NSInteger)timestamp{
    NSString *timeStr = [NSString stringWithFormat:@"%ld",(long)timestamp];
    NSTimeInterval interval = [timeStr doubleValue];
    if (timeStr.length >10) {
       interval=[[timeStr substringToIndex:10] doubleValue];
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
    
}

/**
 * 计算指定时间与当前的时间差
 * @param compareDateStr   某一指定时间
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */
+(NSString *) compareCurrentTime:(NSString *)compareDateStr
{
    if (isEmptyString(compareDateStr)) {
        return nil;
    }else{
        if (compareDateStr.length <19) {
            compareDateStr = [NSString stringWithFormat:@"%@:00",compareDateStr];
        }
        NSDateFormatter *date = [[NSDateFormatter alloc]init];
        [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *endD = [date dateFromString:compareDateStr];
        
        NSTimeInterval  timeInterval = [endD timeIntervalSinceNow];
        timeInterval = -timeInterval;
        long temp = 0;
        NSString *result;
        if (timeInterval < 60) {
            result = [NSString stringWithFormat:@"刚刚"];
        }
        else if((temp = timeInterval/60) <60){

            result = [NSString stringWithFormat:@"%ldmin",temp];
        }
        
        else if((temp = temp/60) <24){
            result = [NSString stringWithFormat:@"%ldhour",temp];
        }
        
        else if((temp = temp/24) <30){
            result = [NSString stringWithFormat:@"%ldday",temp];
        }
        
        else if((temp = temp/30) <12){
            result = [NSString stringWithFormat:@"%ldmonth",temp];
        }
        else{
            temp = temp/12;
            result = [NSString stringWithFormat:@"%ldyear",temp];
        }
        return  result;
    }
}
+(BOOL)isDianzCompareTime:(NSString *)timeStr{
    if (isEmptyString(timeStr)) {
        return nil;
    }else{
        if (timeStr.length <19) {
            timeStr = [NSString stringWithFormat:@"%@:00",timeStr];
        }
        NSDateFormatter *date = [[NSDateFormatter alloc]init];
        [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *endD = [date dateFromString:timeStr];
        
        NSTimeInterval  timeInterval = [endD timeIntervalSinceNow];
        timeInterval = -timeInterval;
        long temp = 0;
        NSString *result;
       if((temp = temp/24) <30){
            result = [NSString stringWithFormat:@"%ldday",temp];
           if (temp<7) {
               return YES;
           }else{
               return NO;
           }
       }else{
           return NO;
       }
    }
}
+ (NSDate *)postDataTimeStr:(NSString *)timeStr
{
    long long birthday=[timeStr longLongValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:birthday/1000.0];
    return date;
}
+(NSString *)isEqualToNil:(NSString *)str
{
    if (!str)
    {
        return @"0";
    }
    else
    {
        if(![str isEqual:[NSNull null]])
        {
            return str;
        }
        else{
            return @"0";
        }
    }
}
@end
