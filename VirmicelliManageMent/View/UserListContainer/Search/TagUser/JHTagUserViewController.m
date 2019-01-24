//
//  JHTagUserViewController.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2019/1/3.
//  Copyright © 2019年 Satoshi Nakamoto. All rights reserved.
//

#import "JHTagUserViewController.h"
#import "JHNoteListContainerView.h"
@interface JHTagUserViewController ()
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) JHNoteListContainerView *containerView;
@end

@implementation JHTagUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_search_collected_default"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemOnclicked)];
    self.navigationItem.rightBarButtonItem.tintColor = c25510642;
}
-(void)downloadDataList:(NSString *)next_max_id{
    NSString *urlStr = KSearchTagDetail(self.titleStr);
    if (next_max_id) {
        urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"&max_id=%@",next_max_id]];
    }
//    [self showLoding];
    [[JHNetworkManager shareInstance] POST:urlStr dict:nil succeed:^(id data) {
//        [self hiddenLoding];
        JHResultResponseModel *response = [[JHResultResponseModel alloc] initWithObject:data];
        if ([response.status isEqualToString:@"ok"]) {
            NSArray *arry = [self getUserMediaDataList:response.users];
            [self.dataList addObjectsFromArray:arry];
            [self.containerView setContentWithDataList:self.dataList withMore:response.next_max_id];
        }else{
            [self showAlertViewWithText:response.status afterDelay:1];
        }
        
    } failure:^(NSError *error) {
//        [self hiddenLoding];
        [self showAlertNetworkError];
    }];
}
-(void)setContentWithNameText:(NSString *)text{
    self.titleStr = text;
    self.navigationItem.title = [NSString stringWithFormat:@"#%@",text];
    [self downloadDataList:nil];
}
#pragma mark - IBAction
-(void)rightItemOnclicked{
    
}
-(void)loadSubViews{
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    // 避免循环引用
    __weak typeof(self) weakself = self;
    self.containerView.block = ^(NSInteger status, NSString *next_max_id) {
        if (status == 0) {
            weakself.dataList = nil;
            [weakself downloadDataList:nil];
        }else{
            [weakself downloadDataList:next_max_id];
        }
        
    };
}
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
