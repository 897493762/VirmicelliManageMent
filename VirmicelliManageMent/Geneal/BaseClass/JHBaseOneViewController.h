//
//  JHBaseOneViewController.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/10/11.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "MXGoogleADController.h"
#import "JHUserInfoView.h"

@interface JHBaseOneViewController : MXGoogleADController
@property (nonatomic , strong) JHUserInfoView *titleView;
-(void)creatPurChaseView;
@end
