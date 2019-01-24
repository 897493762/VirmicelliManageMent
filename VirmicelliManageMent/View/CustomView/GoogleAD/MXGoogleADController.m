//
//  MXGoogleADController.m
//  GoogleAD
//
//  Created by Mr.Xiao on 2018/1/3.
//  Copyright © 2018年 Mr.Xiao. All rights reserved.
//

#define iOS11_0Later ([UIDevice currentDevice].systemVersion.floatValue >= 11.0f)
#define IPHONEX (CGSizeEqualToSize(CGSizeMake(375.f, 812.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(812.f, 375.f), [UIScreen mainScreen].bounds.size))


#define KEY_SWITCH_COUNT_AD @"keyAD"
#define KEY_SWITCH_COUNT_COMMENT @"keyComment"

#import "MXGoogleADController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <StoreKit/StoreKit.h>
#import "RMStore.h"
#import "JHPurseProductModel.h"
@interface MXGoogleADController ()<GADInterstitialDelegate,GADBannerViewDelegate,RMStoreObserver>

@property (nonatomic, strong) UIView *bannerCantainerView;
//@property (nonatomic, strong) GADBannerView *bannerView;
@property (nonatomic, strong) GADInterstitial *interstitial;
@property (nonatomic, strong) GADRequest *requset;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, copy) NSString *productID;

@property (nonatomic, assign) NSInteger interstitialStatus;

/**
 测试设备ID号 如广告未展示出来 请在一下数组添加 设备号会在log窗有打印 请找到 粘贴进来
 真机需要添加 模拟器请无视
 */
@property (nonatomic, strong) NSArray *testDevices;

@end

@implementation MXGoogleADController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if ([self isShowInsterstitial] == YES) {
        self.interstitial = [self creatNewInterstitial];
        [self creatNewBannerView];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]  setStatusBarHidden:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];

}
#pragma mark - custom accessors
- (void)creatNewBannerView{
    GADBannerView *bannerView = [[GADBannerView alloc] initWithAdSize:GADAdSizeFromCGSize(CGSizeMake(kScreenWidth, kScreenWidth)) origin:CGPointMake(0,[self adjustHeightWithBannerDistanceBoom])];
    bannerView.adUnitID = [MXGoogleManager shareInstance].adUnitIBanner;
    bannerView.delegate = self;
    bannerView.rootViewController = self;
    [bannerView loadRequest:[self requset]];
    [self creatCancelButton];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self.bannerCantainerView];
    [self.bannerCantainerView addSubview:bannerView];
    self.bannerCantainerView.hidden = YES;
}
-(UIView *)bannerCantainerView{
    if (_bannerCantainerView == nil) {
        _bannerCantainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.5;
        view.frame = _bannerCantainerView.frame;
        [_bannerCantainerView addSubview:view];
    }
    return _bannerCantainerView;
}
/*当成功调用了一下GADInterstitial的presentFromRootViewController展示插屏广告之后。下次如果这个对象只调用loadRequest来请求新的广告，在下次显示广告时，日志会提示：
 Request Error: Will not send request because interstitial object has been used.
 
 解决方法：重新再实例化一个新的GADInterstital对象，然后发送请求。具体初始化代码可以参考上面
 
 找了半天问题  解决方法是 重复初始化GADRequest  之前确实是初始化了interstittal 但是发现request没有初始化 所以广告弹出依然有问题
 */
- (GADInterstitial *)creatNewInterstitial{
    GADInterstitial *interstitial = [[GADInterstitial alloc] initWithAdUnitID:[MXGoogleManager shareInstance].adUnitIDInterstitial];
    interstitial.delegate = self;
    [interstitial loadRequest:[self requset]];
    return interstitial;
}

-(GADRequest *)requset{
    GADRequest *request = [GADRequest request];
    request.testDevices = self.testDevices;
    return request;
}

//获取tabbar的高度 适配下iPhone X的高度
- (CGFloat)getTabbarHeight{
    if (IPHONEX) {
        return 49.0f+34.0f;
    }else{
        return 49.0f;
    }
}

