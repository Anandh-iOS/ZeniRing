//
//  DeviceCenter.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/7.
//  设备中心

#import "DeviceCenter.h"
#import "ConfigModel.h"

#import "DBTables.h"
#import "NotificationNameHeader.h"
#import "TimeUtils.h"

#import "NSString+Check.h"
#import "OTAHelper.h"
#import "OusideBleDiscovery.h"
#import "sleepScoreData.h"
#import "goalValues.h"
const NSTimeInterval AUTO_SCAN_TIME_OUT = 120;//120;

NSString * const CP_NAME = @"Linktop";

@interface DeviceCenter ()


@property(assign, nonatomic)BOOL autoConnectOn;
@property(strong, nonatomic)NSTimer *autoConnectScanTimer; // 自动连接扫描超时计时器
@property(strong, nonatomic)NSTimer *batteryFreshTimer; // 自动连接扫描超时计时器

@property(assign, nonatomic)NSInteger historyCacheCount, currHisidx; //此次历史数据条目



@property(copy, nonatomic) void(^scanTimeoutBlk)(void);

@property(strong, nonatomic)NSNumber *lastSyncTimeInteval;  // 上次同步时间戳

@property(strong, nonatomic)NSMutableArray<DBSleepData *> *currentSelectDataSleepArray; //
@property(strong, nonatomic)NSMutableArray<DBSleepData *> *currentSelectNapArray; // nap array
@property(strong, nonatomic)NSMutableArray<DBHeartRate *> *currentSelectHeartRate;
@property(strong, nonatomic)NSNumber *avgActiveHeartRate;


@property(strong, nonatomic)OusideBleDiscovery *ousideBleManager;

/* 睡眠计算相关 */
@property(strong, nonatomic)dispatch_queue_t sleepQueue;

@property(strong, nonatomic)NSDate *calcSleepDate;


/* 睡眠计算相关 */

@property(assign, nonatomic)BOOL isCustomBleManage;

@end


@implementation DeviceCenter
+ (instancetype)instance {
    static DeviceCenter *_deviceCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
          // 要使用self来调用
        _deviceCenter = [[self alloc] init];
        [[LTSRingSDK instance] registWithCompany:CP_NAME];
    });
    return _deviceCenter;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self->_sdk = [LTSRingSDK instance];
        self.sdk.blescanDelegate = self;
        self.sdk.bleDataDelegate = self;
        self.sleepQueue = dispatch_queue_create("sleep_queue", DISPATCH_QUEUE_SERIAL);
      
    }
    return self;
}

-(void)registWithisCustomBleManage:(BOOL)isCustomBleManage
{
    self.isCustomBleManage = isCustomBleManage;
    if (isCustomBleManage) {
        self.ousideBleManager = [[OusideBleDiscovery alloc]init];
        self.ousideBleManager.scanDelegate = self;
    }
}


//开启自动连接
-(void)startAutoConnect:(void (^)(void))scanTimeoutBlk
{
    if (self.bindDevice) {
        self.autoConnectOn = YES;
        [self.autoConnectScanTimer invalidate];
        self.scanTimeoutBlk = scanTimeoutBlk;
        WEAK_SELF
        self.autoConnectScanTimer = [NSTimer scheduledTimerWithTimeInterval:AUTO_SCAN_TIME_OUT repeats:NO block:^(NSTimer * _Nonnull timer) {
            STRONG_SELF
            if (strongSelf.scanTimeoutBlk) {
                strongSelf.scanTimeoutBlk(); // 回调超时
            }
        }];
        [self startBleScan];
        
    }
}

-(void)cancelAutoCOnnect {
    [self.autoConnectScanTimer invalidate];
    [self stopBleScan];
    
}



/// 设备列表刷新
/// @param perphelArray  scaned devices
-(void)srScanDeviceDidRefresh:(NSArray<SRBLeService *> *)perphelArray
{
    if ([self.appScanDelegate respondsToSelector:@selector(srScanDeviceDidRefresh:)]) {
        [self.appScanDelegate srScanDeviceDidRefresh:perphelArray];
    }
    
    // 自动连接
    if (self.bindDevice != nil && self.autoConnectOn) {
        WEAK_SELF
        [perphelArray enumerateObjectsUsingBlock:^(SRBLeService * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            STRONG_SELF
            DebugNSLog(@"found devcie: %@", obj.macAddress);
            if ([obj.macAddress isEqual:strongSelf.bindDevice.macAddress]) {
                // 自动连接
                [strongSelf connectDevice:obj];
                [strongSelf stopBleScan];

                *stop = YES;
            }
        }];
    }
    
//    if (self.bindDevice && self.autoConnectOn) {
//
//        // 自动连接
//        [perphelArray enumerateObjectsUsingBlock:^(SRBLeService * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if ([obj.macAddress isEqual:self.bindDevice.macAddress]) {
//                [[LTSRingSDK instance] connectDevice:obj];
//            }
//        }];
//
//    }

}


