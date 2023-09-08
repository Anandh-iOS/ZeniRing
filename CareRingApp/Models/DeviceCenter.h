//
//  DeviceCenter.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/7.
//

#import <Foundation/Foundation.h>



#import "SRDeviceInfo.h"
#import "LTSRingSDK.h"
#import "SRBLeService.h"
#import "DBDevices.h"
#import "SleepStageHeader.h"
#import "ReadyDrawObj.h"

#import "DBSleepData.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SYNC_FINISH) {
    SYNC_FINISH_HEARTRATE,
    SYNC_FINISH_HRV,
    SYNC_FINISH_THERMOMOTER,
    SYNC_FINISH_OXYGEN,
    SYNC_FINISH_STEP,
};


typedef NS_ENUM(NSUInteger, SLEEP_CONTRI) {
    CONTRI_TOTAL_SLEEP,
    CONTRI_QUALITY_SLEEP,
    CONTRI_DEEP_SLEEP,
    CONTRI_AVERAGE_HR
};



@interface DeviceCenter : NSObject<SRBleScanProtocal, SRBleDataProtocal>

@property(weak, nonatomic)id<SRBleScanProtocal> appScanDelegate;
@property(weak, nonatomic)id<SRBleDataProtocal> appDataDelegate;

@property(strong, nonatomic, nullable)DBDevices *bindDevice; // 已绑定的设备
//@property(strong, nonatomic, nullable) DBDevices *readyUnbindDevice; // 准备解绑的设备


@property(assign, nonatomic, readonly)NSInteger currentBatteryLevel;
@property(assign, nonatomic, readonly)BOOL isCharging;
@property(weak, nonatomic, readonly)LTSRingSDK *sdk;

@property(strong, nonatomic)ReadyDrawObj *heartRateObj, *hrvObj, *temperautreFluObj;


/// 同步历史回调
/// @param isComplte 是否结束
/// @param totalCount 总数
/// @param currentCount 当前已上传数目
@property(copy, nonatomic)void (^ _Nullable historySyncCbk)(BOOL isComplte, NSInteger totalCount, NSInteger currentCount);

/// 数据保存完毕,通知刷新
//@property(copy, nonatomic)void (^ _Nullable historySaveFinishCbk)(SYNC_FINISH finishType);

// 受限模式回调
//@property(copy, nonatomic)void (^ _Nullable bindFinishCbk)(BOOL isBindLimit);

-(void)registWithisCustomBleManage:(BOOL)isCustomBleManage
;



-(void)startBleScan;
-(void)stopBleScan;
-(void)connectDevice:(SRBLeService *)device;
-(void)disconnectCurrentService;

// 当前已连接的设备
-(SRBLeService *)currentDevice;
-(BOOL)isBleConnected; //当前是否连接设备

-(void)startAutoConnect:(void (^)(void))scanTimeoutBlk ; //开启自动连接

-(void)cancelAutoCOnnect;
-(BOOL)startSyncDeviceCacheData;

-(void)unbindCurrentDevice:(void (^ _Nullable)(void))cmpBlk;  // 解绑
-(void)bindCurrentDevice; // 绑定

-(void)saveUpdateRemind;

-(void)logout;

/// 检查是否需要更新
/// @param remoteVersion 远程的版本号
-(BOOL)checkNeedUpdate:(NSString *)remoteVersion;

/* about sleep */
-(void)querySleep:(NSDate *)date;
-(void)queryhearRate:(NSDate *)date;
-(NSDictionary *)getSleepData :(SLEEP_CONTRI)SleepContriType;

-(NSMutableArray<DBSleepData *> *)GetSleepDBData;
-(NSMutableArray<DBSleepData *> *)GetNapSleepDBData;

-(NSDate *)currentQueryDate;

/* about sleep */



- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
+ (instancetype)instance;
@end

NS_ASSUME_NONNULL_END
