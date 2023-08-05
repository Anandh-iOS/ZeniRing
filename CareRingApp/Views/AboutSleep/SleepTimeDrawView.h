//
//  SleepTimeDrawView.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/24.
//

#import <UIKit/UIKit.h>
#import "SleepStageHeader.h"
#import "StagingSubObj.h"

//#import "SleepObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface SleepTimeDrawView : UIView

@property(strong, nonatomic)NSDate *startDate, *endDate;
@property(strong, nonatomic)NSMutableArray <NSDictionary *> *objArray;


@property(strong, nonatomic)UIView *xLabelArea; // 横坐标标签
@property(strong, nonatomic)UIView *drawView;  // 画线段

-(void)startDraw:(NSMutableArray<StagingSubObj *> * ) sleepObjArray SleepStart:(NSNumber *)  startSleepTimeInterval  SleepEnd:(NSNumber *)endSleepTimeInterval;

-(void)drawNone;
@end

NS_ASSUME_NONNULL_END
