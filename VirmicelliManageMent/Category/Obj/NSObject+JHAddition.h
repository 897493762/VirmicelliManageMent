//
//  NSObject+JHAddition.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/5.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHArticleModel.h"
@interface NSObject (JHAddition)
/*
 *has加密
 */
- (NSString *)hmac:(NSString* )plaintext withKey:(NSString *)key;

//获取当前的时间

-(NSString*)getCurrentTimes;

/*
 *date转string
 */
- (NSString *)getDateString:(NSDate *)date;
/*
 *保存图片到系统相册
 */
//- (void)saveImageFinished:(UIImage *)image;
/**
 生成二维码
 
 @param url 二维码的URL
 @param View 添加到哪一个View上面
 */
- (UIImage *)setErWeiMaWithUrl:(NSString *)url text:(NSString *)text AndView:(UIView *)View;
//两个UIImage 合成一个Image
-(UIImage *)getImage:(UIImage *)imageOne imageTwo:(UIImage *)imageTwo;
-(UIImage *)getCustomImage:(UIImage *)imageOne imageTwo:(UIImage *)imageTwo;
-(UIImage *)getShareImage:(UIImage *)bgImage imageOne:(UIImage *)imageOne imageTwo:(UIImage *)imageTwo;

//view 转化成image
- (UIImage *)imageForView:(UIView *)view;
- (UIImage *)setQRCodeWithContent:(NSString *)content watermarkImage:(UIImage *)watermar;
- (UIImage *)imageForView:(UIView *)view withBounds:(CGRect)bounds;

#pragma mark -- 保存图片到系统相册
- (void)loadImageFinished:(UIImage *)image succeed:(void (^)(BOOL data))succeed;
#pragma mark -- 保存视频到系统相册
- (void)downloadVideoFinished:(NSString *)url succeed:(void (^)(BOOL data))succeed;
#pragma mark -- 打开Instagram
-(void)openInstagramReleaseImage:(NSString *)assetUrl;
#pragma mark -- 分享
-(UIActivityViewController *)shareContentWithUserWithFeed:(JHArticleModel* )userWithFeed;


@end
