//
//  SRDeviceInfo.h
//  sr01sdkProject
//
//  Created by 兰仲平 on 2022/5/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DEV_COLOR) {
    DEV_COLOR_DARK = 0,   // color dark
    DEV_COLOR_SILVER = 1, // color silver
    DEV_COLOR_GOLD = 2,   // color gold
    DEV_COLOR_ROSE_GOLD = 3,  // rose gold
};

typedef NS_ENUM(NSInteger, MAIN_CHIP_TYPE) {
    MAIN_CHIP_14531_00 = 0,
    MAIN_CHIP_14531_01 = 1,
}; //ring's main chip type

typedef NS_ENUM(NSUInteger, CMD_EXECTE_ERROR_REASON) {
    REASON_NONE = 0,
    REASON_1, // 设备自动测量中
    REASON_2, // 设备在运动模式测量中
    REASON_3, // 设备app测量中
    REASON_4, // 参数错误
};

@interface SRDeviceInfo : NSObject
@property(assign, nonatomic, readonly)DEV_COLOR color; // ring's color
@property(assign, nonatomic, readonly)NSUInteger size; // ring's size

@property(strong, nonatomic, readonly)NSString *softWareVersion; // ring's Firmware version
@property(strong, nonatomic, readonly)NSString *bleMacAddress; //  ring's mac address


@end

NS_ASSUME_NONNULL_END