/// 同步设备历史数据
-(BOOL)startSyncDeviceCacheData {
    
    if (self.lastSyncTimeInteval) {
        
        NSDate *date = [NSDate date];
        if ([date timeIntervalSince1970] - self.lastSyncTimeInteval.doubleValue < 30 * 60) {
            return NO; //半小时内不同步
        }
    }
    
    [self.sdk functionGetHistoryData]; //发送蓝牙指令
    self.lastSyncTimeInteval = @([[NSDate date] timeIntervalSince1970]); //防止重复下发
    return YES;
}


-(void)startBleScan {
    DebugNSLog(@"ble CBManagerState: %ld", (long)self.sdk.bleCenterManagerState);
    if (self.isCustomBleManage) {
        [self.ousideBleManager startScanning];
    } else {
        [self.sdk startBleScan];
    }
}

-(void)stopBleScan {
    if (self.isCustomBleManage) {
        [self.ousideBleManager stopScanning];
    } else {
        [self.sdk stopBleScan];

    }
}

-(void)connectDevice:(SRBLeService *)device {
    if (self.isCustomBleManage) {
        [self.ousideBleManager connectPeripheral:device];
    } else {
        [self.sdk connectDevice:device];
    }
}

-(void)disconnectCurrentService {
    if (self.isCustomBleManage) {
        [self.ousideBleManager disconnectPeripheral:self.sdk.currentDevice];
    } else {
        [self.sdk disconnectCurrentService];

    }
    
}

// 当前已连接的设备
-(SRBLeService *)currentDevice {
    return [self.sdk currentDevice];
}
-(BOOL)isBleConnected
{
    BOOL isconnected = [self.sdk currentDevice] != nil && [self.sdk currentDevice].peripheral.state == CBPeripheralStateConnected;
    
    return isconnected;
}



-(void)bindCurrentDevice
{
    WEAK_SELF
    [self.sdk functionSetBindeDevice:YES]; // 下发指令标记设备已被绑定
    if (self.bindDevice == nil) {
        // 保存db
        DBDevices  *device = [[DBDevices alloc]init];
        device.macAddress = self.sdk.currentDevice.macAddress;
        [device insert:^(BOOL succ) {
            STRONG_SELF
            strongSelf->_bindDevice = device;
            NSLog(@"插入绑定设备  %d", succ);
//            if (self.bindFinishCbk) {
//                self.bindFinishCbk(NO);
//            }
//            [self.sdk functionGetDeviceSN];
        }];
    } else {
        // 绑定未被绑定过的设备
        [self.bindDevice deleteFromTable:^{
            STRONG_SELF
            DBDevices  *device = [[DBDevices alloc]init];
            device.macAddress = strongSelf.sdk.currentDevice.macAddress;
            [device insert:^(BOOL succ) {
                STRONG_SELF
                strongSelf->_bindDevice = device;
                NSLog(@"插入绑定设备  %d", succ);
//                if (strongSelf.bindFinishCbk) {
//                    strongSelf.bindFinishCbk(NO);
//                }
//                [strongSelf.sdk functionGetDeviceSN];

            }];
            strongSelf->_bindDevice = device;
        }];
    }
}

-(void)unbindCurrentDevice:(void (^ _Nullable)(void))cmpBlk
{
    WEAK_SELF
    if (self.bindDevice) {
        [self.bindDevice deleteFromTable:^{
        STRONG_SELF
            strongSelf->_bindDevice = nil;
            if (cmpBlk) {
                cmpBlk();
            }
        }];
       
    }
    
}

