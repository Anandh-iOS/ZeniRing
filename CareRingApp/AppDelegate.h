//
//  AppDelegate.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/1.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(strong, nonatomic)UIWindow *window;
//@property(strong, nonatomic)NSString *cacheAccount;

-(void)checkBindedDevice;

-(void)start;
-(void)logout;

@end

