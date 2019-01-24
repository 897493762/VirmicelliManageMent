//
//  JHRepostViewController.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/29.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHRepostViewController.h"
#import "JHCustomButton.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "JHTouchView.h"
#import "AFNetworking.h"
@interface JHRepostViewController ()
/* 内容列表 */
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIImageView *photo;
@property (strong, nonatomic) UIView *oneView;
@property (strong, nonatomic) UIView *twoView;
@property (strong, nonatomic) UIButton *nextButton;
@property (strong, nonatomic) UIImageView *nextIcon;
@property (strong, nonatomic) UILabel *nextLable;
@property (nonatomic, strong) UIView *signView;
@property (nonatomic, strong) UIView *bagView;
@property (nonatomic, strong) UIImageView *signIcon;
@property (nonatomic, strong) UIImageView *userIcon;
@property (nonatomic, strong) UILabel *userLable;
@property (nonatomic, strong) JHTouchView *lineView;

@property (nonatomic, assign) CGFloat picHeight;
@property (nonatomic, strong) NSMutableArray *oneButtons;
@property (nonatomic, strong) NSMutableArray *twoButtons;

- (void)nextButtonOnclicked:(UIButton *)sender;

@end

@implementation JHRepostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title  = NSLocalizedString(@"2751", nil);
    self.zf_interactivePopDisabled = YES;
}

-(void)setModel:(JHArticleModel *)model{
    _model = model;
    [self.photo sd_setImageWithURL:[NSURL URLWithString:model.profile_pic_url] placeholderImage:[UIImage imageNamed:@"img_posts_s"] options:SDWebImageAllowInvalidSSLCertificates];
    self.picHeight =model.insPhotoSize.height;
    [self initSignView];
    self.userLable.text = model.user.username;
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:model.user.profile_pic_url] placeholderImage:[UIImage imageNamed:@"img_posts_s"] options:SDWebImageAllowInvalidSSLCertificates];
    [self.photo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.picHeight));
    }];
    self.lineView.max_y = self.picHeight;
}

