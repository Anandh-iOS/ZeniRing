//
//  ReadyDrawObj.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/22.
//

#import "ReadyDrawObj.h"
#import "TimeUtils.h"
//#import "tools.h"
#import "DBTables.h"
#import "DeviceCenter.h"
#import "NotificationNameHeader.h"
#import <YYKit.h>

@implementation ReadyDrawObj

//-(void)startDraw {
//
//    [self createTestData];
//    if (self.readyDrawDataBlk) {
//        self.readyDrawDataBlk(self.valuesArray);
//    }
//
//}

- (instancetype)initWithType:(ReadyDrawObjType)type
{
    self = [super init];
    if (self) {
        self.readyDrawObjType = type;
    }
    return self;
}

-(void)clean {
    self.maxValue = nil;
    self.minValue = nil;
    self.avgValue = nil;
    self.maxIndex = nil;
    self.minIndex = nil;
    [self.valuesArray removeAllObjects];
}

-(void)queryHeartRateData:(NSDate *)begin End:(NSDate *)end
{
    
    DB_WEAK_SELF
    [DBHeartRate queryBy:[DeviceCenter instance].bindDevice.macAddress Begin:begin End:end OrderBeTimeDesc:NO Cpmplete:^(NSMutableArray<DBHeartRate *> * _Nonnull results, NSNumber *maxHr, NSNumber *minHr,NSNumber *avgHr) {
        DB_STRONG_SELF
        // @"time" : date, @"value"
        strongSelf.valuesArray = [NSMutableArray new];
        strongSelf.maxValue = nil;
        strongSelf.minValue = nil;
        if (results.count == 0) {
            strongSelf.maxValue = nil;
            strongSelf.minValue = nil;
            strongSelf.avgValue = nil;
            [strongSelf.valuesArray removeAllObjects];
            [[NSNotificationCenter defaultCenter]postNotificationOnMainThreadWithName:NOTI_NAME_SLEEP_HRV_QUERY_READY
                                                                               object:nil];
            return;
        }
        __block double maxVal = 0;
        __block double  minVal = 0;
        __block double avgVal = 0;
        for (int i = 0; i < results.count; i++) {
            DBHeartRate *  obj = results[i];
            
            if (i > 0 && obj.value.doubleValue - results[i-1].value.doubleValue >= 40) {
                obj.value = @( (obj.value.doubleValue + results[i-1].value.doubleValue) / 2 );

            }
            
            NSDictionary *dict = @{@"time": obj.time,
                                   @"value" : obj.value,
            };
            
            [strongSelf.valuesArray addObject:dict];
            
        }
//        [results enumerateObjectsUsingBlock:^(DBHeartRate * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//
//
//
//        }];
        [strongSelf.valuesArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (idx == 0) {
                maxVal =[obj[@"value"] doubleValue];
                minVal = maxVal;
                strongSelf.maxIndex = @(idx);
                strongSelf.minIndex = @(idx);
            } else {
                if ([obj[@"value"] doubleValue] > maxVal) {
                    maxVal = [obj[@"value"] doubleValue];
                    strongSelf.maxIndex = @(idx);

                }
                if ([obj[@"value"] doubleValue] < minVal) {
                    minVal = [obj[@"value"] doubleValue];
                    strongSelf.minIndex = @(idx);
                }
            }
            
            avgVal += [obj[@"value"] doubleValue];
        }];
        
        avgVal /= results.count;
        strongSelf.maxValue = @(maxVal);
        strongSelf.minValue = @(minVal);
        strongSelf.avgValue = @(avgVal);
        // 发通知
        [[NSNotificationCenter defaultCenter]postNotificationOnMainThreadWithName:NOTI_NAME_SLEEP_HEART_RATE_QUERY_READY object:nil];
//        if (strongSelf.readyDrawDataBlk) {
//            strongSelf.readyDrawDataBlk(strongSelf.valuesArray);
//        }
        
    }];
    
}

