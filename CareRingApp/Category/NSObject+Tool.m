//
//  NSObject+Tool.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/8/29.
//

#import "NSObject+Tool.h"

@implementation NSObject (Tool)
-(void)mainThreadDelayAfter:(float)second Blk:(void(^)(void))block
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (block) {
            block();
        }
        
    });
}
@end
