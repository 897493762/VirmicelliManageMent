//
//  JHTagContainerView.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/12.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHTagContainerView.h"
#import "JHTagImageCollectionViewCell.h"
#import "JHTagTitleCollectionViewCell.h"
#import "JHBasicTagCollectionViewCell.h"
#import "JHImageCollectionViewCell.h"
#import "JHMediaViewController.h"
#import "JHGenealViewController.h"
@interface JHTagContainerView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, assign) NSInteger type;
@property (strong, nonatomic) NSTimer *timer;

@end
@implementation JHTagContainerView
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

-(void)setContentWithInsModelList:(NSArray *)dataList{
    if (self.dataList == dataList) {
        return;
    }
    self.dataList = dataList;
    self.itemWidth = M_RATIO_SIZE(54);
    self.itemHeight = M_RATIO_SIZE(82);
    self.type = 0;
    [self.collectionView reloadData];
}
-(void)setContentWithTagList:(NSArray *)dataList{
    if (self.dataList == dataList) {
        return;
    }
    self.dataList = dataList;
    self.itemWidth = kScreenWidth/self.dataList.count;
    self.itemHeight = M_RATIO_SIZE(40);
    self.type = 1;
    [self.collectionView reloadData];
   
}
-(void)setContentWithDataList:(NSArray *)dataList {
    if (self.dataList == dataList) {
        return;
    }
    self.dataList = dataList;
    self.itemWidth = (int)(kScreenWidth-M_RATIO_SIZE(24))/self.dataList.count;
    self.itemHeight = M_RATIO_SIZE(45);
    self.type = 2;
    [self.collectionView reloadData];
    self.containerView.backgroundColor = [UIColor colorWithR:255 g:171 b:195 alpha:1];
    self.collectionView.backgroundColor = [UIColor whiteColor];

}

-(void)setContentWithBsicList:(NSArray *)dataList{
//    if (self.dataList == dataList) {
//        return;
//    }
    self.dataList = dataList;
    self.itemWidth = kScreenWidth/3;
    self.itemHeight = M_RATIO_SIZE(80);
    self.type = 3;
    [self.collectionView reloadData];
    self.collectionView.backgroundColor = c255255255;
    self.containerView.backgroundColor = c255255255;
    self.backgroundColor = c255255255;
    [self addTimer];

}
//添加定时器
- (void)addTimer
{
    [self removeTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
}
- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}
- (void)nextImage
{
    if ((int)self.collectionView.contentOffset.x % (int)self.itemWidth == 0) {
        CGFloat offsetX = self.collectionView.contentOffset.x + self.itemWidth;
        [self.collectionView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }else {
        NSInteger count = round(self.collectionView.contentOffset.x / self.itemWidth);
        [self.collectionView setContentOffset:CGPointMake(count * self.itemWidth, 0) animated:NO];
    }
}
-(void)setContentWithGenealList:(NSArray *)dataList{
    if (self.dataList == dataList) {
        return;
    }
    self.dataList = dataList;
    self.itemWidth = M_RATIO_SIZE(54);
    self.itemHeight = M_RATIO_SIZE(54);
    self.type = 4;
    [self.collectionView reloadData];
    self.collectionView.backgroundColor = c255255255;
    self.containerView.backgroundColor = c255255255;
    self.backgroundColor = c255255255;
}
#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.type == 3) {
        return self.dataList.count*3;
    }else{
        return self.dataList.count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 0) {
        JHTagImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHTagImageCollectionViewCell" forIndexPath:indexPath];
        [cell setContentWithUserModel:self.dataList[indexPath.row]];
        return cell;
    }else if (self.type == 1) {
        JHTagTitleCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"JHTagTitleCollectionViewCell" forIndexPath:indexPath];
        [cell setContentWithTitleStr:self.dataList[indexPath.item]];
        if (self.selectedIndex == indexPath.row) {
            cell.nameLable.textColor = c667587;
        }else{
            cell.nameLable.textColor = c161170181;
        }
        return cell;
    }else if (self.type == 4) {
            JHImageCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"JHImageCollectionViewCell" forIndexPath:indexPath];
            [cell setContentWithGenealArticleModel:self.dataList[indexPath.row]];
            return cell;
        }
    else{
        JHBasicTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHBasicTagCollectionViewCell" forIndexPath:indexPath];
        if (self.type == 3) {
            [cell setContentWithTagModel:self.dataList[indexPath.item % self.dataList.count]];
        }else{
            [cell setContentWithTagModel:self.dataList[indexPath.row]];
        }
        return cell;
    }
}
//cell 大小

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.itemWidth,self.itemHeight);
}

