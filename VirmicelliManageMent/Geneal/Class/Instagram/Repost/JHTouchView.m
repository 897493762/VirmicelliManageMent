//
//  JHTouchView.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2019/1/24.
//  Copyright © 2019年 Satoshi Nakamoto. All rights reserved.
//

#import "JHTouchView.h"

@implementation JHTouchView
-(void)awakeFromNib{
    [super awakeFromNib];
    [self loadTextField];
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self loadTextField];
    }
    return self;
}

//悬浮按钮点击
- (void)suspendBtnClicked:(id)sender
{
//    self.testFieled.userInteractionEnabled = YES;
    [self.testFieled becomeFirstResponder];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    //移动状态
    UIGestureRecognizerState recState =  recognizer.state;
    
    switch (recState) {
        case UIGestureRecognizerStateBegan:
            if (self.block) {
                self.block(1);
            }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [recognizer translationInView:self.superview];
            CGPoint newCenter = CGPointMake(self.center.x+ translation.x,
                                            self.center.y + translation.y);
            //    限制屏幕范围：
            newCenter.y = MAX(self.frame.size.height/2, newCenter.y);
            newCenter.y = MIN(self.superview.frame.size.height - self.frame.size.height/2, newCenter.y);
            newCenter.x = MAX(self.frame.size.width/2, newCenter.x);
            newCenter.x = MIN(self.superview.frame.size.width - self.frame.size.width/2,newCenter.x);
            self.center = newCenter;
            [recognizer setTranslation:CGPointZero inView:self.superview];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
           
            if (self.block) {
                self.block(2);
            }
        }
            break;
            
        default:
            break;
    }
    
}
#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.testFieled) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (self.testFieled.text.length >= 20) {
            self.testFieled.text = [textField.text substringToIndex:20];
            return NO;
        }
    }
    return YES;
}
-(void)loadTextField{
    [self addSubview:self.testFieled];
    [self addSubview:self.spButton];
    [self.testFieled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.spButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
-(CustomTextField *)testFieled{
    if (_testFieled == nil) {
        _testFieled = [[CustomTextField alloc] init];
        _testFieled.textColor = c255255255;
        _testFieled.font = [UIFont systemFontOfSize:16];
        _testFieled.textAlignment = NSTextAlignmentCenter;
        _testFieled.delegate = self;
        _testFieled.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _testFieled;
}
-(UIButton *)spButton{
    if (_spButton == nil) {
        _spButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_spButton addTarget:self action:@selector(suspendBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        //创建移动手势事件
        UIPanGestureRecognizer *panRcognize=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [panRcognize setMinimumNumberOfTouches:1];
        [panRcognize setEnabled:YES];
        [panRcognize delaysTouchesEnded];
        [panRcognize cancelsTouchesInView];
        [_spButton addGestureRecognizer:panRcognize];
    }
    return _spButton;
}
@end
