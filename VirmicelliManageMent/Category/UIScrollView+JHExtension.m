//
//  UIScrollView+JHExtension.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2019/1/9.
//  Copyright © 2019年 Satoshi Nakamoto. All rights reserved.
//

#import "UIScrollView+JHExtension.h"

@implementation UIScrollView (JHExtension)
+ (void)load {
    
    
    
    NSLog(@"scrollView调用了load方法");
    
    
    
    if (@available(iOS 11.0, *)){
        
        [[self appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        
    }
    
}
@end
