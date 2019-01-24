//
//  UIViewController+TBAddition.m
//  TensWeibo
//
//  Created by MWeit on 16/3/30.
//  Copyright © 2016年 Weit. All rights reserved.
//

#import "UIViewController+TBAddition.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import "UIImage+GIF.h"
#import "InsToastUtil.h"
#import "InsAuthPopView.h"
#import "InsLoginTool.h"
#import "AFNetworking.h"
const char *hudKey;
const char *alertViewKey;

@implementation UIViewController (TBAddition)

- (void)hiddenLoding {
    MBProgressHUD *hud = objc_getAssociatedObject(self, hudKey);
    [hud hideAnimated:YES];
}
-(void)showLoadToView:(UIView *)view{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.bezelView.color = [UIColor blackColor];
    hud.margin = 10.0f; //设置HUD和customerView的边距（默认是20）
    objc_setAssociatedObject(self, hudKey, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);;
    
}
-(void)showLoding{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.bezelView.color = [UIColor blackColor];
    hud.margin = 10.0f; //设置HUD和customerView的边距（默认是20）
    objc_setAssociatedObject(self, hudKey, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)showAlertViewWithText:(NSString *)text afterDelay:(NSTimeInterval)delay {
    if (!self.navigationController.view) {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor blackColor];
    hud.bezelView.alpha = 0.8f;
    hud.label.text = text;
    hud.label.textColor = [UIColor whiteColor];
    hud.label.font = [UIFont systemFontOfSize:15];
    hud.label.numberOfLines = 0;
    hud.offset= CGPointMake(0, -64);
    if (delay > 0) {
        [hud hideAnimated:YES afterDelay:delay];
    }else{
        [hud hideAnimated:YES];
    }
    
    objc_setAssociatedObject(self, alertViewKey, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)showAlertViewWithImage:(NSString *)imageName WithTitle:(NSString *)title afterDelay:(NSTimeInterval)delay{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    hud.contentColor = [UIColor whiteColor];
    hud.label.text = title;
    hud.label.textColor = [UIColor colorWithR:51 g:51 b:51 alpha:1];
    [hud hideAnimated:YES afterDelay:delay];
}
-(void)showSuccessAlertViewWithText:(NSString *)text afterDelay:(NSTimeInterval)delay{
    UIImageView *customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success_icon"]];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.customView = customView;
    hud.bezelView.color = [UIColor blackColor];
    hud.bezelView.alpha = 0.8f;
    hud.label.text = text;
    hud.label.textColor = [UIColor whiteColor];
    hud.label.font = [UIFont systemFontOfSize:15];
    
    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    k.values =  @[@(0.1),@(0.5),@(1.0)];
    k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
    k.calculationMode = kCAAnimationLinear;
    [customView.layer addAnimation:k forKey:@"SHOW"];
    
    [hud hideAnimated:YES afterDelay:delay];

}
- (void)showGifToView:(UIView *)view{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.margin = 0;
    //11，背景框的最小大小
    hud.minSize = CGSizeMake(M_RATIO_SIZE(172),M_RATIO_SIZE(128));
    hud.square = NO;
    UIImageView *gifImageView = [[UIImageView alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"refresh" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage sd_animatedGIFWithData:data];
    gifImageView.image = image;
    UIView *customView = [[UIView alloc] init];
    gifImageView.frame = CGRectMake(0, 0, M_RATIO_SIZE(13), M_RATIO_SIZE(13));
    gifImageView.center = customView.center;
    [customView addSubview:gifImageView];
    hud.customView = customView;
    hud.bezelView.color = [UIColor whiteColor];
    hud.bezelView.alpha = 1;
    objc_setAssociatedObject(self, hudKey, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(void)showAlertNetworkError{
    [self showAlertViewWithText:NSLocalizedString(@"0007", nil) afterDelay:1];
}
/**
 *  弹出选择框
 */
- (void)showAlertTitle:(NSString *)title message:(NSString *)message withDefaultTitle:(NSString *)defaultTitle cancelTitle:(NSString *)cancelTitle succeed:(void (^)(int))succeed{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title                                                                   message:message                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:defaultTitle style:UIAlertActionStyleDefault                                                          handler:^(UIAlertAction * action) {
        succeed(1);                                                        }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault                                                          handler:^(UIAlertAction * action) {
        succeed(2);                                                        }];
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
-(BOOL)getLoginErrorAlertContent:(NSError *)error withUserName:(NSString *)userName{
    if ([error.domain isEqualToString:AFURLResponseSerializationErrorDomain]) {
        // server error
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:0 error:nil];
        NSString *error_type = [response valueForKey:@"error_type"];
        NSString *checkpoint_url = [response valueForKey:@"checkpoint_url"];
        NSString *message = [response valueForKey:@"message"];

        if ([error_type containsString:@"checkpoint_challenge_required"]) {
            [[InsLoginTool createLoginTool] showAlterViewWithTitle:[NSString stringWithFormat:NSLocalizedString(@"5003", nil),userName,userName]WithLogin:YES withCheckpoint_url:checkpoint_url];

        }else if ([error_type containsString:@"bad_password"]){
            [MobClick event:@"logoin_failed"];
            [InsToastUtil showMsgWithTitle:NSLocalizedString(@"5001", nil) content:nil];
        }else{
            [MobClick event:@"logoin_failed"];
            [InsToastUtil showMsgWithTitle:message content:nil];
        }
        return YES;

    } else if ([error.domain isEqualToString:NSCocoaErrorDomain]) {
        [MobClick event:@"timeout"];
        [self showAlertNetworkError];
        return NO;

    } else if ([error.domain isEqualToString:NSURLErrorDomain]) {
        [MobClick event:@"timeout"];
        [self showAlertNetworkError];
        return NO;
    }
    return NO;
}
/*!
 @brief 打开instagram个人信息页面
 */
- (void)openInstagram:(NSString* _Nonnull)userName success:(void (^ _Nullable)(void))success failure:(BOOL (^ _Nullable)(NSError * _Nonnull error))failure
{
    NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat:@"instagram://user?username=%@",userName]];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        [[UIApplication sharedApplication] openURL:instagramURL];
    }
}
@end
