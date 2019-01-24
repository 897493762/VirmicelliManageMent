//
//  JHBasicViewController.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/4.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHBasicViewController.h"
#import "JHChooseUserMaskView.h"
#import "JHCustomButton.h"
#import "JHUserInfoView.h"
#import "JHUsersListViewController.h"
#import "JHLoginViewController.h"
#import "JHTestModel.h"
#import "JHUserinfosModel.h"
#import "JHUsersListViewController.h"
#import "JHSearchViewController.h"
#import "JHTagContainerView.h"
#import "JHBaseiHeaderView.h"
#import "JHTagTitleModel.h"
#import "JHBasicCollectionViewCell.h"
#import "JHAnalysisViewController.h"
@interface JHBasicViewController()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    CGFloat _collectionCellWidth;
}
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *contentView;
@property (nonatomic , strong) JHBaseiHeaderView *headerView;
@property (nonatomic , strong) UICollectionView *collectionView;

@property (nonatomic , assign) BOOL isFollow;
@property (nonatomic , assign) BOOL isPraising;
@property (nonatomic , assign) BOOL isPraised;
@property (nonatomic , assign) NSInteger followEachCount;

@property (nonatomic , strong) JHUserInfoModel *userInfoModel;

@property (nonatomic , strong) NSMutableArray *dataList;

@property (nonatomic , strong) NSMutableArray *praised;
@property (nonatomic , strong) NSMutableArray *praising;

@property (nonatomic , strong) NSMutableArray *cancelFollowList;
@property (nonatomic , strong) NSMutableArray *collectFollowList;

@property (nonatomic, strong) NSMutableArray *tagList;
@end

@implementation JHBasicViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _collectionCellWidth = (kScreenWidth -M_RATIO_SIZE(33))/2;
    [self loadSubViews];
    [self loadData];
    [self.headerView setContentWithDataList:self.tagList];
    self.view.backgroundColor = [UIColor colorWithR:237 g:239 b:241 alpha:2];
    [self initEvent];
}
/*
 *用户信息
 */
-(void)getUserInfoData:(BOOL)isRefresh{
    [[JHNetworkManager shareInstance] POST:KUserInfo([JHUserInfoModel unarchive].pkStr)  dict:nil succeed:^(id data) {
        JHResultResponseModel *response = [[JHResultResponseModel alloc] initWithObject:data];
        if ([response.status isEqualToString:@"ok"]) {
            JHUserInfoModel *userInfoModel = [[JHUserInfoModel alloc] initWithObject:response.user];
            [self setContentWithUserInfoModel:userInfoModel isRefresh:isRefresh];
        }else{
            [self showAlertViewWithText:response.status afterDelay:1];
        }
    } failure:^(NSError *error) {
        [self showAlertNetworkError];
    }];
}
//帖子
-(void)getMediaData:(NSString *)next_max_id{
    JHUserRequestModel *request = [[JHUserRequestModel alloc] init];
    request.ig_sig_key_version = @"4";
    request.rank_token =KRank_token;
    request.max_id = next_max_id;
    request.ranked_content = @"true";
    NSString *urlStr = [KFeeduser([JHUserInfoModel unarchive].pkStr) stringByAppendingString:[request description]];
    [[JHNetworkManager shareInstance] POST:urlStr dict:nil succeed:^(id data) {
        JHResultResponseModel *response = [[JHResultResponseModel alloc] initWithObject:data];
        if ([response.status isEqualToString:@"ok"]) {
            for (int i=0; i<response.users.count; i++) {
                NSDictionary *dic = response.users[i];
                JHMediaModel *user = [self getNotesDataList:dic];
                [self downloadFeedData:user.pk];
            }
            if (response.more_available) {
                [self getMediaData:response.next_max_id];
            }
            if (response.users.count == 0) {
                self.isPraising = YES;
                [UIView performWithoutAnimation:^{
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
                    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];                    }];
            }
            [[JHCoreDataStackManager shareInstance] saveMedia:response.users withMore:response.more_available succeed:^(NSInteger data) {
                if (!response.more_available) {
                    NSLog(@"加载完成------");
                    [self updateTags:[self updateBasicTagData:self.tagList withName:@"Media" withCount:0]];

                }
            }];
        }
    } failure:^(NSError *error) {
    }];
}
-(void)downloadFeedData:(NSString *)pk{
    [self downloadData:KMediaLikers(pk) withColum:@"praising" withMaxId:nil succeed:nil];
    [self downloadData:KMediaComments(pk) withColum:@"comment" withMaxId:nil succeed:nil];
}
//获取用户
-(void)downloadData:(NSString *)url withColum:(NSString *)colum withMaxId:(NSString *)next_max_id succeed:(void (^)(id data))succeed{
    if (next_max_id !=nil) {
        url = [url stringByAppendingString:[NSString stringWithFormat:@"&max_id=%@",next_max_id]];
    }
    [[JHNetworkManager shareInstance] POST:url dict:nil succeed:^(id data) {
        JHResultResponseModel *response = [[JHResultResponseModel alloc] initWithObject:data];
        if ([response.status isEqualToString:@"ok"]) {
            [[JHCoreDataStackManager shareInstance] save:response.users withColum:colum withMore:response.more_available];

            if ([colum isEqualToString:@"praising"]) {
                [self.praising addObjectsFromArray:response.users];
                if (!response.more_available || (self.praising.count>99&&!self.isPraising)) {
                    self.isPraising = YES;
                    [UIView performWithoutAnimation:^{
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
                        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];                    }];
                }
            }else if ([colum isEqualToString:@"praised"]){
                [self.praised addObjectsFromArray:response.users];
                if (!response.more_available || (self.praised.count>99&&!self.isPraised)) {
                    self.isPraised = YES;
                    [UIView performWithoutAnimation:^{
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
                        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                    }];
                }
            }
            if (response.more_available) {
                [self downloadData:url withColum:colum withMaxId:response.next_max_id succeed:nil];
            }
            
        }
        if (succeed) {
            succeed(response.users);
        }
        
    } failure:^(NSError *error) {
        if (succeed) {
            succeed(nil);
        }
    }];
}

