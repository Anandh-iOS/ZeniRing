//
//  DBHeartRate.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/7.
//

#import <Foundation/Foundation.h>
#import "DBValueSuper.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBHeartRate : DBValueSuper


/// Get the heart rate data reported by the device
/// - Parameters:
///   - macAddress: device mac address
///   - beginDate: start of time range
///   - endDate: end of time range
///   - isDesc: YES = reverse chronological order , NO=chronologically ascending
///   - cmpBlk: return result.  maxHr -- Returns the largest value in the list,
///                       minHr -- Returns the smallest value in the list,
///                       avgHr -- Returns the average of the data in the list
+(void)queryBy:(NSString * _Nonnull)macAddress
         Begin:(NSDate *)beginDate
           End:(NSDate *)endDate
OrderBeTimeDesc:(BOOL)isDesc
      Cpmplete:(void(^)(NSMutableArray<DBHeartRate *> *results,
                        NSNumber *maxHr, NSNumber *minHr,
                        NSNumber *avgHr))cmpBlk;


@end

NS_ASSUME_NONNULL_END
