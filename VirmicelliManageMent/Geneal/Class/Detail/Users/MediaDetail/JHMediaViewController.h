//
//  JHMediaViewController.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/3.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHBaseTwoViewController.h"
#import "JHArticleModel.h"
@interface JHMediaViewController : JHBaseTwoViewController
-(void)setContentWithArticleModel:(JHArticleModel *)model;
-(void)setContentWithArticleModelPk:(NSString *)pk;

@end
