//
//  LocaizeTool.h
//   
//
//  Created by 兰仲平 on 2021/4/15.
//  Copyright © 2021 linktop. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocalizeTool : NSObject

+(NSString *)localizeFromTables:(NSString *)key Tables:(NSArray<NSString *> *)tables;

@end

NS_ASSUME_NONNULL_END
