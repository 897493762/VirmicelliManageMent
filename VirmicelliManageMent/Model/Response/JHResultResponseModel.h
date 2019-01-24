//
//  JHResultResponseModel.h
//  Ganjiuhui
//
//  Created by Wuxiaolian on 17/3/20.
//  Copyright © 2017年 Wuxiaolian. All rights reserved.
//

#import "JHBaseResponseModel.h"

@interface JHResultResponseModel : JHBaseResponseModel
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *logged_in_user;
@property (nonatomic, copy) NSDictionary *user;
@property (nonatomic, strong) NSArray *blocked_list;
//@property (nonatomic, strong) NSArray *items;
//@property (nonatomic, strong) NSArray *ranked_items;
@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) NSArray *tray;
@property (nonatomic, strong) NSArray *feed_items;
@property (nonatomic, strong) NSArray *results;
@property (nonatomic, strong) NSDictionary *reel;

@property (nonatomic, assign) BOOL more_available;

@property (nonatomic, copy) NSString *next_max_id;
@property (nonatomic, copy) NSString *checkpoint_url;

@end