#pragma mark -- 睡眠相关
-(void)querySleep:(NSDate *)date
{

    self.calcSleepDate = date;
    // 0 通知日期变更,其他界面各自查询
    [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:NOTI_NAME_SLEEP_DATE_CHANGE object:self.calcSleepDate];
    
    /* 计算睡眠*/

    // 测试
    WEAK_SELF
    NSDate *beginDate = [TimeUtils zeroOfBeforeDayDate:self.calcSleepDate];
    NSDate *endDate = [TimeUtils zeroOfDate:self.calcSleepDate];
    // query sleep data
    [DBSleepData queryDbSleepBy:self.bindDevice.macAddress Begin:[beginDate timeIntervalSince1970] EndTime:[endDate timeIntervalSince1970] Comp:^(NSMutableArray<DBSleepData *> * _Nonnull results) {
        STRONG_SELF
#if DEBUG
        // test nap show
//        DBSleepData *napData = [[DBSleepData alloc]init];
//        napData.isNap = YES;
//        napData.sleepStart = @(1685577600);
//        napData.sleepEnd = @(napData.sleepStart.doubleValue + 3600);
//        StagingDataV2 *stage = [[StagingDataV2 alloc]init];
//        stage.startTime = napData.sleepStart.doubleValue;
//        stage.endTime = napData.sleepEnd.doubleValue;
//        napData.stagingData = stage;
//

//        DBSleepData *napData2 = [[DBSleepData alloc]init];
//        napData2.isNap = YES;
//        napData2.sleepStart = @(1685577600 + 7200);
//        napData2.sleepEnd = @(napData2.sleepStart.integerValue + 3600);
//        StagingDataV2 *stage2 = [[StagingDataV2 alloc]init];
//        stage2.startTime = napData.sleepStart.doubleValue;
//        stage2.endTime = napData.sleepEnd.doubleValue;
//        napData2.stagingData = stage2;
//
//        [results addObjectsFromArray:@[napData, napData2]];

#endif
        if (results.count) { //
            strongSelf.currentSelectDataSleepArray = [NSMutableArray new];
            strongSelf.currentSelectNapArray = [NSMutableArray new];
            
            [results enumerateObjectsUsingBlock:^(DBSleepData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.isNap) {
                    [strongSelf.currentSelectNapArray addObject:obj];
                } else {
                    [strongSelf.currentSelectDataSleepArray addObject:obj];
                }
                
            }];


            [strongSelf otherQueryAfterQueryOrCalcSleep:NO];

            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:NOTI_NAME_SLEEP_CALC_FINISH
                               
                                                                                object:nil]; // notify sleep query finish

        } else {
            
            
#if DEBUG
            // Create a start timestamp for the week (adjust as needed)
            NSTimeInterval startTimestamp = [[NSDate date] timeIntervalSince1970];
            
            // Create an array to store the dummy sleep data objects
            NSMutableArray<DBSleepData *> *dummySleepDataArray = [NSMutableArray array];
            
            // Generate dummy sleep data for a week (7 days)
            for (int i = 0; i < 7; i++) {
                // Create a new DBSleepData object
                DBSleepData *dummySleepData = [[DBSleepData alloc] init];
                
                // Assign dummy values to the properties
                dummySleepData.sleepStart = @(startTimestamp);
                dummySleepData.sleepEnd = @(startTimestamp + (8 * 3600)); // 8 hours of sleep
                dummySleepData.dateString = [NSString stringWithFormat:@"Date %d", i + 1];
                dummySleepData.macAddress = @"00:11:22:33:44:55";
                dummySleepData.hr = @(65 + (arc4random() % 10)); // Random HR value
                dummySleepData.hrv = @(55 + (arc4random() % 10)); // Random HRV value
                dummySleepData.br = @(12 + (arc4random() % 3)); // Random BR value
                dummySleepData.spo2 = @(97 + (arc4random() % 2)); // Random SpO2 value
                dummySleepData.hrDip = @(0.2 + (arc4random() % 3) / 10.0); // Random HR Dip value
                dummySleepData.duration = @(8 * 3600); // 8 hours in seconds
                dummySleepData.qulalityDuration = @(7 * 3600); // 7 hours in seconds
                dummySleepData.deepDuration = @(3 * 3600); // 3 hours in seconds
                dummySleepData.effieiency = @(85 + (arc4random() % 5)); // Random efficiency value
                // Assuming StagingDataV2 is another object, you would create and assign it here
                
                dummySleepData.isNap = NO; // Not a nap
                
                // Add the dummy sleep data object to the array
                [dummySleepDataArray addObject:dummySleepData];
                
                // Increment the start timestamp for the next day
                startTimestamp += 24 * 3600; // 24 hours in seconds
            }
            ////////////////////////////////////////////////////////////////////////////////
            
            strongSelf.currentSelectDataSleepArray = dummySleepDataArray; //nil by default, changed to add dummy data
#endif
            
            [strongSelf otherQueryAfterQueryOrCalcSleep:YES];
           

            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:NOTI_NAME_SLEEP_CALC_FINISH
                               
                                                                                object:nil]; //
        }
    
    }];
    

}


