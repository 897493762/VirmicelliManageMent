//
//  JHPurchase.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/10/25.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHPurchase.h"
#import "RMStore.h"
#import "JHPurseProductModel.h"
#ifdef DEBUG
// 开发环境
static BOOL const isDEBUG = TRUE ;
#else
// 生产环境
static BOOL const isDEBUG  = FALSE;
#endif

static JHPurchase *_instance;
@implementation JHPurchase
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_instance) {
            _instance = [[JHPurchase alloc] init];
        }
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_instance) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}

- (id)copy {
    return _instance;
}
/**
 *  内购
 *  type:1(恢复购买) 2（购买）
 */
- (void)clickPhures:(int)type succeed:(void (^)(BOOL data))succeed{
    if (type == 1) {
        [self restoreProductsucceed:^(BOOL data) {
            succeed(data);
        }];
        if ([FiveStarUtil fiveStarEnabled]) {
            [MobClick event:@"returnPurchase"];
        }
    }else{
        NSArray *productIds = @[[MXGoogleManager shareInstance].productID];
        [self requestProductData:productIds succeed:^(BOOL data) {
            if (data) {
                BOOL isRequest = [RMStore canMakePayments];
                if (isRequest) {
                    for (NSString *product in productIds) {
                        [self buyProduct:product succeed:^(BOOL data) {
                            succeed(data);
                        }];
                    }
                }else{
                    succeed(NO);
                }
                
            }else{
                succeed(NO);
            }
        }];
        if ([FiveStarUtil fiveStarEnabled]) {
            [MobClick event:@"purchase"];
        }
    }
    if ([FiveStarUtil fiveStarEnabled]) {
        [MobClick event:@"buy_00"];
    }

}

