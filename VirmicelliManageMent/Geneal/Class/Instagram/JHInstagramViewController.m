//
//  JHInstagramViewController.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/26.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHInstagramViewController.h"
#import "JHTagContainerView.h"
#import "JHInsNoteTableViewCell.h"
#import "JHArticleModel.h"
#import "ZFPlayer.h"
#import "ZFAVPlayerManager.h"
@interface JHInstagramViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JHTagContainerView *tagView;
@property (nonatomic, strong) NSMutableArray *trayList;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSString *next_max_id;
@property (nonatomic, strong) ZFPlayerController *player;
@end

@implementation JHInstagramViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self downloadReelsData];
    [self downloadFreetimeline:nil];
    [self initPlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarClickNotification:) name:kSelectTabBarItemNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UIImageView *titileView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_index_top_Instagram"]];
    self.navigationItem.titleView  = titileView;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    @weakify(self)
    [self.tableView zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
        @strongify(self)
        [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
    }];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.player stop];
}
/*
 全部关注的帖子列表
 */
- (void)downloadReelsData{
    [[JHNetworkManager shareInstance] POST:KUserReels dict:nil succeed:^(id data) {
        JHResultResponseModel *response = [[JHResultResponseModel alloc] initWithObject:data];
        if ([response.status isEqualToString:@"ok"]) {
            NSArray *arry = [self getTrayDataList:response.tray];
            [self.tagView setContentWithInsModelList:arry];
        }else{
            [self showAlertViewWithText:response.status afterDelay:1];
        }
    } failure:^(NSError *error) {
        [self showAlertNetworkError];
    }];
}
/*
 获取用户时间线
 */
- (void)downloadFreetimeline:(NSString *)next_max_id{
    NSString *urlStr;
    if (isEmptyString(next_max_id)) {
        urlStr = KUserTimeline([JHUserInfoModel unarchive].pkStr);
    }else{
        urlStr = [KUserTimeline([JHUserInfoModel unarchive].pkStr) stringByAppendingString:[NSString stringWithFormat:@"&max_id=%@",next_max_id]];
    }
    [[JHNetworkManager shareInstance] POST:urlStr dict:nil succeed:^(id data) {
        JHResultResponseModel *response = [[JHResultResponseModel alloc] initWithObject:data];
        if ([response.status isEqualToString:@"ok"]) {
            NSArray *arry = [self getFeedItemsDataList:response.feed_items];
            [self.dataList addObjectsFromArray:arry];
            [self.tableView reloadData];
            self.next_max_id = response.next_max_id;
            if (!response.more_available) {
                self.tableView.mj_footer.hidden = YES;
                
            }else{
                self.tableView.mj_footer.hidden = NO;
            }
        }
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if (isEmptyString(next_max_id)) {
            @weakify(self)
            [self.tableView zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
                @strongify(self)
                [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
            }];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}
#pragma mark - UIScrollViewDelegate   列表播放必须实现

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
    [scrollView zf_scrollViewDidScroll];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewWillBeginDragging];
}
#pragma mark - UITableViewDelegate && UITableViewDetaSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    JHInsNoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHInsNoteTableViewCell" forIndexPath:indexPath];
    [cell setContentWitharticleModel:self.dataList[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    JHArticleModel *model = self.dataList[indexPath.row];
    return model.inscellHeight;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}
#pragma mark - ZFTableViewCellDelegate

- (void)zf_playTheVideoAtIndexPath:(NSIndexPath *)indexPath {
    [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
}

-(void)tabBarClickNotification:(NSNotification *)ano{
    NSInteger selectIndex = [[ano.userInfo valueForKey:@"selectedIndex"] integerValue];
    if (selectIndex == 0) {
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }
}
#pragma mark - private method

/// play the video
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop {
    if (self.dataList.count == 0) {
        return;
    }
    JHArticleModel *layout = self.dataList[indexPath.row];
    if (layout.media_type == 2){
        carousel_media *media = layout.media[0];
        video_versions *video = media.videos[0];
        NSLog(@"%@---------video",video.url);
        [self.player playTheIndexPath:indexPath assetURL:[NSURL URLWithString:video.url] scrollToTop:scrollToTop];
    }
  
}
-(void)loadSubViews{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.tagView.frame = CGRectMake(0, 0, kScreenWidth, M_RATIO_SIZE(82));
    self.tableView.tableHeaderView = self.tagView;
    [self.tableView registerClass:[JHInsNoteTableViewCell class] forCellReuseIdentifier:@"JHInsNoteTableViewCell"];
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadDataList)];
    self.tableView.mj_footer = footer;
    self.tableView.mj_header = [JHRefreshHeader headerWithRefreshingBlock:^{
        [self headerData];
    }];
    self.tableView.mj_footer.hidden = YES;
}
-(void)initPlayer{
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    /// player,tag值必须在cell里设置
    self.player = [ZFPlayerController playerWithScrollView:self.tableView playerManager:playerManager containerViewTag:100];
    /// 1.0是消失100%时候
    self.player.playerDisapperaPercent = 1.0;
    @weakify(self)
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        [self.player stopCurrentPlayingCell];
        [self.tableView zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
            @strongify(self)
            [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
        }];
    };
    self.player.playerPlayTimeChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSTimeInterval currentTime, NSTimeInterval duration) {
        @strongify(self)
        NSLog(@"当前播放时间=%f-----%f",currentTime,duration);
       
    };
}
-(void)headerData{
    self.dataList = nil;
    self.next_max_id = nil;
    [self downloadReelsData];
    [self downloadFreetimeline:nil];
}
-(void)loadDataList{
    [self downloadFreetimeline:self.next_max_id];
}
#pragma mark - Custom Acessors

-(JHTagContainerView *)tagView{
    if (_tagView == nil) {
        _tagView = [[JHTagContainerView alloc] init];
    }
    return _tagView;
}
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        /// 停止的时候找出最合适的播放(只能找到设置了tag值cell)
        @weakify(self)
        _tableView.zf_scrollViewDidStopScrollCallback = ^(NSIndexPath * _Nonnull indexPath) {
            @strongify(self)
            [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
        };
    }
    return _tableView;
}

-(NSMutableArray *)trayList{
    if (_trayList == nil) {
        _trayList = [NSMutableArray array];
    }
    return _trayList;
}
-(NSMutableArray *)dataList{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}
@end