-(void)queryhearRate:(NSDate *)date
{
    NSDate *begin = [TimeUtils zeroOfDate:date];
    NSDate *end = [TimeUtils zeroOfBeforeDayDate:date];
    WEAK_SELF
    [DBHeartRate queryBy:[DeviceCenter instance].bindDevice.macAddress Begin:begin End:end OrderBeTimeDesc:YES Cpmplete:^(NSMutableArray<DBHeartRate *> * _Nonnull results, NSNumber *maxHr, NSNumber *minHr,NSNumber *avgHr) {

        if (results.count) { //
            self.currentSelectDataSleepArray = [NSMutableArray new];
            self.currentSelectNapArray = [NSMutableArray new];
            
            [results enumerateObjectsUsingBlock:^(DBHeartRate * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.currentSelectHeartRate addObject:obj];
                
            }];
            
            self.avgActiveHeartRate = avgHr;

            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:NOTI_NAME_SLEEP_HEART_RATE_QUERY_READY
                               
                                                                                object:nil]; // notify sleep query finish
        }
        
       
        
    }];

}

-(NSDictionary *)getSleepData :(SLEEP_CONTRI)SleepContriType
{
    
    // Create a dictionary to map SLEEP_CONTRI values to property keys
    NSDictionary<NSNumber *, NSString *> *SleepDataMapping = @{
        @(CONTRI_TOTAL_SLEEP): @"duration",
        @(CONTRI_QUALITY_SLEEP): @"qulalityDuration",
        @(CONTRI_AVERAGE_HR): @"hr",
        @(CONTRI_DEEP_SLEEP): @"deepDuration"
    };
    // Create a dictionary to map SLEEP_CONTRI values to Goal property keys
    NSDictionary<NSNumber *, NSString *> *goalDataMapping = @{
        @(CONTRI_TOTAL_SLEEP): @"sleepValue",
        @(CONTRI_QUALITY_SLEEP): @"qualityValue",
        @(CONTRI_AVERAGE_HR): @"dipPercentage",
        @(CONTRI_DEEP_SLEEP): @"deepValue"
    };
    
    NSArray *subTitles = @[_L(L_TIEM_DETAIL_TARGET_SLEEP_DURATION),_L(L_TIEM_DATA_STR_QUALITY_SLEEP_FIN),_L(L_TIEM_DATA_STR_DEEP_SLEEP_FIN),_L(L_TIEM_DETAIL_TARGET_HRIMMERSE)];
    
    if(SleepContriType == CONTRI_TOTAL_SLEEP || SleepContriType == CONTRI_DEEP_SLEEP || SleepContriType == CONTRI_QUALITY_SLEEP)
    {
        // Initialize a variable to store the sum of durations
        NSNumber *totalDuration = @0;

        // Iterate through the array and accumulate the durations
        for (DBSleepData *sleepData in self.currentSelectDataSleepArray) {
            NSNumber *duration = @0;
            NSString *propertyKey = SleepDataMapping[@(SleepContriType)];
            
            // Check if the property key exists and is valid
            if (propertyKey && [sleepData respondsToSelector:NSSelectorFromString(propertyKey)]) {
                duration = [sleepData valueForKey:propertyKey];
            }
            
            // Check if the duration is not nil before adding it to the total
            if (duration) {
                totalDuration = @(totalDuration.doubleValue + duration.doubleValue);
            }
        }
        

        goalValues *goalData = [goalValues retrieveGoalValues];
        NSString *goalPropertyKey = goalDataMapping[@(SleepContriType)];
        NSArray *components = @[];
        NSString *goalString;
        
        if (goalPropertyKey) {
            NSString *goalVal = [goalData valueForKey:goalPropertyKey];
            components = [goalVal  componentsSeparatedByString:@" "];
            goalString = [NSString stringWithFormat:subTitles[SleepContriType], [goalData valueForKey:goalPropertyKey]];
        }
        
        // Calculate hours and minutes
        NSInteger totalDurationInMinutes = [totalDuration integerValue] / 60;
        NSInteger hours = totalDurationInMinutes / 60;
        NSInteger minutes = totalDurationInMinutes % 60;
        
        
        NSInteger Goalhours = 0;
        NSInteger Goalminutes = 0;

        if (components.count >= 2) {
            Goalhours = [[components objectAtIndex:0] integerValue];
            Goalminutes = [[components objectAtIndex:1] integerValue];
        }
        
        
        
        
        NSInteger totalDurationAInMinutes = (hours * 60) + minutes;//Actual duaration
        NSInteger totalGoalDurationInMinutes = (Goalhours * 60) + Goalminutes;//Goal Duration

        // Calculate the percentage
        NSInteger percentage = totalDurationAInMinutes / totalGoalDurationInMinutes * 100;
        

        //update the score object to calculated the scores
        
        if(SleepContriType == CONTRI_TOTAL_SLEEP)
        {[sleepScoreData sharedInstance].achievedSleepDurationPercentage =  @(percentage);}
        else if(SleepContriType == CONTRI_DEEP_SLEEP)
        {[sleepScoreData sharedInstance].achievedDeepSleepPercentage =  @(percentage);}
        else if(SleepContriType == CONTRI_QUALITY_SLEEP)
        {[sleepScoreData sharedInstance].achievedQualitSleepDurationPercentage = @(percentage);}
        
        // Format the hours and minutes 8h 0m (24%)
        NSString *formattedDuration = [NSString stringWithFormat:_L(L_TIEM_DATA_STR_SLEEP_DURATION), (long)hours, (long)minutes, percentage];
        
        NSDictionary *dict = @{@"percentage":@(percentage),
                               @"duration":totalDuration,
                               @"labelA":formattedDuration,
                               @"labelB":goalString
        };
        return  dict;
    }
    else
    {
        
        NSNumber *totalHr = @0;
        // Iterate through the array of DBSleepData objects
        for (DBSleepData *sleepData in self.currentSelectDataSleepArray) {
            // Add the hrDip value of each object to the total
            totalHr = @([totalHr floatValue] + [sleepData.hr floatValue]);
        }

        // Calculate the average hrDip value as a rounded integer
        NSNumber *averageSleepHr = @(round([totalHr floatValue] / [self.currentSelectDataSleepArray count]));
                        
        goalValues *goalData = [goalValues retrieveGoalValues];
        double hrDipPercentage = ([self.avgActiveHeartRate doubleValue] - [averageSleepHr doubleValue])/[self.avgActiveHeartRate doubleValue];
        
        [sleepScoreData sharedInstance].achievedDipPercent =  @(hrDipPercentage);
        
        NSString *dipPercentage = [NSString stringWithFormat:@"%.1f%%",isinf(hrDipPercentage) ? 0.0 : hrDipPercentage];
        NSDictionary *dict = @{@"percentage":@(hrDipPercentage),
                               @"duration":totalHr,
                               @"labelA":[NSString stringWithFormat:@"%@ %@(%@)",isnan([averageSleepHr floatValue]) ? @"--" : averageSleepHr,_L(L_UNIT_HR), dipPercentage],
                               @"labelB":[NSString stringWithFormat:_L(L_TIEM_DETAIL_TARGET_HRIMMERSE), goalData.dipPercentage]
        };
        return  dict;

    }
    
    
}




