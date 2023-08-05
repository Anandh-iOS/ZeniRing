//
//  NSNumber+Imperial.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/8/9.
//

#import "NSNumber+Imperial.h"

@implementation NSNumber (Imperial)

/**
 * 身高公制（cm）转英制（ft,in）
 * */
-(NSArray<NSNumber *> *)toImperialHeight
{
    double result = self.doubleValue / 30.48;
    
    int ft = (int)(floor(result));
    
    int inch = (int)(round((result - ft) * 12));
    if (inch >= 12) {
        ft += (inch / 12);
        inch -= 12;
    }
    return @[@(ft), @(inch)];//arrayOf(ft, inch)
}

/**
 * 身高英制（ft,in）转公制（cm）
 * */
+(NSNumber *)toMetricHeight:(int)ft Inch:(int)inch
{
    return @((inch / 12.0f + ft) * 30.48f);
}

/**
 * 体重公制（kg）转英制（lbs）
 * */
-(NSNumber *)toImperialWeight
{
    
    return @(self.floatValue * 2.2046f);
}

/**
 * 体重英制（lbs）转公制（kg）
 * */
-(NSNumber *)toMetricWeight
{
    return @(self.floatValue / 2.2046f);
    
}

/**
 * 正常摄氏度转华氏度公式是 c = value × 1.8 + 32.0
 * 但由于本APP所显示的温度值均为差值（温度波动），
 * 对于差值的转换，正确公式应该是 c = value_diff × 1.8
 * */
-(NSNumber *)toTempF
{
    return @( round(self.doubleValue * 1.8));
   
}

@end
