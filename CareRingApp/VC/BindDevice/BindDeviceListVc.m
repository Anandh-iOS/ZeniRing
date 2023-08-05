//
//  BindDeviceListVc.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/14.
//

#import "BindDeviceListVc.h"
#import "DeviceCenter.h"
#import "DeviceCell.h"
#import "BindSuccVc.h"
#include "BindParameterHeader.h"
#import "SRDeviceInfo+description.h"
#import "UIViewController+Custom.h"
#import "UITableViewCell+Styles.h"
#import "LTPHud.h"
#import <MJRefresh/MJRefresh.h>


typedef NS_ENUM(NSUInteger, CONECT_STATE) {
    CONECT_STATE_SCANING,  // 扫描中
    CONECT_STATE_SCAN_NONE, //没扫描到
    CONECT_STATE_WAIT_CHOOSE, // 等待连接
    CONECT_STATE_CONNECTING,  // 连接中传输数据
    CONECT_STATE_CONNECTED,  // 连接成功
    CONECT_STATE_BIND_SUCCESS,
};

@interface BindDeviceListVc ()<UITableViewDelegate, UITableViewDataSource ,SRBleScanProtocal, SRBleDataProtocal>

/* 搜索到的设备列表 */
@property(strong, nonatomic)UITableView *deviceTableView;
@property(strong, nonatomic)NSArray<SRBLeService *> *deviceArray;

@property(assign, nonatomic)CONECT_STATE state; // 状态机

@property(strong, nonatomic)UILabel *titleLabel, *tipsLabel, *tableHeadLabel;
@property(strong, nonatomic)SRBLeService *connectingDevice;

@property(strong, nonatomic)NSTimer *scanTimer;
// 等待连接的设备信息
@property(strong, nonatomic)UIView *connectingDevInfoView;
@property(weak, nonatomic)UILabel *connectingDevTextLabel, *connectingDetailLabel;

@property(assign, nonatomic)BOOL isBindLimit;

@end

@implementation BindDeviceListVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initui];
}

-(void)initui {
    [self.view addSubview:self.deviceTableView];
   
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.tipsLabel];
    [self.view addSubview:self.connectingDevInfoView];
    
    UILabel *headLabel = [UILabel new];
//    headLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    headLabel.textAlignment = NSTextAlignmentLeft;
    headLabel.textColor = UIColor.lightGrayColor;
    headLabel.text = _L(L_TIP_DEVICE_NEAR_YOU);
    headLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:headLabel];
    self.tableHeadLabel = headLabel;
    self.tableHeadLabel.hidden = YES;
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(BINDE_TITLE_TOP_OFFSET);
        make.leading.equalTo(self.view.mas_leading).offset(20);
        make.trailing.equalTo(self.view.mas_trailing).inset(20);
    }];
    
  
    
    [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(30);
    }];
    
    [self.tableHeadLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.titleLabel);
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(30);
        make.height.equalTo(@40);
    }];
    
    [self.deviceTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.tipsLabel);
        make.top.equalTo(self.tableHeadLabel.mas_bottom).offset(0);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
    
    [self.connectingDevInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.titleLabel);
        make.top.equalTo(self.tipsLabel);
        make.height.equalTo(@70);
    }];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[LTPHud Instance] hideHud];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [DeviceCenter instance].appDataDelegate = self;
    [DeviceCenter instance].appScanDelegate = self;
    self.state = CONECT_STATE_SCANING;
    [self performSelector:@selector(startScanAndChangeState) withObject:nil afterDelay:1.0];
    
}

