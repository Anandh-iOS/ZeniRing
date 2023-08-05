//
//  SleepHrObj.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/7/18.
//  画图使用睡眠心率

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SleepHrObj : NSObject

@property(strong, nonatomic)NSNumber *time; // NSTimeInterval
@property(strong, nonatomic)NSNumber *hr;   // 这一时间测量的心率

- (instancetype)initWithHr:(NSNumber *)hr Time:(NSNumber *)time;

@end

NS_ASSUME_NONNULL_END
