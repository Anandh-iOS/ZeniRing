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


@end

NS_ASSUME_NONNULL_END
