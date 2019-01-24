//
//  JHGenealViewController.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/28.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHGenealViewController.h"
#import "JHNoteListContainerView.h"
#import "JHGenealHeaderView.h"
#import "JHTagContainerView.h"
#import "JHGenealOtherHeader.h"
#import "JHSetViewController.h"
@interface JHGenealViewController ()
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *contentView;
@property (nonatomic, strong) JHNoteListContainerView *noteView;
@property (nonatomic, strong) JHGenealHeaderView *headerView;
@property (nonatomic, strong) JHGenealOtherHeader *otherHeaderView;
@property (nonatomic, strong) JHTagContainerView *tagView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSMutableArray *tagList;
@property (nonatomic, assign) BOOL isOther;
@property (nonatomic, strong) NSString *pk;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *next_max_id;

@end

@implementation JHGenealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initContentView];
    if (!self.isOther) {
        self.pk =[JHUserInfoModel unarchive].pkStr;
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarClickNotification:) name:kSelectTabBarItemNotification object:nil];
    }
    [self getUserInfoData];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.isOther) {
        self.navigationItem.title  = NSLocalizedString(@"2755", nil);
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStylePlain target:self action:nil];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"index_footer_setting_selected"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemOnClicked)];
        self.navigationItem.rightBarButtonItem.tintColor =c25510642;
    }

}
-(void)setContentWithPkStr:(NSString *)pk{
    self.pk =pk;
    self.isOther = YES;
}
-(void)setContentWithUserName:(NSString *)userName{
    self.username = userName;
    self.isOther = YES;
}
/*
 *用户信息
 */
-(void)getUserInfoData{
    NSString *urlStr;
    if (isEmptyString(self.username)) {
        urlStr =KUserInfo(self.pk);
    }else{
        urlStr = KUserNameInfo(self.username);
    }
    [[JHNetworkManager shareInstance] POST:urlStr  dict:nil succeed:^(id data) {
        JHResultResponseModel *response = [[JHResultResponseModel alloc] initWithObject:data];
        if ([response.status isEqualToString:@"ok"]) {
            JHUserInfoModel *userInfoModel = [[JHUserInfoModel alloc] initWithObject:response.user];
            self.pk = userInfoModel.pkStr;
            [self setContentWithUserModel:userInfoModel];
          
        }else{
            [self showAlertViewWithText:response.status afterDelay:1];
        }
    } failure:^(NSError *error) {
        [self showAlertNetworkError];
    }];
}
/*
 *用户的好友关系
 */
-(void)getShowFriend{
    [[JHNetworkManager shareInstance] POST:KUserShow(self.pk) dict:nil succeed:^(id data) {
        JHCheckResponseModel *response = [[JHCheckResponseModel alloc] initWithObject:data];
        if ([response.status isEqualToString:@"ok"]) {
            if (self.frameVC == 1) {
                [self.otherHeaderView setContentWithFollow:response.following];
            }else{
                [self.headerView setContentWithFollow:response.following];
            }
        }
    } failure:^(NSError *error) {
    }];
}

/*
 获取用户故事列表
 */
-(void)getUserStoryData{
    [[JHNetworkManager shareInstance] POST:KUserStory(self.pk)  dict:nil succeed:^(id data) {
        JHResultResponseModel *response = [[JHResultResponseModel alloc] initWithObject:data];
        if ([response.status isEqualToString:@"ok"]) {
            NSArray *item = [response.reel valueForKey:@"items"];
            NSArray *arry = [self getUserMediaDataList:item];
            [self.tagList addObjectsFromArray:arry];
            [self setContentWithTagList:self.tagList];
        }else{
            [self showAlertViewWithText:response.status afterDelay:1];
        }
    } failure:^(NSError *error) {
    }];
}
/*
 *获取帖子
 */
