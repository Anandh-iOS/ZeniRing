//
//  NSObject+Tool.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/8/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Tool)
-(void)mainThreadDelayAfter:(float)second Blk:(void(^)(void))block;

@end

NS_ASSUME_NONNULL_END
