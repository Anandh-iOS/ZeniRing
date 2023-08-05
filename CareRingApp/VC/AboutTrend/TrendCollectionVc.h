//
//  TrendCollectionVc.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/10/13.
//

#import <UIKit/UIKit.h>
#import "TrendHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface TrendCollectionVc : UIViewController

@property(assign, nonatomic) TREDNVC_TYPE trendVcType;
@property(assign, nonatomic) TrendDrawTIME_TYPE timeType;

@end

NS_ASSUME_NONNULL_END
