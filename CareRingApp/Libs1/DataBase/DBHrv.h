//
//  DBHrv.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/7.
//

#import <Foundation/Foundation.h>
#import "DBValueSuper.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBHrv : DBValueSuper


///  Get hrv average over time range
/// - Parameters:
///   - macAddress: device mac address
///   - beginDate: start of time range
///   - endDate: end of time range
///   - cmpBlk: return result. average -- average value
///                     maxTime -- Last data in ascending time order
///                     minTime -- First data in ascending order by time
+(void)queryAverage:(NSString * _Nonnull)macAddress Begin:(NSDate *)beginDate End:(NSDate *)endDate  Cpmplete:(void(^)(NSNumber * _Nullable average, NSNumber * _Nullable maxTime,  NSNumber * _Nullable minTime ) )cmpBlk;


///  Get the hrv data collection in the time range
/// - Parameters:
///   - macAddress: device mac address
///   - beginDate: start of time range
///   - endDate:  end of time range
///   - isDesc: YES = reverse chronological order , NO=chronologically ascending
///   - cmpBlk:  return result.  maxHrv -- Returns the largest value in the list,
///                      minHrv -- Returns the smallest value in the list,
///                      avgHrv -- Returns the average of the data in the list
+(void)queryBy:(NSString * _Nonnull)macAddress Begin:(NSDate *)beginDate End:(NSDate *)endDate OrderBeTimeDesc:(BOOL)isDesc Cpmplete:(void(^)(NSMutableArray<DBHrv *> *results, NSNumber *maxHrv, NSNumber *minHrv, NSNumber *avgHrv))cmpBlk;




@end

NS_ASSUME_NONNULL_END