- (void)getNoteMaxId:(NSString * _Nullable)maxid{
    JHUserRequestModel *request = [[JHUserRequestModel alloc] init];
    request.rank_token = KRank_token;
    request.max_id = maxid;
    request.ranked_content = @"true";
    NSString *urlStr = [KFeeduser(self.pk) stringByAppendingString:[request description]];
    [[JHNetworkManager shareInstance] POST:urlStr dict:nil succeed:^(id data) {
        JHResultResponseModel *response = [[JHResultResponseModel alloc] initWithObject:data];
        if ([response.status isEqualToString:@"ok"]) {
            JHResultResponseModel *response = [[JHResultResponseModel alloc] initWithObject:data];
            if ([response.status isEqualToString:@"ok"]) {
                self.next_max_id = response.next_max_id;
                NSArray *arry = [self getUserMediaDataList:response.users];
                [self.dataList addObjectsFromArray:arry];
                [self setContentWithDataList:self.dataList];
                [self.noteView setContentWithDataList:self.dataList withMore:nil];
                self.headerView.medias = arry;
            }
            if (response.more_available) {
                self.scrollView.mj_footer.hidden = NO;
            }else{
                self.scrollView.mj_footer.hidden = YES;
            }
        }
        [self.scrollView.mj_header endRefreshing];
        [self.scrollView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [self.scrollView.mj_header endRefreshing];
        [self.scrollView.mj_footer endRefreshing];

    }];
}
-(void)setContentWithUserModel:(JHUserInfoModel *)model{
    [self getUserStoryData];
    [self getNoteMaxId:nil];
    if (self.isOther) {
        [self getShowFriend];
        self.navigationItem.title = model.username;
    }
    if (self.frameVC == 1) {
        [self.otherHeaderView setContentWithUserInfo:model];
    }else{
        [self.headerView setContentWithUserInfo:model];
        CGFloat height = [model.biography calcTextSizeWith:[UIFont systemFontOfSize:13] totalSize:CGSizeMake(kScreenWidth-M_RATIO_SIZE(30), CGFLOAT_MAX)];
        [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
            if (isEmptyString(model.external_url)) {
                make.height.equalTo(@(M_RATIO_SIZE(102)+height));
            }else{
                make.height.equalTo(@(M_RATIO_SIZE(102)+15+height));
            }
        }];
    }
   
}
-(void)setContentWithDataList:(NSMutableArray *)dataList{
    float list =dataList.count;
    float a =(list/3);
    CGFloat ceilA = ceilf(a);
    [self.noteView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(M_RATIO_SIZE(126)*ceilA));
    }];
}
-(void)setContentWithTagList:(NSMutableArray *)list{
    if (list.count ==0) {
        [self.tagView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [self.noteView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tagView.mas_bottom).offset(M_RATIO_SIZE(10));
        }];
        self.tagView.hidden = YES;
    }else{
        [self.tagView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(K_RATIO_SIZE(54));
        }];
        [self.noteView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tagView.mas_bottom).offset(M_RATIO_SIZE(20));
        }];
        self.tagView.hidden = NO;
    }
    [self.tagView setContentWithGenealList:[list copy]];
}
#pragma mark - IBAction
-(void)rightItemOnClicked{
    JHSetViewController *set = [self.storyboard instantiateViewControllerWithIdentifier:@"JHSetViewController"];
    set.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:set animated:YES];
}
-(void)tabBarClickNotification:(NSNotification *)ano{
    NSInteger selectIndex = [[ano.userInfo valueForKey:@"selectedIndex"] integerValue];
    if (selectIndex == 4) {
        [self.scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }
}
#pragma mark -- ui
-(void)initContentView{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    if (self.frameVC == 1) {
        [self.contentView addSubview:self.otherHeaderView];
    }else{
        [self.contentView addSubview:self.headerView];
    }
    [self.contentView addSubview:self.tagView];
    [self.contentView addSubview:self.noteView];

    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
   
    if (self.frameVC == 1) {
        [self.otherHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self.contentView);
            make.height.equalTo(K_RATIO_SIZE(180));
        }];
    }else{
        [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self.contentView);
        }];
    }
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.frameVC == 1) {
            make.top.equalTo(self.otherHeaderView.mas_bottom);
        }else{
            make.top.equalTo(self.headerView.mas_bottom).offset(M_RATIO_SIZE(20));
        }
        make.leading.trailing.equalTo(self.contentView);
    }];
    [self.noteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.tagView.mas_bottom).offset(M_RATIO_SIZE(20));
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.noteView.mas_bottom).offset(M_RATIO_SIZE(10));
    }];
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadDataList)];
    self.scrollView.mj_footer = footer;
    self.scrollView.mj_header = [JHRefreshHeader headerWithRefreshingBlock:^{
        [self headerData];
    }];
    self.scrollView.mj_footer.hidden = YES;
}
-(void)headerData{
    [self getUserInfoData];
    self.dataList = nil;
}
-(void)loadDataList{
    [self getNoteMaxId:self.next_max_id];
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
    }
    return _scrollView;
}

-(JHGenealHeaderView *)headerView{
    if (_headerView == nil) {
        _headerView = [[JHGenealHeaderView alloc] init];
    }
    return _headerView;
}
-(JHTagContainerView *)tagView{
    if (_tagView == nil) {
        _tagView = [[JHTagContainerView alloc] init];
    }
    return _tagView;
}
-(JHNoteListContainerView *)noteView{
    if (_noteView == nil) {
        _noteView = [[JHNoteListContainerView alloc] init];
        _noteView.collectionView.bounces = NO;
        _noteView.collectionView.scrollEnabled = NO;
    }
    return _noteView;
}
-(NSMutableArray *)dataList{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}
-(NSMutableArray *)tagList{
    if (_tagList == nil) {
        _tagList = [NSMutableArray array];
    }
    return _tagList;
}
-(JHGenealOtherHeader *)otherHeaderView{
    if (_otherHeaderView == nil) {
        _otherHeaderView = [[JHGenealOtherHeader alloc] init];
    }
    return _otherHeaderView;
}
@end