-(void)startScanAndChangeState {
//    [[DeviceCenter instance] stopBleScan];
//    [[DeviceCenter instance] startBleScan]; //开始扫描
    self.state = CONECT_STATE_SCANING;
//    [self.scanTimer invalidate];
//    WEAK_SELF
//    self.scanTimer = [NSTimer scheduledTimerWithTimeInterval:120 repeats:NO block:^(NSTimer * _Nonnull timer) {
//        STRONG_SELF
//        if (strongSelf) {
//            strongSelf.state = CONECT_STATE_SCAN_NONE;
//        }
//    }];
    [self onlyStartScan];
}
-(void)onlyStartScan {
    [[DeviceCenter instance] stopBleScan];
    [[DeviceCenter instance] startBleScan]; //开始扫描
    
    
    [self.scanTimer invalidate];
    WEAK_SELF
    self.scanTimer = [NSTimer scheduledTimerWithTimeInterval:120 repeats:NO block:^(NSTimer * _Nonnull timer) {
        STRONG_SELF
        if (strongSelf) {
            strongSelf.state = CONECT_STATE_SCAN_NONE;
        }
    }];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.deviceArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[DeviceCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([self class])];
    }
    cell.imageView.image = [UIImage imageNamed:@"dev_ring"];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    SRBLeService *device = self.deviceArray[indexPath.row];

    NSString *colorDesc = [SRDeviceInfo colorDesc:device.deviceColor];
    NSString *sizeDesc = [SRDeviceInfo sizeDesc:device.deviceSize];

   
    NSString *genStr = @"";
    if (device.mainChipType > MAIN_CHIP_14531_00) {
        genStr = [NSString stringWithFormat:@"%@ %lu%@", _L(L_DEV_GENERATION), (unsigned long)device.deviceGeneration, _L(L_COMMA)];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@%@%@",colorDesc, _L(L_COMMA), genStr, sizeDesc ];//device.advDataLocalName;
    cell.textLabel.font = [UIFont fontWithName:FONT_ARIAL_BOLD size:19];
    cell.textLabel.textColor = UIColor.whiteColor;
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    // 临时
    if (!device.macAddress.length) {
        self.deviceArray[indexPath.row].macAddress = [self.deviceArray[indexPath.row].peripheral.identifier UUIDString];
    }
    cell.detailTextLabel.text = device.macAddress;

    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.deviceTableView) {
        cell.layer.mask = nil;
        [cell addTopBottomCornerRadius:ITEM_BG_COLOR IndexPath:indexPath TableView:tableView CornerRadius:ITEM_CORNOR_RADIUS]; // 首位单元格加圆角
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[DeviceCenter instance] connectDevice:self.deviceArray[indexPath.row]];
    self.connectingDevice = self.deviceArray[indexPath.row];
    self.state = CONECT_STATE_CONNECTING; //连接中
}

-(UITableView *)deviceTableView
{
    if (!_deviceTableView) {
        _deviceTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _deviceTableView.delegate = self;
        _deviceTableView.dataSource = self;
        WEAK_SELF
        _deviceTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            STRONG_SELF
            // 下拉刷新列表
            [strongSelf onlyStartScan];
            strongSelf.deviceArray = nil;
            [strongSelf.deviceTableView reloadData];
            [strongSelf.deviceTableView.mj_header endRefreshing];
        }];
        
        MJRefreshNormalHeader *header = (MJRefreshNormalHeader *)(_deviceTableView.mj_header);
        header.lastUpdatedTimeLabel.hidden = YES;//控制是否显示上次加载时间label
        header.stateLabel.hidden = YES;//控制是否显示加载状态label

        
        _deviceTableView.hidden = YES;
        
    }
    return _deviceTableView;
}

