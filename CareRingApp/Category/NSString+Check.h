//
//  NSString+Check.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/8/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Check)

/// 检查是否包含非法字符 YES = 包含
-(BOOL)isContainSpecialCharacters;
// yes = 复合规则
-(BOOL)isValiadEmail;

//-(int)transVersionToInt;
-(BOOL)versionIsLowThan:(NSString *)remote;
@end

NS_ASSUME_NONNULL_END
