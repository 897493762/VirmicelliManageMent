//
//  InsLoginTool.h
//  InstaSecrets
//
//  Created by liuming on 2018/3/8.
//  Copyright © 2018年 liuming. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface InsLoginTool : NSObject
+(nonnull instancetype)createLoginTool;
-(void)showAlterViewWithTitle:(NSString *)title  WithLogin:(BOOL)login withCheckpoint_url:(NSString *)checkpoint_url;
@end
