//
//  NSDate+HMTools.h
//   
//
//  Created by 兰仲平 on 2021/11/9.
//  Copyright © 2021 linktop. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (HMTools)
// 计算年龄
-(NSInteger)age;
-(NSString *)formatPdfShareTime:(NSString *)formatString;


/// 周几缩写
-(NSString *)weekDayStringShort;

/// 月份缩写
-(NSString *)monthStringShort;

@end

NS_ASSUME_NONNULL_END
