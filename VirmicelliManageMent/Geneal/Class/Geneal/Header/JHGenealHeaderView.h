//
//  JHGenealHeaderView.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/29.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHGenealHeaderView : UIView
@property(nonatomic, strong)NSArray *medias;
-(void)setContentWithUserInfo:(JHUserInfoModel *)model;
-(void)setContentWithFollow:(BOOL)isFollow;

@end
