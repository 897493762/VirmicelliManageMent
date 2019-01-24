//
//  EmailUtil.m
//  Instagram-fans
//
//  Created by wanglong on 16/8/24.
//  Copyright © 2016年 wanglong. All rights reserved.
//

#import "EmailUtil.h"
#import "sys/utsname.h"



@interface EmailUtil()<MFMailComposeViewControllerDelegate>

@end
@implementation EmailUtil


/**第1步: 存储唯一实例*/
static EmailUtil *_instance;

/**第2步: 分配内存孔家时都会调用这个方法. 保证分配内存alloc时都相同*/
+(id)allocWithZone:(struct _NSZone *)zone{
    //调用dispatch_once保证在多线程中也只被实例化一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

/**第3步: 保证init初始化时都相同*/
+(instancetype)getInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[EmailUtil alloc] init];
    });
    return _instance;
}

/**第4步: 保证copy时都相同*/
-(id)copyWithZone:(NSZone *)zone{
    return _instance;
}

-(void)sendEmail:(UIViewController *)controller
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mymailpicker = [[MFMailComposeViewController alloc] init];
        mymailpicker.mailComposeDelegate = self;
        [mymailpicker setSubject:[NSString stringWithFormat:NSLocalizedString(@"0006",nil),kAppName]];
        // Set up recipients
        NSArray *toRecipients = [NSArray arrayWithObject:IAEmail];
        
        //选择自己喜欢的颜色
        UIColor * color = [UIColor whiteColor];
        //这里我们设置的是颜色，还可以设置shadow等，具体可以参见api
        NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
        //大功告成
        mymailpicker.navigationBar.titleTextAttributes = dict;
        [mymailpicker setToRecipients:toRecipients];
        
        // Fill out the email body text
        NSMutableString *emailBody = [[NSMutableString alloc] initWithFormat:NSLocalizedString(@"0002",nil),[UIDevice currentDevice].systemVersion,deviceString,kAppVersion];
        [mymailpicker setMessageBody:emailBody isHTML: NO];
        
        mymailpicker.modalPresentationStyle = UIModalPresentationFormSheet;
        [controller presentViewController:mymailpicker animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SEND_EMAIL"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];

    }
    else
    {
        NSMutableString *mailUrl = [[NSMutableString alloc]init];
        //添加收件人
        [mailUrl appendString:[NSString stringWithFormat:@"mailto:?to=%@",IAEmail]];
        //添加主题
        [mailUrl appendString:[NSString stringWithFormat:@"&subject=%@",[NSString stringWithFormat:NSLocalizedString(@"0006",nil),kAppName]]];
        //添加邮件内容
        [mailUrl appendString:@"&body="];
        [mailUrl appendFormat:NSLocalizedString(@"0002",nil),[UIDevice currentDevice].systemVersion,deviceString,kAppVersion];
        NSString* email = [mailUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];
        
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES
                                   completion:nil];
}


@end
