//
//  AppDelegate.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/1.
//

#import <YYKit/YYKit.h>
#import "AppDelegate.h"
#import "HMTabbarController.h"
#import "HMUserdefaultUtil.h"
//#import "MainNav.h"

#import "ConfigModel.h"
#import "LoginVc.h"
#import "DBTables.h"

#import "DeviceCenter.h"
#import "LTPHud.h"
#import "BindeTipsVc.h"
#import "NotificationNameHeader.h"
#import "MainNav.h"
//#import "LTPserverAPI.h"

@interface AppDelegate ()

@property(strong, nonatomic)HMTabbarController *tabbarConctroller;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    [self start];
    [[DeviceCenter instance] registWithisCustomBleManage:YES];

    
    return YES;
}

-(void)logout {
    self.window = nil;
    self.tabbarConctroller = nil;
    [self start];
}

-(void)start {
    if (self.window == nil) {
        self.window = [[UIWindow alloc]initWithFrame: [UIScreen mainScreen].bounds];
    }
    

    // 进入主界面
    if (!self.tabbarConctroller) {
        HMTabbarController *tabbarConctroller = [[HMTabbarController alloc] init];
        self.tabbarConctroller = tabbarConctroller;
        
        [self.tabbarConctroller createTabs];

    }

    self.window.rootViewController = self.tabbarConctroller;
    [self.window makeKeyAndVisible];
    [self goLoginVc];

    
}

-(void)goLoginVc {
    // 弹出登录窗口
    LoginVc *vc = [[LoginVc alloc] init];
//    vc.cacheAccount = self.cacheAccount;

    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    nav.navigationBar.translucent = YES;
//    nav.navigationBar.barTintColor = UIColor.clearColor;
    nav.navigationBar.shadowImage = [UIImage new];
    [nav.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    self.cacheAccount = nil;
    [self.tabbarConctroller presentViewController:nav animated:YES completion:nil];
}






-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    // 仅适配竖屏
    return UIInterfaceOrientationMaskPortrait;
    
}

@end
