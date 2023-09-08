//
//  MainNav.m
//   
//
//  Created by 兰仲平 on 2021/4/20.
//  Copyright © 2021 linktop. All rights reserved.
//

#import "MainNav.h"
#import "goalValues.h"

@interface MainNav ()

@end

@implementation MainNav

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = UIColor.clearColor;
        self.navigationBar.standardAppearance = appearance;
        self.navigationBar.scrollEdgeAppearance = self.navigationBar.standardAppearance;
    }
    self.navigationBar.translucent = NO; // 导航栏不透明
    
    
    //Set Initial values for Goals module
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL isFirstLaunch = [defaults boolForKey:@"isFirstLaunch"];

    if (!isFirstLaunch) {
        [defaults setBool:YES forKey:@"isFirstLaunch"];
        [goalValues setDefaultValue];
    }

    
}

-(instancetype)initWithRootViewController:(UIViewController *)rootViewController ShowNavBar:(BOOL)show
{
    if (self = [super initWithRootViewController:rootViewController]) {
        self.navigationBarHidden = !show;
    }
    
    return self;
    
}


//是否自动旋转,返回YES可以自动旋转
- (BOOL)shouldAutorotate
{
    if ([self.topViewController respondsToSelector:@selector(shouldAutorotate)])
    {
        return [self.topViewController shouldAutorotate];
    }
    return NO;
}

//返回支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([self.topViewController respondsToSelector:@selector(supportedInterfaceOrientations)])
    {
        return [self.topViewController supportedInterfaceOrientations];
    }
    return UIInterfaceOrientationMaskPortrait;
}

//这个是返回优先方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if ([self.topViewController respondsToSelector:@selector(preferredInterfaceOrientationForPresentation)])
    {
        return [self.topViewController preferredInterfaceOrientationForPresentation];
    }
    return UIInterfaceOrientationPortrait;
}

@end
