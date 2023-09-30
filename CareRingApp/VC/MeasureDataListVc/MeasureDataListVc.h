//
//  MeasureDataListVc.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/7/4.
//

#import <UIKit/UIKit.h>
#import "NAVTemplateViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MEASURE_LIST_TYPE) {
    MEASURE_LIST_TYPE_HEART_RATE,
    MEASURE_LIST_TYPE_HRV,
    MEASURE_LIST_TYPE_THERMEMOTER_FLU, // 体温振幅
};

@interface MeasureDataListVc : NAVTemplateViewController

@property(strong, nonatomic)NSDate *date; //相应日期

@property(strong, nonatomic)NSNumber * sleepBeginStamp, *sleepEndStamp;

-(instancetype)initWith:(MEASURE_LIST_TYPE)type;



@end

NS_ASSUME_NONNULL_END
