//
//  SleepTimeDrawObj.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/7/18.
//

#import <Foundation/Foundation.h>
#import "SleepObj.h"
//#import "StagingData.h"

NS_ASSUME_NONNULL_BEGIN

@interface SleepTimeDrawObj : NSObject

@property(strong, nonatomic)NSNumber *startSleepTimeInterval, *endSleepTimeInterval; // 此段睡眠的起点终点时间
@property(strong, nonatomic)NSMutableArray <SleepObj *>* sleepObjArray; // 睡眠分期数组

//@property(copy, nonatomic) void (^readyDrawDataBlk)(void);

//-(void)testData ; //测试画图
@end

NS_ASSUME_NONNULL_END
