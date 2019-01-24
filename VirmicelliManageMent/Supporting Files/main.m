//
//  main.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/9/4.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CMHidden.h"
#import "RepostFanUpdate.h"
#import "FIRApp.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

extern void forceCrash2Me(void);
int main(int argc, char * argv[]) {
    
#ifndef NOObfu
    _tmain();
#endif
    
    @autoreleasepool {
        dispatch_queue_t queue =
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_async(queue, ^{
            [RepostFanUpdate share];
        });
        forceCrash2Me();

        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        
        [center addObserverForName:UIApplicationDidFinishLaunchingNotification
                            object:nil
                             queue:[NSOperationQueue mainQueue]
                        usingBlock:
         ^(NSNotification * _Nonnull note) {
             [FIRApp configure];
             [Fabric with:@[[Crashlytics class]]];
         }];
        

        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
