//
//  UIImage+JHAddition.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/20.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JHAddition)
+(UIImage *) getImageFromURL:(NSString *)fileURL;
+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

@end
