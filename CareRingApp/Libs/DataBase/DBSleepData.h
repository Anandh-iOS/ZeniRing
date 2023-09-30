//
//  DBSleepData.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/11/1.
//  睡眠数据的缓存

#import <Foundation/Foundation.h>
#import "StagingDataV2.h"

@class TrendCommonObj;

NS_ASSUME_NONNULL_BEGIN
@class FMDatabase;
@interface DBSleepData : NSObject

@property(strong, nonatomic) NSNumber *sleepStart;  // sleep start timestamp
@property(strong, nonatomic) NSNumber *sleepEnd;    // Sleep end timestamp
@property(strong, nonatomic) NSString *dateString;
@property(strong, nonatomic) NSString *macAddress;

@property(strong, nonatomic) NSNumber *hr;   //Average heart rate during sleep
@property(strong, nonatomic) NSNumber *hrv;  //hrv during sleep
@property(strong, nonatomic) NSNumber *br;   //Average respiration rate during sleep
@property(strong, nonatomic) NSNumber *spo2; //Average Blood Oxygen During Sleep


@property(strong, nonatomic) NSNumber *hrDip; //Heart rate immersion ratio float
@property(strong, nonatomic) NSNumber *duration; //Sleep duration unit (seconds)
@property(strong, nonatomic) NSNumber *qulalityDuration; //Quality sleep duration unit (seconds)
@property(strong, nonatomic) NSNumber *deepDuration; //Deep sleep duration unit (seconds)

@property(strong, nonatomic) NSNumber *effieiency; // Other times except wake and divided by the total time
@property(strong, nonatomic) StagingDataV2 *stagingData; // sleep staging data

@property(assign, nonatomic)BOOL isNap;

/// copy object
/// - Parameter oriSleep: original instance
+(instancetype)copyWithDbSleepData:(DBSleepData *)oriSleep;

/// Query for sleep data
/// - Parameters:
///   - macAddress: devic's macaddress
///   - beginTime: start of time range
///   - endTime: end of time range
///   - cmpBlk: return result
///
+(void)queryDbSleepBy:(NSString *)macAddress Begin:(NSTimeInterval)beginTime EndTime:(NSTimeInterval)endTime Comp:(void(^)(NSMutableArray<DBSleepData *> *results))cmpBlk;

@end

NS_ASSUME_NONNULL_END
