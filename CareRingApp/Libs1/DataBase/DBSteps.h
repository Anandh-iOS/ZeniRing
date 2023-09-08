//
//  DBSteps.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/7/4.
//

#import "DBValueSuper.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBSteps : DBValueSuper

@property(strong, nonatomic)NSNumber *motion;


/// Get the pedometer data reported by the device
/// - Parameters:
///   - macAddress: device mac address
///   - beginDate: start of time range
///   - endDate: end of time range
///   - isDesc: YES = reverse chronological order , NO=chronologically ascending
///   - cmpBlk: return result
+(void)queryBy:(NSString * _Nonnull)macAddress
         Begin:(NSDate *)beginDate End:(NSDate *)endDate
OrderBeTimeDesc:(BOOL)isDesc
      Cpmplete:(void(^)(NSMutableArray<DBSteps *> *results))cmpBlk;



@end

NS_ASSUME_NONNULL_END
