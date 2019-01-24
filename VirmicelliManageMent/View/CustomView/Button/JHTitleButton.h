//
//  JHTitleButton.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/7.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHTitleButton : UIButton
@property (nonatomic, strong) UILabel *lableOne;
@property (nonatomic, strong) UILabel *lableTwo;

+ (instancetype) createButton;
-(void)setContentWithLableOneStr:(NSString *)oneStr withLableTwoStr:(NSString *)twoStr;
@end
