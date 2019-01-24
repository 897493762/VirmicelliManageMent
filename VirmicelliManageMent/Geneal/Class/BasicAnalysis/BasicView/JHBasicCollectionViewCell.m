//
//  JHBasicCollectionViewCell.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/5.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHBasicCollectionViewCell.h"
#import "UIImage+GIF.h"
@implementation JHBasicCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadSubViews];
    }
    return self;
}
-(void)setContentWithTestModel:(JHTestModel *)model{
    if (self.model == model) {
        return;
    }
    self.model = model;
    self.lableOne.text = self.model.title;
    [self hiddenLoding];
    if ([self.model.title isEqualToString:NSLocalizedString(@"2008", nil)]) {
        self.lableTwo.text = @"";
    }else{
        [self showGifToView:self.lableTwo];
    }
}

-(void)setContentIsRefreshing:(BOOL)isRefreshing withCount:(NSInteger)count{
    NSString *countStr = [NSString stringWithFormat:@"%ld",count];
    [self hiddenLoding];
    if (isRefreshing) {
        if ([self.model.title isEqualToString:NSLocalizedString(@"2004", nil)] || [self.model.title isEqualToString:NSLocalizedString(@"2005", nil)]) {
            int count = [countStr intValue];
            if (count >99) {
                self.lableTwo.text =@"99+";
            }else{
                self.lableTwo.text = countStr;
            }
        }else{
            self.lableTwo.text = countStr;
        }
    }else{
        [self showGifToView:self.lableTwo];
        self.lableTwo.text = @"";
    }
}


#pragma mark - UI
-(void)loadSubViews{
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.signIcon];
    [self.containerView addSubview:self.lableOne];
    [self.containerView addSubview:self.lableTwo];

    [self setUpSubViews];
}
-(void)setUpSubViews{
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.signIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.centerY.equalTo(self.containerView);
        make.width.equalTo(K_RATIO_SIZE(3));
        make.height.equalTo(K_RATIO_SIZE(35));
    }];
    [self.lableOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(M_RATIO_SIZE(13)));
        make.leading.equalTo(K_RATIO_SIZE(10));
    }];
    [self.lableTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.bottom.equalTo(K_RATIO_SIZE(-10));
    }];

}
#pragma mark - Custom Accessors
-(UIView *)containerView{
    if (_containerView == nil) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.masksToBounds = YES;
        _containerView.layer.cornerRadius = M_RATIO_SIZE(5);
    }
    return _containerView;
}
-(UIImageView *)signIcon{
    if (_signIcon == nil) {
        _signIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_index_analysis_left"]];
    }
    return _signIcon;
}
-(UILabel *)lableOne{
    if (_lableOne == nil) {
        _lableOne = [UILabel createLableTextColor:[UIColor colorWithR:66 g:75 b:87 alpha:1] font:11 numberOfLines:0];
    }
    return _lableOne;
}
-(UILabel *)lableTwo{
    if (_lableTwo == nil) {
        _lableTwo = [UILabel createLableTextColor:c25510642 font:18 numberOfLines:1];
        _lableTwo.text = @"フォローバックされていない";
        _lableTwo.adjustsFontSizeToFitWidth = YES;
        _lableTwo.textAlignment = NSTextAlignmentRight;

    }
    return _lableTwo;
}

@end
