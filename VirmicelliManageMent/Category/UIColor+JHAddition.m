//
//  UIColor+JHAddition.m
//  Ganjiuhui
//
//  Created by 罗毅 on 16/5/20.
//  Copyright © 2016年 blueteam. All rights reserved.
//

#import "UIColor+JHAddition.h"

@implementation UIColor (JHAddition)

+ (UIColor *)colorWithR:(CGFloat)r g:(CGFloat)g b:(CGFloat)b alpha:(CGFloat)alpha {
    
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:alpha];
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert {
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6 && [cString length] != 8) {
        return [UIColor clearColor];
    }
    unsigned int r = 255.0f, g = 255.0f, b = 255.0f, a = 255.0f;
    [[NSScanner scannerWithString:[cString substringWithRange:NSMakeRange(0, 2)]] scanHexInt:&r];
    [[NSScanner scannerWithString:[cString substringWithRange:NSMakeRange(2, 2)]] scanHexInt:&g];
    [[NSScanner scannerWithString:[cString substringWithRange:NSMakeRange(4, 2)]] scanHexInt:&b];
    if ([cString length] == 8) {
        [[NSScanner scannerWithString:[cString substringWithRange:NSMakeRange(6, 2)]] scanHexInt:&a];
    }
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:((float) a / 255.0f)];
}
@end
