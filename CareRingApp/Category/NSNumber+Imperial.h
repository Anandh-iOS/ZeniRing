//
//  NSNumber+Imperial.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/8/9.
//  公制/英制 转换

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (Imperial)
/**
 * 身高公制（cm）转英制（ft,in）
 * */
-(NSArray<NSNumber *> *)toImperialHeight;

/**
 * 身高英制（ft,in）转公制（cm）
 * */
+(NSNumber *)toMetricHeight:(int)ft Inch:(int)inch;

/**
 * 体重公制（kg）转英制（lbs）
 * */
-(NSNumber *)toImperialWeight;

/**
 * 体重英制（lbs）转公制（kg）
 * */
-(NSNumber *)toMetricWeight;
/**
 * 正常摄氏度转华氏度公式是 c = value × 1.8 + 32.0
 * 但由于本APP所显示的温度值均为差值（温度波动），
 * 对于差值的转换，正确公式应该是 c = value_diff × 1.8
 * */
-(NSNumber *)toTempF;

@end

NS_ASSUME_NONNULL_END
