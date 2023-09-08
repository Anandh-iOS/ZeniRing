//
//  DBHistoryDataSr03.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/8/15.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN
@class FMDatabase;

@interface DBHistoryDataSr03 : NSObject


/// Query resting heart rate
/// - Parameters:
///   - macAdres: device mac address
///   - date: The date you want to query
///   - cmpBlk: return result. restHr -- 24-hour resting heart rate for the day of the incoming date
+(void)queryueryRestHrBymacAdres:(NSString *)macAdres Date:(NSDate *)date CMP:(void(^)(NSNumber *restHr ))cmpBlk;


/// Query the measurement data of the sport mode.
/// - Parameters:
///   - macAddress: device mac address
///   - beginDate: start of time
///   - endDate: end of time
///   - isDesc: YES= output in reverse chronological order
///   - cmpBlk: return result.
+(void)queryForSportBy:(NSString * _Nonnull)macAddress Begin:(NSDate *)beginDate End:(NSDate *)endDate OrderBeTimeDesc:(BOOL)isDesc Cpmplete:(void(^)(NSMutableArray<NSDictionary *> *results))cmpBlk;


@end

NS_ASSUME_NONNULL_END
