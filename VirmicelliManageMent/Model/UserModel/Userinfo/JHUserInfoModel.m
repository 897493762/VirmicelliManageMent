//
//  JHUserInfoModel.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/5.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHUserInfoModel.h"

@implementation JHUserInfoModel

-(CGFloat)usernameWidth{
    if (_usernameWidth == 0) {
        _usernameWidth = [self.username calcTextSizeWithWidth:[UIFont systemFontOfSize:17] totalSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    }
    return _usernameWidth;
}
-(NSString *)sign{
    if (_sign == nil) {
        _sign = [NSString stringWithFormat:@"%ld%@%@",self.pk,self.username,self.profile_pic_url];
    }
    return _sign;
}
-(NSString *)pkStr{
    if (_pkStr == nil) {
        _pkStr = [NSString stringWithFormat:@"%ld",self.pk];
    }
    return _pkStr;
}
-(NSString *)rank_token{
    if (_rank_token == nil) {
        _rank_token = [NSString stringWithFormat:@"%ld_%@",self.pk,phoneAdId];
    }
    return _rank_token;
}
-(NSString *)descCont{
    if (_descCont == nil) {
        _descCont = [NSString stringWithFormat:@"%@\n%@",self.biography,self.external_url];
    }
    return _descCont;
}
-(NSMutableAttributedString *)descAttribut{
    if (_descAttribut == nil) {
        if (isEmptyString(self.biography)&&isEmptyString(self.external_url)) {
        }else{
            NSMutableAttributedString *attrituteString = [[NSMutableAttributedString alloc] initWithString:self.descCont];
            NSRange range = [self.descCont rangeOfString:self.external_url];
            [attrituteString addAttribute:NSForegroundColorAttributeName
                                       value:c25210642
                                     range:range];//设置颜色
            _descAttribut =  attrituteString;
        }
        
    }
    return _descAttribut;
}
-(BOOL)is_following{
    if (!_is_following) {
        if (self.account_type == 1) {
            _is_following = YES;
        }
    }
    return _is_following;
}

@end
