//
//  DayWeakMonthTrendVc.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/10/10.
//

#import "NAVTemplateViewController.h"
#import "TrendHeader.h"



NS_ASSUME_NONNULL_BEGIN

@interface DayWeakMonthTrendVc : NAVTemplateViewController

@property(assign, nonatomic)TREDNVC_TYPE trendVcType;
@property(strong, nonatomic)NSString *navTitleString;


@end

NS_ASSUME_NONNULL_END
