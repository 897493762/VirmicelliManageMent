//
//  JHChooseUserMaskView.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/6.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^callBlock)(NSInteger index);

@interface JHChooseUserMaskView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic, copy) callBlock block;
@property(nonatomic, assign) BOOL isShow;
@property (nonatomic, strong) NSMutableArray *dataList;

-(void)showInView:(UIView *)view;
-(void)hiddenView;
@end