//边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (self.type == 0) {
        return UIEdgeInsetsMake(0, M_RATIO_SIZE(10), 0, M_RATIO_SIZE(10));
    }else{
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (self.type == 0 || self.type == 4) {
        return M_RATIO_SIZE(10);
    }else{
        return 0;
    }
    
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 4) {
        JHMediaViewController *media = [self.viewcontroller.storyboard instantiateViewControllerWithIdentifier:@"JHMediaViewController"];
        [media setContentWithArticleModel:self.dataList[indexPath.row]];
        [self.viewcontroller.navigationController pushViewController:media animated:YES];
    }else if (self.type == 0){
        JHUserModel *model = self.dataList[indexPath.row];
        JHGenealViewController *geneal = [self.viewcontroller.storyboard instantiateViewControllerWithIdentifier:@"JHGenealViewController"];
        [geneal setContentWithPkStr:model.pkStr];
        [self.viewcontroller.navigationController pushViewController:geneal animated:YES];
    }else{
        if (self.selectedIndex != indexPath.row) {
            if ([self.delegate respondsToSelector:@selector(basicTag:didSelectedAtIndex:withTitle:)]) {
                [self.delegate basicTag:self didSelectedAtIndex:indexPath.row withTitle:self.title];
            }
            if ([self.likeDelegate respondsToSelector:@selector(likeTag:didSelectedAtIndex:withTitle:)]) {
                [self.likeDelegate likeTag:self didSelectedAtIndex:indexPath.row withTitle:self.title];
            }
            if ([self.searchDelegate respondsToSelector:@selector(searchTag:didSelectedAtIndex:withTitle:)]) {
                [self.searchDelegate searchTag:self didSelectedAtIndex:indexPath.row withTitle:self.title];
            }
            self.selectedIndex = indexPath.row;
            
        }
    }

    
    
}
// 滚动到中间初始位置
- (void)scrollToCenterOrigin
{
    NSInteger centerOrigin = self.dataList.count;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:centerOrigin inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

// 滚动到中间结束位置
- (void)scrollToCenterEnd
{
    NSInteger centerEnd = self.dataList.count * 2 - 1;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:centerEnd inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.type == 3) {
        CGFloat offsetX = scrollView.contentOffset.x;
        CGFloat width = self.itemWidth;
        if ((int)offsetX % (int)width == 0) {
            NSInteger index = (NSInteger)(offsetX / width);
            NSInteger number = [self.collectionView numberOfItemsInSection:0];
            if (index == 0) {
                [self scrollToCenterOrigin];
            }
            if (index == number - 3) {
                [self scrollToCenterEnd];
            }
        }
    }
   
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.type == 3) {
        [self removeTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.type == 3) {
        [self addTimer];
    }
}

#pragma mark - ui
-(void)loadSubViews{
    [self addSubview:self.containerView];
    
    [self.containerView addSubview:self.collectionView];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
    }];
    [self.collectionView registerClass:[JHTagImageCollectionViewCell class] forCellWithReuseIdentifier:@"JHTagImageCollectionViewCell"];
    [self.collectionView registerClass:[JHTagTitleCollectionViewCell class] forCellWithReuseIdentifier:@"JHTagTitleCollectionViewCell"];
    [self.collectionView registerClass:[JHBasicTagCollectionViewCell class] forCellWithReuseIdentifier:@"JHBasicTagCollectionViewCell"];
    [self.collectionView registerClass:[JHImageCollectionViewCell class] forCellWithReuseIdentifier:@"JHImageCollectionViewCell"];

    self.containerView.backgroundColor = [UIColor colorWithR:247 g:247 b:247 alpha:1];
    self.collectionView.backgroundColor = [UIColor colorWithR:247 g:247 b:247 alpha:1];
}
#pragma mark - accessors
-(UIView *)containerView{
    if (_containerView == nil) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}
-(UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.scrollEnabled = YES;
        collectionView.pagingEnabled = YES;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView = collectionView;
        _collectionView.layer.masksToBounds = NO;
        _collectionView.layer.cornerRadius = M_RATIO_SIZE(2);
    }
    return _collectionView;
}

-(void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    [self.collectionView reloadData];
}
@end
