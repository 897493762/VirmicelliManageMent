//
//  JHGuideViewController.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/14.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHGuideViewController.h"
#import "JHGuideView.h"
@interface JHGuideViewController ()<UIScrollViewDelegate>
/* 内容列表 */
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *contentView;
@property (nonatomic, strong) UIView *CircleView;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *pageList;

@end

@implementation JHGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger index =scrollView.contentOffset.x/kScreenWidth;
    [self updateTitleView:index];
}

-(void)updateTitleView:(NSInteger)tag{
    if (self.currentPage != tag) {
        self.currentPage = tag;
        for (UIView *view in self.pageList) {
            if (view.tag == self.currentPage) {
                view.backgroundColor = [UIColor colorWithHexString:@"#FC6A2A"];
            }else{
                view.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
            }
        }
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}
#pragma mark - ui
-(void)loadSubViews{
    [self.view addSubview:self.CircleView];
    [self.CircleView addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self setUpSubViews];
}
-(void)setUpSubViews{
    [self.CircleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
 
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.CircleView);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
    __weak typeof(self) weakself = self;
    int total = 4;
    if (self.isPush) {
        total=1;
    }else{
        [self initPageView];
    }
    for (int i=0; i<total; i++) {
        JHGuideView *view = [JHGuideView initView];
        view.index = i;
        view.isPush = self.isPush;
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.width.equalTo(@(kScreenWidth));
            make.leading.equalTo(@(kScreenWidth*i));
        }];
        if (i==total-1) {
            [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(view.mas_trailing);
            }];
        }
        view.block = ^(NSInteger nextIndex) {
            [weakself.scrollView setContentOffset:CGPointMake(kScreenWidth*nextIndex, 0) animated:YES];
        };
    }
}
-(void)initPageView{
    [self.CircleView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(K_RATIO_SIZE(153));
        make.trailing.equalTo(K_RATIO_SIZE(-152));
        make.bottom.equalTo(K_RATIO_SIZE(-93));
        make.height.equalTo(K_RATIO_SIZE(10));
    }];
    self.pageList = [NSMutableArray array];
    for (int i=0; i<4; i++) {
        UIView *view = [[UIView alloc] init];
        view.tag = i;
        if (i == 0) {
            view.backgroundColor = [UIColor colorWithHexString:@"#FC6A2A"];
        }else{
            view.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
        }
        [self.lineView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@(M_RATIO_SIZE(20)*i));
            make.width.height.equalTo(K_RATIO_SIZE(10));
            make.centerY.equalTo(self.lineView);
        }];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = M_RATIO_SIZE(5);
        [self.pageList addObject:view];
    }
}

#pragma mark - Custom Acessors
-(UIView *)CircleView{
    if (_CircleView == nil) {
        _CircleView = [[UIView alloc] init];
    }
    return _CircleView;
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.scrollEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}
-(UIView *)lineView{
    if (_lineView == nil){
        _lineView = [[UIView alloc] init];
    }
    return _lineView;
}
@end
