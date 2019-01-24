//
//  JHMediaVideoView.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/5.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHMediaVideoView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>


@interface JHMediaVideoView ()
@property (nonatomic,strong)AVPlayer *player;//播放器对象
@property (nonatomic,strong)AVPlayerItem *currentPlayerItem;
@property (nonatomic,strong)UIView *contentView;
@property (nonatomic,strong)UIImageView *loadLogo;
@property (nonatomic,strong)UIButton *volumeButton;
@property (nonatomic,strong)MPVolumeView *volumeView;
@property (nonatomic,strong)UISlider *volumeSlider;

@property (nonatomic,assign)CGFloat volumeCount;

@end
@implementation JHMediaVideoView
-(void)awakeFromNib{
    [super awakeFromNib];
    [self initSubViews];
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self initSubViews];
    }
    return self;
}
/*
 *创建播放器
 */
-(void)creatPlayer:(NSString *)url{
    self.urlStr = url;
    NSURL *webVideoUrl = [NSURL URLWithString:url];
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:webVideoUrl];
    self.currentPlayerItem = playerItem;
    self.player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    [self showPlayer];

}
/*
 *创建显示视频的AVPlayerLayer,设置视频显示属性，并添加视频图层
 */
-(void)showPlayer{
    AVPlayerLayer *avLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    avLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    avLayer.frame = CGRectMake(0, 0, self.width, self.height);
    [self.layer addSublayer:avLayer];
    [self bringSubviewToFront:self.contentView];
}
/*
 *执行play方法，开始播放
 */
-(void)play{
    self.isPlay = YES;
    if (self.isPlayEnd) {
        self.isPlayEnd = NO;
        // 播放完成后重复播放
        // 跳到最新的时间点开始播放
        [self.player seekToTime:CMTimeMake(0, 1)];
    }
    [self.player play];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification   object:self.player.currentItem];

}
-(void)stop{
    self.isPlay = NO;
    [self.player pause];

}
-(void)initSubViews{
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.loadLogo];
    [self.contentView addSubview:self.volumeButton];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.loadLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(K_RATIO_SIZE(10));
        make.trailing.equalTo(K_RATIO_SIZE(-10));
    }];
    [self.volumeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.equalTo(self.contentView);
        make.width.height.equalTo(K_RATIO_SIZE(30));
    }];
    //通过KVO来观察status属性的变化，来获得播放之前的错误信息
    [self.currentPlayerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
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
    self.volumeCount =currentVol;

    [self setVolumeIcon:currentVol];
    UISlider *volumeSlider = [self volumeSlider];
    self.volumeView.showsVolumeSlider = YES; // 需要设置 showsVolumeSlider 为 YES
    // 下面两句代码是关键
    [volumeSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
    [self.volumeView sizeToFit];
    self.volumeSlider = volumeSlider;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:
(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        //取出status的新值
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey]intValue];
        switch (status) {
            case AVPlayerItemStatusFailed:
                NSLog(@"item 有误");
                break;
            case AVPlayerItemStatusReadyToPlay:
                NSLog(@"准好播放了");
                break;
            case AVPlayerItemStatusUnknown:
                NSLog(@"视频资源出现未知错误");
                break;
            default:
                break;
        }
    }
    //移除监听（观察者）
    [object removeObserver:self forKeyPath:@"status"];
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
- (void)playbackFinished:(NSNotification *)noti
{
    self.isPlayEnd = YES;
    [self play];
 
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
-(void)volumeButtonOnclicked:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self setVolume:self.volumeCount];
    }else{
        [self setVolume:0];

    }
}
#pragma mark - custom accessor
-(UIView *)contentView{
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
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
