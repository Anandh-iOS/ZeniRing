//
//  TimeUtils.h
//   
//
//  Created by lanzhongping on 2020/12/1.
//  Copyright © 2020 linktop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+HMTools.h"

NS_ASSUME_NONNULL_BEGIN

@interface TimeUtils : NSObject
/// 取当天的0点时间
+ (NSDate *)zeroOfDate:(NSDate *)inputDate;

/// 取下一天的0点时间
+ (NSDate *)zeroOfNextDayDate:(NSDate *)inputDate;

/// 取前一天的0点时间
+ (NSDate *)zeroOfBeforeDayDate:(NSDate *)inputDate;

//取出在一天中的第几小时 24小时制
+(NSInteger)getHour:(NSDate *)inputDate;
/// inputDate开始倒数 days 的0点0分时间
/// @param days 倒数天数
/// @param inputDate 其实日期
+(NSDate *)getDayDateBefore:(NSUInteger)days From:(NSDate *)inputDate;

/// 计算属于一年中的第几天
/// @param inputDate
+(NSInteger)getDayOfYear:(NSDate *)inputDate;

/// 取当天所在年的开始时间
+ (NSDate *)zeroOfYearByDate:(NSDate *)inputDate;

/// 取出月中第几号
/// @param inputDate 日期

+(NSInteger)getDayOfMonth:(NSDate *)inputDate;

/// 获取日期中的年月日
/// @param inputDate
/// @param BLk
+(void)getYearMonthDayFromDate:(NSDate *)inputDate Cmp:(void(^)(NSInteger year, NSInteger month, NSInteger day))BLk;
/// 计算闰年
/// @param year 
+(BOOL)bissextile:(int)year;

//获得某年的周数
+(NSInteger)getWeekAccordingToYear:(NSInteger)year;
/**
 *  获取某年某周的范围日期
 *
 *  @param year       年份
 *  @param weekofYear year里某个周
 *
 *  @return 时间范围字符串
 */
+(NSArray<NSDate *> *)getWeekRangeDate_Year:(NSInteger)year WeakOfYear:(NSInteger)weekofYear;


/// 转化为日期0点0分的 date
/// @param year 年
/// @param month 月
/// @param day 日
+(NSDate *)transToDateBy:(NSNumber *)year Month:(NSNumber *)month Day:(NSNumber *)day;


/// 获取月份对应的字符串
/// @param month 月份
+(NSString *)getStringOfMonth:(NSNumber *)month;


+ (NSDate *)modifyDate:(NSDate *)inputDate newHour:(NSInteger)hour newMinute:(NSInteger)minute newSecond:(NSInteger)second;


/// 一年52周的日期
/// @param year 年
/// @param firstDayOfWeek 每周第一天  1=周日
+(NSMutableArray<NSMutableArray <NSDate *> *> *)everyWeekDatesOfYearGroupByWeak:(NSUInteger)year FirstDayOfWeek:(NSUInteger)firstDayOfWeek;

/// 周的日期
/// @param year 年
/// @param firstDayOfWeek 每周第一天是周几 1=周日
+(NSMutableArray<NSMutableArray<NSMutableArray<NSDate *> *> *> *)serverialWeekRangeDatesOfYear:(NSUInteger)year FirstDayOfWeek:(NSUInteger)firstDayOfWeek;


/// 每月的日期范围
/// @param year 年
+(NSMutableArray <NSMutableArray<NSDate *> *>*)monthRangeDateofYear:(NSUInteger)year;


@end

NS_ASSUME_NONNULL_END
