//
//  UILabel+JHAddition.h
//  RumHeadLine
//
//  Created by Wuxiaolian on 2017/10/27.
//  Copyright © 2017年 Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (JHAddition)
//创建lable
+ (UILabel*)createLableTextColor:(UIColor *)textColor font:(int)font  numberOfLines:(int)numberOfLines;
+(UILabel *)labelWithText:(NSString *)text Font:(CGFloat)font Color:(UIColor *)color Alignment:(NSTextAlignment)alignment;

// 获取lable行数
- (NSArray *)getLinesArrayOfStringInLabel:(UILabel *)label;
@end
