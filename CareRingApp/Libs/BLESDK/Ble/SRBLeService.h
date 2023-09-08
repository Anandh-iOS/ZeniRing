//
//  LeKeyFobService.h
//
//
//  Created by linktoplinktop on 2019/2/18.
//  Copyright © 2019 Linktop. All rights reserved.
//  Connected Bluetooth device operation

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "SRDeviceInfo.h"


@interface SRBLeService : NSObject

/* Querying Sensor */
@property (readonly) CBPeripheral *peripheral;  // Bluetooth Peripheral Object
@property (strong, nonatomic)NSNumber *rssi;    // rssi while scanning

@property (strong, nonatomic)NSString *advDataLocalName; // Bluetooth broadcast name
@property (strong, nonatomic)NSString *macAddress;       // Bluetooth mac address

@property(assign, nonatomic)DEV_COLOR deviceColor;    // color
@property(assign, nonatomic)int deviceSize;   // size

@property(assign, nonatomic)MAIN_CHIP_TYPE mainChipType; // main chip
@property(assign, nonatomic)NSUInteger deviceGeneration;  // generation

@property(strong, nonatomic)NSNumber *needOemAuth; //need oem auth
@property(strong, nonatomic)NSString *snString;
@property(strong, nonatomic)NSData *authSnData;
@property(strong, nonatomic)NSString * softWareVersion;// ring's firmware version

@property(assign, nonatomic)BOOL isBinded; // is binded
@property(assign, nonatomic)NSInteger hrMeasureDurations;
@property(assign, nonatomic)BOOL isSupportSportMode;
@property(assign, nonatomic)BOOL isWaveDataOn;  //Whether the real-time heart rate blood oxygen measurement waveform is reported


- (instancetype) initWithPeripheral:(CBPeripheral *)peripheral;

/// create instance. Use when scanning externally
/// - Parameter advertisementData: Bluetooth Broadcast Dictionary
-(void)setAdvData:(NSDictionary *)advertisementData;

@end
