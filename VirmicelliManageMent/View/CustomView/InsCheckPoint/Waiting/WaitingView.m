//
//  WaitingDialog.m
//  Instagram-fans
//
//  Created by 李敏 on 2016/09/08.
//  Copyright © 2016年 wanglong. All rights reserved.
//

#import "WaitingView.h"

@interface WaitingView()

@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *marginConstraint;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;

@property (assign, atomic) BOOL showing;

@end

@implementation WaitingView

+ (instancetype)createView {
	return [[WaitingView alloc] init];
}

- (instancetype)init {
	self = [super init];
	if(self) {
		UINib *nib = [UINib nibWithNibName:@"WaitingView" bundle:nil];
		[nib instantiateWithOwner:self options:nil];
		self.showing = NO;
	}
	return self;
}

- (void)show {
	[self showMessage:nil];
}

- (void)showMessage:(NSString *)message
{
	UIWindow *wnd = [UIApplication sharedApplication].keyWindow;
	[self showInView:wnd message:message];
}

- (void)showInView:(UIView *)view {
	[self showInView:view message:nil];
}

- (void)showInView:(UIView *)view message:(NSString *)message
{
    if(!self.showing) {
		self.message = message;
		self.view.frame = view.bounds;
		[view addSubview:self.view];
		self.showing = YES;
	}
}

- (void)hide
{
	if(self.showing) {
		[self.view removeFromSuperview];
		
		self.showing = NO;
	}
}

- (void)setMessage:(NSString *)message {
	_message = message;
	
	self.marginConstraint.constant = message == nil || message.length == 0 ? 0 : 10;
	self.messageLabel.text = message;
}

@end
