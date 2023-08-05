//
//  DBDevices.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/7.
//  绑定设备表

#import <Foundation/Foundation.h>

#import "SRDeviceInfo.h"
NS_ASSUME_NONNULL_BEGIN

@class DeviceOtherInfo;

@interface DBDevices : NSObject
@property(assign, nonatomic)NSNumber *cId; // unique index
@property(strong, nonatomic)NSString *macAddress; // Bluetooth peripheral mac address
@property(strong, nonatomic)DeviceOtherInfo *otherInfo;  // Other information about the device


/// Query all DBDevices instances saved locally
/// - Parameter cmpBlk: return result
+(void)queryAllByCpmplete:(void(^)(NSMutableArray<DBDevices *> *results))cmpBlk;


/// Save a new binded device record locally
/// - Parameter complete: return result
-(void)insert:(void(^)(BOOL succ))complete;


///  Update other information of the device saved locally
/// - Parameter complete: return result
-(void)updateOtherInfo:(void(^)(BOOL succ))complete;


/// delete binded device,All data associated with the mac address of this device will
/// be cleared.
/// - Parameter cmpBlk: call back
-(void)deleteFromTable:(void (^)(void))cmpBlk;

@end

@interface DeviceOtherInfo :NSObject

@property(assign, nonatomic)DEV_COLOR color; // ring's color
@property(assign, nonatomic)NSInteger size;  // ring's size
@property(strong, nonatomic)NSString *sn, *fireWareVersion;// sn=serial number, fireWareVersion=Device firmware version number
@property(assign, nonatomic)MAIN_CHIP_TYPE mainChipType; // 主芯片型号
@property(assign, nonatomic)NSUInteger deviceGeneration;  // 迭代版本

/// Convert to a.b.c format
-(NSString *)transFirmVersionToRemoteType;

@end

NS_ASSUME_NONNULL_END
