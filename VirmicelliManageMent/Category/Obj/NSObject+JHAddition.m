//
//  NSObject+JHAddition.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/5.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "NSObject+JHAddition.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import "YSQRCode.h"
#import "AFNetworking.h"
@implementation NSObject (JHAddition)
- (NSString *)hmac:(NSString* )plaintext withKey:(NSString *)key
{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [plaintext cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMACData = [[NSData alloc]initWithBytes:cHMAC length:sizeof(cHMAC)];
    //dataWithBytes:cHMAC length:sizeof(cHMAC)];
    const unsigned char *buffer = (const unsigned char* )[HMACData bytes];
    NSMutableString *HMAC = [[NSMutableString alloc]initWithCapacity:HMACData.length* 2];
    //stringWithCapacity:HMACData.length * 2];
    for (int i = 0; i < HMACData.length; ++i){
        [HMAC appendFormat:@"%02x", buffer[i]];
    }
    
    return HMAC ;
}
//获取当前的时间

-(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}
/*
 *date转string
 */
- (NSString *)getDateString:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString *currentTimeString = [formatter stringFromDate:date];
    
    return currentTimeString;
}
- (UIImage *)setQRCodeWithContent:(NSString *)content watermarkImage:(UIImage *)watermar{
    YSQRCodeGenerator *generator = [YSQRCodeGenerator new];
    generator.content = content;
    [generator setColorWithBackColor:[UIColor whiteColor] foregroundColor:[UIColor blackColor]];
    generator.watermark = watermar;
    generator.icon = watermar;
    generator.iconSize = CGSizeMake(M_RATIO_SIZE(15), M_RATIO_SIZE(15));
    UIImage *image = [generator generate];
    return image;
}
/**
 生成二维码
 
 @param url 二维码的URL
 @param View 添加到哪一个View上面
 */
- (UIImage *)setErWeiMaWithUrl:(NSString *)url text:(NSString *)text AndView:(UIView *)View{
    // 1、创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 恢复滤镜的默认属性
    [filter setDefaults];
    // 2、设置数据
    NSString *string_data = url;
    // 将字符串转换成 NSdata (虽然二维码本质上是字符串, 但是这里需要转换, 不转换就崩溃)
    NSData *qrImageData = [string_data dataUsingEncoding:NSUTF8StringEncoding];
    
    // 设置过滤器的输入值, KVC赋值
    [filter setValue:qrImageData forKey:@"inputMessage"];
    
    // 3、获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    // 图片小于(27,27),我们需要放大
    outputImage = [outputImage imageByApplyingTransform:CGAffineTransformMakeScale(20, 20)];
    // 4、将CIImage类型转成UIImage类型
    UIImage *start_image = [UIImage imageWithCIImage:outputImage];
    
    // - - - - - - - - - - - - - - - - 添加中间小图标 - - - - - - - - - - - - - - - -
    // 5、开启绘图, 获取图形上下文 (上下文的大小, 就是二维码的大小)
    UIGraphicsBeginImageContext(start_image.size);
    // 把二维码图片画上去 (这里是以图形上下文, 左上角为(0,0)点
    [start_image drawInRect:CGRectMake(0, 0, start_image.size.width, start_image.size.height)];
    
    // 再把小图片画上去
    UILabel *lable =[UILabel createLableTextColor:[UIColor colorWithR:255 g:96 b:103 alpha:1] font:14 numberOfLines:1];
    lable.text = text;
    lable.backgroundColor = [UIColor whiteColor];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.frame = CGRectMake(0, 0, M_RATIO_SIZE(90), M_RATIO_SIZE(8)+15);
    UIImage *image = [self imageForView:lable];
    CGFloat icon_imageW = lable.frame.size.width*4;
    CGFloat icon_imageH = lable.frame.size.height*4;
    CGFloat icon_imageX = (start_image.size.width - icon_imageW) * 0.5;
    CGFloat icon_imageY = (start_image.size.height - icon_imageH) * 0.5;
    [image drawInRect:CGRectMake(icon_imageX, icon_imageY, icon_imageW, icon_imageH)];
    UIImage *ZImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 9、将最终合得的图片显示在UIImageView上
    return ZImage;
}

