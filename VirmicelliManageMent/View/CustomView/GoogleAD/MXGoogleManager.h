//
//  MXGoogleManager.h
//  GoogleAD
//
//  Created by Mr.Xiao on 2018/1/2.
//  Copyright © 2018年 Mr.Xiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXGoogleManager : NSObject

@property (nonatomic, copy) NSString *adUnitIBanner;

@property (nonatomic, copy) NSString *adUnitIDInterstitial;

@property (nonatomic, copy) NSString *appleID;

@property (nonatomic, copy) NSString *testDevice;


@property (nonatomic, assign) NSInteger switchHomeVCShowAD;
@property (nonatomic, assign) NSInteger switchFollowVCShowAD;
@property (nonatomic, assign) NSInteger switchTagVCShowAD;

@property (nonatomic, assign) NSInteger switchVCShowComment;

@property (nonatomic, assign) BOOL isShowComment;
@property (nonatomic, assign) BOOL isGoComment;

//去广告productIdentifier
@property (nonatomic, copy) NSString *productID;


+ (instancetype) shareInstance;

@end