/// 查询或者计算出睡眠后的操作
-(void)otherQueryAfterQueryOrCalcSleep:(BOOL)isClean {
    
    if (isClean) {
        [self.heartRateObj clean];
        [self.hrvObj clean];
        [self.temperautreFluObj clean];
    } else {
        // 查询 用于折线图
        NSDate *sleepStartDate = [NSDate dateWithTimeIntervalSince1970:self.currentSelectDataSleepArray.firstObject.stagingData.startTime];
        NSDate *sleepEndDate = [NSDate dateWithTimeIntervalSince1970:self.currentSelectDataSleepArray.firstObject.stagingData.endTime];

        [self.heartRateObj queryHeartRateData:sleepStartDate
                                   End:sleepEndDate ];
//
        [self.hrvObj queryHRVData:sleepStartDate
                                   End:sleepEndDate];
        [self.temperautreFluObj queryTemperatureFluData:sleepStartDate  End:sleepEndDate];
    }
}


-(NSMutableArray<DBSleepData *> *)GetSleepDBData {
    return self.currentSelectDataSleepArray; // 数据库原始数据
}

-(NSMutableArray<DBSleepData *> *)GetNapSleepDBData {
    return self.currentSelectNapArray;
}

-(NSDate *)currentQueryDate {
    if (!self.calcSleepDate) {
        self.calcSleepDate = [NSDate date];
    }
    return self.calcSleepDate;
}



