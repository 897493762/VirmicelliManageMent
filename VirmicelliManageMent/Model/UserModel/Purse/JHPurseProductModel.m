//
//  JHPurseProductModel.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/10/10.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHPurseProductModel.h"

@implementation JHPurseProductModel
-(NSString *)transactionDateStr{
    if (self.transactionDate !=nil) {
        _transactionDateStr = [self getDateString:self.transactionDate];
    }
    return _transactionDateStr;
}
-(NSDate *)getFutureDate{
    NSCalendar *calendar = nil;
    if ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0) {
        calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    } else {
        calendar = [NSCalendar currentCalendar];
    }
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.transactionDate];
    [dateComponents setYear:1];
    [dateComponents setDay:3];
    NSDate *newdate = [calendar dateByAddingComponents:dateComponents toDate:self.transactionDate options:0];
    return newdate;
}
@end
