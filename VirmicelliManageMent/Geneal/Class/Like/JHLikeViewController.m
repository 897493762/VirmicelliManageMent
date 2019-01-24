//
//  JHLikeViewController.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/27.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHLikeViewController.h"
#import "JHTagContainerView.h"
#import "JHNoteListContainerView.h"
#import "JHUserLikerContainerView.h"
@interface JHLikeViewController ()<UIScrollViewDelegate,JHLikeTagDelegate>
@property (nonatomic, strong) JHTagContainerView *tagView;

/* 内容列表 */
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *contentView;
@property (nonatomic, strong) UIView *CircleView;

@property (nonatomic , strong) NSMutableArray *contentArry;
@property (nonatomic, assign) CGFloat tagWidth;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) CGFloat lineX;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSArray *titleArry;
@property (nonatomic , strong) NSMutableArray *likedList;
@property (nonatomic , strong) NSMutableArray *savedList;

@end

@implementation JHLikeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleArry = @[NSLocalizedString(@"2769", nil),NSLocalizedString(@"2770", nil),NSLocalizedString(@"2771", nil),NSLocalizedString(@"2768", nil)];
    self.tagWidth = kScreenWidth/self.titleArry.count;
    [self loadSubViews];
    [self downloadLikedData:nil withType:0];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarClickNotification:) name:kSelectTabBarItemNotification object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = NSLocalizedString(@"2761", nil);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStylePlain target:self action:nil];
}
/*
 获取我点赞的media
 */
- (void)downloadLikedData:(NSString *)next_max_id withType:(int)type{
    NSString *urlStr;
    if (type == 0) {
        urlStr =KfeedLiked;
    }else{
        urlStr = KFeedsaved;
    }
    if (next_max_id !=nil) {
        urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"&max_id=%@",next_max_id]];
    }
    [[JHNetworkManager shareInstance] POST:urlStr dict:nil succeed:^(id data) {
        JHResultResponseModel *response = [[JHResultResponseModel alloc] initWithObject:data];
        if ([response.status isEqualToString:@"ok"]) {
            if (type == 0) {
                NSArray *arry = [self getUserMediaDataList:response.users];
                [self.likedList addObjectsFromArray:arry];
            }else{
                NSArray *arry = [self getFavoriteMediaDataList:response.users];
                [self.savedList addObjectsFromArray:arry];
            }
            if (self.contentArry.count>0) {
                JHNoteListContainerView *view = self.contentArry[type];
                if (type == 0) {
                    [view setContentWithDataList:self.likedList withMore:response.next_max_id];
                }else{
                    [view setContentWithDataList:self.savedList withMore:response.next_max_id];
                }
            }
        }else{
            [self showAlertViewWithText:response.status afterDelay:1];
        }
   
    } failure:^(NSError *error) {
        [self showAlertNetworkError];
    }];
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger index =scrollView.contentOffset.x/kScreenWidth;
    if (self.currentPage != index) {
        self.currentPage = index;
        [self updateTitleView:index];
        self.tagView.selectedIndex =index;
    }
}

-(void)updateTitleView:(NSInteger)tag{
    self.lineX = tag*self.tagWidth;
    [self.view setNeedsUpdateConstraints];
    [self.view needsUpdateConstraints];
    [UIView animateWithDuration:0.15 animations:^{
        [self.view layoutIfNeeded];
    }];
    if (self.currentPage == 1) {
        if (self.savedList.count ==0) {
            [self downloadLikedData:nil withType:1];
        }
    }
}
#pragma mark -- JHSTagContainerDelegate
-(void)likeTag:(JHTagContainerView *)tagView didSelectedAtIndex:(NSInteger)index withTitle:(NSString *)title{
    [self.scrollView setContentOffset:CGPointMake(kScreenWidth*index, 0) animated:YES];
}
-(void)tabBarClickNotification:(NSNotification *)ano{
    NSInteger selectIndex = [[ano.userInfo valueForKey:@"selectedIndex"] integerValue];
    if (selectIndex == 3) {
        JHNoteListContainerView *view = self.contentArry[self.currentPage];
        [view.collectionView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }
}
#pragma mark - ui
-(void)loadSubViews{
    [self.view addSubview:self.tagView];
    [self.tagView addSubview:self.lineView];
    [self.view addSubview:self.CircleView];
    [self.CircleView addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self setUpSubViews];
    [self initCircleSubViews];
    [self.tagView setContentWithTagList:self.titleArry];
}
-(void)setUpSubViews{
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self.view);
        make.height.equalTo(K_RATIO_SIZE(40));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tagView);
        make.width.equalTo(@(self.tagWidth));
        make.height.equalTo(@(M_RATIO_SIZE(1)));
        make.leading.equalTo(@(self.lineX));
    }];
    
    [self.CircleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tagView.mas_bottom);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.CircleView);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
}
-(void)initCircleSubViews{
    for (int i=0; i<2; i++) {
        JHNoteListContainerView *view = [[JHNoteListContainerView alloc]init];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.width.equalTo(@(kScreenWidth));
            make.leading.equalTo(@(kScreenWidth*i));
        }];
        // 避免循环引用
        __weak typeof(self) weakself = self;
        view.block = ^(NSInteger status, NSString *next_max_id) {
            if (status == 0) {
                if (i==0 || i==1) {
                    if (i == 0) {
                        weakself.likedList = nil;
                    }else{
                        weakself.savedList = nil;
                    }
                    [weakself downloadLikedData:nil withType:i];
                }
            }else{
                if (i==0 || i==1) {
                    [weakself downloadLikedData:next_max_id withType:i];
                }
            }
            
        };
        [self.contentArry addObject:view];
    }
    for (int i=2; i<self.titleArry.count; i++) {
        JHUserLikerContainerView *view = [[JHUserLikerContainerView alloc]init];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.width.equalTo(@(kScreenWidth));
            make.leading.equalTo(@(kScreenWidth*i));
        }];
        if (i==self.titleArry.count-1) {
            [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(view.mas_trailing);
            }];
            [view setContentWithDataList:[JHUserInfoModel unarchive].collectTags withTitle:self.titleArry[i]];
        }else{
            [view setContentWithDataList:[JHUserInfoModel unarchive].collectUsers withTitle:self.titleArry[i]];
        }
        
        
    }
}
// 更新移动线条位置
- (void)updateViewConstraints {
    if (self.lineView.superview) {
        [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@(self.lineX));
        }];
    }
    [super updateViewConstraints];
}
#pragma mark - Custom Acessors

-(JHTagContainerView *)tagView{
    if (_tagView == nil) {
        _tagView = [[JHTagContainerView alloc] init];
        _tagView.likeDelegate = self;
    }
    return _tagView;
}
-(UIView *)lineView{
    if (_lineView == nil){
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor =c25510642;
    }
    return _lineView;
}
-(UIView *)CircleView{
    if (_CircleView == nil) {
        _CircleView = [[UIView alloc] init];
    }
    return _CircleView;
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
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
-(NSMutableArray *)contentArry{
    if (_contentArry == nil) {
        _contentArry = [NSMutableArray array];
    }
    return _contentArry;
}
-(NSMutableArray *)likedList{
    if (_likedList == nil) {
        _likedList = [NSMutableArray array];
    }
    return _likedList;
}
-(NSMutableArray *)savedList{
    if (_savedList == nil) {
        _savedList = [NSMutableArray array];
    }
    return _savedList;
}
@end
