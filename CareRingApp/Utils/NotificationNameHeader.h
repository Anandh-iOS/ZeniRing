//
//  NorificationNameHeader.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/8/3.
//  定义通知的名称

#ifndef NotificationNameHeader_h
#define NotificationNameHeader_h
#import "NSNotificationCenter+YYAdd.h"

#define NOTI_NAME_SLEEP_CALC_FINISH  @"sleep_calc_fin"  // 睡眠计算完成

#define NOTI_NAME_AUTOLOGIN_SUCC  @"NOTI_NAME_AUTOLOGIN_SUCC"  // 自动登录完成

#define NOTI_NAME_SLEEP_DATE_CHANGE  @"NOTI_NAME_SLEEP_DATE_CHANGE"  // 计算日期变更
#define NOTI_NAME_NEED_UPDATE  @"NOTI_NAME_NEED_UPDATE"  // 有新更新可用

#define NOTI_NAME_SLEEP_HRV_QUERY_READY @"NOTI_NAME_SLEEP_HRV_QUERY_READY" // 睡眠期间hrv查询完毕
#define NOTI_NAME_SLEEP_HEART_RATE_QUERY_READY @"NOTI_NAME_SLEEP_HEART_RATE_QUERY_READY" // 睡眠期间hrv查询完毕
#define NOTI_NAME_SLEEP_TEMPERATURE_QUERY_READY @"NOTI_NAME_SLEEP_TEMPERATURE_QUERY_READY" // 睡眠期间体温查询完毕


#endif /* NorificationNameHeader_h */
