//
//  SleepTimeDrawObj.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/7/18.
//  总体控制睡眠画图

#import "SleepTimeDrawObj.h"
#import "TimeUtils.h"

@implementation SleepTimeDrawObj



/// 测试数据
//-(void)testData {
//    double hours = 8.0f; // 时间跨度 小时
//    NSDate *endDate = [NSDate date]; // 睡眠结束时间
//    NSTimeInterval endInterval = [endDate timeIntervalSince1970];
//    
//    NSTimeInterval timeInterVal = hours * 3600; // 总时间跨度
//    
//    NSTimeInterval startInterval = endInterval - timeInterVal; // 睡眠开始时间
//    self.startSleepTimeInterval = @(startInterval);
//    self.endSleepTimeInterval = @(endInterval);
//    
////    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startInterval]; // 睡眠开始时间
//    self.sleepObjArray = [NSMutableArray new];
//    
// 
//    
//    SleepObj *temp = [self createTestSleepObj:NREM1 HR:@80 Start:endInterval - hours*3600  Hours:1 TotalIntreVal:&hours];
//    [self.sleepObjArray addObject:temp];
//    
//    temp = [self createTestSleepObj:NREM3 HR:@80 Start:endInterval - hours*3600 Hours:1 TotalIntreVal:&hours];
//    [self.sleepObjArray addObject:temp];
//    
//    temp = [self createTestSleepObj:NREM1 HR:@80 Start:endInterval - hours*3600 Hours:0.5 TotalIntreVal:&hours];
//    [self.sleepObjArray addObject:temp];
//    
//    temp = [self createTestSleepObj:REM HR:@80 Start:endInterval - hours*3600 Hours:1 TotalIntreVal:&hours];
//    [self.sleepObjArray addObject:temp];
//
//    temp = [self createTestSleepObj:NREM1 HR:@80 Start:endInterval - hours*3600 Hours:2 TotalIntreVal:&hours];
//    [self.sleepObjArray addObject:temp];
//
//    temp = [self createTestSleepObj:NREM3 HR:@80 Start:endInterval - hours*3600 Hours:1.5 TotalIntreVal:&hours];
//    [self.sleepObjArray addObject:temp];
//
//    temp = [self createTestSleepObj:WAKE HR:@80 Start:endInterval - hours*3600 Hours:1 TotalIntreVal:&hours];
//    [self.sleepObjArray addObject:temp];
//
//    if (self.readyDrawDataBlk) {
//        self.readyDrawDataBlk();
//    }
//    
//}

-(SleepObj *)createTestSleepObj:(SleepStagingType)sleepType HR:(NSNumber *)hr Start:(NSTimeInterval)start  Hours:(NSTimeInterval)hours TotalIntreVal:(double *)totalIntreVal
{
    SleepObj *obj = [[SleepObj alloc]init];
    obj.sleepType = sleepType;
    obj.hrObjArray = [NSMutableArray new];
    SleepHrObj *hrObjStart = [[SleepHrObj alloc]initWithHr:hr Time:@(start)];
    SleepHrObj *hrObjEnd = [[SleepHrObj alloc]initWithHr:hr Time:@(start + hours * 3600)];
    *totalIntreVal -= hours;
    [obj.hrObjArray addObject:hrObjStart];
    [obj.hrObjArray addObject:hrObjEnd];
    
    return obj;
}

@end