#pragma mark - Model
-(void)setContentWithUserInfoModel:(JHUserInfoModel *)model isRefresh:(BOOL)isRefresh{
    if (self.userInfoModel == model) {
        return;
    }
    self.userInfoModel = model;
    [self.titleView setContenWithUserName:self.userInfoModel.username withIconUrlStr:self.userInfoModel.profile_pic_url withNameStrWidth:self.userInfoModel.usernameWidth];
    [self.collectionView reloadData];
    self.headerView.userModel = self.userInfoModel;
    
}
-(void)updateTags:(NSArray *)arry{
    self.tagList = [arry copy];
    [self.headerView setContentWithDataList:self.tagList];
}

#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JHBasicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHBasicCollectionViewCell" forIndexPath:indexPath];
    [cell setContentWithTestModel:self.dataList[indexPath.row]];
    if (indexPath.row == 0) {
        [cell setContentIsRefreshing:self.isFollow withCount:self.userInfoModel.follower_count - self.followEachCount];
        
    }else if (indexPath.row == 1){
        [cell setContentIsRefreshing:self.isFollow withCount:self.userInfoModel.following_count - self.followEachCount];
        
    }else if (indexPath.row == 2){
        [cell setContentIsRefreshing:self.isFollow withCount:self.followEachCount];
    }else{
        if (indexPath.row == 3) {
            [cell setContentIsRefreshing:self.isPraised withCount:self.praised.count];
        }else if (indexPath.row == 4){
            [cell setContentIsRefreshing:self.isPraising withCount:self.praising.count];
        }else if(indexPath.row == 6){
            [cell setContentIsRefreshing:YES withCount:self.collectFollowList.count];
        }else if(indexPath.row == 5){
            [cell setContentIsRefreshing:self.isFollow withCount:self.cancelFollowList.count];
        }
    }
        
    return cell;
}
//cell 大小

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(_collectionCellWidth,M_RATIO_SIZE(75));
}

//边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(M_RATIO_SIZE(10), M_RATIO_SIZE(10), 0,M_RATIO_SIZE(10));
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    JHTestModel *model = self.dataList[indexPath.row];
    if (indexPath.item == self.dataList.count-1) {
        JHSearchViewController *search = [self.storyboard instantiateViewControllerWithIdentifier:@"JHSearchViewController"];
        search.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:search animated:YES];
    }else{
        JHUsersListViewController *foot = [self.storyboard instantiateViewControllerWithIdentifier:@"JHUsersListViewController"];
        foot.hidesBottomBarWhenPushed = YES;
        if (indexPath.row<5) {
            [foot setContentWithDataList:nil withTitle:model.title withTag:0];
        }else{
            if (indexPath.row == 5) {
                [foot setContentWithDataList:self.cancelFollowList withTitle:model.title withTag:0];
            }else{
                [foot setContentWithDataList:self.collectFollowList withTitle:model.title withTag:0];
            }
        }
        [self.navigationController pushViewController:foot animated:YES];
    }
    [self statisticsUserEvent:model.title];
    self.switchVC = 2;
    [MXGoogleManager shareInstance].switchTagVCShowAD +=1;
    NSInteger index =[MXGoogleManager shareInstance].switchTagVCShowAD;
    if (self.isShowInsterstitial && index >=3) {
        [self showInterstitial];
    }
}


- (void)setupRefresh {
    //下拉刷新 在开始刷新后会调用此block
    self.scrollView.mj_header = [JHRefreshHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
}

-(void)loadData{
    [[JHCoreDataStackManager shareInstance] clear];
    self.isPraised = NO;
    self.isPraising = NO;
    self.isFollow = NO;
    self.praising = nil;
    self.praised = nil;
    self.collectFollowList = nil;
    [self.collectionView reloadData];
    [self getUserInfoData:NO];

    [NSThread detachNewThreadSelector:@selector(getEachFollowersData) toTarget:self withObject:nil];
    [NSThread detachNewThreadSelector:@selector(getPraisedData) toTarget:self withObject:nil];
    [NSThread detachNewThreadSelector:@selector(getPraisingData) toTarget:self withObject:nil];
    [UIView performWithoutAnimation:^{
        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:6 inSection:0]]];
    }];
    [self.scrollView.mj_header endRefreshing];
}

