//
//  CrashReporting.m
//  ZZAD
//
//  Created by doorxp on 2017/3/27.
//  Copyright © 2017年 zxaa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <Firebase.h>
#import <Crashlytics/Crashlytics.h>

#ifdef DEBUG
void MyLog(NSString *format, ...) {
    
    NSProcessInfo *pinfo = [NSProcessInfo processInfo];
    
    if (![[pinfo arguments] containsObject:@"ADDEBUG"]) {
        return;
    }
    
    va_list ap;
    va_start(ap, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:ap];
    va_end(ap);
    
    str = [str stringByAppendingString:@"\n"];
    
    printf("%s", str.UTF8String);
}
#endif

//*
typedef id (*INITFUNC)(id self, SEL _cmd);

INITFUNC oldInit = NULL;

id myInit(id self, SEL _cmd) {
    id ret = oldInit(self, _cmd);
    [ret setValue:@(false) forKey:@"bCrashReportEnabled"];
    return ret;
}

void forceCrash2Me() {
    
    Class cls = NSClassFromString(@"UMAnalyticsConfig");

    if(cls == Nil) {
        return;
    }

    SEL sel =  NSSelectorFromString(@"myInit");
    class_addMethod(cls, sel, (IMP)myInit, "@@");
    
    
    Method m1 = class_getInstanceMethod(cls, @selector(init));
    oldInit = (INITFUNC)method_getImplementation(m1);
    Method m2 = class_getInstanceMethod(cls, sel);
    
    method_exchangeImplementations(m1, m2);
    
}
 // */


void testCrash(void) {
     [[Crashlytics sharedInstance] crash];
}
