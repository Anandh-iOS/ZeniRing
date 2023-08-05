
#import "OusideBleDiscovery.h"


#define SR_SERVICE_UUID     0xFEF5

@interface OusideBleDiscovery () <CBCentralManagerDelegate, CBPeripheralDelegate>

@property(strong, nonatomic) CBCentralManager *centralManager;
@property(assign, nonatomic) BOOL pendingInit;


@end

@implementation OusideBleDiscovery
{
    CBUUID *_otaMainServiceUUID;  // ota 主服务
}


+ (CBUUID*) sigUUIDToCBUUID:(uint16_t)UUID
{
    uint8_t b[2] = { (UUID >> 8) & 0xff, UUID & 0xff };
    return [CBUUID UUIDWithData:[NSData dataWithBytes:b length:2]];
}

+ (uint16_t) sigUUIDFromCBUUID:(CBUUID*)UUID
{
    const uint8_t* b = UUID.data.bytes;
    return UUID.data.length == 2 ? (b[0] << 8) | b[1] : (uint16_t) 0;
}



-(instancetype)init
{
    self = [super init];
    if (self)
    {
        _pendingInit = YES;
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];

        _foundPeripherals = [[NSMutableArray alloc] init];
        _otaMainServiceUUID = [[self class] sigUUIDToCBUUID:SR_SERVICE_UUID];

        
	}
    return self;
}

-(void)stconnectPeripheralTimeout:(id)sender {
    
}

- (void) dealloc
{
    // We are a singleton and as such, dealloc shouldn't be called.
//    assert(NO);
}




- (void) centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{

}



- (void) centralManager:(CBCentralManager *)central didRetrievePeripheral:(CBPeripheral *)peripheral
{
	[central connectPeripheral:peripheral options:nil];
//    [_discoveryDelegate stdiscoveryDidRefresh];
}

//delete the stored device uuid in list
- (void) centralManager:(CBCentralManager *)central didFailToRetrievePeripheralForUUID:(CFUUIDRef)UUID error:(NSError *)error
{
	/* Nuke from plist. */
//	[DeviceRecordManager removeSavedDevice:UUID];
    
}



#pragma mark -
#pragma mark Discovery

/// 开始扫描
- (void) startScanning
{
    [self stopScanning];
    [_foundPeripherals removeAllObjects];
    
    NSArray	*uuidArray	= @[_otaMainServiceUUID];
    NSDictionary *options = @{ CBCentralManagerScanOptionAllowDuplicatesKey : @(NO) };
    
	[_centralManager scanForPeripheralsWithServices:uuidArray options:options];

}


- (void) stopScanning
{
    if (_centralManager != nil) {
        [_centralManager stopScan];
        
    }
    
}


/// 扫描发现设备
/// @param central 蓝牙中心
/// @param peripheral 扫描到外设
/// @param advertisementData 外谁的信息
/// @param RSSI 蓝牙信号
- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    NSString *advertisementName = [advertisementData objectForKey:@"kCBAdvDataLocalName"];

    NSArray *services = [advertisementData valueForKey:CBAdvertisementDataServiceUUIDsKey];
    NSArray *servicesOvfl = [advertisementData valueForKey:CBAdvertisementDataOverflowServiceUUIDsKey];

    __block BOOL canAdd = [services containsObject:_otaMainServiceUUID] || [servicesOvfl containsObject:_otaMainServiceUUID];
   
    if (canAdd)
    {
        
        SRBLeService *service = [[SRBLeService alloc] initWithPeripheral:peripheral];
        [service setAdvData:advertisementData];
        service.rssi = RSSI;
        
        if (service.macAddress != nil) {
            
            DebugNSLog(@"ouside scan add %@ %@", service.advDataLocalName, service.macAddress);
            [self addToFoundService:service AdvertisementData:advertisementData];
            
            if ([_scanDelegate respondsToSelector:@selector(srScanDeviceDidRefresh:)]) {
                [_scanDelegate srScanDeviceDidRefresh:[NSArray arrayWithArray:_foundPeripherals]];
            }
        }
        
    }
}

-(void)addToFoundService:(SRBLeService *)service AdvertisementData:(NSDictionary *)advertisementData
{
    BOOL canAdd = YES;
    // 防止重复加入
    for (SRBLeService *s in _foundPeripherals) {
        if (service.peripheral == s.peripheral) {
            canAdd = NO;
            break;
        }
        
    }
    
    if (canAdd) {
        [_foundPeripherals addObject:service];
    }
    
}


-(void)sendData:(NSData *)data type:(CBCharacteristicWriteType)type
{

    
}

#pragma mark -
#pragma mark retrievePeripheral

- (void) retrievePeripheral:(NSString *)uuid
{
    if (uuid != nil) {
        CFUUIDRef uuidRef = CFUUIDCreateFromString(NULL, (__bridge CFStringRef)uuid);
        NSArray *uuids = [NSArray arrayWithObject:(__bridge id)uuidRef];
        [_centralManager retrievePeripheralsWithIdentifiers:uuids];
    }
    
}

- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
//    [self.scanDelegate stdidRetrievePeripherals:peripherals];
}

