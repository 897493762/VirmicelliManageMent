//
//  ZFCollectionViewCell.m
//  Player
//
//  Created by 任子丰 on 17/3/22.
//  Copyright © 2017年 任子丰. All rights reserved.
//

#import "ZFCollectionViewCell.h"
#import <ZFPlayer/UIImageView+ZFCache.h>

@implementation ZFCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.coverImageView.tag = 100;
        [self initSubViews];
    }
    return self;
}
-(void)setContentWithImgUrl:(NSString *)imgUrl withtype:(NSInteger)type{
    if (self.imgUrl == imgUrl) {
        return;
    }
    self.imgUrl = imgUrl;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"img_posts_s"] options:SDWebImageAllowInvalidSSLCertificates];

    if (type == 2) {
        self.loadLogo.hidden = NO;
        self.volumeButton.hidden = NO;
    }else{
        self.loadLogo.hidden = YES;
        self.volumeButton.hidden = YES;;
    }

}
- (void)layoutSubviews {
    [super layoutSubviews];
 
}

-(void)initSubViews{
    [self.contentView addSubview:self.coverImageView];
    
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.contentView addSubview:self.loadLogo];
    [self.contentView addSubview:self.volumeButton];
    [self.loadLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(K_RATIO_SIZE(10));
        make.trailing.equalTo(K_RATIO_SIZE(-10));
    }];
    [self.volumeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.equalTo(self.contentView);
        make.width.height.equalTo(K_RATIO_SIZE(30));
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    [self getValumeView];
}
/*
 * 设置音量
 */
- (void)setVolume:(CGFloat)value {
    [self.volumeSlider setValue:value animated:NO];
}
-(void)getValumeView{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    CGFloat currentVol = audioSession.outputVolume;
    if (currentVol >0) {
        self.volumeCount =currentVol;
    }else{
        self.volumeCount =10;
    }
    
    [self setVolumeIcon:currentVol];
    UISlider *volumeSlider = [self volumeSlider];
    self.volumeView.showsVolumeSlider = YES; // 需要设置 showsVolumeSlider 为 YES
    // 下面两句代码是关键
    [volumeSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
    [self.volumeView sizeToFit];
    self.volumeSlider = volumeSlider;
}

-(void)setVolumeIcon:(CGFloat)value{
    if (value>0) {
        [self.volumeButton setImage:[UIImage imageNamed:@"icon_volume_on"] forState:UIControlStateNormal];
        self.volumeButton.selected = YES;
    }else{
        [self.volumeButton setImage:[UIImage imageNamed:@"icon_volume_off"] forState:UIControlStateNormal];
        self.volumeButton.selected = NO;
    }
}
//系统声音改变

-(void)volumeChanged:(NSNotification *)notification

{
    float volume = [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    [self setVolumeIcon:volume];
    if (volume>0) {
        self.volumeCount = volume;
    }
    NSLog(@"FlyElephant-系统音量:%f", volume);
    
}
-(void)volumeButtonOnclicked:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self setVolume:self.volumeCount];
    }else{
        [self setVolume:0];
        
    }
}
#pragma mark - custom accessor
- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_posts_s"]];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.tag = 100;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
        _coverImageView.clipsToBounds = YES;
    }
    return _coverImageView;
}
-(UIImageView *)loadLogo{
    if (_loadLogo == nil) {
        _loadLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_video"]];
    }
    return _loadLogo;
}

-(UIButton *)volumeButton{
    if (_volumeButton == nil) {
        _volumeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_volumeButton setImage:[UIImage imageNamed:@"icon_volume_on"] forState:UIControlStateNormal];
        [_volumeButton addTarget:self action:@selector(volumeButtonOnclicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _volumeButton;
}
- (MPVolumeView *)volumeView {
    if (!_volumeView) {
        _volumeView = [[MPVolumeView alloc] init];
        _volumeView.hidden = YES;
        [self.window addSubview:_volumeView];
    }
    return _volumeView;
}
/*
 * 遍历控件，拿到UISlider
 */
- (UISlider *)volumeSlider {
    UISlider* volumeSlider = nil;
    for (UIView *view in [self.volumeView subviews]) {
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeSlider = (UISlider *)view;
            break;
        }
    }
    return volumeSlider;
}
@end
