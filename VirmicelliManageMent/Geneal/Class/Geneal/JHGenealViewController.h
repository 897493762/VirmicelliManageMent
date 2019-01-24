//
//  JHGenealViewController.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/28.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHBaseTwoViewController.h"

@interface JHGenealViewController : JHBaseTwoViewController
@property (nonatomic, assign) NSInteger frameVC;
-(void)setContentWithPkStr:(NSString *)pk;
-(void)setContentWithUserName:(NSString *)userName;

@end
