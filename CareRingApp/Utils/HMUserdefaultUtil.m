//
//  HMUserdefaultUtil.m
//   
//
//  Created by lanzhongping on 2021/2/26.
//  Copyright © 2021 linktop. All rights reserved.
//

#import "HMUserdefaultUtil.h"

NSString * const PRIV_KEY = @"key_privacy_agree"; // lintop

NSString * const KEY_LASTACCOUNT = @"key_last_account";
NSString * const KEY_LASTPWD = @"key_last_pwd";

NSString * const KEY_IS_UNIT_IMPERIAL = @"key_is_unit_imperial";

NSString * const KEY_IS_NOTICE_ON = @"key_is_notice_on";  // 通知是否打开
NSString * const KEY_IS_INSERTED = @"key_is_inserted_activity_test";  //

NSString * const KEY_UPDATE_REMIND = @"kum";

@implementation HMUserdefaultUtil

//是否打开通知
+ (BOOL)isNoticeOn {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return  [userDefault boolForKey:KEY_IS_NOTICE_ON];
}
// 保存是否打开通知开关
+ (void)setNoticeOn:(BOOL)on
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:on forKey:KEY_IS_NOTICE_ON];
    [userDefault synchronize];
}

//是否已插入测试数据
+ (NSTimeInterval)insertActivityTestDataTime
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return  [userDefault doubleForKey:KEY_IS_INSERTED];
}

+ (void)setInsertActivityTestDataTime:(NSTimeInterval)time
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setDouble:time forKey:KEY_IS_INSERTED];
    [userDefault synchronize];
}



@end
