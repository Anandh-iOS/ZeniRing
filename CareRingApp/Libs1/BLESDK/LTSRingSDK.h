//
//  LTStethoscopeSDK.h
//  hc21SDK
//
//  Created by lanzhongping on 2021/1/6.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


NS_ASSUME_NONNULL_BEGIN

@class SRBLeService;
@class SRDeviceInfo;

typedef enum {
    // Value zero must not be used !! Notifications are sent when status changes.
    SROTAR_SRV_STARTED      = 0x01,     // Valid memory device has been configured by initiator. No sleep state while in this mode
    SROTAR_CMP_OK           = 0x02,     // SPOTA process completed successfully.
    SROTAR_SRV_EXIT         = 0x03,     // Forced exit of SROTAR service.
    SROTAR_CRC_ERR          = 0x04,     // Overall Patch Data CRC failed
    SROTAR_PATCH_LEN_ERR    = 0x05,     // Received patch Length not equal to PATCH_LEN characteristic value
    SROTAR_EXT_MEM_WRITE_ERR= 0x06,     // External Mem Error (Writing to external device failed)
    SROTAR_INT_MEM_ERR      = 0x07,     // Internal Mem Error (not enough space for Patch)
    SROTAR_INVAL_MEM_TYPE   = 0x08,     // Invalid memory device
    SROTAR_APP_ERROR        = 0x09,     // Application error
    
    // SUOTAR application specific error codes
    SROTAR_IMG_STARTED      = 0x10,     // SPOTA started for downloading image (SUOTA application)
    SROTAR_INVAL_IMG_BANK   = 0x11,     // Invalid image bank
    SROTAR_INVAL_IMG_HDR    = 0x12,     // Invalid image header
    SROTAR_INVAL_IMG_SIZE   = 0x13,     // Invalid image size
    SROTAR_INVAL_PRODUCT_HDR= 0x14,     // Invalid product header
    SROTAR_SAME_IMG_ERR     = 0x15,     // Same Image Error
    SROTAR_EXT_MEM_READ_ERR = 0x16,     // Failed to read from external memory device
    
} SROTA_STATUS_VALUES;


typedef NS_ENUM(UInt8, EXCUTED_CMD) {
    EXCUTED_CMD_SET_SPORT_MODE =      0x01, // Sport mode settings. abandoned
    EXCUTED_CMD_SET_HR_TEMP_MEASURE = 0x02, // Temperature Heart rate measurement settings. abandoned
    EXCUTED_CMD_SET_OXYGEN_MEASURE =  0x03, // Blood Oximetry Settings. abandoned
    EXCUTED_CMD_SYNC_TIME =           0x04, // time synchronization
    EXCUTED_CMD_GET_OXYGEN_HRV =      0x05, // Real-time acquisition of heart rate and blood oxygen
    EXCUTED_CMD_GET_STEPS =           0x06, // Get step count in real time
    EXCUTED_CMD_GET_TEMPERATURE =     0x07, // Get finger temperature in real time
    EXCUTED_CMD_SHUT_DOWN =           0X08, // shutdown
    EXCUTED_CMD_REBOOT =              0X09, // reboot
  
    EXCUTED_CMD_FACTORY_RESET =       0x0a, // restore factory settings
    
    EXCUTED_CMD_HIS_COUNT =           0x0c, // Report number of historical data
    EXCUTED_CMD_HIS_DATA =            0x0d, // Report historical data
    EXCUTED_CMD_CLEAR_HIS_DATA =      0x0e, // Clear the historical data cache
    EXCUTED_CMD_DEVICE_INFO =         0x0f, // Get device information
    EXCUTED_CMD_SN =                  0x10, // serial number
    EXCUTED_CMD_BATTERY =             0X11, // battery power
    EXCUTED_CMD_FUNCTIN_SWITCH =      0x31, // Device function switch
};// 下发命令字

typedef NS_ENUM(NSUInteger, REALTIME_MEASURE_TYPE) {
    REALTIME_MEASURE_HR =  0X00,  // Measure heart rate in real time
    REALTIME_MEASURE_SPO = 0X01,  // Real-time measurement of blood oxygen
};


/* about ble device scan and connect */
@protocol SRBleScanProtocal <NSObject>

@optional
/// scan device list fresh
/// @param perphelArray  scaned devices
-(void)srScanDeviceDidRefresh:(NSArray<SRBLeService *> *)perphelArray;

/// Mobile phone Bluetooth status change notification. Only used when using sdk internal connections.
/// @param state CBManagerState
- (void)srBlePowerStateChange:(CBManagerState)state;

/// Notify the device that Bluetooth has been connected.
/// @param service  Ring Peripherals
- (void)srBleDidConnectPeripheral:(SRBLeService*)service;

/// Notify the device that Bluetooth has been disconnected.
/// @param service  Ring Peripherals
- (void)srBleDidDisconnectPeripheral:(SRBLeService*)service;

@end


/* about ble data translate */
@protocol SRBleDataProtocal <NSObject>

/// perphel is ready for read write
/// @param service current connect devices
- (void)srBleDeviceDidReadyForReadAndWrite:(SRBLeService*)service;

/// Call back for realtime spo2 measurement
/// @param spo -- spo2
- (void)srBleRealtimeSpo:(NSNumber *)spo;

/// Call back for realtime heart rate measurement
/// @param hr  -- heart rate
- (void)srBleRealtimeHeartRate:(NSNumber *)hr;

