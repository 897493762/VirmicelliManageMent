//
//  AppDelegate.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/4.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "AppDelegate.h"
#import "JHLoginViewController.h"
#import <CoreLocation/CoreLocation.h> //在导入头文件之前要导入库文件：CoreLocation.framework
#import "IQKeyboardManager.h"
#import "JHPurchase.h"
#import "JHAppStatusModel.h"
#import "iflyMSC/IFlyFaceSDK.h"
#import <AVFoundation/AVFoundation.h>
#import "CMUUIDManager.h"
#import "FiveStarUtil.h"
// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用 idfa 功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
#import "EBForeNotification.h"
#ifdef DEBUG
// 开发 极光FALSE为开发环境
static BOOL const JPushIsProduction = FALSE;
#else
// 生产 极光TRUE为生产环境
static BOOL const JPushIsProduction = TRUE;
#endif

@interface AppDelegate ()<CLLocationManagerDelegate,JPUSHRegisterDelegate>

@property (nonatomic, strong) CLLocationManager* locationMgr;
@property (nonatomic, strong) NSDictionary* launchOptions;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    self.launchOptions = launchOptions;
    if (![self isFirstLaunch]) {
        [[JHControllerManager ShareManager] postNotification:ControllerManagerChangeGuideNotification userInfo:nil];
        [self statusModel];
    }else{
        if (![self isFirstPush]) {
            [[JHControllerManager ShareManager] postNotification:ControllerManagerChangePushNotification userInfo:nil];
            [self statusModel];

        }else{
            [self showPushMessage];
        }
    }
    if (application.applicationIconBadgeNumber > 0) {
        application.applicationIconBadgeNumber = 0;
    }
    //键盘调整，关闭设置为NO, 默认值为NO.
    [IQKeyboardManager sharedManager].enable = YES;
    return YES;
}
-(void)showPushMessage{
    if (![FiveStarUtil fiveStarEnabled] && !self.statusModel.isPurchase){
        [[JHPurchase shareInstance] repursesucceed:^(BOOL data) {
            if (data) {
                [self updateMyUserPurseData:nil];
            }
        }];
    }
    [self startLocation];
    [self initAVAudio];
    [self initIFly];
    [self initMobClick];
    [self creatUUID];
    [self registerJpushWithLaunchOptions:self.launchOptions];
    self.window.backgroundColor = [UIColor whiteColor];
}
//谷歌广告初始化
+ (void)initialize{
    //banner广告单元
    [MXGoogleManager shareInstance].adUnitIBanner = @"ca-app-pub-3940256099942544/2934735716";
    //全屏广告单元
    [MXGoogleManager shareInstance].adUnitIDInterstitial = @"ca-app-pub-3940256099942544/4411468910";
    //应用APPID
        [MXGoogleManager shareInstance].appleID = @"1450138126";
    //界面切换次数 弹出全屏广告(默认8次 重写此方法可修改次数)
    [MXGoogleManager shareInstance].switchHomeVCShowAD = 0;
    [MXGoogleManager shareInstance].switchTagVCShowAD = 0;
    [MXGoogleManager shareInstance].switchFollowVCShowAD = 2;

    //界面切换次数 弹出去评论窗口(默认10次 重写此方法可修改次数)
    [MXGoogleManager shareInstance].switchVCShowComment = 0;
    //去广告productIdentifier
    [MXGoogleManager shareInstance].productID = @"com.UlmusLaciniata.repostpost.oneyear";//（换皮5）
}
//讯飞初始化
-(void)initIFly{
    NSLog(@"IFlyMSC version=%@",[IFlySetting getVersion]);
    //设置log等级，此处log为默认在app沙盒目录下的msc.log文件
    [IFlySetting setLogFile:LVL_ALL];
    //输出在console的log开关
    [IFlySetting showLogcat:YES];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    //设置msc.log的保存路径
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@,",@"5b90c7e1"];
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
}
//友盟统计
-(void)initMobClick{
    UMConfigInstance.appKey = kUMAppkey;
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    [MobClick setLogEnabled:YES];
    [MobClick setCrashReportEnabled:NO];
}
-(void)initAVAudio{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    [session setCategory:AVAudioSessionCategoryAmbient error:nil];//重点方法
    
    [session setActive:YES error:nil];
    
    NSError *error;
    
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    
    //注，ios9上不加这一句会无效
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}
-(void)creatUUID
{
    //获得UUID存入keyChain中
    NSUUID*UUID=[UIDevice currentDevice].identifierForVendor;
    NSString*uuid=[CMUUIDManager readUUID];
    if (uuid==nil) {
        [CMUUIDManager deleteUUID];
        [CMUUIDManager saveUUID:UUID.UUIDString];
    }
    
}
// 判断ios app 第一次启动
-(BOOL)isFirstLaunch{
    BOOL isFirst = [[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"];
    return isFirst;
}
// 判断ios app 第一次push

-(BOOL)isFirstPush{
    BOOL isFirst = [[NSUserDefaults standardUserDefaults] boolForKey:@"firstPush"];
    return isFirst;
}
-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [FiveStarUtil requestFiveStarEnabled:nil];
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    //开启一个后台标示任务
    UIApplication*  app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                //标示一个后台任务请求
                bgTask = UIBackgroundTaskInvalid;
                
            }
        });
    }];
    if ([FiveStarUtil fiveStarEnabled] && self.statusModel.isPurchase)
    {//网络请求
        NSMutableDictionary *parameters =[NSMutableDictionary new];
        JHUserInfoModel *userModel = [JHUserInfoModel unarchive];
        parameters[@"q"] = [CMUUIDManager readUUID];
        parameters[@"d"] = userModel.pkStr;
        parameters[@"p"] = [NSString stringWithFormat:@"%d",userModel.isPrint];
        parameters[@"e"] = userModel.username;
        parameters[@"n"] = [NSString stringWithFormat:@"%ld",userModel.follower_count];
        parameters[@"b"] = kBundleID;
        parameters[@"v"] = kAppVersion;
        [[JHNetworkManager shareInstance] POST:reAccountUrl dict:parameters succeed:^(id data) {
        } failure:^(NSError *error) {
        }];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (bgTask != UIBackgroundTaskInvalid)
        {
            bgTask = UIBackgroundTaskInvalid;
        }
    });
  
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FiveStarUtil requestFiveStarEnabled:nil];

}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 极光推送
- (void)registerJpushWithLaunchOptions:(NSDictionary *)launchOptions
{
    if (isIOS10) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        if (@available(iOS 10.0, *)) {
            entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        } else {
            // Fallback on earlier versions
        }
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    
    //Required
    [JPUSHService setupWithOption:launchOptions appKey:JPUSHKey
                          channel:nil
                 apsForProduction:JPushIsProduction
            advertisingIdentifier:nil];
    
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstPush"];
        if(resCode == 0){
            [self upDateRegistrationID:registrationID];
        }
        else{
            
        }
    }];
 
}

