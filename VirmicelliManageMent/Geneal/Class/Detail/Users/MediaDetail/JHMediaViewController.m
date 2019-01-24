//
//  JHMediaViewController.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/3.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHMediaViewController.h"
#import "JHCustomButton.h"
#import "JHUsersListViewController.h"
#import "JHMediaCommentsViewController.h"
#import "JHMediaVideoView.h"
#import "JHInsTagViewController.h"
#import "JHMediaViewController.h"
#import "JHRepostViewController.h"
#import "JHUsersListViewController.h"
#import "JHMediaCommentsViewController.h"
#import "JHGenealViewController.h"
#import "JHInsTagViewController.h"
#import "SDWebImageManager.h"

#import "ZFPlayer.h"
#import "ZFAVPlayerManager.h"
#import "ZFPlayerControlView.h"
#import "ZFCollectionViewCell.h"
#import "JHGenealViewController.h"
static NSString * const reuseIdentifier = @"collectionViewCell";

@interface JHMediaViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIImageView *userIcon;
@property (strong, nonatomic) UILabel *userLable;
@property (strong, nonatomic) UILabel *dateLable;
@property (strong, nonatomic) UIView *moreContentView;
@property (strong, nonatomic) NSMutableArray *moreList;
@property (strong, nonatomic) NSMutableArray *videoList;

@property (nonatomic, strong) JHCustomButton *likeButton;
@property (nonatomic, strong) JHCustomButton *msgButton;
@property (nonatomic, strong) UIButton *buttonOne;
@property (nonatomic, strong) UIButton *buttonTwo;
@property (nonatomic, strong) UIButton *buttonThree;
@property (nonatomic, strong) UIButton *buttonFour;
@property (nonatomic, strong) UIButton *buttonUp;

@property (strong, nonatomic) YYLabel *contentLable;
@property (strong, nonatomic) UIView *statusView;

@property (strong, nonatomic) JHArticleModel *model;

@property (assign, nonatomic) NSInteger page;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@end

@implementation JHMediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    @weakify(self)
    [self.collectionView zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
        @strongify(self)
        [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
    }];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.player = nil;
}
-(void)setContentWithArticleModelPk:(NSString *)pk{
    [[JHNetworkManager shareInstance] POST:KMediaInfo(pk) dict:nil succeed:^(id data) {
        JHResultResponseModel *response = [[JHResultResponseModel alloc] initWithObject:data];
        if ([response.status isEqualToString:@"ok"]) {
            if (response.users.count>0) {
                JHArticleModel *model = [[JHArticleModel alloc] initWithObject:response.users[0]];
                [self setContentWithArticleModel:model];
            }
        }else{
            [self showAlertViewWithText:response.status afterDelay:1];
        }
    } failure:^(NSError *error) {
        [self showAlertNetworkError];
    }];
}
#pragma mark -- player
-(void)initPlayer{
    /// playerManager
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    playerManager.view.userInteractionEnabled = NO;
    /// player的tag值必须在cell里设置
    self.player = [ZFPlayerController playerWithScrollView:self.collectionView playerManager:playerManager containerViewTag:100];
    self.player.shouldAutoPlay = YES;
    /// 1.0是消失100%时候
    self.player.playerDisapperaPercent = 1.0;
    
        @weakify(self)
        self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
            @strongify(self)
            [self setNeedsStatusBarAppearanceUpdate];
            self.collectionView.scrollsToTop = !isFullScreen;
        };
    
        self.player.playerDidToEnd = ^(id  _Nonnull asset) {
            @strongify(self)
            [self.player.currentPlayerManager replay];
        };
        /// 播放完成
        self.player.playerDidToEnd = ^(id  _Nonnull asset) {
            @strongify(self)
            NSLog(@"======播放完成");
    
            [self.player.currentPlayerManager replay];
    
        };
        self.player.playerReadyToPlay = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSURL * _Nonnull assetURL) {
            NSLog(@"======开始播放了");
        };
    
}


#pragma mark - 转屏和状态栏

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    /// 如果只是支持iOS9+ 那直接return NO即可，这里为了适配iOS8
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