/// call back device's battery level and charging state
/// @param batteryLevel battery level
/// @param isCharging YES = device is charging
- (void)srBleDeviceBatteryLevel:(NSUInteger)batteryLevel IsCharging:(BOOL)isCharging;

/// call back value of device's sn code
/// @param sn sn code
- (void)srBleSN:(NSString *)sn;

/// Bluetooth report device information
/// @param devInfo device information
- (void)srBleDeviceInfo:(SRDeviceInfo *)devInfo;

/// call back value of history data
/// @param currentCount current received data index
/// @param isComplete YES = translate finish
- (void)srBleHistorySr03DataWithCurrentCount:(NSInteger)currentCount IsComplete:(BOOL)isComplete;

/// call back realtime steps
/// @param steps steps
- (void)srBleDeviceRealtimeSteps:(NSNumber *)steps;

/// call back realtime skin temperature
/// @param temperature skin temperature Unit(℃)
- (void)srBleDeviceRealtimeTemperature:(NSNumber *)temperature;

/// call back for excute result of sended command
/// @param cmd  sended cmd
/// @param isSucc YES = success
- (void)srBleCmdExcute:(EXCUTED_CMD)cmd Succ:(BOOL)isSucc;

/// Return historical data entries
/// @param count The amount of historical data saved by the device
- (void)srBleHistoryDataCount:(NSInteger)count;

/// gain device's cache data time out
- (void)srBleHistoryDataTimeout;

/// Report device binding status
/// @param isBinded  YES = device activated. NO = device not activated
- (void)srBleIsbinded:(BOOL)isBinded;

/// Call back for OEM auth result
/// - Parameter authSucceddful: YES = auth successfully NO = please check company name.
-(void)srBleOEMAuthResult:(BOOL)authSucceddful;

@optional

/// Notify that the sleep calculation is complete
- (void)calculatSleepFinish;

/// call back to report device's measure duration
/// - Parameter seconds: measuration druration
-(void)srBleMeasureDuration:(NSInteger)seconds;

@end


@protocol SROTAProtocal <NSObject>

/// ota error callback
/// @param errorCode error code
-(void)srOtaError:(uint8_t)errorCode;

/// OTA completed
/// @param isSuccessful  YES = successful
-(void)srOtaFinish:(BOOL)isSuccessful;

/// OTA upgrade progress
/// @param progress percentage. Range (0-1)
-(void)srOtaUpdateProgress:(float)progress;

@end



@interface LTSRingSDK : NSObject

@property(weak, nonatomic)id<SRBleScanProtocal> blescanDelegate;  // Bluetooth scan callback object
@property(weak, nonatomic)id<SRBleDataProtocal> bleDataDelegate;  // Bluetooth data callback object
@property(weak, nonatomic)id<SROTAProtocal> bleOtaDelegate;       // ota proxy callback object

+(instancetype)instance;

/// Register sdk. Must be called first.
/// - Parameter cp: company name . defalt is Linktop
-(void)registWithCompany:(NSString  * _Nullable )cp;

/// Notify the sdk of internally connected or disconnected devices
/// @param peripheralService  SRBLeService instance
-(void)setCurrentPeripheralService:(SRBLeService* _Nullable)peripheralService;

/// iOS ble state
/// @return CBManagerState
- (CBManagerState)bleCenterManagerState;

/// Start Bluetooth scanning for peripherals inside the sdk.
-(void)startBleScan;

/// Stop Bluetooth scanning for peripherals inside the sdk.
-(void)stopBleScan;

/// Use sdk internal bluetooth management mechanism to connect devices
-(void)connectDevice:(SRBLeService *)device;

/// Disconnect the Bluetooth device. Only used when using sdk internal bluetooth scanning.
-(void)disconnectCurrentService;

// current connected ring
-(SRBLeService *)currentDevice;

/// Get sdk version
-(NSString *)functionGetSdkVersion;

/// send cmd to power off device
-(void)functionShutDownDevice;

/// send cmd to reboot device
-(void)functionRebootDevice;

/// get device's battery
-(void)functionGetDeviceBattery;

/// device reset to factory status
-(void)functionDeviceReset;

/// get device's SN code
-(void)functionGetDeviceSN;
/// get device's infomation
-(void)functionGetDeviceInfo;

/// get device's cache history data
/// retrun YES = cmd send successful  retrun NO = the last history data process is translating
-(BOOL)functionGetHistoryData;

/// clear device's history data cache
-(void)functionClearDeviceHistoryCache;


/// Device activation status settings
/// @param bind YES = activation device NO = deactivate device
-(void)functionSetBindeDevice:(BOOL)bind;

/// get heart rate or spo2 data by realtime measurement
/// @param type   measurement mode
/// @param isStart   NO=off   yes=on
-(void)functionOxygenOrHeartRate:(REALTIME_MEASURE_TYPE)type IsOpen:(BOOL)isStart;

/// get skin temperature
-(void)functionGetTemperatureOnce;

/// get steps once from ring by realtime measurement
-(void)functionGetStepsOnce;


/// Get the duration of each measurement that the device has set
-(void)functionGetDeviceMeasureDuration;


/// Set the duration of each measurement of the device
/// - Parameter duration: duration of each measurement, uint:second
-(void)functionSetDeviceMeasureDuration:(NSInteger)duration;

/**  About OTA **/

/// Start ota to upgrade the ring firmware
/// - Parameter fileUrl: Device firmware image
-(void)functionStartOta:(NSURL *)fileUrl;

/**  About OTA **/




- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