-(void)repursesucceed:(void (^)(BOOL))succeed{
    [[RMStore defaultStore] restoreTransactionsOnSuccess:^(NSArray *transactions) {
        NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
        NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
        if(!receiptData){//似乎只买过non-renewable subscription类型的物品时，receipt可能为nil
            [[RMStore defaultStore] refreshReceiptOnSuccess:^(){
                NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
                NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
                [self verifyFromApple:receiptData success:^{
                    succeed(YES);
                }failure:^{
                    succeed(NO);
                }];
            } failure:^(NSError *error){
                succeed(NO);
            }];
        }else{
            [self verifyFromApple:receiptData success:^{
                succeed(YES);
            } failure:^{
                succeed(NO);
            }];
        }
        succeed(YES);
    } failure:^(NSError *error) {
    }];
}
//请求商品
- (void)requestProductData:(NSArray *)type succeed:(void (^)(BOOL data))succeed{
    NSLog(@"-------------请求对应的产品信息----------------");
    [[RMStore defaultStore] requestProducts:[NSSet setWithArray:type] success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
        if([products count] == 0){
            NSLog(@"--------------没有商品------------------");
        }
        succeed(YES);
    } failure:^(NSError *error) {
        NSLog(@"--------------请求商品失败-----------------%@-",error);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Products Request Failed", @"")
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                                  otherButtonTitles:nil];
        [alertView show];
        succeed(NO);
    }];
}
//购买商品
-(void)buyProduct:(NSString *)product succeed:(void (^)(BOOL data))succeed{
    [[RMStore defaultStore] addPayment:product success:^(SKPaymentTransaction *transaction) {
        NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
        NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
        [self verifyFromApple:receiptData success:^{
            succeed(YES);

        }failure:^{
            succeed(YES);

        }];
        
    } failure:^(SKPaymentTransaction *transaction, NSError *error) {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Payment Transaction Failed", @"")
                                                           message:error.localizedDescription
                                                          delegate:nil
                                                 cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                                 otherButtonTitles:nil];
        [alerView show];
        succeed(NO);
        
    }];
}
-(void)verifyFromApple:(NSData *_Nullable)invoiceData success:(void (^ _Nullable)(void))success failure:(void (^ _Nullable)(void))failure
{
    if(!invoiceData){
        if(failure){
            failure();
        }
        return;
    }
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *urlString;
    if (isDEBUG){
        urlString = [NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
    }else{
        urlString =  [NSURL URLWithString:@"https://buy.itunes.apple.com/verifyReceipt"];
    }
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    
    NSString *encodeStr = [invoiceData base64EncodedStringWithOptions:0];
    NSDictionary* dataDict = @{@"receipt-data":encodeStr,
                               @"password":IAPKey};
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dataDict options:0 error:nil];
    [request setHTTPBody:requestData];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if(data){
            NSDictionary *dataJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSLog(@"");
            if([dataJSON[@"status"]integerValue]==0){
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSArray* items = dataJSON[@"receipt"][@"in_app"];
                    long long expire_date = 0;
                    long long day = 24*60*60*1000;
                    long long month=30*day;
                    for(NSDictionary* item in items){
                        if([item[@"product_id"] containsString:@".noad"]){
//                            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:adRemoved];
//                            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"hide"];
                        }else{
                            long long t_expire = 0;
                            if([item[@"product_id"] rangeOfString:@".+\\.pay[147]" options:NSRegularExpressionSearch].location != NSNotFound)
                            {
                                t_expire = [item[@"purchase_date_ms"]longLongValue]+month;
                            }else if([item[@"product_id"] rangeOfString:@".+\\.pay[258]" options:NSRegularExpressionSearch].location != NSNotFound)
                            {
                                t_expire = [item[@"purchase_date_ms"]longLongValue]+6*month;
                            }else if([item[@"product_id"] rangeOfString:@".+\\.pay[369]" options:NSRegularExpressionSearch].location != NSNotFound)
                            {
                                t_expire = [item[@"purchase_date_ms"]longLongValue]+12*month;
                            }
                            if([item[@"product_id"] containsString:@"oneyear"]){
                                if([item objectForKey:@"expires_date_ms"]){
                                    t_expire = [item[@"expires_date_ms"] longLongValue];
                                }
                            }
                            if(t_expire>expire_date){
                                expire_date = t_expire;
                            }
                        }
                    }
                    NSDate *expiresDate = [NSString postDataTimeStr:[NSString isEqualToNil:[NSString stringWithFormat:@"%lld", expire_date]]];
                    [self savaProductDate:expiresDate];
                    success();
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure();
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                failure();
            });
        }
        
    }];
    [dataTask resume];
}
//恢复购买
-(void)restoreProductsucceed:(void (^)(BOOL data))succeed{
    [[RMStore defaultStore] restoreTransactionsOnSuccess:^(NSArray *transactions) {
        NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
        NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
        if(!receiptData){//似乎只买过non-renewable subscription类型的物品时，receipt可能为nil
            [[RMStore defaultStore] refreshReceiptOnSuccess:^(){
                NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
                NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
                [self verifyFromApple:receiptData success:^{
                    succeed(YES);
                }failure:^{
                    succeed(NO);
                }];
            } failure:^(NSError *error){
                succeed(NO);
            }];
        }else{
            [self verifyFromApple:receiptData success:^{
                succeed(YES);
            } failure:^{
                succeed(NO);
            }];
        }
    } failure:^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Restore Transactions Failed", @"")
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                                  otherButtonTitles:nil];
        [alertView show];
        succeed(NO);
    }];
}

-(void)savaProductDate:(NSDate *)date{
    JHPurseProductModel *model = [JHPurseProductModel unarchive];
    if (!model) {
        model = [[JHPurseProductModel alloc] init];
    }
    model.transactionDate = date;
    NSDate *now = [NSDate date];
    if ([now compare:date] == NSOrderedAscending) {
        model.isVipState = YES;
    }else{
        model.isVipState = NO;;
    }
    [model archive];
}
@end
