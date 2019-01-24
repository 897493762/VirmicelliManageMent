//
//  JHHelpViewController.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/10/11.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHHelpViewController.h"

@interface JHHelpViewController ()
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *contentView;

@property (nonatomic, strong)UILabel *lable;

@end

@implementation JHHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWebView];
    self.view.backgroundColor = [UIColor whiteColor];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = NSLocalizedString(@"2018", nil);
}

-(void)loadWebView{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.lable];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    [self.lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(K_RATIO_SIZE(5));
        make.trailing.equalTo(K_RATIO_SIZE(-5));
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.lable.mas_bottom).offset(M_RATIO_SIZE(10));
    }];
}
-(UILabel *)lable{
    if (_lable == nil) {
        _lable = [UILabel labelWithText:NSLocalizedString(@"2047", nil) Font:15 Color:[UIColor blackColor] Alignment:NSTextAlignmentLeft];
        _lable.numberOfLines = 0;
    }
    return _lable;
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
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

@end