-(void)getEachFollowersData{
    [[JHNetworkManager shareInstance] getFollowersucceed:^(id data) {
        self.followEachCount = [data integerValue];
        self.isFollow= YES;
        [UIView performWithoutAnimation:^{
            NSMutableArray *arry = [NSMutableArray array];
            for (int i=0; i<3; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [arry addObject:indexPath];
            }
            [self.collectionView reloadItemsAtIndexPaths:arry];
        }];
        [self getCancelFollowDataList];
    }];
}

-(void)getPraisedData{
    [self downloadData:KfeedLiked withColum:@"praised" withMaxId:nil succeed:nil];
}
-(void)getPraisingData{
    [self getMediaData:nil];
}

-(void)getCancelFollowDataList{
    [self getCancelFollow:^(id data) {
        self.cancelFollowList = data;
        [UIView performWithoutAnimation:^{
            [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:0]]];
        }];
    }];
}
//#pragma mark - ui

-(void)loadSubViews{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.headerView];
    [self.contentView addSubview:self.collectionView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.leading.equalTo(self.contentView);
        make.height.equalTo(K_RATIO_SIZE(314));
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.leading.trailing.equalTo(self.contentView);
        make.height.equalTo(K_RATIO_SIZE(350));
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.collectionView.mas_bottom);
    }];

}
-(void)initEvent{
    [self setupRefresh];
    __weak typeof(self) weakself = self;
    self.headerView.block = ^(UIButton *sender) {
        if (sender.tag <2) {
            JHUsersListViewController *foot = [weakself.storyboard instantiateViewControllerWithIdentifier:@"JHUsersListViewController"];
            foot.hidesBottomBarWhenPushed = YES;
            if (sender.tag == 0) {
                [foot setContentWithDataList:[[JHCoreDataStackManager shareInstance] getMyFollwerList] withTitle:NSLocalizedString(@"2150", nil) withTag:0];
            }else{
                [foot setContentWithDataList:[[JHCoreDataStackManager shareInstance] getMyFollowingList] withTitle:NSLocalizedString(@"2140", nil) withTag:0];
            }
            [weakself.navigationController pushViewController:foot animated:YES];
        }else {
            JHAnalysisViewController *detail = [weakself.storyboard instantiateViewControllerWithIdentifier:@"JHAnalysisViewController"];
            detail.hidesBottomBarWhenPushed = YES;
            NSString *title;
            if (sender.tag == 2) {
                title = NSLocalizedString(@"2141", nil);
            }else if(sender.tag == 3){
                title = NSLocalizedString(@"2142", nil);
            }else{
                title = NSLocalizedString(@"2117", nil);
            }
            [detail setContentWithTitle:title];
            [weakself.navigationController pushViewController:detail animated:YES];
            
        }
    };

}


#pragma mark - Custom Acessors
-(JHBaseiHeaderView *)headerView{
    if (_headerView == nil) {
        _headerView = [[JHBaseiHeaderView alloc] init];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}
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
    }
    return _scrollView;
}
-(UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = M_RATIO_SIZE(11);
        layout.minimumLineSpacing = M_RATIO_SIZE(10);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor colorWithR:237 g:239 b:241 alpha:2];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerClass:[JHBasicCollectionViewCell class] forCellWithReuseIdentifier:@"JHBasicCollectionViewCell"];
        _collectionView = collectionView;
        _collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}
-(NSMutableArray *)cancelFollowList{
    if (_cancelFollowList == nil) {
        _cancelFollowList = [NSMutableArray array];
    }
    return _cancelFollowList;
}
-(NSMutableArray *)dataList{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
        [_dataList addObjectsFromArray:[self getAnylysisDataList]];
    }
    return _dataList;
}
-(NSMutableArray *)praising{
    if (_praising == nil) {
        _praising = [NSMutableArray array];
    }
    return _praising;
}
-(NSMutableArray *)praised{
    if (_praised == nil) {
        _praised = [NSMutableArray array];
    }
    return _praised;
}

-(NSMutableArray *)tagList{
    if (_tagList == nil) {
        _tagList = [NSMutableArray array];
        for (int i=2740; i<2751; i++) {
            JHTagTitleModel *model = [[JHTagTitleModel alloc] init];
            NSString *to = [NSString stringWithFormat:@"%d",i];
            model.title = NSLocalizedString(to, nil);
            model.count = 0;
            [_tagList addObject:model];
        }

    }
    return _tagList;
}
-(NSMutableArray *)collectFollowList{
    if (_collectFollowList == nil) {
        _collectFollowList = [[self getAnylysisCollectUser] copy];
    }
    return _collectFollowList;
}
@end
