//
//  SleepObj.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/24.
//   画图使用的睡眠法分期数据

#import <Foundation/Foundation.h>
//#import "StagingListData.h"
#import "SleepHrObj.h"
#import "SleepStageHeader.h"
// 睡眠类型
//typedef NS_ENUM(NSUInteger, SLEEP_TYPE) {
//    SLEEP_TYPE_WAKE,
//    SLEEP_TYPE_REM,
//    SLEEP_TYPE_LIGHT_SLEEP,
//    SLEEP_TYPE_DEEP_SLEEP,
//};


NS_ASSUME_NONNULL_BEGIN

@interface SleepObj : NSObject

@property(assign, nonatomic)SleepStagingType sleepType;  // 睡眠类型
//@property(strong, nonatomic)NSDate *startDate, *endDate; // 这一段睡眠的时间段
@property(strong, nonatomic)NSMutableArray <SleepHrObj *> *hrObjArray;

@end

NS_ASSUME_NONNULL_END