#pragma mark -- UI
-(void)loadSubView{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.photo];
    [self.contentView addSubview:self.oneView];
    [self.contentView addSubview:self.twoView];
    [self.contentView addSubview:self.nextButton];
    [self.nextButton addSubview:self.nextIcon];
    [self.nextButton addSubview:self.nextLable];
    [self setupSubviews];
    [self initOneView];
    [self initTwoView];
}
-(void)setupSubviews{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    [self.photo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self.contentView);
    }];
    [self.oneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(K_RATIO_SIZE(50));
        make.trailing.equalTo(K_RATIO_SIZE(-50));
        make.height.equalTo(K_RATIO_SIZE(40));
        make.top.equalTo(self.photo.mas_bottom).offset(M_RATIO_SIZE(30));
    }];
    [self.twoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.height.equalTo(self.oneView);
        make.top.equalTo(self.oneView.mas_bottom).offset(M_RATIO_SIZE(20));
    }];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.height.equalTo(self.oneView);
        make.top.equalTo(self.twoView.mas_bottom).offset(M_RATIO_SIZE(20));
    }];
    [self.nextIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nextButton);
        make.leading.equalTo(K_RATIO_SIZE(34));
        make.width.height.equalTo(K_RATIO_SIZE(24));
    }];
    [self.nextLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(self.nextButton);
        make.leading.equalTo(self.nextIcon.mas_trailing).offset(M_RATIO_SIZE(15));
        make.trailing.equalTo(K_RATIO_SIZE(-5));
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.nextButton.mas_bottom).offset(M_RATIO_SIZE(38));
    }];
}
-(void)initOneView{
    NSArray *images = @[@"icon_repost_text_bottom",@"icon_repost_text_top",@"icon_repost_text_right",@"icon_repost_text_left",@"icon_repost_text_none"];
    for (int i=0; i<images.count; i++) {
        JHCustomButton *button = [JHCustomButton createImageButton];
        button.titleImage.image = [UIImage imageNamed:images[i]];
        [self.oneView addSubview:button];
        CGFloat wid=(kScreenWidth-M_RATIO_SIZE(100))/5;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.oneView);
            make.width.equalTo(@(wid));
            make.leading.equalTo(@(wid*i));
        }];
        [button updateImgWid:M_RATIO_SIZE(24) WithHeight:M_RATIO_SIZE(24)];
        if (i==0) {
            button.backgroundColor = [UIColor colorWithHexString:@"#EDEFF1"];
        }else{
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = [UIColor colorWithHexString:@"#EDEFF1"];
            [self.oneView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.top.bottom.equalTo(button);
                make.width.equalTo(@1);
            }];
        }
        button.tag = i;
        [button addTarget:self action:@selector(buttonOnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.oneButtons addObject:button];
        
    }
    self.oneView.layer.borderColor= [UIColor colorWithHexString:@"#EDEFF1"].CGColor;
    self.oneView.layer.borderWidth = 1;
    self.oneView.layer.masksToBounds = YES;
    self.oneView.layer.cornerRadius = M_RATIO_SIZE(3);
}
-(void)initTwoView{
    for (int i=0; i<5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i == 1) {
            [self.twoView addSubview:button];
        }else{
            [self.contentView addSubview:button];
        }
        CGFloat wid=(kScreenWidth-M_RATIO_SIZE(100))/5;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.twoView);
            make.width.equalTo(@(wid));
            make.leading.equalTo(self.twoView.mas_leading).offset(wid*i);
        }];
        if (i==0) {
            button.backgroundColor = [UIColor colorWithHexString:@"#B1B2B4"];
        }else if (i==1){
            button.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        }else if (i==2){
            button.backgroundColor = [UIColor colorWithHexString:@"#FDA100"];
        }else if (i==3){
            button.backgroundColor = [UIColor colorWithHexString:@"#4194FF"];
        }else if (i==4){
            button.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
            [button setImage:[UIImage imageNamed:@"icon_camera_text_text"] forState:UIControlStateNormal];
        }
        button.tag = i;
        [button addTarget:self action:@selector(buttonTwoOnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.twoButtons addObject:button];
    }
    self.twoView.layer.borderColor= [UIColor colorWithHexString:@"#B1B2B4"].CGColor;
    self.twoView.layer.borderWidth = 1;
    self.twoView.layer.masksToBounds = YES;
    self.twoView.layer.cornerRadius = M_RATIO_SIZE(3);
}
-(void)initSignView{
    [self.photo addSubview:self.signView];
    [self.photo addSubview:self.lineView];
    [self.signView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.width.equalTo(K_RATIO_SIZE(174));
        make.height.equalTo(K_RATIO_SIZE(33));
        make.bottom.equalTo(@0);
    }];
    [self.signView addSubview:self.bagView];
    [self.bagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.signView);
    }];
    [self.signView addSubview:self.signIcon];
    [self.signIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(K_RATIO_SIZE(24));
        make.centerY.equalTo(self.signView);
        make.leading.equalTo(K_RATIO_SIZE(10));
    }];
    [self.signView addSubview:self.userIcon];
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.signView);
        make.width.height.equalTo(K_RATIO_SIZE(23));
        make.leading.equalTo(self.signIcon.mas_trailing).offset(M_RATIO_SIZE(10));
    }];
    [self.signView addSubview:self.userLable];
    [self.userLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userIcon);
        make.leading.equalTo(self.userIcon.mas_trailing).offset(M_RATIO_SIZE(10));
        make.trailing.equalTo(K_RATIO_SIZE(-10));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.width.equalTo(self.photo);
        make.height.equalTo(K_RATIO_SIZE(33));
    }];
    self.photo.userInteractionEnabled = YES;
    [self.view bringSubviewToFront:self.lineView];
    __weak typeof(self) weakSelf = self;
    self.lineView.block = ^(NSInteger tag) {
        if (tag == 1) {
            weakSelf.scrollView.scrollEnabled = NO;
        }else{
            weakSelf.scrollView.scrollEnabled = YES;
        }
    };
    //添加手势
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap1.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap1];
}