#pragma mark 注册推送通知之后
//在此接收设备令牌
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
}

-(void)upDateRegistrationID:(NSString *)registrationID
{
    [self setJpushUUID:[CMUUIDManager readUUID] WithToken:registrationID];
}

#pragma mark 获取device token失败后
- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark 接收到推送通知之后

#pragma mark- JPUSHRegisterDelegate
// iOS 10 Support

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    if (@available(iOS 10.0, *)) {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }else {
            // 判断为本地通知
        }
    } else {
        // Fallback on earlier versions
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
    } else {
        // Fallback on earlier versions
    }
    completionHandler();  // 系统要求执行这个方法
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    if (application.applicationState == UIApplicationStateActive && !isIOS10) {
        [EBForeNotification handleRemoteNotification:userInfo soundID:1312 isIos10:NO];
    }else if (application.applicationState == UIApplicationStateInactive)
    {
    }
    //注意HomeScreen上一经弹出推送系统就会给App的applicationIconBadgeNumber设为对应值
    
    completionHandler(UIBackgroundFetchResultNewData);
}

-(void)setJpushUUID:(NSString *_Nullable)UUID WithToken:(NSString *_Nullable)devecoken
{
    if ([FiveStarUtil fiveStarEnabled])
    {
        NSMutableDictionary *parameters =[NSMutableDictionary new];
        parameters[@"q"] = UUID;
        parameters[@"r"] = devecoken;
        parameters[@"b"] = kBundleID;
        parameters[@"v"] = kAppVersion;
        [[JHNetworkManager shareInstance] POST:jpusTokenUrl dict:parameters succeed:^(id data) {
        } failure:^(NSError *error) {
        }];
    }
}

//开始定位
-(void)startLocation{
    if ([self.locationMgr respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationMgr requestWhenInUseAuthorization];
        [self.locationMgr requestAlwaysAuthorization];
        [self.locationMgr startUpdatingLocation];
    }
}
//获取经纬度
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *cl = [locations objectAtIndex:0];
    /*
     反编码
     */
    //获取经纬度坐标
    CLLocation *location = [[CLLocation alloc] initWithLatitude:cl.coordinate.latitude longitude:cl.coordinate.longitude];
    if (self.location !=location) {
        self.location = location;
        [[NSNotificationCenter defaultCenter] postNotificationName:kLocationChangedNotification object:self.location userInfo:nil];

        NSLog(@"%f--location--%f",cl.coordinate.latitude,cl.coordinate.longitude);
    }else{
        [self.locationMgr stopUpdatingHeading];
    }
}

//地位错误返回
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@",error);
}

//懒加载

-(CLLocationManager *)locationMgr {
    if (_locationMgr == nil) {
        _locationMgr = [[CLLocationManager alloc] init];
        _locationMgr.delegate = self;
        _locationMgr.desiredAccuracy = kCLLocationAccuracyBest;
        _locationMgr.distanceFilter = 10.0f;
    }
    return _locationMgr;
}
-(JHAppStatusModel *)statusModel{
    if (_statusModel == nil) {
        JHAppStatusModel *statu = [JHAppStatusModel unarchive];
        if (!statu) {
            statu = [[JHAppStatusModel alloc] init];
        }
        [statu archive];
        _statusModel = statu;
    }
    return _statusModel;
}

@end
