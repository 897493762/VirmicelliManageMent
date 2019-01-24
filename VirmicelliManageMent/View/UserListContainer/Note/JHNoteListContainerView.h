//
//  JHNoteListContainerView.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/27.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ReturnBlock)(NSInteger status, NSString *next_max_id);

@interface JHNoteListContainerView : UIView
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) ReturnBlock block;
-(void)showHeaderView:(UIView *)headerView headerSize:(CGSize)size;
-(void)setContentWithDataList:(NSArray *)list withMore:(NSString *)next_max_id;
@end