-(void)queryHRVData:(NSDate *)begin End:(NSDate *)end
{
    DB_WEAK_SELF
    [DBHrv queryBy:[DeviceCenter instance].bindDevice.macAddress Begin:begin End:end OrderBeTimeDesc:NO Cpmplete:^(NSMutableArray<DBHrv *> * _Nonnull results, NSNumber *maxHrv, NSNumber *minHrv, NSNumber *avgHrv) {
        DB_STRONG_SELF
        // @"time" : date, @"value"
        strongSelf.valuesArray = [NSMutableArray new];
        strongSelf.maxValue = nil;
        strongSelf.minValue = nil;
        if (results.count == 0) {
            strongSelf.maxValue = nil;
            strongSelf.minValue = nil;
            strongSelf.avgValue = nil;
            [strongSelf.valuesArray removeAllObjects];
            [[NSNotificationCenter defaultCenter]postNotificationOnMainThreadWithName:NOTI_NAME_SLEEP_HRV_QUERY_READY
                                                                               object:nil];
            return;
        }
        
        __block double maxVal = 0;
        __block double  minVal = 0;
        __block double avgVal = 0;
        [results enumerateObjectsUsingBlock:^(DBHrv * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dict = @{@"time": obj.time,
                                   @"value" : obj.value,
            };
            [strongSelf.valuesArray addObject:dict];
            
            if (idx == 0) {
                maxVal = obj.value.doubleValue;
                minVal = maxVal;
            } else {
                if (obj.value.doubleValue > maxVal) {
                    maxVal = obj.value.doubleValue;
                }
                if (obj.value.doubleValue < minVal) {
                    minVal = obj.value.doubleValue;
                }
            }
            
            avgVal += obj.value.doubleValue;
            
        }];
        avgVal /= results.count;
        strongSelf.maxValue = @(maxVal);
        strongSelf.minValue = @(minVal);
        strongSelf.avgValue = @(avgVal);
        
        [[NSNotificationCenter defaultCenter]postNotificationOnMainThreadWithName:NOTI_NAME_SLEEP_HRV_QUERY_READY
                                                                           object:nil];

        
    }];
    
    
}

-(void)queryTemperatureFluData:(NSDate *)begin End:(NSDate *)end
{
    DB_WEAK_SELF
    [DBThermemoter queryBy:[DeviceCenter instance].bindDevice.macAddress Begin:begin EndDate:end OrderBeTimeDesc:NO Cpmplete:^(NSMutableArray<DBThermemoter *> * _Nonnull results,  NSNumber *maxThermemoter, NSNumber *minThermemoter, NSNumber *avgThermemoter) {
        DB_STRONG_SELF
        strongSelf.valuesArray = [NSMutableArray new];
        strongSelf.maxValue = nil;
        strongSelf.minValue = nil;
        if (results.count == 0) {
            strongSelf.maxValue = nil;
            strongSelf.minValue = nil;
            strongSelf.avgValue = nil;
            [strongSelf.valuesArray removeAllObjects];
            [[NSNotificationCenter defaultCenter]postNotificationOnMainThreadWithName:NOTI_NAME_SLEEP_HRV_QUERY_READY
                                                                               object:nil];
            return;
        }
        
        __block double maxVal = 0;
        __block double  minVal = 0;
        __block double avgVal = 0;
        [results enumerateObjectsUsingBlock:^(DBThermemoter * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dict = @{@"time": obj.time,
                                   @"value" : obj.value,
            };
            [strongSelf.valuesArray addObject:dict];
            
            if (idx == 0) {
                maxVal = obj.value.floatValue;
                minVal = maxVal;
            } else {
                if (obj.value.floatValue > maxVal) {
                    maxVal = obj.value.floatValue;
                }
                if (obj.value.floatValue < minVal) {
                    minVal = obj.value.floatValue;
                }
            }
            
            avgVal += obj.value.floatValue;
            
        }];
        
        float tempAvg = avgVal / results.count;
        if (fabs(round(tempAvg * 10)) < 1.0f) {
            tempAvg = 0.f;
        }
        
        avgVal = tempAvg;//results.count;
        strongSelf.maxValue = @(maxVal);
        strongSelf.minValue = @(minVal);
        strongSelf.avgValue = @(avgVal);
        
        [[NSNotificationCenter defaultCenter]postNotificationOnMainThreadWithName:NOTI_NAME_SLEEP_TEMPERATURE_QUERY_READY
                                                                           object:nil];
       
    }];
}


-(void)createTestData {
//
//    self.avgValue = @(58);
//    self.maxValue = @(70);
//    self.minValue = @(50);
//
//    NSDate *startDate = [TimeUtils zeroOfDate:[NSDate date]]; // 当天0点
//    NSTimeInterval startTimeInterval = [startDate timeIntervalSince1970];
//    self.valuesArray = [NSMutableArray arrayWithCapacity:16];
//    for (int i = 0 ; i < 16; i++) {
//        NSDictionary *dict = nil;
//        NSNumber *val = @( [tools getRandomNumber:50 to:70]);
//
//        if (i == 0) {
//            dict = @{ @"time" : startDate, @"value" : val };
//        } else {
//            NSDate *date = [NSDate dateWithTimeIntervalSince1970:startTimeInterval + 30 * 60 * i];
//            dict = @{ @"time" : date, @"value" : val };
//        }
//
//        self.valuesArray[i] = dict;
//
//    }
//
    
    
}


@end
