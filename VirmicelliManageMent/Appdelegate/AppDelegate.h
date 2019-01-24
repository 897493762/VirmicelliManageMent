//
//  AppDelegate.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/4.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "JHAppStatusModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocation *location;
@property (assign, nonatomic) long locationPk;
@property (strong, nonatomic) JHAppStatusModel *statusModel;
@property (assign, nonatomic) NSInteger isFirst;
@property (assign, nonatomic) NSInteger isReture;
@property (assign, nonatomic) NSInteger switchPage;
-(void)showPushMessage;
@end

