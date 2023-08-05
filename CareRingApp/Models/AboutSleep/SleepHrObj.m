//
//  SleepHrObj.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/7/18.
//

#import "SleepHrObj.h"

@implementation SleepHrObj

- (instancetype)initWithHr:(NSNumber *)hr Time:(NSNumber *)time
{
    self = [super init];
    if (self) {
        self.hr = hr;
        self.time = time;
    }
    return self;
}

@end
