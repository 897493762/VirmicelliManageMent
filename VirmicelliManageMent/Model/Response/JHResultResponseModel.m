//
//  JHResultResponseModel.m
//  Ganjiuhui
//
//  Created by Wuxiaolian on 17/3/20.
//  Copyright © 2017年 Wuxiaolian. All rights reserved.
//

#import "JHResultResponseModel.h"

@implementation JHResultResponseModel
-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"items"] || [key isEqualToString:@"comments"]|| [key isEqualToString:@"ranked_items"]) {
        self.users = value;
    }else if ([key isEqualToString:@"checkpoint"]){
        NSDictionary *dic = value;
        self.checkpoint_url = [dic objectForKey:@"url"];
    }else if ([key isEqualToString:@"big_list"]){
        self.more_available = [value integerValue];
    }else if ([key isEqualToString:@"story_ranking_token"]){
        self.next_max_id = value;
    }else if ([key isEqualToString:@"next_max_id"]){
        self.next_max_id = [NSString stringWithFormat:@"%@",value];
    }
    else{
        [super setValue:value forKey:key];
    }
}
@end
