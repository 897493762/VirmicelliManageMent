//
//  JHSSearchDetailViewController.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2019/1/2.
//  Copyright © 2019年 Satoshi Nakamoto. All rights reserved.
//

#import "JHSSearchDetailViewController.h"
#import "CustomTextField.h"
#import "JHTagContainerView.h"
#import "JHHasTagContainerView.h"
@interface JHSSearchDetailViewController ()<UIScrollViewDelegate,UITextFieldDelegate,JHSearchTagDelegate>
@property (nonatomic, strong) UIView *naviView;
@property (nonatomic, strong) CustomTextField *textFiled;
@property (nonatomic, strong) JHTagContainerView *tagView;
/* 内容列表 */
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *contentView;
@property (nonatomic, strong) UIView *CircleView;
@property (nonatomic, strong) JHHasTagContainerView *peopleView;
@property (nonatomic, strong) JHHasTagContainerView *hastagView;

@property (nonatomic, assign) CGFloat tagWidth;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) CGFloat lineX;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSArray *titleArry;
@property (nonatomic, strong) NSMutableArray *searchList;
@property (nonatomic, strong) NSMutableArray *tagList;

@end

@implementation JHSSearchDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleArry = @[NSLocalizedString(@"2767", nil),NSLocalizedString(@"2768", nil)];
    self.tagWidth = kScreenWidth/self.titleArry.count;
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNaviView];
    [self loadSubViews];
    [self.textFiled isFirstResponder];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
/*
 *搜索
 */
-(void)getSerchData:(NSString *)searchText{
    if (isEmptyString(searchText)) {
        return;
    }
    JHUserRequestModel *request = [[JHUserRequestModel alloc] init];
    request.ig_sig_key_version = @"4";
    request.rank_token =KRank_token;
    request.is_typeahead = @"true";
    request.query = searchText;
    NSString *urlStr = [KUsersearch stringByAppendingString:[request description]];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [self showLoding];
    self.searchList = nil;
    [[JHNetworkManager shareInstance] POST:urlStr dict:nil succeed:^(id data) {
        [self hiddenLoding];
        JHResultResponseModel *response = [[JHResultResponseModel alloc] initWithObject:data];
        if ([response.status isEqualToString:@"ok"]) {
            for (NSDictionary *dic in response.users) {
                JHUserModel *user = [[JHUserModel alloc] initWithObject:dic];
                [self.searchList addObject:user];
            }
            [self.peopleView setContentWithDataList:self.searchList withType:0];
        }else{
            [self showAlertViewWithText:response.status afterDelay:1];
        }
    } failure:^(NSError *error) {
        [self hiddenLoding];
        [self showAlertViewWithText:@"网络错误" afterDelay:1];
    }];
}
-(void)getSerchTagData:(NSString *)searchText{
    if (isEmptyString(searchText)) {
        return;
    }
    [self showLoding];
    self.tagList = nil;
    [[JHNetworkManager shareInstance] POST:KSearchTag(searchText) dict:nil succeed:^(id data) {
        [self hiddenLoding];
        JHResultResponseModel *response = [[JHResultResponseModel alloc] initWithObject:data];
        if ([response.status isEqualToString:@"ok"]) {
            for (NSDictionary *dic in response.results) {
                NSString *name = [dic valueForKey:@"name"];
                [self.tagList addObject:name];
            }
            [self.hastagView setContentWithDataList:self.tagList withType:1];
        }else{
            [self showAlertViewWithText:response.status afterDelay:1];
        }
    } failure:^(NSError *error) {
        [self hiddenLoding];
        [self showAlertViewWithText:@"网络错误" afterDelay:1];
    }];
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.textFiled resignFirstResponder];
    NSInteger index =scrollView.contentOffset.x/kScreenWidth;
    if (self.currentPage != index) {
        self.currentPage = index;
        [self updateTitleView:index];
        self.tagView.selectedIndex =index;
    }

}

