//
//  Obfu.h
//  Obfu
//
//  Created by doorxp on 2017/6/27.
//  Copyright © 2017年 doorxp. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (*ALIASCLASS)(Class cls, const char *name);
typedef const char * (*ALIASSTRING)(const char * name);

extern ALIASCLASS aliasClass;
extern ALIASSTRING aliasString;

#define HC(clsname) aliasClass([clsname class],(const void*)L## #clsname)
#define HS(__str__) aliasString((const void*)L##__str__)


#define __CLS__(__prix__, __name__) __prix__##__name__
#define _CLS_(__prix__, __name__) __CLS__(__prix__, __name__)
#define OBFUCLASS(__name__) _CLS_(KKPRE, __name__)

#define __VAR__(a,b) a##b
#define VAR(a,b) __VAR__(a,b)

#define ObfuCode() \
do { \
    const char *t = __TIME__;\
    const int VAR(l,__LINE__) = __LINE__;\
    char a=t[VAR(l,__LINE__)%8];\
    a^=a;\
}while(0)


/*
 
 //列出项目中所使用的类名,我们自己写的
 for i in `find . -name "*.h"`; do grep -o "@interface\s\+\(\w*\)" $i; done | cut -d " " -f 2 | sort -u
 
 
 //列出项目中xib所使用的类名,我们自己写的
 for i in `find . -name "*.xib"`; do grep -o "customClass=\"[a-zA-Z_]*\"" $i; done | cut -d = -f 2 | tr -d "\"" | sort -u > ~/cls.txt
 
  //列出项目中storyboard所使用的类名,我们自己写的
 for i in `find . -name "*.storyboard"`; do grep -o "customClass=\"[a-zA-Z_]*\"" $i; done | cut -d = -f 2 | tr -d "\"" | sort -u > ~/cls.txt
 
 //删除所有系统类与第三方类
// */
