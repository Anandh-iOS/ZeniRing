//
//  NSNumber+formatString.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/7/26.
//

#import "NSNumber+formatString.h"

@implementation NSNumber (formatString)

-(NSString *)thoundSeperateString
{
    NSNumberFormatter *format = [[NSNumberFormatter alloc]init];
    [format setGroupingSize:3];
    [format setGroupingSeparator:@","];
    [format setUsesGroupingSeparator:YES];
    NSString *strValue = [format stringFromNumber:self];
    return strValue;
}

@end
