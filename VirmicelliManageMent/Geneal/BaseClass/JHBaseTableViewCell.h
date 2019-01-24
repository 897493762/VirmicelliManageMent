//
//  JHBaseTableViewCell.h
//  RumHeadLine
//
//  Created by Wuxiaolian on 2018/3/2.
//  Copyright © 2018年 Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHBaseTableViewCell : UITableViewCell
/**
 *  cell将要加载子view
 */
- (void)cellWillLoadSubView;

/**
 *  cell将要加载自动布局
 */
- (void)cellWillLoadAutoLayout;
@end
