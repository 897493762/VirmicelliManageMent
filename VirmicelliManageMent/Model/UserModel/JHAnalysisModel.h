//
//  JHAnalysisModel.h
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/13.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHBaseModel.h"

@interface JHAnalysisModel : JHBaseModel
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSArray *types;

@end

@interface JHTypeModel : JHBaseModel
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSArray *notes;
@property (nonatomic, assign)int tag;

@end

@interface JHRowModel : JHBaseModel
@property (nonatomic, strong)NSString *tile;
@property (nonatomic, strong)NSArray *list;
@end
@interface JHNoteModel : JHBaseModel
//@property (nonatomic, strong)NSString *pic_url;
//@property (nonatomic, strong)NSString *pk;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSArray *users;
@property (nonatomic, assign)int type;
@property (nonatomic, assign)BOOL isRefreshing;

@end
