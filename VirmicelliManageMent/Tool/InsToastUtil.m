//
//  InsToastUtil.m
//  InstaSecrets
//
//  Created by liuming on 2018/3/9.
//  Copyright © 2018年 liuming. All rights reserved.
//

#import "InsToastUtil.h"
#import "EmailUtil.h"
@interface AlertView : UIAlertView <UIAlertViewDelegate>

@property (strong, nonatomic) MessageDialogCancel cancel;


@end

@implementation AlertView

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
        if(_cancel) {
            _cancel();
        }

}

@end

@interface  InsToastUtil ()
@property (nonatomic ,strong) AlertView *alertView;
@end

@implementation InsToastUtil
+(void)showMessage:(NSString *)message
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 0.6f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    
    CGSize LabelSize = CGSizeMake(280, [self getStringHeightWithFront:17 width:280 content:message]);
    label.frame = CGRectMake(10, 5, LabelSize.width, LabelSize.height);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    label.numberOfLines=0;
    [showview addSubview:label];
    
    showview.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width  - LabelSize.width - 20)/2, [[UIScreen mainScreen] bounds].size.height*0.5f, LabelSize.width+20, LabelSize.height+10);
    
    [UIView animateWithDuration:0.3 delay:1.0
                        options:UIViewAnimationOptionCurveEaseIn animations:^{
                            showview.alpha = 0;
                        } completion:^(BOOL finished) {
                            [showview removeFromSuperview];
                        }];
}

+(void)showMsgWithTitle:(NSString *)title content:(NSString*)content {
    [self showMsgWithTitle:title content:content cancel:nil];
}

+(void)showMsgWithTitle:(NSString *)title content:(NSString*)content cancel:(MessageDialogCancel)cancel
{
    
    AlertView *av = [[AlertView alloc] initWithTitle:title message:content delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
    av.delegate = av;
    av.cancel = cancel;
    [av show];
}
+(CGFloat)getStringHeightWithFront:(CGFloat)fontSize width:(CGFloat)width content:(NSString *)content {
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    
    CGSize size =CGSizeMake(width,CGFLOAT_MAX);
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
    CGSize  actualsize =[content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    
    return actualsize.height;
}

@end
