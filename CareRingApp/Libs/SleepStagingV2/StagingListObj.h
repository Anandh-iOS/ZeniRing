//
//  StagingListObj.h
//  sr01sdkProject
//
//  Created by 兰仲平 on 2022/10/19.
//  Node data for sleep staging

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StagingListObj : NSObject

@property(strong, nonatomic)NSNumber *time;  // timestamp
@property(strong, nonatomic)NSNumber *hr;    // heart rate data
@property(strong, nonatomic)NSNumber *motion; // motion count


@end

NS_ASSUME_NONNULL_END
