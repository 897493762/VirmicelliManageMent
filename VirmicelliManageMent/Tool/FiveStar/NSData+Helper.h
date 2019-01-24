//
//  NSData+Helper.h
//  XiaMiMusic
//
//  Created by doorxp on 15/6/4.
//  Copyright (c) 2015年 BlueSea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Helper)
- (NSData *)encode;
- (NSData *)decode;
- (NSData *)base64;
- (NSData*)base64Decode;

- (NSData *)gzippedData;
- (NSData *)gunzippedData;

//- (NSData *)gzippedDataForAndroid;
//- (NSData *)gunzippedDataForAndroid;

- (NSData *)encryptWithKey:(NSString *)key;
- (NSData *)decryptWithKey:(NSString *)key;

- (id)jsonObject;

- (NSString *)string;

- (NSData *)preData;
@end
