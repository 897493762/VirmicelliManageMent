//
//  NSData+Helper.m
//  XiaMiMusic
//
//  Created by doorxp on 15/6/4.
//  Copyright (c) 2015年 BlueSea. All rights reserved.
//

#import <zlib.h>
#import <CommonCrypto/CommonCrypto.h>
#import "NSData+Helper.h"
#include "GTMBase64.h"


#define kSecretKey      @"AC9cFrgB"


const NSUInteger ChunkSize = 1024;

@implementation NSData (Helper)

- (NSData *)encode
{
    NSData *retData  = self;
    retData = [retData encryptWithKey:kSecretKey];
    retData = [GTMBase64 encodeData:retData];
    retData = [retData gzippedData];
    retData = [retData encryptWithKey:kSecretKey];
    retData = [GTMBase64 encodeData:retData];
    return retData;
}

- (NSData*)base64
{
    NSData* retData = self;
    retData = [GTMBase64 encodeData:retData];
    return retData;
}

- (NSData*)base64Decode
{
    NSData *retData = self;
    retData = [GTMBase64 decodeData:retData];
    return retData;
}


- (NSData *)decode
{
    NSData *retData = self;
    retData = [GTMBase64 decodeData:retData];
    retData = [retData decryptWithKey:kSecretKey];
    retData = [retData gunzippedData];
    retData = [GTMBase64 decodeData:retData];
    retData = [retData decryptWithKey:kSecretKey];
    return retData;
}

- (NSData *)zip:(int)windowsBits
{
    if (self.length < 1)
    {
        return nil;
    }
    
    z_stream c_stream;
    
    c_stream.zalloc = Z_NULL;
    c_stream.zfree = Z_NULL;
    c_stream.opaque = Z_NULL;
    c_stream.total_out = 0;
    
    
    if(deflateInit2(&c_stream,
                    Z_DEFAULT_COMPRESSION,
                    Z_DEFLATED,
                    windowsBits,
                    8,
                    Z_DEFAULT_STRATEGY) != Z_OK)
    {
        return nil;
    }
    
    c_stream.next_in = (Bytef *)self.bytes;
    c_stream.avail_in = (uInt)(self.length);
    
    NSMutableData *data = [NSMutableData dataWithLength:ChunkSize];
    
    while (c_stream.avail_in != 0)
    {
        if (c_stream.total_out >= [data length])
        {
            [data increaseLengthBy:ChunkSize];
        }
        
        c_stream.next_out = data.mutableBytes + c_stream.total_out;
        c_stream.avail_out = (uInt)(data.length - c_stream.total_out);
        
        int status = deflate(&c_stream, Z_NO_FLUSH);
        
        if (status < 0)
        {
            NSLog(@"deflate out error :%@", @(status));
            break;
        }
        else if (status == Z_STREAM_END)
        {
            break;
        }
    }
    
    for(; ;)
    {
        
        if (c_stream.total_out >= [data length])
        {
            [data increaseLengthBy:ChunkSize];
        }
        
        int status = deflate(&c_stream, Z_FINISH);
        
        c_stream.next_out = data.mutableBytes + c_stream.total_out;
        c_stream.avail_out = (uInt)(data.length - c_stream.total_out);
        
        if(status == Z_STREAM_END)
        {
            break;
        }
    }
    
    deflateEnd(&c_stream);
    
    [data setLength:c_stream.total_out];
    
    return data;
}

- (NSData *)unzip:(int)windowsBits
{
    if(self.length < 1)
    {
        return 0;
    }
    
    Bytef *inData = (Bytef *)self.bytes;
    
    bool done = false;
    int status = 0;
    z_stream d_strm;
    d_strm.next_in = inData;
    d_strm.avail_in = (uInt)self.length;
    d_strm.total_out = 0;
    d_strm.opaque = 0;
    d_strm.zalloc = Z_NULL;
    d_strm.zfree = Z_NULL;
    if(inflateInit2(&d_strm, windowsBits) != Z_OK)
    {
        return nil;
    }
    
    Bytef buffer[ChunkSize];
    NSMutableData *retData = [NSMutableData data];
    
    uLong totalLen = 0;
    while(!done)
    {
        bzero(buffer, ChunkSize);
        
        d_strm.avail_out = ChunkSize;
        d_strm.next_out = buffer;
        status = inflate(&d_strm, Z_NO_FLUSH);
        
        if(status == Z_STREAM_END || d_strm.avail_in == 0)
        {
            done = true;
        }
        else if(status != Z_OK)
        {
            break;
        }
        
        [retData appendBytes:(char *)buffer length:d_strm.total_out - totalLen];
        totalLen = d_strm.total_out;
    }
    
    inflateEnd(&d_strm);
    
    if(done)
    {
        return retData;
    }
    else
    {
        return nil;
    }
}

