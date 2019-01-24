//
//  JHNotesListViewController.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/21.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHNotesListViewController.h"
#import "JHNoteListCollectionViewCell.h"
#import "JHArticleModel.h"
#import "JHUserinfosModel.h"
#import "JHMediaViewController.h"
@interface JHNotesListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    CGFloat _collectionCellWidth;
}
@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic , strong) NSMutableArray *dataList;

@end

@implementation JHNotesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _collectionCellWidth = (kScreenWidth-M_RATIO_SIZE(21)*2-M_RATIO_SIZE(33))/2;
    [self loadSubViews];
}

-(void)setContentWithAnaTitle:(NSString *)titleStr withTopTitle:(NSString *)topTitle{
    self.navigationItem.title = titleStr;
    [self getAnylysisUserData:titleStr withTopTitle:topTitle succeed:^(id data) {
        self.dataList = data;
        [self initHeaderView:self.dataList.count];
        [self.collectionView reloadData];
    }];
}

#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JHNoteListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHNoteListCollectionViewCell" forIndexPath:indexPath];
    [cell setContentWithNotesModel:self.dataList[indexPath.row] wwithIndex:indexPath.row+1];
    return cell;
}
//cell 大小

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(_collectionCellWidth,M_RATIO_SIZE(192));
}

//边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, M_RATIO_SIZE(21), 0,M_RATIO_SIZE(21));
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    JHArticleModel *model = self.dataList[indexPath.row];
    JHMediaViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"JHMediaViewController"];
    [detail setContentWithArticleModel:model];
    [self.navigationController pushViewController:detail animated:YES];
}
#pragma mark - Event


#pragma mark - ui
-(void)loadSubViews{
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(K_RATIO_SIZE(48));
    }];
}

#pragma mark - Custom Acessors
-(UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = M_RATIO_SIZE(21);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor colorWithR:237 g:239 b:241 alpha:2];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerClass:[JHNoteListCollectionViewCell class] forCellWithReuseIdentifier:@"JHNoteListCollectionViewCell"];
        _collectionView = collectionView;
    }
    return _collectionView;
}

-(NSMutableArray *)dataList{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}
-(void)initHeaderView:(NSInteger)count{
    NSString *countStr = [NSString stringWithFormat:@"%ld",count];
    UIView *view =[[UIView alloc] init];
    UILabel *lableOne = [UILabel labelWithText:self.navigationItem.title Font:15 Color:[UIColor colorWithHexString:@"#424B57"] Alignment:NSTextAlignmentLeft];
    UILabel *lableTwo = [UILabel labelWithText:countStr Font:15 Color:[UIColor colorWithHexString:@"#FB692A"] Alignment:NSTextAlignmentRight];
    [view addSubview:lableOne];
    [view addSubview:lableTwo];
    [lableOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(K_RATIO_SIZE(9));
        make.centerY.equalTo(view);
    }];
    [lableTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(K_RATIO_SIZE(-30));
        make.centerY.equalTo(view);
    }];
    view.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(K_RATIO_SIZE(48));
    }];
}
@end