#pragma mark - private method
- (void)setContentWithArticleModel:(JHArticleModel *)model{
    self.model = model;
    self.player.assetURLs = self.model.media;
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:self.model.user.profile_pic_url] placeholderImage:[UIImage imageNamed:@"img_posts_s"] options:SDWebImageAllowInvalidSSLCertificates];
    self.userLable.text = self.model.user.username;
    self.dateLable.text = self.model.timeStr;
    self.likeButton.titleLabe.text = [NSString stringWithFormat:@"%d",self.model.like_count];
    self.msgButton.titleLabe.text= [NSString stringWithFormat:@"%d",self.model.comment_count];
    self.contentLable.attributedText = [self getAttributedStr:self.model.preview.text];
    [self loadSubViews];
    [self updateDatas];
    [self initPlayer];
}
-(void)updateDatas{
    [self initPhotos];
    [self setUpButtons];
    [self updateButtons];
}
/// play the video
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop {
    carousel_media *media = self.model.media[indexPath.row];
    if (media.videos.count>0) {
        video_versions *video= media.videos[0];
        NSLog(@"%@---------video",video.url);
        [self.player playTheIndexPath:indexPath assetURL:[NSURL URLWithString:video.url] scrollToTop:scrollToTop];
    }
}

#pragma mark - UIScrollViewDelegate  列表播放必须实现

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidEndDecelerating];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [scrollView zf_scrollViewDidEndDraggingWillDecelerate:decelerate];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScrollToTop];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.collectionView]) {
        [scrollView zf_scrollViewDidScroll];
        NSInteger page = scrollView.contentOffset.x/kScreenWidth;
        if (self.page == page) {
            return;
        }
        self.page = page;
        for (int i=0; i<self.moreList.count; i++) {
            UIView *view = self.moreList[i];
            if (i==page) {
                view.backgroundColor = [UIColor colorWithR:255 g:96 b:103 alpha:1];
            }else{
                view.backgroundColor = [UIColor colorWithR:0 g:0 b:0 alpha:0.1];
            }
        }
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewWillBeginDragging];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.media.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    carousel_media *media = self.model.media[indexPath.row];
    candidates *candModel = media.image_versions2.candidates[0];
    [cell setContentWithImgUrl:candModel.url withtype:media.media_type];

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenWidth,self.model.insPhotoSize.height);
}

#pragma matk - UIScrollViewDelegate

