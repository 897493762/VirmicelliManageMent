//
//  JHUserInfoView.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/6.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface JHUserInfoView : UIView
@property(nonatomic, assign) CGSize intrinsicContentSize;
@property (nonatomic , strong) UIView *contanerView;
//@property (nonatomic , strong) UIImageView *icon;
@property (nonatomic , strong) UILabel *nameLable;
@property (nonatomic , strong) UIButton *selectButton;

//@property (nonatomic , strong) UIButton *searchButton;
@property (nonatomic , strong) UIButton *setButton;

-(void)setContenWithUserName:(NSString *)name withIconUrlStr:(NSString *)urlStr withNameStrWidth:(CGFloat ) width;
-(void)updateSubViews;
@end
