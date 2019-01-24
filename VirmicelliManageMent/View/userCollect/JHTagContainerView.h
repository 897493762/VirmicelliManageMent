//
//  JHTagContainerView.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/12.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JHTagContainerView;
@protocol JHTagContainerDelegate <NSObject>
- (void)basicTag:(JHTagContainerView *)tagView didSelectedAtIndex:(NSInteger )index withTitle:(NSString *)title;
@end
@protocol JHLikeTagDelegate <NSObject>
- (void)likeTag:(JHTagContainerView *)tagView didSelectedAtIndex:(NSInteger )index withTitle:(NSString *)title;
@end
@protocol JHSearchTagDelegate <NSObject>
- (void)searchTag:(JHTagContainerView *)tagView didSelectedAtIndex:(NSInteger )index withTitle:(NSString *)title;
@end
@interface JHTagContainerView : UIView
@property(nonatomic, weak)id<JHTagContainerDelegate>delegate;
@property (nonatomic, assign) NSInteger selectedIndex;
@property(nonatomic, weak)id<JHLikeTagDelegate>likeDelegate;
@property(nonatomic, weak)id<JHSearchTagDelegate>searchDelegate;

/*
 *更新数据
 */
-(void)setContentWithInsModelList:(NSArray *)dataList;
-(void)setContentWithDataList:(NSArray *)dataList;
-(void)setContentWithTagList:(NSArray *)dataList;
-(void)setContentWithBsicList:(NSArray *)dataList;
-(void)setContentWithGenealList:(NSArray *)dataList;

@end
