//
//  UILabel+JHAddition.m
//  RumHeadLine
//
//  Created by Wuxiaolian on 2017/10/27.
//  Copyright © 2017年 Wu. All rights reserved.
//

#import "UILabel+JHAddition.h"
#import <CoreText/CoreText.h>

@implementation UILabel (JHAddition)

+(UILabel *)createLableTextColor:(UIColor *)textColor font:(int)font numberOfLines:(int)numberOfLines{
    UILabel*lable = [[UILabel alloc]init];
    lable.textColor =textColor;
    lable.font = [UIFont systemFontOfSize:font];
    lable.numberOfLines = numberOfLines;
    return lable;

}
+(UILabel *)labelWithText:(NSString *)text Font:(CGFloat)font Color:(UIColor *)color Alignment:(NSTextAlignment)alignment{
    UILabel *label =[[UILabel alloc]init];
    label.text = text;
    label.font =[UIFont systemFontOfSize:font];
    label.textColor = color;
    label.textAlignment = alignment;
    return label;
}
- (NSArray *)getLinesArrayOfStringInLabel:(UILabel *)label{
    NSString *text = [label text];
    UIFont *font = [label font];
    CGRect rect = [label frame];
    
    CTFontRef myFont = CTFontCreateWithName(( CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge  id)myFont range:NSMakeRange(0, attStr.length)];
    CFRelease(myFont);
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString(( CFAttributedStringRef)attStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = ( NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    for (id line in lines) {
        CTLineRef lineRef = (__bridge  CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        NSString *lineString = [text substringWithRange:range];
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithFloat:0.0]));
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithInt:0.0]));
//        NSLog(@"''''''''''''''''''%@",lineString);
        [linesArray addObject:lineString];
    }
    
    CGPathRelease(path);
    CFRelease( frame );
    CFRelease(frameSetter);
    return (NSArray *)linesArray;
}
@end