#pragma mark --------->>>>>>>>>> (来这里添加测试设备号，模拟器请无视)
//测试设备ID号 如广告未展示出来 请在以下数组中添加 设备号会在log窗有打印 请找到 粘贴进来
//真机需要添加 模拟器请无视
- (NSArray *)testDevices{
    return @[kGADSimulatorID,@"00922d2eb7811f0b4fbfd06e5788c8a6",@"34d7591587650ded97965e00a75651dd"];
}

#pragma mark -VIEWLOAD
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ dealloc", [self class]);
}


#pragma mark ===================  banner 横幅广告  ===================
//重写此方法 自定义是否显示banner广告 (默认显示广告)
- (BOOL)isShowBanner{
    return YES;
}

//此处可选择 banner展示的高度 (默认 手机50X 平板90X 正常情况无需改变)
- (CGFloat)getSizeFromBannerGADSize{
    return CGSizeFromGADAdSize(kGADAdSizeSmartBannerPortrait).height;
}

//重写此方法 可调整banner广告距屏幕下端的高度  默认为0  在最下端
- (CGFloat)adjustHeightWithBannerDistanceBoom{
    return (kScreenHeight-kScreenWidth)/2;
    
}

#pragma mark =================  interstitial 全屏广告  ==================

//重写此方法 自定义是否显示interstital广告 (默认显示广告)
- (BOOL)isShowInsterstitial{
    return YES;
}

//展示全屏广告
- (void)showInterstitial{
    if ([JHAppStatusModel unarchive].isPurchase || [JHAppStatusModel unarchive].isComment||![FiveStarUtil fiveStarEnabled]) {
        return;
    }
    if (self.interstitial.isReady) {
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        NSLog(@"全屏");
        [self.interstitial presentFromRootViewController:window.rootViewController];
    }
    
}
//展示横幅广告
- (void)showBannerView{
    self.bannerCantainerView.hidden = NO;
}
-(void)creatCancelButton{
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    cancelButton.layer.masksToBounds = YES;
    cancelButton.layer.cornerRadius =M_RATIO_SIZE(16);
    cancelButton.layer.borderColor = [UIColor whiteColor].CGColor;
    cancelButton.layer.borderWidth =1;
    cancelButton.frame = CGRectMake(kScreenWidth-M_RATIO_SIZE(32), [self adjustHeightWithBannerDistanceBoom]-M_RATIO_SIZE(32), M_RATIO_SIZE(32), M_RATIO_SIZE(32));
    cancelButton.backgroundColor = [UIColor blackColor];
    [self.bannerCantainerView addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(bannerCancelButtonOnclicked:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelButton = cancelButton;
}
-(void)bannerCancelButtonOnclicked:(UIButton *)sender{
    self.bannerCantainerView.hidden = YES;
    if (self.switchVC == 1) {
        [MXGoogleManager shareInstance].switchHomeVCShowAD = 0;
    }
    if (self.switchVC == 2) {
        [MXGoogleManager shareInstance].switchTagVCShowAD = 0;
    }
    if (self.switchVC == 3) {
        [MXGoogleManager shareInstance].switchFollowVCShowAD = 0;
    }
    [self showCommentsAlert];
    NSLog(@"%ld----------iiooo",(long)[MXGoogleManager shareInstance].switchHomeVCShowAD);

}
//判断根视图是否 有tabbar 防止tabbar 遮挡banner广告
- (BOOL)isRootControllerWithTabbarController{
    return [(UITabBarController *)self.tabBarController isKindOfClass:[UITabBarController class]];
}
//显示评论弹框
-(void)showCommentsAlert{
    if ([JHAppStatusModel unarchive].isPurchase || [JHAppStatusModel unarchive].isComment || ![FiveStarUtil fiveStarEnabled]) {
        return;
    }
    [self showAlertTitle:NSLocalizedString(@"2033", nil) message:nil withDefaultTitle:NSLocalizedString(@"2036", nil) cancelTitle:NSLocalizedString(@"2034", nil) succeed:^(int tag) {
        [MXGoogleManager shareInstance].switchVCShowComment = 0;
        if (tag == 2) {
            JHAppStatusModel *status =[JHAppStatusModel unarchive];
            status.isComment =YES;
            [status archive];
            [self skipToAppStoreComment];
        }
    }];
    if ([FiveStarUtil fiveStarEnabled]) {
        [MobClick event:@"wuxing_show"];
    }
}
#pragma mark -- GADBannerViewDelegate
- (void)adViewWillDismissScreen:(GADBannerView *)bannerView{
    NSLog(@"横幅广告将要消失");
    
    
}
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"Received ad successfully");
}


- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}
#pragma mark -- 全屏广告代理方法

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad{
    NSLog(@"广告已经接受到了");
    
}

-(void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error{
    NSLog(@"广告接受失败");
}

-(void)interstitialWillPresentScreen:(GADInterstitial *)ad{
    if ([JHAppStatusModel unarchive].isComment) {
        if ([FiveStarUtil fiveStarEnabled]) {
            [MobClick event:@"ads_RESHOW"];
        }
    }
    NSLog(@"广告将要弹出来了");
}

-(void)interstitialDidFailToPresentScreen:(GADInterstitial *)ad{
    NSLog(@"广告弹出失败");
}

-(void)interstitialWillDismissScreen:(GADInterstitial *)ad{
    NSLog(@"广告将要消失");
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.interstitial.hasBeenUsed && [self isShowInsterstitial]) {
        [self showBannerView];
        self.interstitial = [self creatNewInterstitial];
    }
}

-(void)interstitialDidDismissScreen:(GADInterstitial *)ad{
    NSLog(@"广告已经消失了");
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.interstitial.hasBeenUsed && [self isShowInsterstitial]) {
        self.interstitial = [self creatNewInterstitial];
    }
    
    
}

-(void)interstitialWillLeaveApplication:(GADInterstitial *)ad{
    NSLog(@"广告将要离开应用");
}

#pragma mark --------->>>>>>>>>> 评论系统
//跳到appStore评论页
- (void)skipToAppStoreComment{
    if ([FiveStarUtil fiveStarEnabled]) {
        [MobClick event:@"review_frequency"];
    }
    if (iOS11_0Later) {
        NSString *itunesurl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8&action=write-review",[MXGoogleManager shareInstance].appleID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:itunesurl]];
    }else{
        
        NSString *itunesurl = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8",[MXGoogleManager shareInstance].appleID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:itunesurl]];
    }
    [MXGoogleManager shareInstance].isGoComment = YES;
}

//跳到appStore 应用详情页
- (void)skipToAppStoreDetail{
    NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", [MXGoogleManager shareInstance].appleID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}

#pragma mark --------->>>>>>>>>> 监听系统前后台切换
//应用进入后台
- (void)applicationEnterBackground{
    NSLog(@"应用进入后台");
}

//应用来到前台
- (void)applicationBecomeActive{
    self.switchVC = 1;
    [MXGoogleManager shareInstance].switchHomeVCShowAD +=1;
    [MXGoogleManager shareInstance].switchVCShowComment +=1;
    NSInteger count = [MXGoogleManager shareInstance].switchHomeVCShowAD;
    NSLog(@"应用进入前台，可以展示广告了-------%ld",count);
    if (self.isShowInsterstitial && count >=3) {
        [self showInterstitial];
    }
    if ([MXGoogleManager shareInstance].switchVCShowComment >=3) {
        [self showCommentsAlert];
    }
}

#pragma mark 获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    // 定义一个变量存放当前屏幕显示的viewcontroller
    UIViewController *result = nil;
    
    // 得到当前应用程序的关键窗口（正在活跃的窗口）
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    
    // windowLevel是在 Z轴 方向上的窗口位置，默认值为UIWindowLevelNormal
    if (window.windowLevel != UIWindowLevelNormal)
    {
        // 获取应用程序所有的窗口
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            // 找到程序的默认窗口（正在显示的窗口）
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                // 将关键窗口赋值为默认窗口
                window = tmpWin;
                break;
            }
        }
    }
    // 获取窗口的当前显示视图
    UIView *frontView = [[window subviews] objectAtIndex:0];
    
    // 获取视图的下一个响应者，UIView视图调用这个方法的返回值为UIViewController或它的父视图
    id nextResponder = [frontView nextResponder];
    
    // 判断显示视图的下一个响应者是否为一个UIViewController的类对象
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    } else {
        result = window.rootViewController;
    }
    return result;
}

@end
