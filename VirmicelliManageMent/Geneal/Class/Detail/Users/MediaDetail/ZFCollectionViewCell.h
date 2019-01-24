//
//  ZFCollectionViewCell.h
//  Player
//
//  Created by 任子丰 on 17/3/22.
//  Copyright © 2017年 任子丰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ZFCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic,strong)UIImageView *loadLogo;
@property (nonatomic,strong)UIButton *volumeButton;
@property (nonatomic,strong)MPVolumeView *volumeView;
@property (nonatomic,strong)UISlider *volumeSlider;

@property (nonatomic,assign)CGFloat volumeCount;
@property (nonatomic,assign)NSString *imgUrl;

/// 播放按钮block 
@property (nonatomic, copy  ) void(^playBlock)(UIButton *sender);

-(void)setContentWithImgUrl:(NSString *)imgUrl withtype:(NSInteger)type;
@end
