//
//  UIViewController+JHNaviHeight.m
//  Ganjiuhui
//
//  Created by Wuxiaolian on 16/7/19.
//  Copyright © 2016年 WXL. All rights reserved.
//

#import "UIViewController+JHNaviHeight.h"

@implementation UIViewController (JHNaviHeight)

-(CGFloat)navigationBarHight{
    if (KIsiPhoneX) {
        return 88;
    }else{
        return 64;
    }
}
-(CGFloat)statusHeight{
    if (KIsiPhoneX) {
        return 44;
    }else{
        return 20;
    }
}
-(CGFloat)naviHeight{
    return 44;

}
-(CGFloat)tabBarHeight{
    CGFloat tabBarHeight = self.tabBarController.tabBar.frame.size.height;
    return tabBarHeight;
}
-(CGFloat)safeBottomHeight{
    if (KIsiPhoneX) {
        return 34;
    }else{
        return 0;
    }
}
@end
