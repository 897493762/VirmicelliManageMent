//
//  UIView+JHFrame.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/6.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "UIView+JHFrame.h"

@implementation UIView (JHFrame)

- (UIViewController *)viewcontroller{
    UIResponder *nextRes = [self nextResponder];
    do
    {
        if([nextRes isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)nextRes;
        }else
        {
            nextRes = [nextRes nextResponder];
        }
        
    }while (nextRes!= nil);
    
    return nil;
    
}
- (CGFloat)left {
    return CGRectGetMinX(self.frame);
}

- (void)setLeft:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)right {
    return CGRectGetMaxX(self.frame);
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - self.width;
    self.frame = frame;
}

- (CGFloat)top {
    return CGRectGetMinY(self.frame);
}

- (void)setTop:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

-(CGFloat)bottom {
    return CGRectGetMaxY(self.frame);
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - self.height;
    self.frame = frame;
}

-(CGFloat)width {
    return CGRectGetWidth(self.frame);
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    
    return CGRectGetHeight(self.frame);
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}


@end
