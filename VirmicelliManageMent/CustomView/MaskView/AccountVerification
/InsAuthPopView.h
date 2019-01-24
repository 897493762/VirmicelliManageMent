//
//  InsAuthPopView.h
//  InstaSecrets
//
//  Created by liuming on 2018/3/9.
//  Copyright © 2018年 liuming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InsAuthPopView : UIView
@property (nonatomic ,copy) void (^didClickBtn)(void);
- (id)initWithTitle:(NSString *)contentTitle;
- (void)showPopAlertView;
- (void)cancel;
@end