-(void)setState:(CONECT_STATE)state
{
    // 状态机
    WEAK_SELF
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        STRONG_SELF
    switch (state) {
        case CONECT_STATE_SCANING:  // 扫描中
        {
            self.tipsLabel.hidden = YES;
            self.titleLabel.text = _L(L_TITLE_SEARCHING_DEVICE); //扫描设备中
            self.deviceTableView.hidden = YES;
            self.tableHeadLabel.hidden = self.deviceTableView.isHidden;
            [[LTPHud Instance] showHud];
        }
            break;
        case CONECT_STATE_SCAN_NONE: //没扫描到
        {
            // 提示没找到设备
            [[LTPHud Instance] hideHud];
            //                WEAK_SELF
            [self showAlertWarningWithTitle:_L(L_TIPS) Msg:_L(L_TIP_SCAN_NO_DEVICE) btnOk:_L(L_OK) OkBLk:^{
                STRONG_SELF
                
                if (strongSelf) {
                    [strongSelf.navigationController popViewControllerAnimated:YES];
                }
            } CancelBtn:nil CancelBlk:nil Compelete:nil];
            
            
        }
            break;
        case CONECT_STATE_WAIT_CHOOSE: // 等待连接
        {
            [[LTPHud Instance] hideHud];
            self.tipsLabel.hidden = NO;
            self.titleLabel.text = _L(L_TIP_BIND_TITLE);
            self.tipsLabel.text = _L(L_TIP_FOUND_DEVICE);
            self.deviceTableView.hidden = NO;
            self.tableHeadLabel.hidden = self.deviceTableView.isHidden;

        }
            break;
        case CONECT_STATE_CONNECTING:  // 连接中传输数据
        {
            //
            [[LTPHud Instance] showHud];
            [[DeviceCenter instance] stopBleScan]; //停止扫描
            self.tipsLabel.hidden = YES;
            self.deviceTableView.hidden = YES;
            self.tableHeadLabel.hidden = self.deviceTableView.isHidden;

            self.titleLabel.text = [SRDeviceInfo colorDesc:self.connectingDevice.deviceColor];
            
            self.connectingDevInfoView.hidden = NO;
            self.connectingDevTextLabel.text = [SRDeviceInfo sizeDesc:self.connectingDevice.deviceSize];
            self.connectingDetailLabel.text = self.connectingDevice.macAddress;
            
        }
            break;
        case CONECT_STATE_CONNECTED:  // 连接成功
        {
            
        }
            break;
        case CONECT_STATE_BIND_SUCCESS:
        {
            if ( self->_state != CONECT_STATE_BIND_SUCCESS) {
                // 绑定成功
                [[LTPHud Instance] hideHud];
                BindSuccVc *succVc = [BindSuccVc new];
                succVc.isBindeNew = self.isBindeNew;
                [self.navigationController pushViewController:succVc animated:YES];
            }
            
        }
            break;
        default:
            break;
    }
    _state = state;

//    });

}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
//        _titleLabel.text = _L(L_TIP_BIND_TITLE);
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont fontWithName:FONT_ARIAL_BOLD size:BINDE_TITLE_FONT_SIZE];
    }
    return _titleLabel;
}
-(UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel = [UILabel new];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.textColor = UIColor.lightGrayColor;
        _tipsLabel.font = [UIFont systemFontOfSize:16];
//        _tipsLabel.text = _L(L_TIP_BIND_CONT);
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.hidden = YES;
    }
    return _tipsLabel;
        
}

-(UIView *)connectingDevInfoView
{
    if (!_connectingDevInfoView) {
        _connectingDevInfoView = [UIView new];
        UILabel *textlabel = [UILabel new];
        textlabel.textAlignment = NSTextAlignmentLeft;
        textlabel.textColor = UIColor.whiteColor;
        textlabel.font = [UIFont systemFontOfSize:18];
        
        UILabel *detailLabel = [UILabel new];
        detailLabel.textAlignment = NSTextAlignmentLeft;
        detailLabel.textColor = UIColor.lightGrayColor;
        detailLabel.font = [UIFont systemFontOfSize:16];

        [_connectingDevInfoView addSubview:textlabel];
        [_connectingDevInfoView addSubview:detailLabel];
        self.connectingDevTextLabel = textlabel;
        self.connectingDetailLabel = detailLabel;
        [textlabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.trailing.equalTo(textlabel.superview);
            make.bottom.equalTo(detailLabel.mas_top).inset(8);
        }];
        [detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(detailLabel.superview);
            make.height.equalTo(textlabel.mas_height);
        }];
        
        _connectingDevInfoView.hidden = YES;
        
    }
    return _connectingDevInfoView;
}

#pragma mark --蓝牙
/// phone ble power state change
/// @param isOn  YES = powerOn NO = pwoerNO
- (void)srBlePowerStateChange:(CBManagerState)state
{

    
}

-(void)srScanDeviceDidRefresh:(NSArray<SRBLeService *> *)perphelArray
{
    if (!self.isBindLimit) {
        // 扫描设备刷新
        self.deviceArray = perphelArray;
        [self.deviceTableView reloadData];
        if (self.deviceArray.count > 0) {
            if ( self.state != CONECT_STATE_WAIT_CHOOSE) {
                self.state = CONECT_STATE_WAIT_CHOOSE;
            }
            [self.scanTimer invalidate]; // 停止计时
        }
    }
    
    if (self.isBindLimit) {
        // 受限模式的自动连接
        WEAK_SELF
        [perphelArray enumerateObjectsUsingBlock:^(SRBLeService * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            STRONG_SELF
            DebugNSLog(@"受限模式 : obj.macAddress = %@, strongSelf.connectingDevice.macAddress = %@",
                       obj.macAddress,strongSelf.connectingDevice.macAddress);
            
            if ([obj.macAddress isEqual:strongSelf.connectingDevice.macAddress]) {
                // 自动连接
                [[DeviceCenter instance] connectDevice:obj];
                [[DeviceCenter instance]  stopBleScan];
                *stop = YES;
            }
        }];
    
    }
   

}