-(ReadyDrawObj *)heartRateObj
{
    if (!_heartRateObj) {
        _heartRateObj = [[ReadyDrawObj alloc]initWithType:ReadyDrawObjType_heareRate];
    }
    return _heartRateObj;
}
// 体温
-(ReadyDrawObj *)temperautreFluObj
{
    if (!_temperautreFluObj) {
        _temperautreFluObj = [[ReadyDrawObj alloc]initWithType:ReadyDrawObjType_TEMPERATURE];
    }
    return _temperautreFluObj;
}

-(ReadyDrawObj *)hrvObj
{
    if (!_hrvObj) {
        _hrvObj = [[ReadyDrawObj alloc]initWithType:ReadyDrawObjType_hrv];
    }
    return _hrvObj;
}

#pragma mark -- 蓝牙协议

/// phone ble power state change
/// @param isOn  YES = powerOn NO = pwoerNO
- (void)srBlePowerStateChange:(CBManagerState)state
{
    BOOL isOn = NO;
    switch (state) {
        case CBManagerStateUnsupported:// 不支持蓝牙
        {
            //不支持
            DebugNSLog(@"StateChange = CBManagerStateUnsupported");
        }
            break;
        case CBManagerStatePoweredOff:// 未启动
        {
            DebugNSLog(@"StateChange = CBManagerStatePoweredOff");

           
        }
            break;
        case CBManagerStateUnauthorized: // 未授权
        {
            /* Tell user the app is not allowed. */
            DebugNSLog(@"StateChange = CBManagerStateUnauthorized");

        }
            break;
        case CBManagerStateUnknown: // 未知
        {
            /* Bad news, let's wait for another event. */
            DebugNSLog(@"StateChange = CBManagerStateUnknown");

        }
            break;
        case CBManagerStatePoweredOn:// 开启
        {
            DebugNSLog(@"StateChange = CBManagerStatePoweredOn");

            isOn = YES;
        }
            break;
        case CBManagerStateResetting:// 重置中
        {
            DebugNSLog(@"StateChange = CBManagerStateResetting");

            break;
        }
    }
    
    if (!isOn) {
        [self disconnectCurrentService];
    }
    
    if ([self.appScanDelegate respondsToSelector:@selector(srBlePowerStateChange:)]) {
        [self.appScanDelegate srBlePowerStateChange:state];
    }
    
}

- (void)srBleCmdExcute:(EXCUTED_CMD)cmd Succ:(BOOL)isSucc {
    if ([self.appDataDelegate respondsToSelector:@selector(srBleCmdExcute:Succ:)]) {
        [self.appDataDelegate srBleCmdExcute:cmd Succ:isSucc];
    }
}

- (void)srBleDeviceBatteryLevel:(NSUInteger)batteryLevel IsCharging:(BOOL)isCharging {
    _currentBatteryLevel = batteryLevel;
    _isCharging = isCharging;
//    DebugNSLog(@"电量 %lu 充电: %d", (unsigned long)batteryLevel, isCharging);
    if ([self.appDataDelegate respondsToSelector:@selector(srBleDeviceBatteryLevel:IsCharging:)]) {
        [self.appDataDelegate srBleDeviceBatteryLevel:batteryLevel IsCharging:isCharging];
    }
  
}

- (void)srBleDeviceDidReadyForReadAndWrite:(nonnull SRBLeService *)service {
    if ([self.appDataDelegate respondsToSelector:@selector(srBleDeviceDidReadyForReadAndWrite:)]) {
        [self.appDataDelegate srBleDeviceDidReadyForReadAndWrite:service];
    }
  
    // 获取信息
    [self.sdk functionGetDeviceInfo];
 
    
}

