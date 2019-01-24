//
//  NSString+TBAddition.m
//  TensWeibo
//
//  Created by MWeit on 16/3/23.
//  Copyright © 2016年 Weit. All rights reserved.
//

#import "NSString+TBAddition.h"

@implementation NSString (TBAddition)

- (CGFloat)calcTextSizeWith:(UIFont *)font totalSize:(CGSize)totalSize {
    NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin |
    NSStringDrawingUsesFontLeading;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary *attributes = @{ NSFontAttributeName :font, NSParagraphStyleAttributeName :style};
    
    
        CGSize size = [self boundingRectWithSize:totalSize
                                         options:opts
                                      attributes:attributes
                                         context:nil].size;
    
    return ceil(size.height);

}

-(CGFloat)calcTextSizeWithWidth:(UIFont *)font totalSize:(CGSize)totalSize{
    NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin |
    NSStringDrawingUsesFontLeading;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary *attributes = @{ NSFontAttributeName :font, NSParagraphStyleAttributeName :style};
    
    
    CGSize size = [self boundingRectWithSize:totalSize
                                     options:opts
                                  attributes:attributes
                                     context:nil].size;
    
    return ceil(size.width);
}


/**
 *  计算富文本字体高度
 *
 *  @param lineSpeace 行高
 *  @param font       字体
 *  @param width      字体所占宽度
 *
 *  @return 富文本高度
 */
-(CGFloat)getSpaceLabelHeightwithSpeace:(CGFloat)lineSpeace withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    /** 行高 */
    paraStyle.lineSpacing = lineSpeace;
    // NSKernAttributeName字体间距
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    CGSize size = [self boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    NSLog(@"%f-----富文本高度",size.height);
    return size.height;
}
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    if ([html containsString:@"\n"]) {
        html = [html stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    return html;
}
-(BOOL)isPhoneStr:(NSString *)phoneStr{
    phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (phoneStr.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((13[3,49])|(149)|(153)|(17[3,7])|(18[0,1,9]))\\d{8}$";

        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:phoneStr];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:phoneStr];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:phoneStr];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }

}
-(BOOL)ischaracterAndNumber:(NSString *)str{
    NSString *regex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL result = [pred evaluateWithObject:str];
    return result;
}
-(BOOL)deptNameInputShouldChinese:(NSString *)str{
    BOOL isValid = NO;
    
    if (str.length > 0)
    {
        for (NSInteger i=0; i<str.length; i++)
        {
            unichar chr = [str characterAtIndex:i];
            
            if (chr < 0x80)
            { //字符
                if (chr >= 'a' && chr <= 'z')
                {
                    isValid = YES;
                }
                else if (chr >= 'A' && chr <= 'Z')
                {
                    isValid = YES;
                }
                else if (chr >= '0' && chr <= '9')
                {
                    isValid = NO;
                }
                else if (chr == '-' || chr == '_')
                {
                    isValid = YES;
                }
                else
                {
                    isValid = NO;
                }
            }
            else if (chr >= 0x4e00 && chr < 0x9fa5)
            { //中文
                isValid = YES;
            }
            else
            { //无效字符
                isValid = NO;
            }
            
            if (!isValid)
            {
                break;
            }
        }
    }
    
    return isValid;
}
-(BOOL)deptNumInputShouldNumber:(NSString *)str{
    NSString *regex =@"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL result = [pred evaluateWithObject:str];
    return result;
}
-(BOOL)deptPassInputShouldAlpha:(NSString *)str{
    NSString *regex =@"[a-zA-Z]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL result = [pred evaluateWithObject:str];
    return result;
}
-(BOOL)isEmailStr:(NSString *)str{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:str];
}
-(BOOL)isPasswordStr:(NSString *)str{
    NSString *pattern = @"^([a-zA-Z]|[a-zA-Z0-9]|[0-9]){6,18}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}
/**
 *  更改网页内容宽高
 *  @param htmlString  html标签
 */
- (NSString *)changeHtmlContentSize:(NSString *)htmlString{
    
    if(htmlString!=nil)
    {
        NSString *htmlStr = [NSString stringWithFormat:@"<html><head><meta name='viewport' content='width=device-width, initial-scale=1.0, user-scalable=no'> <link href='https://oss.zgtjtt.com/tjtt_app_style/tjtt_content_1.0.0.css' rel='stylesheet'><script type='text/javascript'>var winWidth = window.screen.width;var size = (winWidth / 750) * 100;document.documentElement.style.fontSize = (size < 100 ? size : 100) + 'px';window.onload = function(){"
            "var $img = document.getElementsByTagName('img');\n"
            "for(var p in  $img){\n"
            " $img[p].style.width = '100%%';\n"
            "$img[p].style.height ='auto'\n"
            "}"
            "}</script></head><body>%@",htmlString];
//        NSLog(@"%@",htmlStr);
        return htmlStr;
    }
    
    return @""; 
    
}
-(NSString *)changeImageUrlContentSize:(NSString *)imageUrl withWidth:(CGFloat)width withHeight:(CGFloat)height{
    int w = (int)width;
    int h = (int)height;
    if ([imageUrl containsString:@"oss"]) {
            return [NSString stringWithFormat:@"%@?x-oss-process=image/resize,m_fixed,h_%@,w_%@/format,webp",imageUrl,[NSString stringWithFormat:@"%d",h],[NSString stringWithFormat:@"%d",w]];

    }else{
        return imageUrl;
    }

}
//从htmlString中截取需要的字符串
- (NSArray *)componentsSeparatedFromString:(NSString *)fromString toString:(NSString *)toString
{
    if (!fromString || !toString || fromString.length == 0 || toString.length == 0) {
        return nil;
    }
    NSMutableArray *subStringsArray = [[NSMutableArray alloc] init];
    NSString *tempString = self;
    NSRange range = [tempString rangeOfString:fromString];
    while (range.location != NSNotFound) {
        tempString = [tempString substringFromIndex:(range.location + range.length)];
        range = [tempString rangeOfString:toString];
        if (range.location != NSNotFound) {
            [subStringsArray addObject:[tempString substringToIndex:range.location]];
            range = [tempString rangeOfString:fromString];
        }
        else
        {
            break;
        }
    }
    return subStringsArray;
}
- (CGRect)textRectWithSize:(CGSize)size attributes:(NSDictionary *)attributes
{
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
}
@end
