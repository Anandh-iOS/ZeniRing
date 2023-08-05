//
//  NSDate+HMTools.m
//   
//
//  Created by 兰仲平 on 2021/11/9.
//  Copyright © 2021 linktop. All rights reserved.
//

#import "NSDate+HMTools.h"
#import "ConfigModel.h"

@implementation NSDate (HMTools)

-(NSInteger)age
{
   
    // 2.创建日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 3.利用日历对象比较两个时间的差值
    NSDateComponents *cmps = [calendar components:type fromDate:self toDate:[NSDate date] options:0];
    // 4.输出结果
//    NSLog(@"两个时间相差%ld年%ld月%ld日%ld小时%ld分钟%ld秒", cmps.year, cmps.month, cmps.day, cmps.hour, cmps.minute, cmps.second);
    return cmps.year;
    
}

-(NSString *)formatPdfShareTime:(NSString *)formatString
{
// _L(L_PDF_TIME_FORMAT)
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatString ];
    NSString *timeStr = [formatter stringFromDate:self];
    return  timeStr;
}


/// 周几的缩写
-(NSString *)weekDayStringShort {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"E~EEE";
    return  [formatter stringFromDate:self];
    
}
-(NSString *)monthStringShort {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"LLL";
    return  [formatter stringFromDate:self];
    
}

@end
