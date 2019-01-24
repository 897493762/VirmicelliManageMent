//
//  JHBaseiHeaderView.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/28.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^BasicHeaderBlock)(UIButton *sender);

@interface JHBaseiHeaderView : UIView
@property (nonatomic, strong) JHUserInfoModel *userModel;
@property (nonatomic, copy) BasicHeaderBlock block;

-(void)setContentWithDataList:(NSArray *)list;
@end