-(void)setUpButtons{
    [self setContentLikeButton:self.model.has_liked];
    if (self.model.media_type == 8) {
        self.buttonFour.hidden = YES;
        [self.buttonThree setBackgroundImage:[UIImage imageNamed:@"icon_saved"] forState:UIControlStateNormal];
    }else{
        self.buttonFour.hidden = NO;
        [self.buttonThree setBackgroundImage:[UIImage imageNamed:@"icon_repost"] forState:UIControlStateNormal];
    }
}
-(NSMutableAttributedString *)getAttributedStr:(NSString *)text{
    if (isEmptyString(text)) {
        return nil;
    }
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc]initWithString:text];
    mutableString.yy_lineSpacing = 0;
    mutableString.yy_font = [UIFont systemFontOfSize:12];
    mutableString.yy_color =[UIColor colorWithR:66 g:75 b:87 alpha:1];
    
    for (NSString *str in self.model.preview.insTagArry) {
        NSString *tagStr = [@"#"stringByAppendingString:str];
        if ([text containsString:tagStr]) {
            NSRange range = [text rangeOfString:tagStr];
            [mutableString yy_setTextHighlightRange:range color:[UIColor colorWithR:252 g:106 b:42 alpha:1] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                JHInsTagViewController *tag = [self.storyboard instantiateViewControllerWithIdentifier:@"JHInsTagViewController"];
                tag.hidesBottomBarWhenPushed = YES;
                [tag setContentWithTagName:str];
                [self.navigationController pushViewController:tag animated:YES];
            }];
        }
        
    }
    return mutableString;
}
-(void)setContentLikeButton:(BOOL)select{
    if (select) {
        [self.buttonOne setBackgroundImage:[UIImage imageNamed:@"icon_like_default"] forState:UIControlStateNormal];
        self.buttonOne.selected = YES;
    }else{
        [self.buttonOne setBackgroundImage:[UIImage imageNamed:@"icon_like_pressed"] forState:UIControlStateNormal];
        self.buttonOne.selected = NO;
    }
}
#pragma matk - ui
-(void)loadSubViews{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.userIcon];
    [self.contentView addSubview:self.userLable];
    [self.contentView addSubview:self.dateLable];
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.likeButton];
    [self.contentView addSubview:self.msgButton];
    [self.contentView addSubview:self.moreContentView];
    [self.contentView addSubview:self.contentLable];
    [self.contentView addSubview:self.statusView];

    [self setUpSubViews];
}
-(void)setUpSubViews{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(K_RATIO_SIZE(12));
        make.leading.equalTo(K_RATIO_SIZE(10));
        make.width.height.equalTo(K_RATIO_SIZE(56));
    }];
    [self.userLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.userIcon.mas_trailing).offset(M_RATIO_SIZE(10));
        make.centerY.equalTo(self.userIcon);
    }];
    [self.dateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(K_RATIO_SIZE(-20));
        make.centerY.equalTo(self.userIcon);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.contentView);
        make.top.equalTo(self.userIcon.mas_bottom).offset(M_RATIO_SIZE(11));
        make.height.equalTo(@(self.model.insPhotoSize.height));
    }];
    [self.moreContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom);
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(K_RATIO_SIZE(16));
    }];
    [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).offset(M_RATIO_SIZE(20));
        make.leading.trailing.equalTo(self.contentView);
        make.height.equalTo(K_RATIO_SIZE(41));
        
    }];
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(K_RATIO_SIZE(12));
        make.top.equalTo(self.statusView.mas_bottom);
        make.height.equalTo(K_RATIO_SIZE(44));
    }];
    [self.msgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.likeButton.mas_trailing).offset(M_RATIO_SIZE(16));
        make.centerY.height.equalTo(self.likeButton);
    }];
 
    [self.contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.userIcon);
        make.trailing.equalTo(K_RATIO_SIZE(-10));
        make.top.equalTo(self.likeButton.mas_bottom).offset(M_RATIO_SIZE(5));
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentLable.mas_bottom).offset(M_RATIO_SIZE(17));
    }];
    [self.likeButton setUpLeftImgWithWid:M_RATIO_SIZE(18) WithHeight:M_RATIO_SIZE(18) WithSpan:0];
    [self.msgButton setUpLeftImgWithWid:M_RATIO_SIZE(18) WithHeight:M_RATIO_SIZE(18) WithSpan:0];
    [self initStutasSubViews];
}
-(void)initStutasSubViews{
    NSArray *iconStrList = @[@"icon_like_pressed",@"icon_collected_default",@"icon_repost",@"icon_saved",@"icon_share"];
    for (int i=0; i<iconStrList.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:iconStrList[i]] forState:UIControlStateNormal];
        [self.statusView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.statusView);
            make.width.height.equalTo(K_RATIO_SIZE(24));
            if (i == 4) {
                make.trailing.equalTo(K_RATIO_SIZE(-10));
            }else{
                CGFloat left = M_RATIO_SIZE(7)+M_RATIO_SIZE(40)*i;
                make.leading.equalTo(@(left));
            }
        }];
        if (i == 0) {
            self.buttonOne = button;
        }else if (i == 1){
            self.buttonTwo = button;
        }else if (i == 2){
            self.buttonThree = button;
        }else if (i == 3){
            self.buttonFour = button;
        }else if (i == 4){
            self.buttonUp = button;
        }
        button.tag = i;
        [button addTarget:self action:@selector(buttonOnclicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)initPhotos{
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.model.insPhotoSize.height));
    }];
    CGFloat moreWidth =M_RATIO_SIZE(6)*self.model.media.count+M_RATIO_SIZE(10)*(self.model.media.count-1);
    [self.moreContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(moreWidth));
    }];
    if (self.model.media.count>1) {
        for (int i=0; i<self.model.media.count; i++) {
            [self creatMoreViewIndex:i];
        }
    }
    
}

-(void)creatMoreViewIndex:(int)index{
    UIView *moreView = [[UIView alloc] init];
    moreView.backgroundColor = [UIColor colorWithR:0 g:0 b:0 alpha:0.1];
    moreView.layer.masksToBounds = YES;
    moreView.layer.cornerRadius =M_RATIO_SIZE(3);
    [self.moreContentView addSubview:moreView];
    [moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.moreContentView);
        make.leading.equalTo(@(M_RATIO_SIZE(16)*index));
        make.width.height.equalTo(K_RATIO_SIZE(6));
    }];
    if (index == 0) {
        moreView.backgroundColor = [UIColor colorWithR:255 g:96 b:103 alpha:1];
    }
    [self.moreList addObject:moreView];
}

-(void)updateButtons{
    CGFloat wid1 =[self.likeButton.titleLabe.text calcTextSizeWithWidth:[UIFont systemFontOfSize:14] totalSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)]+M_RATIO_SIZE(20);
    CGFloat wid2 =[self.msgButton.titleLabe.text calcTextSizeWithWidth:[UIFont systemFontOfSize:14] totalSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)]+M_RATIO_SIZE(20);
    
    [self.likeButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(wid1));
    }];
    [self.msgButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(wid2));
    }];
}
-(void)setContentCollectutton:(BOOL)select{
    if (select) {
        [self.buttonTwo setBackgroundImage:[UIImage imageNamed:@"icon_collected_pressed"] forState:UIControlStateNormal];
        self.buttonTwo.selected = YES;
    }else{
        [self.buttonTwo setBackgroundImage:[UIImage imageNamed:@"icon_collected_default"] forState:UIControlStateNormal];
        self.buttonTwo.selected = NO;
    }
}

