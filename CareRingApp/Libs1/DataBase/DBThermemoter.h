//
//  DBThermemoter.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/7.
//

#import <Foundation/Foundation.h>
#import "DBValueSuper.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBThermemoter : DBValueSuper


/// Get the finger temperature data reported by the device
/// - Parameters:
///   - macAddress: device mac address
///   - beginDate: start of time range
///   - endDate: end of time range
///   - isDesc: YES = reverse chronological order , NO=chronologically ascending
///   - cmpBlk: return result.  maxThermemoter -- Returns the largest value in the list,
///                       minThermemoter -- Returns the smallest value in the list,
///                       avgThermemoter -- Returns the average of the data in the list
+(void)queryBy:(NSString * _Nonnull)macAddress Begin:(NSDate *)beginDate EndDate:(NSDate *)endDate OrderBeTimeDesc:(BOOL)isDesc Cpmplete:(void(^)(NSMutableArray<DBThermemoter *> *results, NSNumber *maxThermemoter, NSNumber *minThermemoter, NSNumber *avgThermemoter))cmpBlk;


@end

NS_ASSUME_NONNULL_END
