//
//  InsCheckPointViewController.m
//  InstaSecrets
//
//  Created by liuming on 2018/3/9.
//  Copyright © 2018年 liuming. All rights reserved.
//

#import "InsCheckPointViewController.h"
#import "WaitingView.h"
#import "AppDelegate.h"
@interface InsCheckPointViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *checkPointView;
@property (strong, nonatomic) WaitingView *waiting;
@end

@implementation InsCheckPointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.checkPointView.scrollView.bounces=NO;
    self.checkPointView.scrollView.showsVerticalScrollIndicator=NO; self.checkPointView.scrollView.showsVerticalScrollIndicator=NO;
    self.checkPointView.delegate = self;
    self.waiting = [WaitingView createView];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.checkPointUrl]];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [self.checkPointView loadRequest:request];
    
    
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
#pragma mark - webView代理方法
/**
 *  webView开始发送请求的时候就会调用
 */
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
    [self.waiting show];
}

/**
 *  webView请求完毕的时候就会调用
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [self.waiting hide];;
}
/**
 *  webView请求失败的时候就会调用
 */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.waiting hide];
}

/**
 *  当webView发送一个请求之前都会先调用这个方法, 询问代理可不可以加载这个页面(请求)
 *
 *  @return YES : 可以加载页面,  NO : 不可以加载页面
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    if ([request.URL.absoluteString isEqualToString:@"https://i.instagram.com/"])
    {
        [[JHControllerManager ShareManager] postNotification:ControllerManagerChangeToLoginNotification userInfo:nil];
        return  NO;
    }
    return YES;
}

@end
