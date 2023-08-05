//
//  ActivityObj.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/16.
//  用户活动的画图和数据展示

#import "ActivityObj.h"
#import "ConfigModel.h"
#import "BarDrawView.h"
//#import "tools.h"
#import "DBTables.h"
#import "TimeUtils.h"
#import <DateTools/DateTools.h>

@implementation ActivityObj


-(NSString *)titleString {
    NSString *txt = nil;
    switch (self.type) {
        case ACTIVITYOBJ_TYPE_HR:
        {
            txt = _L(L_BAR_DRAW_TITLE_HR);
        }
            break;
        case ACTIVITYOBJ_TYPE_HRV:
        {
            txt = _L(L_BAR_DRAW_TITLE_HRV);

        }
            break;
        case ACTIVITYOBJ_TYPE_TEMP:
        {
            txt = _L(L_BAR_DRAW_TITLE_TEMP);
        }
            break;
            
        default:
            break;
    }
    return txt;
}

-(UIImage *)typeImage {
    UIImage *image = nil;
    switch (self.type) {
        case ACTIVITYOBJ_TYPE_HR:
        {
            image = [UIImage imageNamed:@"active_hr"];
        }
            break;
        case ACTIVITYOBJ_TYPE_HRV:
        {
            image = [UIImage imageNamed:@"active_hrv"];

        }
            break;
        case ACTIVITYOBJ_TYPE_TEMP:
        {
            image = [UIImage imageNamed:@"active_temp"];

        }
            break;
            
        default:
            break;
    }
    
    return image;
}

-(NSString *)unitString {
    NSString *txt = nil;
    switch (self.type) {
        case ACTIVITYOBJ_TYPE_HR:
        {
            txt = _L(L_UNIT_HR);
        }
            break;
        case ACTIVITYOBJ_TYPE_HRV:
        {
            txt = _L(L_UNIT_MS);

        }
            break;
        case ACTIVITYOBJ_TYPE_TEMP:
        {
        
            txt = _L(L_UNIT_TEMP_C); // 摄氏度

            

        }
            break;
            
        default:
            break;
    }
    
    return txt;
}


-(NSMutableArray<NSNumber *> *)barDrawVerticalCoordinate
{
   
    // 纵坐标
    NSArray *res = nil;
    switch (self.type) {
        case ACTIVITYOBJ_TYPE_HR:
        {
            res = @[@(100), @(40), ];
        }
            break;
        case ACTIVITYOBJ_TYPE_HRV:
        {
            
            res = @[@(150), @(100), @(50),];
        }
            break;
        case ACTIVITYOBJ_TYPE_TEMP:
        {
           
            res = @[@(3.0f), @(2.0f), @(1.0f), @(0.0f), @(-1.0f),];
        }
            break;
            
        default:
            break;
    }
    NSMutableArray *resAll = [NSMutableArray arrayWithArray:res];
    
    return resAll;
}

// 动态计算Y标签坐标
-(NSMutableArray<NSNumber * > *)calcRealVerticalCoordinate:(NSNumber *)max Min:(NSNumber *)min {
    NSMutableArray *res = [NSMutableArray new];
    if (max == nil && min == nil) {
        return [self barDrawVerticalCoordinate];
    }
    switch (self.type) {
        case ACTIVITYOBJ_TYPE_HR:
        {
//            DebugNSLog(@"首页 心率 max=%@ min=%@ ", max, min);
            int step = 0;
            if (max.intValue - min.intValue >= 100) {
                step = 50;
            } else {
                step = 25;
            }
            // 按跨度上下取整
            
            int labelMax = max.intValue % step == 0 ? max.intValue : (max.intValue + step)/step * step;
            int labelMin = min.intValue / step * step;
            
            for (int i = labelMax;  i >= labelMin; i-= step) {
                [ res addObject:@(i)];
                
            }
//            [res insertObject:max atIndex:0];
//            [res addObject:@(min.intValue/10 * 10)];
            
        }
            break;
        case ACTIVITYOBJ_TYPE_HRV:
        {
            int step = 50;
            int labelMax = max.intValue % step == 0 ? max.intValue : (max.intValue + step)/step * step;
            int labelMin = min.intValue / step * step;
            for (int i = labelMax;  i >= labelMin; i-= step) {
                [ res addObject:@(i)];
                
            }
//            [res insertObject:max atIndex:0];
//            [res addObject:@(min.intValue/10 * 10)];
        }
            break;
        case ACTIVITYOBJ_TYPE_TEMP:
        {
            float step = 1;
           
            for (int i = (int)(max.floatValue + step);  i >= (int)(min.floatValue - step); i-= step) {
                [ res addObject:@(i)];
                
            }
//            [res insertObject:max atIndex:0];
//            [res addObject:min];
        }
            break;
            
        default:
            break;
    }
    
    return res;
}

-(void)queryData:(NSDate *)date Macaddress:(NSString *)macAddress
{

    switch (self.type) {
        case ACTIVITYOBJ_TYPE_HR:
        {
            WEAK_SELF
            NSDate *begin = [TimeUtils zeroOfDate:date];
            NSDate *end = [begin dateByAddingTimeInterval:24*3600];
            
            [DBHeartRate queryBy:macAddress Begin:begin End:end OrderBeTimeDesc:NO Cpmplete:^(NSMutableArray<DBHeartRate *> * _Nonnull results, NSNumber *maxHr, NSNumber *minHr, NSNumber *avgHr) {
                STRONG_SELF
                NSMutableArray<BarDrawObj *> *objArray = [NSMutableArray arrayWithCapacity:24];
                for (int i = 0; i < 24; i++) {
                    BarDrawObj * drwObj = [[BarDrawObj alloc]init];
                    drwObj.hour = i;
                    [objArray addObject:drwObj];
                }
                
                __block NSNumber *allMax = results.firstObject.value;
                __block NSNumber *allMin = results.firstObject.value;
                
                [results enumerateObjectsUsingBlock:^(DBHeartRate * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSInteger hour = [obj.time hour];
                    [objArray[hour].valueArrayOfHour addObject:obj.value];
                    
                    
                    if ([obj.value intValue] > allMax.intValue) {
                        allMax = obj.value;
                    }
                    if ([obj.value intValue] < allMin.intValue) {
                        allMin = obj.value;
                    }
                }];
                for (BarDrawObj *obj in objArray) {
                    [obj sortValueAsc:YES];
                }
                
                strongSelf.allMaxValue = allMax;
                strongSelf.allMinVaue = allMin;
                
                strongSelf.cacheObjArray = objArray;
                if (strongSelf.readyDrawDataBlk) {
                    strongSelf.readyDrawDataBlk(objArray, allMax, allMin);
                }
                
                if (results.count) {
                    strongSelf.maxTimeInDate = @([results.lastObject.time timeIntervalSince1970]);
                    strongSelf.averageInDate = results.firstObject.value;
                } else {
                    strongSelf.maxTimeInDate = nil;
                    strongSelf.averageInDate = nil;
                }
                if (strongSelf.showValueBlk) {
                    strongSelf.showValueBlk(strongSelf.averageInDate, strongSelf.maxTimeInDate);
                }
                
            }];
            
  
        }
            break;
        case ACTIVITYOBJ_TYPE_HRV:
        {
           
        }
            break;
        case ACTIVITYOBJ_TYPE_TEMP:
        {}
            break;
            
        default:
            break;
    }
        
}



@end
