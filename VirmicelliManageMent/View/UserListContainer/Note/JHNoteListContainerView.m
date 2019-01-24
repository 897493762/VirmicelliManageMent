//
//  JHNoteListContainerView.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/27.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHNoteListContainerView.h"
#import "JHImageCollectionViewCell.h"
#import "JHMediaViewController.h"
#import "JHMediaViewController.h"
@interface JHNoteListContainerView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSString *next_max_id;
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, assign) CGSize headerSize;
@property (nonatomic, strong) UIView *headerView;

@end
@implementation JHNoteListContainerView
-(void)awakeFromNib{
    [super awakeFromNib];
    [self loadSubViews];
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self loadSubViews];
    }
    return self;
}
-(void)setContentWithDataList:(NSArray *)list withMore:(NSString *)next_max_id{
    if (self.dataList == list) {
        return;
    }
    self.dataList = [list copy];
    self.next_max_id = next_max_id;
    [self.collectionView reloadData];
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    if (isEmptyString(self.next_max_id)) {
        self.collectionView.mj_footer.hidden = YES;
    }else{
        self.collectionView.mj_footer.hidden = NO;
    }
}
-(void)showHeaderView:(UIView *)headerView headerSize:(CGSize)size{
    self.headerSize = size;
    self.headerView = headerView;
    [self.collectionView reloadData];
}
#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JHImageCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"JHImageCollectionViewCell" forIndexPath:indexPath];
    [cell setContentWithArticleModel:self.dataList[indexPath.row]];
    return cell;
}
//cell 大小

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.itemWidth,self.itemHeight);
}

//边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return M_RATIO_SIZE(3);
    
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return M_RATIO_SIZE(3);
    
}

//header的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return self.headerSize;
}
//通过设置SupplementaryViewOfKind 来设置头部或者底部的view，其中 ReuseIdentifier 的值必须和 注册是填写的一致，本例都为 “reusableView”
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    [header addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(header);
    }];
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    JHMediaViewController *media = [self.viewcontroller.storyboard instantiateViewControllerWithIdentifier:@"JHMediaViewController"];
    media.hidesBottomBarWhenPushed = YES;
    [media setContentWithArticleModel:self.dataList[indexPath.row]];
    [self.viewcontroller.navigationController pushViewController:media animated:YES];
    
}
-(void)tapAction:(id)tap{
    
}
#pragma mark - ui
-(void)loadSubViews{
    self.itemWidth =(kScreenWidth-M_RATIO_SIZE(7))/3;
    self.itemHeight = self.itemWidth;
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.collectionView registerClass:[JHImageCollectionViewCell class] forCellWithReuseIdentifier:@"JHImageCollectionViewCell"];
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadDataList)];
    self.collectionView.mj_footer = footer;
    self.collectionView.mj_header = [JHRefreshHeader headerWithRefreshingBlock:^{
        [self headerData];
    }];
    self.collectionView.mj_footer.hidden = YES;
}
-(void)headerData{
    if (self.block) {
        self.block(0, self.next_max_id);
    }
}
-(void)loadDataList{
    if (self.block) {
        self.block(1, self.next_max_id);
    }
    
}
#pragma mark - custom accessors

-(UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.scrollEnabled = YES;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView = collectionView;
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];

        _collectionView.layer.masksToBounds = NO;
        _collectionView.layer.cornerRadius = M_RATIO_SIZE(2);
    }
    return _collectionView;
}
-(NSMutableArray *)dataList{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}
@end
