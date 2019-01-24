//
//  EmailUtil.h
//  Instagram-fans
//
//  Created by wanglong on 16/8/24.
//  Copyright © 2016年 wanglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface EmailUtil : NSObject

+(instancetype)getInstance;

-(void)sendEmail:(UIViewController *)controller;

@end
