//
//  JHAPPMacro.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/4.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#ifndef JHAPPMacro_h
#define JHAPPMacro_h

#define kMainDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define kDocumentsPath          [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

#define kScreenWidth            CGRectGetWidth([UIScreen mainScreen].bounds)
#define kScreenHeight           CGRectGetHeight([UIScreen mainScreen].bounds)

#define isEmptyString(str) ((str == nil) || (str.length == 0) || [str isEqual:[NSNull null]]) || [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0 ? YES: NO

//计算等比例大小
//#define M_RATIO_SIZE(s) ceilf(kScreenWidth/(375.0/s))
//#define K_RATIO_SIZE(s) @(ceilf(kScreenWidth/(375.0/s)))

#define M_APAD_SIZE(s) ceilf(kScreenWidth/kScreenHeight/(375.0/667.0/s))
#define IS_PAD (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)

#define M_RATIO_SIZE(s) (IS_PAD ? ceilf(kScreenWidth/kScreenHeight/(375.0/667.0/s)) : ceilf(kScreenWidth/(375.0/s)))
#define K_RATIO_SIZE(s) (IS_PAD ? @(ceilf(kScreenWidth/kScreenHeight/(375.0/667.0/s))) : @(ceilf(kScreenWidth/(375.0/s))))

//手机系统版本
#define phoneVersion [[UIDevice currentDevice] systemVersion]

#define STATUS_BAR_HEIGHT (iPhoneX ? 44.f : 20.f)

#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO) //判断机型是否为iphonex
#define KDistanceBottom ceilf(KIsiPhoneX ? 34 : 0) // 距离底部
#define IG_SIG_KEY @"e1712d2f592becfdea858c4d0ad4e7c5f230c446094155a1663d612e1290c841"
#define IG_SIG_KEY_VERSION @"4"
#define IG_USER_AGENT @"Instagram 10.9.0 Android (23/6.0.1; 640dpi; 1440x2560; samsung; SM-G930F; herolte; samsungexynos8890; en_US)"

#define phoneAdId  [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]
#define KRank_token [NSString stringWithFormat:@"%@_%@",[JHUserInfoModel unarchive].pkStr,phoneAdId]
// app id
#define kBundleID [[NSBundle mainBundle]bundleIdentifier]

// app名称

#define kAppName [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleDisplayName"]
// app版本
#define kAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define kFiveASIRequestKey   @"http://www.tiprepostvideo.club/app1450138126.conf"
#define kUMAppkey   @"5c136c02b465f53179000107"
#define kEnableFiveStarCommentsKey [NSString stringWithFormat:@"kEnableFiveStarCommentsKey112%@",kAppVersion]
#define kFiveStarCommentsKey @"kFiveStarCommentsKey"
#define kFiveStarCommentsLaterKey @"kFiveStarCommentsLaterKey"

#define appStoreShortURL [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8",[MXGoogleManager shareInstance].appleID]
//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
// 判断系统版本
#define isIOS10 ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)

#define UniqueIdentifier [[[UIDevice currentDevice] identifierForVendor] UUIDString]
#define font(n) [UIFont systemFontOfSize:n]

#define IAPKey @"14661608884b4205b19a7777387691e7"//（换皮5）

#define JPUSHKey @"e0990ff10d1c52550eed6b7d"
#define IAEmail @"repostgoodfeedback@gmail.com"

//像素转尺寸
#define px(n) (n)/2

#define jpusTokenUrl  @"http://tiprepostvideo.club/regisrpskfive"
#define reAccountUrl  @"http://tiprepostvideo.club/currentrpskfive"



#define testVerInvoiceURL @"http://instamanagerfollowers.xyz/certfeuptest"
#define termsURL @"https://goo.gl/e5TkJC"
#define privacyPolicyURL @"https://goo.gl/9Scn7m"
#define appStoreURL @"https://itunes.apple.com/jp/app/id1447094330?l=zh&ls=1&mt=8"
// 颜色相关
#define ICRGBColor(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
// 文字颜色
//#define titleColor (ICRGBColor(255,171,195))
#define c255171195  ICRGBColor(255,171,195)
#define c255225225 ICRGBColor(255,225, 225)
#define c646871 ICRGBColor(64,68, 71)
#define c203203203 ICRGBColor(203,203, 203)
#define c373842    ICRGBColor(37, 38, 42)
#define c586166   ICRGBColor(58, 61, 66)
#define  c343539 ICRGBColor(34,35, 39)
#define c172180189 ICRGBColor(172,180,189)
#define c52168252 ICRGBColor(52,168,252)
#define c96183255 ICRGBColor(96,183, 255)
#define c49167252 ICRGBColor(49,167,252)
#define c444444  ICRGBColor(44, 44, 44)
#define c25510642  ICRGBColor(255, 106, 42)
#define c25210642  ICRGBColor(252, 106, 42)

#define c667587 ICRGBColor(66,75, 87)
#define c161170181 ICRGBColor(161,170, 181)
#define c255255255 ICRGBColor(255,255, 255)

// 屏幕尺寸相关
#define WidthRatio [UIScreen mainScreen].bounds.size.width/375.0
#define HeightRatio [UIScreen mainScreen].bounds.size.height/667.0
// Include any system framework and library headers here that should be included in all compilation units.
// You will also need to set the Prefix Header build setting of one or more of your targets to reference this file.
#endif /* JHAPPMacro_h */
