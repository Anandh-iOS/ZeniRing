//
//  NSString+Check.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/8/23.
//

#import "NSString+Check.h"

@implementation NSString (Check)
//非法字符
-(BOOL)isContainSpecialCharacters {
    
    NSCharacterSet *nameCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"] invertedSet];
    NSRange userNameRange = [self rangeOfCharacterFromSet:nameCharacters];
    if (userNameRange.location != NSNotFound) {
        NSLog(@"包含特殊字符");
        return YES;
    }
    return NO;
}

-(BOOL)isValiadEmail
{
    
    // ^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$
    NSString* emailRegu = @"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$";
       NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegu];
       return [numberPre evaluateWithObject:self];
    
}

-(int)transVersionToInt
{
    
    NSArray<NSString *> *arr =  [self componentsSeparatedByString:@"."];
    int res = 0;
    NSMutableString *tempString = [NSMutableString new];
    for (int i = 0; i < arr.count; i++) {
        [tempString appendFormat:@"%d", arr[i].intValue];
        
    }
    res = [tempString intValue];
    return res;
    
}

-(BOOL)versionIsLowThan:(NSString *)remote {
    
    NSArray<NSString *> *arrLocal =  [self componentsSeparatedByString:@"."];
    NSArray<NSString *> *arrRemote =  [remote componentsSeparatedByString:@"."];
    if (arrLocal.count != arrRemote.count) {
        return NO; //格式不匹配
    }
    BOOL isLow = NO;
    for (int i = 0; i < arrLocal.count; i++) {
        if ([arrLocal[i] intValue] < [arrRemote[i] intValue]) {
            isLow = YES;
            break;
        }
        
    }
    
    return isLow;
}

@end
