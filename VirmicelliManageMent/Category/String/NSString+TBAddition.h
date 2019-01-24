//
//  NSString+TBAddition.h
//  TensWeibo
//
//  Created by MWeit on 16/3/23.
//  Copyright © 2016年 Weit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TBAddition)


/**
 *  计算文本的高度
 *
 *  @param font      字体大小
 *  @param totalSize 总文本大小
 *
 *  @return 文字高度
 */
- (CGFloat)calcTextSizeWith:(UIFont *)font totalSize:(CGSize)totalSize;
- (CGFloat)calcTextSizeWithWidth:(UIFont *)font totalSize:(CGSize)totalSize;
-(CGFloat)getSpaceLabelHeightwithSpeace:(CGFloat)lineSpeace withFont:(UIFont*)font withWidth:(CGFloat)width;
- (NSString *)filterHTML:(NSString *)html;

- (BOOL )isPhoneStr:(NSString *)phoneStr;
//字母和数字
- (BOOL )ischaracterAndNumber:(NSString *)str;
// 汉字
- (BOOL)deptNameInputShouldChinese:(NSString *)str;
// 数字
- (BOOL)deptNumInputShouldNumber:(NSString *)str;
// 字母
- (BOOL)deptPassInputShouldAlpha:(NSString *)str;
- (BOOL )isEmailStr:(NSString *)str;
- (BOOL )isPasswordStr:(NSString *)str;
/**
 *  更改网页内容宽高
 *  @param htmlString  html标签
 */
- (NSString *)changeHtmlContentSize:(NSString *)htmlString;

/**
 *  强制宽高缩略
 *  https://help.aliyun.com/document_detail/44688.html?spm=a2c4g.11186623.4.2.8oPYUV    阿里云
 */
- (NSString *)changeImageUrlContentSize:(NSString *)imageUrl withWidth:(CGFloat)width withHeight:(CGFloat)height;
//从htmlString中截取需要的字符串
- (NSArray *)componentsSeparatedFromString:(NSString *)fromString toString:(NSString *)toString;
//** 根据文字字体大小返回文本宽度*/
- (CGRect)textRectWithSize:(CGSize)size attributes:(NSDictionary *)attributes;
@end
