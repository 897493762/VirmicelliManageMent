//
//  UIView+JHAddition.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/4.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "UIView+JHAddition.h"
#import "MBProgressHUD.h"
//#import <objc/runtime.h>
//#import <UIKit/UIKit.h>
#import "UIImage+GIF.h"
static NSString *hudKey;
static NSString *alertViewKey;

@implementation UIView (JHAddition)
-(void)addCornerRadiusToView:(UIView *)view cornerRadius:(CGFloat)cornerRadius{
    view.layer.cornerRadius = YES;
    view.layer.cornerRadius = cornerRadius;
}
-(void)addShadowInView:(UIView *)superView ToView:(UIView *)view withOpacity:(float)shadowOpacity shadowRadius:(CGFloat)shadowRadius shadowOffset:(CGSize)shadowOffset andCornerRadius:(CGFloat)cornerRadius{
    view.layer.cornerRadius = cornerRadius;
    view.layer.shadowOffset = shadowOffset;
    view.layer.shadowOpacity = shadowOpacity;
    view.layer.shadowRadius = shadowRadius;
    view.layer.shadowColor = [UIColor colorWithHexString:@"#000000"].CGColor;
}
-(void)addShadowView:(UIView *)view withOpacity:(float)shadowOpacity shadowRadius:(CGFloat)shadowRadius shadowOffset:(CGSize)shadowOffset andBackgroundColor:(UIColor *)backgroundColor shadowColor:(UIColor *)shadowColor{
    view.layer.backgroundColor = backgroundColor.CGColor;
    view.layer.shadowColor = shadowColor.CGColor;
    view.layer.shadowOffset = shadowOffset;
    view.layer.shadowOpacity = shadowOpacity;
    view.layer.shadowRadius = shadowRadius;
}
//网络加载框
- (void)showLodingInView:(UIView *)view{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.bezelView.color = [UIColor blackColor];
    hud.margin = 10.0f; //设置HUD和customerView的边距（默认是20）
    objc_setAssociatedObject(self, &hudKey, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)showGifToView:(UIView *)view{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.margin = 0;
    //11，背景框的最小大小
    hud.minSize = CGSizeMake(M_RATIO_SIZE(26),M_RATIO_SIZE(26));
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
    objc_setAssociatedObject(self, &hudKey, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)hiddenLoding {
    MBProgressHUD *hud = objc_getAssociatedObject(self, &hudKey);
    [hud hideAnimated:YES];
}
@end
