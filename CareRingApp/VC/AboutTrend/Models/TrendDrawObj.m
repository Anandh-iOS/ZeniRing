//
//  TrendDrawObj.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/10/13.
//

#import "TrendDrawObj.h"

@implementation TrendDrawObj

- (instancetype)initWithType:(TREDNVC_TYPE)type TimeType:(TrendDrawTIME_TYPE)timeType
{
    self = [super init];
    if (self) {
        self->_dataType = type;
        self->_timeType = timeType;
    }
    return self;
}


/// 按年 和 类型创建 对象数组
/// - Parameters:
///   - year: 年
///   - type: 业务数据类型
///   - dateType: 时间分组类型
+(NSMutableArray<TrendDrawObj *> *)objArrayWith:(NSUInteger)year DataType:(TREDNVC_TYPE)type TimeType:(TrendDrawTIME_TYPE)dateType
{
    NSMutableArray<TrendDrawObj *> * array = [NSMutableArray new];
    switch (dateType) {
        case TrendDrawTIME_TYPE_DAY_PREPAGE:
        {
            
        }
            break;
        case TrendDrawTIME_TYPE_EVERY_WEEK_PREPAGE: // 一页一周
        {
            NSMutableArray<NSMutableArray <NSDate *> *> *times = [TimeUtils everyWeekDatesOfYearGroupByWeak:year FirstDayOfWeek:1];
            
            [times enumerateObjectsUsingBlock:^(NSMutableArray<NSDate *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TrendDrawObj *trendObj = [[TrendDrawObj alloc]initWithType:type TimeType:dateType];
                trendObj.oneWeekDates = obj;
                [array addObject:trendObj];
            }];
        }
            break;
        case  TrendDrawTIME_TYPE_SEVERIAL_WEEK_PREPAGE: // 一页 8周
        {
         
            NSMutableArray<NSMutableArray<NSMutableArray<NSDate *> *> *> *times = [TimeUtils serverialWeekRangeDatesOfYear:year FirstDayOfWeek:1];
            [times enumerateObjectsUsingBlock:^(NSMutableArray<NSMutableArray<NSDate *> *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TrendDrawObj *trendObj = [[TrendDrawObj alloc]initWithType:type TimeType:dateType];
                trendObj.severialWeekdates = obj;
                [array addObject:trendObj];
                
            }];
        }
            break;
        case TrendDrawTIME_TYPE_12_MONTH_PERPAGE: // 一页 一年12月
        {
            NSMutableArray<NSMutableArray <NSDate *> *> *times = [TimeUtils monthRangeDateofYear:year];
            
            [times enumerateObjectsUsingBlock:^(NSMutableArray<NSDate *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TrendDrawObj *trendObj = [[TrendDrawObj alloc]initWithType:type TimeType:dateType];
                trendObj.monthDateRange = obj;
                [array addObject:trendObj];
            }];
        }
            break;
        default:
            break;
    }
    
    
    return array;
}

@end
