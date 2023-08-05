//
//  LeDiscovery.h
//
//
//  Created by linktoplinktop on 2019/2/18.
//  Copyright © 2019 Linktop. All rights reserved.
//  蓝牙扫描连接

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "SRBLeService.h"
#import "LTSRingSDK.h"





@interface OusideBleDiscovery : NSObject

@property (nonatomic, weak) id<SRBleScanProtocal>       scanDelegate;

@property (retain, nonatomic) NSMutableArray<SRBLeService *>    *foundPeripherals;//发现设备
@property(strong, atomic, readonly)SRBLeService *currentService; //当前正在处理中的外设



- (CBManagerState)deviceBleCenterState;

- (void) startScanning;//开始扫描
- (void) stopScanning;//停止扫描
- (void)cancelAllReconnect;//取消重连

- (void) connectPeripheral:(SRBLeService*)keyService;//连接外设 用于用户从列表选择设备
- (void) disconnectPeripheral:(SRBLeService*)keyService;//手动断开外设

- (void) retrievePeripheral:(NSString *)uuid;//重连外设



@property (nonatomic) BOOL isRefreahing;




@end