- (UIImage *)imageForView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    
    if ([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    else
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
-(UIImage *)imageForView:(UIView *)view withBounds:(CGRect)bounds{
    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, 0);
    
    if ([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        [view drawViewHierarchyInRect:bounds afterScreenUpdates:YES];
    else
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
//两个UIImage 合成一个Image
-(UIImage *)getImage:(UIImage *)imageOne imageTwo:(UIImage *)imageTwo{
    UIGraphicsBeginImageContext(imageOne.size);
    [imageOne drawInRect:CGRectMake(0, 0, imageOne.size.width,imageOne.size.height)];
    CGFloat icon_imageW = M_RATIO_SIZE(40);
    CGFloat icon_imageH = M_RATIO_SIZE(40);
    CGFloat icon_imageX = (imageOne.size.width - icon_imageW) * 0.5;
    CGFloat icon_imageY = (imageOne.size.height - icon_imageH) * 0.5;
    [imageTwo drawInRect:CGRectMake(icon_imageX, icon_imageY, icon_imageW,icon_imageH)];
    UIImage *ZImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return ZImage;
}
-(UIImage *)getCustomImage:(UIImage *)imageOne imageTwo:(UIImage *)imageTwo{
    UIGraphicsBeginImageContext(imageOne.size);
    [imageOne drawInRect:CGRectMake(0, 0, imageOne.size.width,imageOne.size.height)];
    CGFloat icon_imageW = imageTwo.size.width*imageOne.size.width/205;
    CGFloat icon_imageH = imageTwo.size.height*imageOne.size.width/205;
    CGFloat icon_imageX = 10;
    CGFloat icon_imageY = 120*imageOne.size.width/205;
    NSLog(@"%f-----%f",imageOne.size.width,imageOne.size.height);
    [imageTwo drawInRect:CGRectMake(icon_imageX, icon_imageY, icon_imageW,icon_imageH)];
    UIImage *ZImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return ZImage;
}
-(UIImage *)getShareImage:(UIImage *)bgImage imageOne:(UIImage *)imageOne imageTwo:(UIImage *)imageTwo{
    UIGraphicsBeginImageContext(bgImage.size);
//    [bgImage drawInRect:CGRectMake(0, 0, bgImage.size.width,bgImage.size.height)];
//    [imageOne drawInRect:CGRectMake(0, 0, imageOne.size.width,imageOne.size.height)];
    [bgImage drawInRect:CGRectMake(0, 0, bgImage.size.width,bgImage.size.height)];

    NSLog(@"%f-----%f",imageOne.size.width,imageOne.size.height);
    NSLog(@"%f-----%f",imageTwo.size.width,imageTwo.size.height);

//    [imageOne drawInRect:CGRectMake(0, 0, imageOne.size.width,imageOne.size.height)];
    [imageTwo drawInRect:CGRectMake(0, 0, imageTwo.size.width,imageTwo.size.height)];

    UIImage *ZImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return ZImage;
}
#pragma mark -- 保存图片到系统相册
- (void)loadImageFinished:(UIImage *)image succeed:(void (^)(BOOL data))succeed{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    if (succeed) {
        succeed(YES);
    }
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}
#pragma mark -- 保存视频到系统相册
- (void)downloadVideoFinished:(NSString *)url succeed:(void (^)(BOOL data))succeed{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString  *fullPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"jaibaili.mp4"];
    NSURL *urlNew = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlNew];
    NSURLSessionDownloadTask *task =
    [manager downloadTaskWithRequest:request
                            progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                return [NSURL fileURLWithPath:fullPath];
                            }
                   completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                       [self saveVideo:fullPath];
                       if (succeed) {
                           succeed(YES);
                       }
                   }];
    [task resume];

}
//videoPath为视频下载到本地之后的本地路径
- (void)saveVideo:(NSString *)videoPath{
    
    if (videoPath) {
        NSURL *url = [NSURL URLWithString:videoPath];
        BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([url path]);
        if (compatible)
        {
            //保存相册核心代码
            UISaveVideoAtPathToSavedPhotosAlbum([url path], self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}


//保存视频完成之后的回调
- (void) savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        NSLog(@"保存视频失败%@", error.localizedDescription);
    }
    else {
        NSLog(@"保存视频成功");
    }
}
#pragma mark -- 打开Instagram
-(void)openInstagramReleaseImage:(NSString *)assetUrl{
    NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat:@"instagram://library?AssetPath=%@&InstagramCaption=Image", [self urlEncode:assetUrl]]];
    if ([[UIApplication sharedApplication]canOpenURL:instagramURL]){
        [[UIApplication sharedApplication]openURL:instagramURL];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/jp/app/instagram/id389801252?mt=8"]];
    }
}
- (NSString *)urlEncode:(NSString *)encode {
    return (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)encode, CFSTR(""), kCFStringEncodingUTF8);
}
#pragma mark -- 分享
-(UIActivityViewController *)shareContentWithUserWithFeed:(JHArticleModel* )userWithFeed{
    //要分享的内容，加在一个数组里边，初始化UIActivityViewController
    NSString *textToShare = kAppName;
    NSString *content = userWithFeed.preview.text;
    NSURL *urlToShare;
    if (isEmptyString(userWithFeed.profile_pic_url))
    {
        
        urlToShare = [NSURL URLWithString:userWithFeed.user.profile_pic_url];
    }
    
    else
    {
        urlToShare = [NSURL URLWithString:userWithFeed.profile_pic_url];

    }
    
    NSArray *activityItems = @[textToShare,urlToShare,content.length?content:@""];
    /**
     创建分享视图控制器
     
     ActivityItems  在执行activity中用到的数据对象数组。数组中的对象类型是可变的，并依赖于应用程序管理的数据。例如，数据可能是由一个或者多个字符串/图像对象，代表了当前选中的内容。
     
     Activities  是一个UIActivity对象的数组，代表了应用程序支持的自定义服务。这个参数可以是nil。
     
     */
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    
    // 设置字体属性
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        //初始化回调方法
        UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError)
        {
            NSLog(@"activityType :%@", activityType);
            if (completed)
            {
                NSLog(@"completed");
            }
            else
            {
                NSLog(@"cancel");
            }
            
        };
        
        // 初始化completionHandler，当post结束之后（无论是done还是cancell）该blog都会被调用
        activityVC.completionWithItemsHandler = myBlock;
    }else{
        
        UIActivityViewControllerCompletionHandler myBlock = ^(NSString *activityType,BOOL completed)
        {
            NSLog(@"activityType :%@", activityType);
            if (completed)
            {
                NSLog(@"completed");
            }
            else
            {
                NSLog(@"cancel");
            }
            
        };
        // 初始化completionHandler，当post结束之后（无论是done还是cancell）该blog都会被调用
        activityVC.completionHandler = myBlock;
    }
    
    //Activity 类型又分为“操作”和“分享”两大类
    /*
     UIKIT_EXTERN NSString *const UIActivityTypePostToFacebook     NS_AVAILABLE_IOS(6_0);
     UIKIT_EXTERN NSString *const UIActivityTypePostToTwitter      NS_AVAILABLE_IOS(6_0);
     UIKIT_EXTERN NSString *const UIActivityTypePostToWeibo        NS_AVAILABLE_IOS(6_0);    //SinaWeibo
     UIKIT_EXTERN NSString *const UIActivityTypeMessage            NS_AVAILABLE_IOS(6_0);
     UIKIT_EXTERN NSString *const UIActivityTypeMail               NS_AVAILABLE_IOS(6_0);
     UIKIT_EXTERN NSString *const UIActivityTypePrint              NS_AVAILABLE_IOS(6_0);
     UIKIT_EXTERN NSString *const UIActivityTypeCopyToPasteboard   NS_AVAILABLE_IOS(6_0);
     UIKIT_EXTERN NSString *const UIActivityTypeAssignToContact    NS_AVAILABLE_IOS(6_0);
     UIKIT_EXTERN NSString *const UIActivityTypeSaveToCameraRoll   NS_AVAILABLE_IOS(6_0);
     UIKIT_EXTERN NSString *const UIActivityTypeAddToReadingList   NS_AVAILABLE_IOS(7_0);
     UIKIT_EXTERN NSString *const UIActivityTypePostToFlickr       NS_AVAILABLE_IOS(7_0);
     UIKIT_EXTERN NSString *const UIActivityTypePostToVimeo        NS_AVAILABLE_IOS(7_0);
     UIKIT_EXTERN NSString *const UIActivityTypePostToTencentWeibo NS_AVAILABLE_IOS(7_0);
     UIKIT_EXTERN NSString *const UIActivityTypeAirDrop            NS_AVAILABLE_IOS(7_0);
     */
    
    // 分享功能(Facebook, Twitter, 新浪微博, 腾讯微博...)需要你在手机上设置中心绑定了登录账户, 才能正常显示。
    //关闭系统的一些activity类型
    activityVC.excludedActivityTypes = @[];
    
    //在展现view controller时，必须根据当前的设备类型，使用适当的方法。在iPad上，必须通过popover来展现view controller。在iPhone和iPodtouch上，必须以模态的方式展现。
    return activityVC;
}
@end