- (void)srBleCmdExcute:(EXCUTED_CMD)cmd Succ:(BOOL)isSucc {
    
}

- (void)srBleDeviceBatteryLevel:(NSUInteger)batteryLevel IsCharging:(BOOL)isCharging {
    
}

- (void)srBleDeviceDidReadyForReadAndWrite:(nonnull SRBLeService *)service {
    self.state = CONECT_STATE_CONNECTED;
    

}

- (void)srBleDeviceInfo:(nonnull SRDeviceInfo *)devInfo {
    
}

-(void)srBleOEMAuthResult:(BOOL)authSucceddful
{
    DebugNSLog(@"OEM auth result :%@", authSucceddful? @"yes": @"no");
   
    WEAK_SELF
    if (!authSucceddful) {
        
        [[LTPHud Instance] hideHud];
        
        [self showAlertWarningWithTitle:_L(L_TIPS) Msg:@"OEM auth failed.Please use the corresponding manufacturer's equipment." btnOk:_L(L_SURE) OkBLk:^{
            STRONG_SELF
            [strongSelf.navigationController popViewControllerAnimated:YES];
        } CancelBtn:nil CancelBlk:nil Compelete:^{
            
        }];
        
     
        return;
    }
    
    
    if ([DeviceCenter instance].currentDevice.isBinded) {
        [[LTPHud Instance] hideHud];
        // 重复绑定相同戒指
        if ([DeviceCenter instance].bindDevice
            && [[DeviceCenter instance].bindDevice.macAddress isEqual:[DeviceCenter instance].currentDevice.macAddress]) {
            // 直接成功
            self.state = CONECT_STATE_BIND_SUCCESS;
            return;
        }
        
        // 受限模式
        
        [self showAlertWarningWithTitle:_L(L_TIPS)
                                          Msg:_L(L_TIP_LIMIT_MODE)
                                        btnOk:_L(L_DEV_RESET)
                                        OkBLk:^{
            STRONG_SELF
            strongSelf.isBindLimit = YES;
            // 发送还原出厂
            [[DeviceCenter instance].sdk functionSetBindeDevice:NO];
            [[DeviceCenter instance].sdk functionDeviceReset]; // 设备恢复出厂设置后会关机
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [strongSelf.navigationController popViewControllerAnimated:YES];
            });
//            [[DeviceCenter instance] bindCurrentDevice];
//            self.state = CONECT_STATE_BIND_SUCCESS;
            
        } CancelBtn:_L(L_CANCEL) CancelBlk:^{
            STRONG_SELF
            [[DeviceCenter instance] disconnectCurrentService]; // 蓝牙断开
            [strongSelf.navigationController popViewControllerAnimated:YES];
            
        } Compelete:nil];
    } else {
        [[DeviceCenter instance] bindCurrentDevice];
        self.state = CONECT_STATE_BIND_SUCCESS;

    }
    
}
- (void)srBleDeviceRealtimeSteps:(nonnull NSNumber *)steps {
    
}

- (void)srBleDeviceRealtimeTemperature:(nonnull NSNumber *)temperature {
    
}

- (void)srBleDidConnectPeripheral:(nonnull SRBLeService *)service {
    
    
}

- (void)srBleDidDisconnectPeripheral:(nonnull SRBLeService *)service {
    
   
}

- (void)srBleIsbinded:(BOOL)isBinded
{
    

}


/// call back value of history data SR03 使用
/// @param isComplete YES = translate finish
- (void)srBleHistorySr03DataWithCurrentCount:(NSInteger)currentCount IsComplete:(BOOL)isComplete
{
    
}

- (void)srBleHistoryDataTimeout {
    
}

-(void)srBleRealtimeSpo:(NSNumber *)spo
{
   
}

-(void)srBleRealtimeHeartRate:(NSNumber *)hr
{
  
}

- (void)srBleSN:(nonnull NSString *)sn {
    
}


@end