- (NSData *)gzippedData
{
    
    return [self zip:-MAX_WBITS];
    
}

- (NSData *)gunzippedData
{
    return [self unzip:-MAX_WBITS];
}

- (NSData *)gzippedDataForAndroid
{
    return [self zip:(15+16)];
}

- (NSData *)gunzippedDataForAndroid
{
    return [self unzip:(15+32)];
}

- (NSData *)encrypt:(CCOperation)encryptOperation
                key:(NSString *)key
{
    size_t dataInLength = [self length];
    
    //   CCCryptorStatus ccStatus;
    char *dataOut = NULL;
    size_t dataOutAvailable = 0;
    size_t dataOutMoved = 0;
    
    dataOutAvailable = (dataInLength + (kCCBlockSizeDES-1)) & ~(kCCBlockSizeDES-1);
    dataOut = (char*)malloc(dataOutAvailable);
    memset((void *)dataOut, 0x0, dataOutAvailable);
    
    //控制长度，长度低于规定长度填充
    char vkey[kCCKeySizeDES + 1];
    bzero(vkey, kCCKeySizeDES + 1);
    memcpy(vkey, [key UTF8String],  MIN(key.length, kCCKeySizeDES));
    
    char *srcData = (char*)malloc(dataOutAvailable);
    bzero(srcData, dataOutAvailable);
    memcpy(srcData, self.bytes, MIN(dataOutAvailable, self.length));
    
    //CCCrypt函数 加密/解密
    //ccStatus =
    CCCrypt(encryptOperation,    // 加密/解密
            kCCAlgorithmDES,
            kCCOptionECBMode,
            vkey,                // 密钥
            kCCKeySizeDES,
            nil,                 // 可选的初始矢量
            srcData,              // 数据的存储单元
            dataOutAvailable,        // 数据的大小
            (void *)dataOut,     // 用于返回数据
            dataOutAvailable,
            &dataOutMoved);
    
    NSData *result = nil;
    
    //去掉填充
    while (dataOut[dataOutMoved-1] == '\0' && dataOutMoved>0)
    {
        dataOutMoved --;
    }
    
    result = [NSData dataWithBytes:(const void *)dataOut
                            length:(NSUInteger)dataOutMoved];
    
    free(srcData);
    free(dataOut);
    
    return result;
}

- (NSData *)encryptWithKey:(NSString *)key
{
    return [self encrypt:kCCEncrypt key:key];
}

- (NSData *)decryptWithKey:(NSString *)key
{
    return [self encrypt:kCCDecrypt key:key];
}

- (id)jsonObject
{
    return [NSJSONSerialization JSONObjectWithData:self
                                           options:NSJSONReadingAllowFragments
                                             error:nil];
}

- (NSString *)string
{
    return [[NSString alloc] initWithData:self
                                 encoding:NSUTF8StringEncoding];
}

typedef const char KEY[8];
//AC9cFrgB
KEY $0 ={'A','C','9','c','F','r','g','B'};

KEY *a = &$0;
KEY **b = &a;
KEY ***c = &b;

- (NSData *)preData {
    
    if (self.length < 1)
    {
        return nil;
    }
    
    const char *vkey = ***c;
    char iv[8];
    
    bzero(iv, 8);
    
    NSData *tmp = [GTMBase64 decodeData:self];
    
    if (!tmp && tmp.length < 8) {
        
        return self;
    }
    
    char *p = (char*)tmp.bytes;
    
    memcpy(iv, p, 8);
    
    p+=8;
    
    char *dataOut = NULL;
    size_t dataOutAvailable = 0;
    size_t dataOutMoved = 0;
    
    size_t len = self.length - 8;
    
    dataOutAvailable = (len + (kCCBlockSizeDES-1)) & ~(kCCBlockSizeDES-1);
    dataOut = (char*)malloc(dataOutAvailable);
    memset((void *)dataOut, 0x0, dataOutAvailable);
    
    CCCrypt(kCCDecrypt,    //解密
            kCCAlgorithmDES,
            0,
            vkey,                // 密钥
            kCCKeySizeDES,
            iv,                 // 可选的初始矢量
            p,              // 数据的存储单元
            len,        // 数据的大小
            (void *)dataOut,     // 用于返回数据
            dataOutAvailable,
            &dataOutMoved);
    
    NSData *data = [NSData dataWithBytes:dataOut length:strlen((char*)dataOut)];
    
    free(dataOut);
    dataOut = NULL;
    
    return data;
}

@end
