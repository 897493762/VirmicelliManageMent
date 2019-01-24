//
//  JHUsersListViewController.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/7.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHBaseTwoViewController.h"
#import "JHArticleModel.h"
@interface JHUsersListViewController : JHBaseTwoViewController
-(void)setContentWithDataList:(NSArray *)dataList withTitle:(NSString *)titleStr withTag:(int)tag;
-(void)setContentWithPk:(NSString *)pk withTitle:(NSString *)title withUsername:(NSString *)username;

//-(void)setContentWithArticleModel:(JHArticleModel *)model;
-(void)setContentWithAnaTitle:(NSString *)titleStr withTopTitle:(NSString *)topTitle;

@end
