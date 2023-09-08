//
//  StagingDataV2.h
//  sr01sdkProject
//
//  Created by 兰仲平 on 2022/8/16.
//

#import <Foundation/Foundation.h>
#import "StagingSubObj.h"
NS_ASSUME_NONNULL_BEGIN

@interface StagingDataV2 : NSObject

@property(assign, nonatomic)NSTimeInterval startTime; // sleep start timestamp
@property(assign, nonatomic)NSTimeInterval endTime;  // Sleep end timestamp
@property(assign, nonatomic)double averageHr; // sleep average heart rate
@property(strong, nonatomic, nullable)NSMutableArray<StagingSubObj *> *ousideStagingList;// sleep staging data

@end

NS_ASSUME_NONNULL_END
