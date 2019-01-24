//
//  InsToastUtil.h
//  InstaSecrets
//
//  Created by liuming on 2018/3/9.
//  Copyright © 2018年 liuming. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^MessageDialogCancel)(void);
typedef void(^MessageDialogSure)(void);

@interface InsToastUtil : NSObject
+(void)showMessage:(NSString *)message;
+(void)showMsgWithTitle:(NSString *)title content:(NSString*)content;
+(void)showMsgWithTitle:(NSString *)title content:(NSString*)content cancel:(MessageDialogCancel)cancel;

@end
