//
//  DBValueSuper.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/7.
//

#import <Foundation/Foundation.h>

#define DB_WEAK_SELF  __weak typeof(self) weakSelf = self;
#define DB_STRONG_SELF  __strong typeof(weakSelf) strongSelf = weakSelf;

NS_ASSUME_NONNULL_BEGIN

@interface DBValueSuper : NSObject

@property(assign, nonatomic)int cId; // unique index
@property(strong, nonatomic)NSDate *time; // Data sampling time point
@property(strong, nonatomic)NSNumber *value; // Data
@property(strong, nonatomic)NSString *macAddress; // The mac address of the device to which it belongs


@end

NS_ASSUME_NONNULL_END
