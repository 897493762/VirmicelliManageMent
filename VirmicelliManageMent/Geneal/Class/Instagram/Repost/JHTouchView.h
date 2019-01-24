//
//  JHTouchView.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2019/1/24.
//  Copyright © 2019年 Satoshi Nakamoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"
typedef void (^TouchBlock)(NSInteger tag);

@interface JHTouchView : UIView<UITextFieldDelegate>
@property (nonatomic, assign) CGFloat max_y;
@property (nonatomic, copy) TouchBlock block;
@property (nonatomic, strong) CustomTextField *testFieled;
@property (nonatomic, strong) UIButton *spButton;

@end
