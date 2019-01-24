//
//  JHMediaVideoView.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/5.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHMediaVideoView : UIView
@property (nonatomic ,strong)NSString *urlStr;
@property (nonatomic ,assign)BOOL isPlay;
@property (nonatomic ,assign)BOOL isPlayEnd;

/*
 *创建播放器
 */
-(void)creatPlayer:(NSString *)url;
-(void)play;
-(void)stop;
@end
