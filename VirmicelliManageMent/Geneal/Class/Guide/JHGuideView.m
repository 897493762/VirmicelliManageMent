//
//  JHGuideView.m
//  VirmicelliManageMent
//
//  Created by Satoshi Nakamoto on 2018/12/14.
//  Copyright © 2018年 Satoshi Nakamoto. All rights reserved.
//

#import "JHGuideView.h"

@implementation JHGuideView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.photoHeight.constant = M_RATIO_SIZE(478);
    self.phtoTop.constant = 0;
    self.textLableLeft.constant = M_RATIO_SIZE(20);
    self.textLableRight.constant = M_RATIO_SIZE(20);
    self.textLableBottom.constant = M_RATIO_SIZE(147);
    self.nextButtonBottom.constant = M_RATIO_SIZE(20);
    self.skipWidth.constant = M_RATIO_SIZE(118);
    self.skipHeight.constant = M_RATIO_SIZE(45);
    self.skipButton.layer.masksToBounds = YES;
    self.skipButton.layer.cornerRadius = M_RATIO_SIZE(2);
    self.nextButton.layer.masksToBounds = YES;
    self.nextButton.layer.cornerRadius = M_RATIO_SIZE(2);
    CGFloat left = (kScreenWidth - M_RATIO_SIZE(118)*2-M_RATIO_SIZE(32))/2;
    self.skipLeft.constant = left;
    self.nextRight.constant = left;
}
+(instancetype)initView{
    // 封装Xib的加载过程
    return [[NSBundle mainBundle] loadNibNamed:@"JHGuideView" owner:nil options:nil].firstObject;
}
-(void)setIsPush:(BOOL)isPush{
    _isPush = isPush;
    if (_isPush) {
        self.photoHeight.constant = kScreenHeight;
        self.skipButton.hidden = YES;
        self.nextButton.hidden = YES;
        self.skipWidth.constant = M_RATIO_SIZE(305);
        self.skipHeight.constant = M_RATIO_SIZE(50);
        self.nextButtonBottom.constant = M_RATIO_SIZE(60);

        self.textLable.hidden = YES;
        self.skipTwoButton.backgroundColor = [UIColor colorWithHexString:@"#4193FF"];
        self.skipTwoButton.titleLabel.font = [UIFont systemFontOfSize:25];
        [self.skipTwoButton setTitle:NSLocalizedString(@"2133", nil) forState:UIControlStateNormal];
        [self bringSubviewToFront:self.skipTwoButton];
        if([[self currentLanguage] compare:@"zh-Hans" options:NSCaseInsensitiveSearch]==NSOrderedSame || [[self currentLanguage] compare:@"zh-Hans-CN" options:NSCaseInsensitiveSearch]==NSOrderedSame || [[self currentLanguage] compare:@"zh-Hant" options:NSCaseInsensitiveSearch]==NSOrderedSame|| [[self currentLanguage] compare:@"zh-Hant-CN" options:NSCaseInsensitiveSearch]==NSOrderedSame)
        {
            NSLog(@"current Language == Chinese");
            if (KIsiPhoneX) {
                self.photo.image = [UIImage imageNamed:@"img_push_X_en"];

            }else{
                self.photo.image = [UIImage imageNamed:@"img_push_en"];

            }
        }else if([[self currentLanguage] compare:@"en"options:NSCaseInsensitiveSearch]==NSOrderedSame || [[self currentLanguage] compare:@"en-CN" options:NSCaseInsensitiveSearch]==NSOrderedSame){
            if (KIsiPhoneX) {
                self.photo.image = [UIImage imageNamed:@"img_push_X_en"];
                
            }else{
                self.photo.image = [UIImage imageNamed:@"img_push_en"];
                
            }
        }else{
            if (KIsiPhoneX) {
                self.photo.image = [UIImage imageNamed:@"img_push_X_jp"];

            }else{
                self.photo.image = [UIImage imageNamed:@"img_push_jp"];

            }

            
        }
    }
}

-(NSString*)currentLanguage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLang = [languages objectAtIndex:0];
    return currentLang;
}
- (IBAction)nextButtonOnclicked:(UIButton *)sender {
    if (self.index == 3) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [[JHControllerManager ShareManager] postNotification:ControllerManagerChangePushNotification userInfo:nil];
    }else{
        if (self.block) {
            self.block(self.index+1);
        }
    }

}

- (IBAction)skipButtonOnclicked:(UIButton *)sender {
    if (self.isPush) {
        [kMainDelegate showPushMessage];
        [[JHControllerManager ShareManager] postNotification:ControllerManagerChangeToHomeNotification userInfo:nil];

    }else{
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [[JHControllerManager ShareManager] postNotification:ControllerManagerChangePushNotification userInfo:nil];
    }
}

-(void)setIndex:(NSInteger)index{
    _index = index;
    NSString *dexc = [NSString stringWithFormat:@"273%ld",_index];
    NSString *iconStr = [NSString stringWithFormat:@"img_guide_0%ld",_index+1];
    self.textLable.text = NSLocalizedString(dexc, nil);
    self.photo.image = [UIImage imageNamed:iconStr];
    if (_index == 3) {
        self.skipTwoButton.hidden = YES;
    }else{
        self.skipButton.hidden = YES;
        self.nextButton.hidden = YES;
    }
}
@end
