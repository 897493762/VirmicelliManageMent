//
//  JHCommentModel.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/3.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHCommentModel.h"

@implementation JHCommentModel
-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"user"]) {
        self.user = [[JHUserModel alloc] initWithObject:value];
    }else{
        [super setValue:value forKey:key];
    }
}
-(NSMutableAttributedString *)contentAttribute{
    if (_contentAttribute == nil) {
        NSString *str = [NSString stringWithFormat:@"%@  %@",self.user.username,self.text];
        NSRange range1 = [str rangeOfString:self.user.username];
        NSRange range2 = [str rangeOfString:self.text];

        NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attriStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithR:64 g:68 b:71 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:14]} range:range1];
        [attriStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithR:145 g:145 b:145 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:12]} range:range2];
        _contentAttribute = attriStr;
        
    }
    return _contentAttribute;
}
@end