- (void)srBleDeviceInfo:(nonnull SRDeviceInfo *)devInfo {
    
    if (devInfo) {
//        if(!self.bindDevice)
//        {
//            self.bindDevice = [[DBDevices alloc] init];
//            self.bindDevice.macAddress = devInfo.bleMacAddress;
//        }
        
        self.bindDevice.otherInfo.fireWareVersion = devInfo.softWareVersion;
        self.bindDevice.otherInfo.size = devInfo.size;
        self.bindDevice.otherInfo.color = devInfo.color;
        self.bindDevice.otherInfo.mainChipType = self.sdk.currentDevice.mainChipType;
        self.bindDevice.otherInfo.deviceGeneration = self.sdk.currentDevice.deviceGeneration;
        [self.bindDevice updateOtherInfo:^(BOOL succ) {
            [self checkNeedUpdate];// 检查更新
            
        }];
    }
    if ([self.appDataDelegate respondsToSelector:@selector(srBleDeviceInfo:)]) {
        [self.appDataDelegate srBleDeviceInfo:devInfo];
    }

}

-(void)srBleOEMAuthResult:(BOOL)authSucceddful
{
    
    // get battery
    [self.sdk functionGetDeviceBattery];

  
    
    if ([self.appDataDelegate respondsToSelector:@selector(srBleOEMAuthResult:)]) {
        [self.appDataDelegate srBleOEMAuthResult:authSucceddful];
    }
    if (authSucceddful) {
        // sync history data
        [self startSyncDeviceCacheData];
        // get device's measure duration
        [self.sdk functionGetDeviceMeasureDuration];
    }
    
}

-(void)srBleMeasureDuration:(NSInteger)seconds
{
    self.currentDevice.hrMeasureDurations = seconds;
    if ([self.appDataDelegate respondsToSelector:@selector(srBleMeasureDuration:)]){
        [self.appDataDelegate srBleMeasureDuration:seconds];
    }
}

- (void)srBleDidConnectPeripheral:(nonnull SRBLeService *)service {
    
    [self stopBleScan];
    
    [self.autoConnectScanTimer invalidate];// 扫描超时定时器
    self.autoConnectOn = NO;
    self.lastSyncTimeInteval = nil;

    [self.sdk setCurrentPeripheralService:service];// important
    
    if ([self.appScanDelegate respondsToSelector:@selector(srBleDidConnectPeripheral:)]) {
        [self.appScanDelegate srBleDidConnectPeripheral:service];
    }
    
}

- (void)srBleDidDisconnectPeripheral:(nonnull SRBLeService *)service {
    
    _currentBatteryLevel = 0;
    _isCharging = NO;
    
    if ([self.appScanDelegate respondsToSelector:@selector(srBleDidDisconnectPeripheral:)]) {
        [self.appScanDelegate srBleDidDisconnectPeripheral:service];
    }
    [self.batteryFreshTimer invalidate];
    self.autoConnectOn = NO;
   self.lastSyncTimeInteval = nil;
    [self.sdk setCurrentPeripheralService:nil];// important

}

/// 历史记录条数
- (void)srBleHistoryDataCount:(NSInteger)count {
    DebugNSLog(@"历史总数 %ld", count);
    self.historyCacheCount = count;
    self.currHisidx = 0;
    DebugNSLog(@"lzp srBleHistoryDataCount: %ld", (long)count);

    if (self.historyCacheCount == 0) {
        if (self.historySyncCbk) {
            self.historySyncCbk(YES, 1, 1);
        }
    }
}



/// call back value of history data SR03 使用
/// @param isComplete YES = translate finish
- (void)srBleHistorySr03DataWithCurrentCount:(NSInteger)currentCount IsComplete:(BOOL)isComplete
{
    
    self.currHisidx = currentCount;
//    DebugNSLog(@"lzp Sr03Data currentcount: %ld", (long)currentCount);

    
    if (self.historySyncCbk) {
        self.historySyncCbk(isComplete, self.historyCacheCount, self.currHisidx);
//        DebugNSLog(@"lzp call historySyncCbk currentaccount: %ld complete:%d", (long)currentCount, isComplete);

    }
  

    if (isComplete) { // 特殊处理
        self.lastSyncTimeInteval = @([[NSDate date] timeIntervalSince1970]); //记录同步成功时间
    }
    
}



- (void)srBleHistoryDataTimeout {
    if ([self.appDataDelegate respondsToSelector:@selector(srBleHistoryDataTimeout)]) {
        [self.appDataDelegate srBleHistoryDataTimeout];
    }
}

-(void)srBleRealtimeSpo:(NSNumber *)spo
{
    if ([self.appDataDelegate respondsToSelector:@selector(srBleRealtimeSpo:)]) {
        [self.appDataDelegate srBleRealtimeSpo:spo];
    }
}