#pragma mark - IBAction
-(void)likecommentButtonOnclicked:(UIButton *)sender{
    if (sender.tag == 1) {
        JHUsersListViewController *list = [self.storyboard instantiateViewControllerWithIdentifier:@"JHUsersListViewController"];
        [list setContentWithPk:self.model.pkStr withTitle:NSLocalizedString(@"2762", nil) withUsername:self.model.user.username];
        [self.navigationController pushViewController:list animated:YES];
    }else{
        JHMediaCommentsViewController *list = [self.storyboard instantiateViewControllerWithIdentifier:@"JHMediaCommentsViewController"];
        [list setContentWithArticleModel:self.model];
        [self.navigationController pushViewController:list animated:YES];
    }
}
-(void)postStatusTag:(NSInteger)tag isSlect:(BOOL)select{
    [self showLoding];
    [[JHNetworkManager shareInstance] postStatus:tag isSelected:select withPk:self.model.pkStr succeed:^(BOOL data) {
        [self hiddenLoding];
        if (data) {
            NSString *text;
            if (tag == 0) {
                if (select) {
                    text =@"点赞成功！";
                }else{
                    text =@"取消点赞成功！";
                }
                [self setContentLikeButton:select];
            }else{
                if (select) {
                    text =@"收藏成功！";
                }else{
                    text =@"取消收藏成功！";
                }
                [self setContentCollectutton:select];
            }
            [self showAlertViewWithText:text afterDelay:1];
        }else{
            NSString *text;
            if (tag == 0) {
                if (select) {
                    text =@"点赞失败！";
                }else{
                    text =@"取消点赞失败！";
                }
            }else{
                if (select) {
                    text =@"收藏失败！";
                }else{
                    text =@"取消收藏失败！";
                }
            }
            [self showAlertViewWithText:text afterDelay:1];
        }
    } failure:^(NSString *error) {
        [self hiddenLoding];
        [self showAlertViewWithText:error afterDelay:1];
    }];
}
-(void)buttonOnclicked:(UIButton *)sender{
    if (sender.tag == 2 && self.model.media_type !=8) {
        JHRepostViewController *repost = [self.storyboard instantiateViewControllerWithIdentifier:@"JHRepostViewController"];
        repost.hidesBottomBarWhenPushed = YES;
        repost.model = self.model;
        [self.navigationController pushViewController:repost animated:YES];
    }else if (sender.tag == 0){
        self.buttonOne.selected = !self.buttonOne.selected;
        [self postStatusTag:sender.tag isSlect:self.buttonOne.selected];
    }else if (sender.tag == 1){
        self.buttonTwo.selected = !self.buttonTwo.selected;
        [self postStatusTag:sender.tag isSlect:self.buttonTwo.selected];
    }else if (sender.tag == 3 || (self.model.media_type == 8 && sender.tag == 2)){
        [self showLoding];
        carousel_media *media = self.model.media[self.page];
        if (media.videos.count >0) {
            video_versions *video= media.videos[0];
            [self downloadVideoFinished:video.url succeed:^(BOOL data) {
                [self hiddenLoding];
                [self showAlertViewWithText:NSLocalizedString(@"2412", nil) afterDelay:1];
            }];
        }else{
            candidates *candModel = media.image_versions2.candidates[0];
            [self toSaveImage:candModel.url];;
        }
        
    }else{
        UIActivityViewController *activityVC = [self shareContentWithUserWithFeed:self.model];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            activityVC.popoverPresentationController.sourceView = self.view;
            [self presentViewController:activityVC animated:YES completion:nil];
        } else {
            [self presentViewController:activityVC animated:YES completion:nil];
        }
    }
}


