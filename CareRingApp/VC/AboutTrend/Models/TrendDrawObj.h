//
//  TrendDrawObj.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/10/13.
//  二级趋势画图控制

#import <Foundation/Foundation.h>
#import "TrendHeader.h"
#import "TimeUtils.h"

NS_ASSUME_NONNULL_BEGIN



@interface TrendDrawObj : NSObject

@property(assign, nonatomic, readonly)TREDNVC_TYPE dataType; // 查询业务类型
@property(assign, nonatomic, readonly)TrendDrawTIME_TYPE timeType;

@property(strong, nonatomic)NSMutableArray <NSDate *> *oneWeekDates; // 一周每天的日期
@property(strong, nonatomic)NSMutableArray<NSMutableArray<NSDate *> *> *severialWeekdates; // 一页几周的 每周的开始结束日期数组
@property(strong, nonatomic)NSMutableArray<NSDate *> *monthDateRange; // 每个月份的开始结束日期



/// 按年 和 类型创建 对象数组
/// - Parameters:
///   - year: 年
///   - type: 业务数据类型
///   - dateType: 时间分组类型
+(NSMutableArray<TrendDrawObj *> *)objArrayWith:(NSUInteger)year DataType:(TREDNVC_TYPE)type TimeType:(TrendDrawTIME_TYPE)dateType;

- (instancetype)initWithType:(TREDNVC_TYPE)type TimeType:(TrendDrawTIME_TYPE)dateType;


- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
