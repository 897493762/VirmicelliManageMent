//
//  CustomTextField.m
//  Ganjiuhui
//
//  Created by Wuxiaolian on 16/9/7.
//  Copyright © 2016年 Wuxiaolian. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

//控制placeHolder的位置，左右缩20
-(CGRect)placeholderRectForBounds:(CGRect)bounds{
    CGRect inset = CGRectMake(bounds.origin.x+self.DistanceLeft, bounds.origin.y, bounds.size.width, bounds.size.height);//更好理解些
    return inset;
}
//控制显示文本的位置
-(CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+self.DistanceLeft, bounds.origin.y, bounds.size.width-self.DistanceLeft-self.ClearRight, bounds.size.height);//更好理解些
    
    return inset;
    
}
//控制编辑文本的位置
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    
    CGRect inset = CGRectMake(bounds.origin.x +self.DistanceLeft, bounds.origin.y, bounds.size.width-self.DistanceLeft-self.ClearRight -20, bounds.size.height);
    return inset;
}

- (CGRect)clearButtonRectForBounds:(CGRect)bounds{

    CGRect rect = [super clearButtonRectForBounds:bounds];
    
    return CGRectOffset(rect, -self.ClearRight, 0);

}
-(void)setDistanceLeft:(CGFloat)DistanceLeft{
    _DistanceLeft = DistanceLeft;
}

-(void)setClearRight:(CGFloat)ClearRight{
    _ClearRight = ClearRight;
}
@end
