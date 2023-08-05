//
//  LocaizeTool.m
//   
//
//  Created by 兰仲平 on 2021/4/15.
//  Copyright © 2021 linktop. All rights reserved.
//

#import "LocalizeTool.h"

@implementation LocalizeTool
+(NSString *)localizeFromTables:(NSString *)key Tables:(NSArray<NSString *> *)tables {
    if (!tables.count) {
        return nil;
    }
    NSString *locaString = nil;
    for (NSString *tableName in tables) {
        
        NSString *strTmp = [NSBundle.mainBundle localizedStringForKey:key value:nil table:tableName];
        locaString = strTmp;
        if ([strTmp isEqual:key]) {
            continue;
        } else {
            break;
        }
    }
    
  
    return locaString;
    
    
}

@end
