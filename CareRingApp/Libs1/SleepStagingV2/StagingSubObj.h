//
//  StagingSubObj.h
//  sr01sdkProject
//
//  Created by 兰仲平 on 2022/10/19.
//  staging node set

#import <Foundation/Foundation.h>
#import "SleepStageHeader.h"
#import "StagingListObj.h"
NS_ASSUME_NONNULL_BEGIN

@interface StagingSubObj : NSObject

@property(assign, nonatomic)SleepStagingType type;  //  sleep stage type
@property(strong, nonatomic)NSMutableArray<StagingListObj *> *list; // staging node set



@end

NS_ASSUME_NONNULL_END