-(void)srBleRealtimeHeartRate:(NSNumber *)hr
{
    if ([self.appDataDelegate respondsToSelector:@selector(srBleRealtimeHeartRate:)]) {
        [self.appDataDelegate srBleRealtimeHeartRate:hr];
    }
}

- (void)srBleDeviceRealtimeSteps:(nonnull NSNumber *)steps {
    if ([self.appDataDelegate respondsToSelector:@selector(srBleDeviceRealtimeSteps:)]) {
        [self.appDataDelegate srBleDeviceRealtimeSteps:steps];
    }
}

- (void)srBleDeviceRealtimeTemperature:(nonnull NSNumber *)temperature {
    if ([self.appDataDelegate respondsToSelector:@selector(srBleDeviceRealtimeTemperature:)]) {
        [self.appDataDelegate srBleDeviceRealtimeTemperature:temperature];
    }
}



- (void)srBleSN:(nonnull NSString *)sn {
    DebugNSLog(@"sn:%@", sn);
    if (self.bindDevice) {
        self.bindDevice.otherInfo.sn = sn;
        [self.bindDevice updateOtherInfo:^(BOOL succ) {
            
        }];
    }
    
    if ([self.appDataDelegate respondsToSelector:@selector(srBleSN:)]) {
        [self.appDataDelegate srBleSN:sn];
    }
}

// 获取sn号时回调
- (void)srBleIsbinded:(BOOL)isBinded
{
    
    if ([self.appDataDelegate respondsToSelector:@selector(srBleIsbinded:)]) {
        [self.appDataDelegate srBleIsbinded:isBinded];
    }
    
}

-(void)calculatSleepFinish
{
    [self querySleep:self.currentQueryDate];
    
}



#pragma mark -- ble ouside scan
//-(void)startOusideScan
//{
//
//    [self.ousideBleManager startScanning];
//
//}
//-(void)stopOusideScan
//{
//    [self.ousideBleManager stopScanning];
//}


-(BOOL)checkNeedUpdate:(NSString *)remoteVersion
{
    if (!remoteVersion) {
        return NO;
    }
    
    NSString *localVer = self.bindDevice.otherInfo.fireWareVersion;
    
    if ([localVer versionIsLowThan:remoteVersion]) {
        
        return YES;
    }
    return NO;
}

-(void)checkNeedUpdate {
    NSString *ver = [[DeviceCenter instance].bindDevice.otherInfo transFirmVersionToRemoteType];
//    [[LTPHud Instance] showHud];
    WEAK_SELF
    [[OTAHelper Instance] otaQueryUpgrade:OTA_HOST Port:[NSString stringWithFormat:@"%d", SR03_OTA_PORT] Version:ver Cat:SR03_CAT Pid:SR03_PID CBK:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error, NSDictionary * _Nullable resultDict) {
        STRONG_SELF
        /* 返回值
         {
             desc = "SR03 V1.0.0 TEST";  版本描述
             sign = fa5e262f7c91464c6627a4c700f176c1; 文件的md5签名
             size = 37156; 文件长度，单位字节
             uri = "http://hccvin.com:9037/ota/6af1c8c4c0"; 该版本下载地址，为http格式，支持断点续传
             ver = "1.0.0"; 最新版本
         }
         */
        DebugNSLog(@"ota 请求 %@", resultDict);
        BOOL needUpdate = [[DeviceCenter instance] checkNeedUpdate:resultDict[@"ver"]];
        if (needUpdate) {
            if (resultDict) {
                [OTAHelper Instance].imgObj = [[OTAImgObj alloc]initWithDict:resultDict];
                [OTAHelper Instance].imgObj.downLoadCBK = ^(NSURL * _Nonnull imgFileUrl) {
//                    [[LTPHud Instance] hideHud];
                    if (imgFileUrl) {
                        [self sendNotifyUpdate:resultDict[@"ver"]];
                    }
                };
                [[OTAHelper Instance].imgObj download];
                
            }
        }
        
      
        
    }];
}

-(void)sendNotifyUpdate:(NSString *)remoteVersion {
    
    
    
}

-(void)saveUpdateRemind {
    
  
}



-(void)logout {
    [self disconnectCurrentService];
    _bindDevice = nil;
    _currentBatteryLevel = 0;
    _isCharging = NO;
    self.calcSleepDate = nil;
    
    
    [self.heartRateObj clean];
    [self.hrvObj clean];
    [self.temperautreFluObj clean];
}



@end
