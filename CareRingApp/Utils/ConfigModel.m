//
//  ConfigModel.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/1.
//

#import "ConfigModel.h"

 NSString * const NONE_VALUE = @"--";
 NSUInteger PWD_LENGTH_LOW = 6; // 密码长度下限
 NSUInteger PWD_LENGTH_HIGH = 16; // 密码长度上限

const CGFloat LOGIN_TITLE_SIZE = 22.0f;

@implementation ConfigModel


+(NSString *)appVersion {
    NSString *appversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return  appversion;
}
+(NSString *)appName {
    NSString *appname = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    return  appname;
}

@end
