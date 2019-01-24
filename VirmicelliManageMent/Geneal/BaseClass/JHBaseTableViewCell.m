//
//  JHBaseTableViewCell.m
//  RumHeadLine
//
//  Created by Wuxiaolian on 2018/3/2.
//  Copyright © 2018年 Wu. All rights reserved.
//

#import "JHBaseTableViewCell.h"

@implementation JHBaseTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self cellWillLoadSubView];
        [self cellWillLoadAutoLayout];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}
-(void)cellWillLoadSubView{
    
}
-(void)cellWillLoadAutoLayout{
    
}
@end