-(void)updateTitleView:(NSInteger)tag{
    self.currentPage = tag;
    self.lineX = tag*self.tagWidth;
    [self.view setNeedsUpdateConstraints];
    [self.view needsUpdateConstraints];
    [UIView animateWithDuration:0.15 animations:^{
        [self.view layoutIfNeeded];
    }];
    if (self.currentPage == 0) {
        [self getSerchData:self.textFiled.text];
    }else{
        [self getSerchTagData:self.textFiled.text];
    }
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.textFiled resignFirstResponder];
    if (self.currentPage == 0) {
        [self getSerchData:self.textFiled.text];
    }else{
        [self getSerchTagData:self.textFiled.text];
    }
    return YES;
}
#pragma mark - JHSearchTagDelegate
-(void)searchTag:(FPTYXJPYSLGZWLGGXDZJHTagContainerView *)tagView didSelectedAtIndex:(NSInteger)index withTitle:(NSString *)title{
    [self.scrollView setContentOffset:CGPointMake(kScreenWidth*index, 0) animated:YES];

}
#pragma mark - ui
-(void)loadSubViews{
    [self.view addSubview:self.tagView];
    [self.tagView addSubview:self.lineView];
    [self.view addSubview:self.CircleView];
    [self.CircleView addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.peopleView];
    [self.contentView addSubview:self.hastagView];

    [self setUpSubViews];
    [self.tagView setContentWithTagList:self.titleArry];
}
-(void)setUpSubViews{
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_bottom);
        make.leading.trailing.equalTo(self.view);
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
    [self.peopleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.width.equalTo(@(kScreenWidth));
        make.leading.equalTo(@0);
    }];
    [self.hastagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(self.peopleView);
        make.leading.equalTo(@(kScreenWidth));
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.hastagView.mas_trailing);
    }];
    
}
#pragma mark - IBAction
-(void)rightItemClicked{
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - custom accessors
-(void)initNaviView{
    UIView *view = [[UIView alloc] init];
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_search_search_small"]];
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelButton setTitle:NSLocalizedString(@"0001", nil) forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithHexString:@"#A1AAB5"] forState:UIControlStateNormal];
    [self.view addSubview:view];
    [view addSubview:self.textFiled];
    [view addSubview:icon];
    [view addSubview:cancelButton];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(self.statusHeight));
        make.leading.trailing.equalTo(self.view);
        make.height.equalTo(@44);
    }];
    [self.textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.equalTo(view);
        make.trailing.equalTo(K_RATIO_SIZE(-80));
    }];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(K_RATIO_SIZE(10));
        make.centerY.equalTo(view);
        make.width.height.equalTo(K_RATIO_SIZE(20));
    }];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.trailing.height.equalTo(view);
        make.width.equalTo(K_RATIO_SIZE(80));
    }];
    [cancelButton addTarget:self action:@selector(rightItemClicked) forControlEvents:UIControlEventTouchUpInside];
    self.naviView = view;
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
#pragma mark - custom accesssors
-(CustomTextField *)textFiled{
    if (_textFiled == nil) {
        _textFiled = [[CustomTextField alloc] init];
        _textFiled.font = [UIFont systemFontOfSize:16];
        _textFiled.textColor = [UIColor colorWithHexString:@"#424B57"];
        _textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textFiled.DistanceLeft = M_RATIO_SIZE(35);
        _textFiled.placeholder = NSLocalizedString(@"2766", nil);
        _textFiled.returnKeyType = UIReturnKeySearch;
        _textFiled.delegate = self;

    }
    return _textFiled;
}
-(JHTagContainerView *)tagView{
    if (_tagView == nil) {
        _tagView = [[JHTagContainerView alloc] init];
        _tagView.searchDelegate = self;
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
-(JHHasTagContainerView *)peopleView{
    if (_peopleView == nil) {
        _peopleView = [[JHHasTagContainerView alloc] init];
    }
    return _peopleView;
}
-(JHHasTagContainerView *)hastagView{
    if (_hastagView == nil) {
        _hastagView = [[JHHasTagContainerView alloc] init];
    }
    return _hastagView;
}
-(NSMutableArray *)searchList{
    if (_searchList == nil) {
        _searchList = [NSMutableArray array];
    }
    return _searchList;
}
-(NSMutableArray *)tagList{
    if (_tagList == nil) {
        _tagList = [NSMutableArray array];
    }
    return _tagList;
}
@end