#pragma mark - IBACtion
-(void)nextButtonOnclicked:(UIButton *)sender{
     UIImage *image =  [self imageForView:self.photo];
    if (self.model.media_type== 2){
        carousel_media *media = self.model.media[0];
        video_versions *video = media.videos[0];
            [self playerDownload:video.url];
        }else{
            [self loadImageFinished:image];
        }
}
/*
 *保存图片到相册
 */
- (void)loadImageFinished:(UIImage *)image
{
    __block ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
    [lib writeImageToSavedPhotosAlbum:image.CGImage metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        NSLog(@"assetURL = %@, error = %@", assetURL, error);
        lib = nil;
        [self openInstagramReleaseImage:assetURL.absoluteString];
    }];
}
//-----下载视频--
- (void)playerDownload:(NSString *)url{
    [self showLoding];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString  *fullPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"jaibaili.mp4"];
    NSURL *urlNew = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlNew];
    NSURLSessionDownloadTask *task =
    [manager downloadTaskWithRequest:request
                            progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                return [NSURL fileURLWithPath:fullPath];
                            }
                   completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                       [self saveVideo:fullPath];
                   }];
    [task resume];
    
}

//videoPath为视频下载到本地之后的本地路径
- (void)saveVideo:(NSString *)videoPath{
    
    if (videoPath) {
        NSURL *url = [NSURL URLWithString:videoPath];
        BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([url path]);
        if (compatible)
        {
            //保存相册核心代码
            UISaveVideoAtPathToSavedPhotosAlbum([url path], self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
            [self openInstagramReleaseImage:url.absoluteString];
        }
    }
}


//保存视频完成之后的回调
- (void) savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    [self hiddenLoding];
    if (error) {
        NSLog(@"保存视频失败%@", error.localizedDescription);
    }
    else {
        NSLog(@"保存视频成功");
       
    }
}

-(void)buttonOnClicked:(UIButton *)sender{
    for (UIButton *button in self.oneButtons) {
        if (button.tag == sender.tag) {
            button.backgroundColor = [UIColor colorWithHexString:@"#EDEFF1"];
        }else{
            button.backgroundColor = [UIColor whiteColor];
        }
    }
    if (sender.tag == 4) {
        self.signView.hidden = YES;
    }else{
        self.signView.hidden = NO;
        if (sender.tag == 0) {
            self.signView.transform = CGAffineTransformIdentity;
        }else if (sender.tag == 1){
            self.signView.transform =  CGAffineTransformMakeTranslation(0, -self.picHeight+M_RATIO_SIZE(33));
        }else if (sender.tag == 2){
            self.signView.transform =CGAffineTransformMakeRotation(M_PI_2);
            self.signView.transform = CGAffineTransformTranslate(self.signView.transform,-M_RATIO_SIZE(71)-self.picHeight+M_RATIO_SIZE(174), M_RATIO_SIZE(71)-kScreenWidth+M_RATIO_SIZE(33));
        }else if (sender.tag == 3){
            self.signView.transform =CGAffineTransformMakeRotation(M_PI_2);
            self.signView.transform = CGAffineTransformTranslate(self.signView.transform,-M_RATIO_SIZE(71)-self.picHeight+M_RATIO_SIZE(174), M_RATIO_SIZE(71));
        }
    }
    
    
}
-(void)buttonTwoOnClicked:(UIButton *)sender{
    if (sender.tag ==4) {
        self.lineView.hidden = sender.selected;
        sender.selected = !sender.selected;
    }else{
        if (sender.tag == 1) {
            self.signIcon.image = [UIImage imageNamed:@"icon_repost"];
            self.userLable.textColor = [UIColor blackColor];
        }else{
            self.signIcon.image = [UIImage imageNamed:@"icon_repost_repost"];
            self.userLable.textColor = c255255255;
        }
        if (sender.tag == 0) {
            self.bagView.alpha = 0.5;
            self.bagView.backgroundColor =[UIColor blackColor];
            
        }else{
            self.bagView.backgroundColor = sender.backgroundColor;
            self.bagView.alpha = 1;
        }
        self.lineView.backgroundColor =self.bagView.backgroundColor;
        self.lineView.alpha =self.bagView.alpha;
    }
}

