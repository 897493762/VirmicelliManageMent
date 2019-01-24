//
//  JHCheckResponseModel.m
//  RumHeadLine
//
//  Created by Wuxiaolian on 17/4/7.
//  Copyright © 2017年 Wu. All rights reserved.
//

#import "JHCheckResponseModel.h"
@implementation JHCheckResponseModel
-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"friendship_status"]) {
        self.friendStatus = [[JHStatus alloc] initWithObject:value];
    }else{
        [super setValue:value forKey:key];
    }
}
@end

@implementation JHStatus
@end