#pragma mark -
#pragma mark Connection/Disconnection
/****************************************************************************/
/*						Connection/Disconnection                            */
/****************************************************************************/
- (void) connectPeripheral:(SRBLeService*)keyService
{
    //停止扫描
    [_centralManager stopScan];
    
    if (keyService == _currentService) {
        if ( _currentService.peripheral.state == CBPeripheralStateConnected) {
            // 已连接
            if ([self.scanDelegate respondsToSelector:@selector(srBleDidConnectPeripheral:)]) {
                [self.scanDelegate srBleDidConnectPeripheral:_currentService];
                return;
            }
        } else {
            [_centralManager connectPeripheral:_currentService.peripheral options:nil];
            return;
        }
       
    } else {
        
        if (_currentService.peripheral.state == CBPeripheralStateConnected) {
            [_centralManager cancelPeripheralConnection:_currentService.peripheral];
            DebugNSLog(@"主动断开 %s %d", __func__, __LINE__);
           
        }
        _currentService = keyService;
        
        if (keyService.peripheral.state != CBPeripheralStateConnected) {
            [_centralManager connectPeripheral:keyService.peripheral options:nil];
            [self performSelector:@selector(stconnectPeripheralTimeout:) withObject:keyService afterDelay:900.0f];
        }
    }
    
	
}

//-(void)

- (void)connectPeripheralTimeout:(id)obj
{
    SRBLeService *p = obj;
    if (!(p.peripheral.state == CBPeripheralStateConnected)) {
//        [_scanDelegate stconnectPeripheralTimeout:p];
    }
}

- (void) disconnectPeripheral:(SRBLeService*)keyService
{

    if (_currentService == keyService) {

    }
    
    if (![_foundPeripherals containsObject:_currentService] && _currentService != nil)
    {
        [_foundPeripherals addObject:_currentService];
    }
    if (keyService.peripheral) {
        [_centralManager cancelPeripheralConnection:keyService.peripheral];
        DebugNSLog(@"主动断开 %s %d", __func__, __LINE__);

    }
    _currentService = nil;
}

- (void)cancelAllReconnect
{
//    for (LeKeyFobService *s in self.connectedServices) {
        if (!(_currentService.peripheral.state == CBPeripheralStateConnected)) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stconnectPeripheralTimeout:) object:_currentService.peripheral];
        }
//    }
    for (CBPeripheral *p in self.foundPeripherals) {
        if (!(p.state ==CBPeripheralStateConnected)) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stconnectPeripheralTimeout:) object:p];
        }
    }

}


- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
//	LeKeyFobService	*service	= nil;
//	BOOL isExist = NO;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stconnectPeripheralTimeout:) object:peripheral];
    
    
    if ([_currentService.peripheral.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
        
        if (_currentService.peripheral.state == CBPeripheralStateConnected){
            
            if ([self.scanDelegate respondsToSelector:@selector(srBleDidConnectPeripheral:)]) {
                [self.scanDelegate srBleDidConnectPeripheral:_currentService];
                return;
            }
            
//            [_currentService setPerpheralDelegate:_peripheralDelegate];
//            [_currentService start]; // 开始业务
//
//            //代理回调
//            [_peripheralDelegate stkeyFobServiceDidChangeStatus:_currentService];
//            [_peripheralDelegate stkeyFobServiceDidConnectPeripheral:_currentService];
//            [_discoveryDelegate stdiscoveryDidRefresh];
            
        }
    }

}



- (void) centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    DebugNSLog(@"Attempted connection to peripheral %@ failed: %@", [peripheral name], [error localizedDescription]);
}



- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{

    if ([_currentService peripheral] != peripheral) {
        return;
    }
    DebugNSLog(@"异常断开 error:%@", error);
    //异常断开的动画
    //3.通知代理
    if ([self.scanDelegate respondsToSelector:@selector(srBleDidDisconnectPeripheral:)]) {
        [self.scanDelegate srBleDidDisconnectPeripheral:_currentService];
    }

    
}


/// 清空所有发现和连接过的设备
- (void) clearDevices
{
    [_foundPeripherals removeAllObjects];
    
    if (_currentService.peripheral.state == CBPeripheralStateConnected) {
        [_centralManager cancelPeripheralConnection:_currentService.peripheral];
        DebugNSLog(@"主动断开 %s %d", __func__, __LINE__);

        _currentService = nil;
    }
    
}

- (CBManagerState)deviceBleCenterState
{
    return  [_centralManager state];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    static CBManagerState previousState = -1;
    /* ios 10.0
     CBManagerStateUnknown = 0,
     CBManagerStateResetting,
     CBManagerStateUnsupported,
     CBManagerStateUnauthorized,
     CBManagerStatePoweredOff,
     CBManagerStatePoweredOn,
     */
//    DebugNSLog(@"手机蓝牙状态: %ld", (long)[_centralManager state]);
	switch ([_centralManager state]) {
        case CBManagerStateUnsupported:
        {
            //不支持
            break;
        }
		case CBManagerStatePoweredOff:
		{
            [self clearDevices];

			break;
		}
            
		case CBManagerStateUnauthorized:
		{
			/* Tell user the app is not allowed. */
			break;
		}
            
		case CBManagerStateUnknown:
		{
			/* Bad news, let's wait for another event. */
			break;
		}
            
		case CBManagerStatePoweredOn:
		{
			_pendingInit = NO;
            
			break;
		}
            
		case CBManagerStateResetting:
		{
			[self clearDevices];
           
			_pendingInit = YES;
			break;
		}
	}
    
    previousState = [_centralManager state];
    if ([_scanDelegate respondsToSelector:@selector(srBlePowerStateChange:)]) {
        [_scanDelegate srBlePowerStateChange:previousState];
    }
}


@end
