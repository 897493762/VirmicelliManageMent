//
//  JHBaseModel.m
//  Ganjiuhui
//
//  Created by 罗毅 on 16/5/20.
//  Copyright © 2016年 blueteam. All rights reserved.
//

#import "JHBaseModel.h"
#import <objc/runtime.h>

#define kArchivePath [NSString stringWithFormat:@"%@/%@", kDocumentsPath, [self class]]

@implementation JHBaseModel

- (instancetype)initWithObject:(id)object {
    self = [super init];
    if (self) {
        
        if ([object isKindOfClass:[NSDictionary class]]) {
            [self setValuesForKeysWithDictionary:object];
        }
        
        if ([object isKindOfClass:[NSData class]]) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:object options:NSJSONReadingMutableContainers error:nil];
            [self setValuesForKeysWithDictionary:dictionary];
        }
        
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (void)setNilValueForKey:(NSString *)key{
    [self setValue:@"" forKey:key];
}
#pragma mark - Public

- (void)archive {
    [NSKeyedArchiver archiveRootObject:self toFile:kArchivePath];
}

+ (instancetype)unarchive {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:kArchivePath];
}

+ (BOOL)removeArchive {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:kArchivePath]) {
        
        return [fileManager removeItemAtPath:kArchivePath error:nil];
    }
    
    return NO;
}

/**
 *  返回当前对象的属性列表
 */
- (NSArray *)propertyList {
    
    unsigned int propertyCount;
    objc_property_t *propertyList = class_copyPropertyList([self class], &propertyCount);
    
    NSMutableArray *propertyNames = [NSMutableArray array];
    
    for (int i=0; i<propertyCount; i++) {
        
        objc_property_t property = propertyList[i];
        
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        [propertyNames addObject:name];
    }
    return propertyNames;
}



#pragma mark - NSCoding

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        for (NSString *name in [self propertyList]) {
            id value = [aDecoder decodeObjectForKey:name];
            [self setValue:value forKey:name];
        }
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    for (NSString *name in [self propertyList]) {
        [aCoder encodeObject:[self valueForKey:name] forKey:name];
    }
}


#pragma mark - Description

- (NSString *)description {
    
    /**
     NSMutableString *string = [NSMutableString string];
     
     for (NSString *name in [self propertyList]) {
     [string appendString:[NSString stringWithFormat:@"%@: %@ \n", name, [self valueForKey:name]]];
     }
     return string;
     
     */
    
    NSMutableString *string = [NSMutableString stringWithString:@"?"];
    
    for (NSString *name in [self propertyList]) {
        
        id value = [self valueForKey:name];
        
        if (value == nil) {
            continue;
        }
        
        NSString *aName = [name isEqualToString:@"idstr"] ?  @"id": name;
        [string appendString:[NSString stringWithFormat:@"%@=%@&", aName, value]];
    }
    
    [string deleteCharactersInRange:NSMakeRange(0, 1)];
    [string deleteCharactersInRange:NSMakeRange(string.length-1, 1)];
    
    return string;
}


@end
