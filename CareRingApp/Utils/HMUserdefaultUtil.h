//
//  HMUserdefaultUtil.h
//
//
//  Created by lanzhongping on 2021/2/26.
//  Copyright © 2021 linktop. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface HMUserdefaultUtil : NSObject








//+ (BOOL)isImperialUint;  //是否英制单位
//+ (void)setImperialUint:(BOOL)isImperialUint; // 保存是否英制单位

/// 是否打开通知
+ (BOOL)isNoticeOn;
/// 保存是否打开通知开关
+ (void)setNoticeOn:(BOOL)on;

+ (NSTimeInterval)insertActivityTestDataTime;
+ (void)setInsertActivityTestDataTime:(NSTimeInterval)time;




@end

NS_ASSUME_NONNULL_END