-(void)viewTapped:(UITapGestureRecognizer *)tap{
    [self.view endEditing:YES];
}
#pragma mark - custom accessors
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollEnabled = YES;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}
-(UIImageView *)photo{
    if (_photo == nil) {
        _photo = [[UIImageView alloc] init];
        
    }
    return _photo;
}
-(UIView *)oneView{
    if (_oneView == nil) {
        _oneView = [[UIView alloc] init];
        _oneView.layer.masksToBounds = YES;
        _oneView.layer.cornerRadius = M_RATIO_SIZE(3);
    }
    return _oneView;
}
-(UIView *)twoView{
    if (_twoView == nil) {
        _twoView = [[UIView alloc] init];
        _twoView.layer.masksToBounds = YES;
        _twoView.layer.cornerRadius = M_RATIO_SIZE(3);
    }
    return _twoView;
}
-(UIButton *)nextButton{
    if (_nextButton == nil) {
        _nextButton = [UIButton buttonWithType: UIButtonTypeCustom];
        _nextButton.backgroundColor = [UIColor colorWithHexString:@"#36C489"];
        _nextButton.layer.masksToBounds = YES;
        _nextButton.layer.cornerRadius = M_RATIO_SIZE(3);
        [_nextButton addTarget:self action:@selector(nextButtonOnclicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}
-(UIImageView *)nextIcon{
    if (_nextIcon == nil) {
        _nextIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_repost_repost"]];
    }
    return _nextIcon;
}
-(UILabel *)nextLable{
    if (_nextLable == nil) {
        _nextLable = [UILabel createLableTextColor:c255255255 font:13 numberOfLines:0];
        _nextLable.text = NSLocalizedString(@"2752", nil);
    }
    return _nextLable;
}
-(UIView *)signView{
    if (_signView == nil) {
        _signView = [[UIView alloc] init];
    }
    return _signView;
}
-(UIImageView *)signIcon{
    if (_signIcon == nil) {
        _signIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_repost_repost"]];
    }
    return _signIcon;
}
-(UIImageView *)userIcon{
    if (_userIcon == nil) {
        _userIcon = [[UIImageView alloc] init];
        _userIcon.layer.masksToBounds = YES;
        _userIcon.layer.cornerRadius = M_RATIO_SIZE(23)/2;
    }
    return _userIcon;
}
-(UILabel *)userLable{
    if (_userLable == nil) {
        _userLable = [UILabel createLableTextColor:c255255255 font:15 numberOfLines:2];
    }
    return _userLable;
}
-(NSMutableArray *)oneButtons{
    if (_oneButtons == nil) {
        _oneButtons = [NSMutableArray array];
    }
    return _oneButtons;
}
-(NSMutableArray *)twoButtons{
    if (_twoButtons == nil) {
        _twoButtons = [NSMutableArray array];
    }
    return _twoButtons;
}
-(UIView *)bagView{
    if (_bagView == nil) {
        _bagView= [[UIView alloc] init];
        _bagView.backgroundColor = [UIColor blackColor];
        _bagView.alpha = 0.5;
    }
    return _bagView;
}
-(JHTouchView *)lineView{
    if (_lineView == nil) {
        _lineView = [[JHTouchView alloc] init];
        _lineView.backgroundColor =self.bagView.backgroundColor;
        _lineView.alpha = self.bagView.alpha;
        _lineView.hidden = YES;
        _lineView.userInteractionEnabled = YES;
    }
    return _lineView;
    
}
@end
