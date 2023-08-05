//
//  LNCTabbarController.m
//   
//
//  Created by lanzhongping on 2020/11/4.
//  Copyright © 2020 linktop. All rights reserved.
//

#import "HMTabbarController.h"
#import "Appdelegate.h"
#import "MainNav.h"
#import "ConfigModel.h"
#import "MainSleepVc.h"
#import "MainActivityVc.h"
#import "MainSettingVc.h"

@interface HMTabbarController ()

@end

@implementation HMTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.translucent = NO;
    [[UITabBar appearance] setBarTintColor:[UIColor blackColor]];
    self.tabBar.tintColor = MAIN_BLUE;
    self.tabBar.unselectedItemTintColor = [UIColor lightGrayColor];
}

-(void)createTabs
{
    // 首页
    [self addSubControllers: [[MainNav alloc]initWithRootViewController:[MainActivityVc new] ShowNavBar:YES]
                      Title:_L(L_TAB_ACTIVITY) ImageName:@"tab_activity_unsec" SelectImagName:@"tab_activity_select"];

    // 睡眠
    [self addSubControllers:[[MainNav alloc]initWithRootViewController:[MainSleepVc new] ShowNavBar:NO]
                      Title:_L(L_TAB_SLEEP) ImageName:@"tab_sleep_unsec" SelectImagName:@"tab_sleep_select"];
    
    // 设置
    [self addSubControllers:[[MainNav alloc]initWithRootViewController:[MainSettingVc new] ShowNavBar:YES]
                      Title:_L(L_TAB_SETTING) ImageName:@"tab_setting_unsec" SelectImagName:@"tab_setting_select"];
    
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.viewdidAppearBLK) {
        self.viewdidAppearBLK();
    }
}

- (void)addSubControllers:(UIViewController *)vc
                    Title:(NSString * __nullable)title
                ImageName:(NSString *)imgNm
           SelectImagName:(NSString *)selecImgNm
{
    if (vc == nil) {
        return;
    }
    
    if (![vc isKindOfClass:[UIViewController class]]) {
        return;
    }
    UIImage *image = [[UIImage imageNamed:selecImgNm] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = image;
    
    vc.tabBarItem.image = [[UIImage imageNamed:imgNm] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    vc.tabBarItem.title = title;
    
    [self addChildViewController:vc];
    
}

//- (BOOL)shouldAutorotate
//{
//    MainNav *nav = (MainNav *)self.selectedViewController;
//    if ([nav isKindOfClass:[MainNav class]])
//    {
//        return [self.selectedViewController shouldAutorotate];
//    }
//    return NO;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    MainNav *nav = (MainNav *)self.selectedViewController;
//    if ([nav isKindOfClass:[MainNav class]])
//    {
//        return [self.selectedViewController supportedInterfaceOrientations];
//    }
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    MainNav *nav = (MainNav *)self.selectedViewController;
//    if ([nav isKindOfClass:[MainNav class]])
//    {
//        return [self.selectedViewController preferredInterfaceOrientationForPresentation];
//    }
//    return UIInterfaceOrientationPortrait;
//}



@end