#pragma mark -- 下载图片、视频
- (void)toSaveImage:(NSString *)urlString {
    
    NSURL *url = [NSURL URLWithString: urlString];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager diskImageExistsForURL:url completion:^(BOOL isInCache) {
        UIImage *img;
        if (isInCache)
        {
            img =  [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
        }
        else
        {
            //从网络下载图片
            NSData *data = [NSData dataWithContentsOfURL:url];
            img = [UIImage imageWithData:data];
        }
        // 保存图片到相册中
        UIImageWriteToSavedPhotosAlbum(img,self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
    }];
    
    
}
//保存图片完成之后的回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
    [self hiddenLoding];
    // Was there an error?
    if (error != NULL)
    {
        // Show error message…
        
        [self showAlertViewWithText:NSLocalizedString(@"2753", nil) afterDelay:1];
    }
    else  // No errors
    {
        // Show message image successfully saved
        [self showAlertViewWithText:NSLocalizedString(@"2753", nil) afterDelay:1];
    }
}

//点击事件
-(void)clickImage
{
    JHGenealViewController *geneal = [self.storyboard instantiateViewControllerWithIdentifier:@"JHGenealViewController"];
    [geneal setContentWithPkStr:self.model.user.pkStr];
    [self.navigationController pushViewController:geneal animated:YES];
}
#pragma mark - Custom Acessors

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.scrollEnabled = YES;
    }
    return _scrollView;
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}
-(UIImageView *)userIcon{
    if (_userIcon == nil) {
        _userIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_posts_s"]];
        _userIcon.layer.masksToBounds = YES;
        _userIcon.layer.cornerRadius = M_RATIO_SIZE(56)/2;
        _userIcon.userInteractionEnabled = YES;//打开用户交互
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
        [_userIcon addGestureRecognizer:tapGesture];
    }
    return _userIcon;
}
-(UILabel *)userLable{
    if (_userLable == nil) {
        _userLable = [UILabel createLableTextColor:[UIColor colorWithR:64 g:68 b:71 alpha:1] font:14 numberOfLines:1];
    }
    return _userLable;
}
-(UILabel *)dateLable{
    if (_dateLable == nil) {
        _dateLable = [UILabel createLableTextColor:[UIColor colorWithR:64 g:68 b:71 alpha:1] font:14 numberOfLines:1];
    }
    return _dateLable;
}
-(YYLabel *)contentLable{
    if (_contentLable == nil) {
        _contentLable = [YYLabel new];
        _contentLable.numberOfLines = 0;  //设置多行显示
        _contentLable.preferredMaxLayoutWidth = kScreenWidth-M_RATIO_SIZE(20); //设置最大的宽度
        _contentLable.userInteractionEnabled = YES;
    }
    return _contentLable;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsZero;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        /// 横向滚动 这行代码必须写
        _collectionView.zf_scrollViewDerection = ZFPlayerScrollViewDerectionHorizontal;
        [_collectionView registerClass:[ZFCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
        _collectionView.pagingEnabled = YES;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        /// 停止的时候找出最合适的播放
        @weakify(self)
        _collectionView.zf_scrollViewDidStopScrollCallback = ^(NSIndexPath * _Nonnull indexPath) {
            @strongify(self)
            [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
        };
    }
    return _collectionView;
}

-(UIView *)moreContentView{
    if (_moreContentView == nil) {
        _moreContentView = [[UIView alloc] init];
    }
    return _moreContentView;
}
-(JHCustomButton *)likeButton{
    if (_likeButton == nil) {
        _likeButton = [JHCustomButton createButton];
        [_likeButton setContentIconStr:@"icon_like" withTextStr:@"0" withTextFont:[UIFont systemFontOfSize:13] WithTextColor:[UIColor colorWithR:161 g:170 b:181 alpha:1]];
        [_likeButton addTarget:self action:@selector(likecommentButtonOnclicked:) forControlEvents:UIControlEventTouchUpInside];
        _likeButton.tag = 1;
    }
    return _likeButton;
}
-(JHCustomButton *)msgButton{
    if (_msgButton == nil) {
        _msgButton = [JHCustomButton createButton];
        [_msgButton setContentIconStr:@"icon_comment" withTextStr:@"0" withTextFont:[UIFont systemFontOfSize:13] WithTextColor:[UIColor colorWithR:161 g:170 b:181 alpha:1]];
        [_msgButton addTarget:self action:@selector(likecommentButtonOnclicked:) forControlEvents:UIControlEventTouchUpInside];
        _msgButton.tag = 2;

    }
    return _msgButton;
}
-(UIView *)statusView{
    if (_statusView == nil) {
        _statusView = [[UIView alloc] init];
    }
    return _statusView;
}
-(NSMutableArray *)moreList{
    if (_moreList == nil) {
        _moreList = [NSMutableArray array];
    }
    return _moreList;
}
-(NSMutableArray *)videoList{
    if (_videoList == nil) {
        _videoList = [NSMutableArray array];
    }
    return _videoList;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
    }
    return _controlView;
}

@end
