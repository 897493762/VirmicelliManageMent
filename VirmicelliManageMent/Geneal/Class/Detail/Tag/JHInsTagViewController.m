//
//  JHInsTagViewController.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2019/1/8.
//  Copyright © 2019年 Satoshi Nakamoto. All rights reserved.
//

#import "JHInsTagViewController.h"
#import "JHSetViewController.h"
#import "JHNoteListContainerView.h"
#import "JHCollectModel.h"

@interface JHInsTagViewController ()
@property (nonatomic, strong) JHNoteListContainerView *containerView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL isLike;

@end

@implementation JHInsTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
    [self showLoding];
    [self downloadData:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_search_collected_default"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemOnClicked)];

    [self updateRightItem];
}
-(void)setContentWithTagName:(NSString *)name{
    self.name = name;
    if ([name containsString:@"\n"]) {
        self.name = [name stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    if ([name containsString:@" "]) {
        self.name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    self.navigationItem.title = self.name;
    self.isLike = [self getFavoriteTag:self.name];
}
-(void)downloadData:(NSString *)next_max_id{
    NSString *url =KFeedtag(self.name);
    if (next_max_id!=nil) {
        url =[KFeedtag(self.name) stringByAppendingString:[NSString stringWithFormat:@"&max_id=%@",next_max_id]];
    }
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  [[JHNetworkManager shareInstance] POST:url dict:nil succeed:^(id data) {
      [self hiddenLoding];
        JHResultResponseModel *response = [[JHResultResponseModel alloc] initWithObject:data];
        if ([response.status isEqualToString:@"ok"]) {
            NSArray *arry = [self getUserMediaDataList:response.users];
            [self.dataList addObjectsFromArray:arry];
            [self.containerView setContentWithDataList:self.dataList withMore:response.next_max_id];
        }else{
            [self showAlertViewWithText:response.status afterDelay:1];
        }
        
    } failure:^(NSError *error) {
        [self hiddenLoding];
        [self showAlertNetworkError];
    }];
}
-(void)initSubViews{
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    __weak typeof(self) weakself = self;
    self.containerView.block = ^(NSInteger status, NSString *next_max_id) {
        if (status == 0) {
            weakself.dataList = nil;
            [weakself downloadData:nil];
        }else{
            [weakself downloadData:next_max_id];
        }
    };
}
#pragma mark - IBAction
-(void)rightItemOnClicked{
    self.isLike = !self.isLike;
    JHCollectModel *model = [[JHCollectModel alloc] init];
    model.tagName = self.name;
    model.medias = [self.dataList copy];
    [self insertOrdeletCollectTags:self.isLike withDatas:model succeed:^(BOOL data) {
        if (self.isLike) {
            [self showAlertViewWithText:@"收藏成功" afterDelay:1];
        }else{
            [self showAlertViewWithText:@"取消收藏成功" afterDelay:1];
        }
        [self updateRightItem];
    }];
}
-(void)updateRightItem{
    if (self.isLike) {
        self.navigationItem.rightBarButtonItem.tintColor =c25510642;
    }else{
        self.navigationItem.rightBarButtonItem.tintColor =[UIColor blackColor];
    }

}
#pragma mark - custom accessors
-(JHNoteListContainerView *)containerView{
    if (_containerView == nil) {
        _containerView = [[JHNoteListContainerView alloc] init];
    }
    return _containerView;
}
-(NSMutableArray *)dataList{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}
@end
