//
//  JHRefreshHeader.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/10/8.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHRefreshHeader.h"

@implementation JHRefreshHeader
- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        //自动改变透明度 （当控件被导航条挡住后不显示）
        self.automaticallyChangeAlpha = YES;
        
        // 设置各种状态下的刷新文字
        [self setTitle:@"下拉可以刷新" forState:MJRefreshStateIdle];
        [self setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
        [self setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
        
        
        // 设置字体
        self.stateLabel.font = [UIFont systemFontOfSize:13];
        self.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:13];
        
        // 设置颜色
        self.stateLabel.textColor = [UIColor grayColor];
        self.lastUpdatedTimeLabel.hidden = YES;
        self.stateLabel.hidden = YES;

        //初始化时开始刷新
//        [self beginRefreshing];
        
    }
    return self;
}

@end
