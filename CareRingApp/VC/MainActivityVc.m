//
//  MainActivityVc.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/2.
//

#import "MainActivityVc.h"
#import "ValueQuarView.h"
#import "ConfigModel.h"
#import "ActivityCell.h"
#import "ActivityObj.h"

#import "DBTables.h"
#import "TimeUtils.h"
#import "MeasureDataListVc.h"
#import "BasicCalendaVc.h"
#import "Blebutton.h"
#import "DeviceCenter.h"
#import "AppDelegate.h"
#import "NotificationNameHeader.h"
#import "NSNumber+formatString.h"
#import "NSNumber+Imperial.h"
#import "OtaRemindView.h"
#import "OTAVc.h"
#import <Toast.h>
#import "OTAHelper.h"
#import "MydeviceVc.h"
#import "UIViewController+Custom.h"
#import "DBHistoryDataSr03.h"
#import "ActivityLineCell.h"
#import "RealtimeMeasureVc.h"

@interface MainActivityVc ()<UITableViewDelegate, UITableViewDataSource,SRBleScanProtocal, SRBleDataProtocal>

@property(strong, nonatomic)UITableView *tableView;
@property(strong, nonatomic)ValueQuarView *heartRateValueSQuar, *hrvValueSQuar, *tempValueSQuar, *stepValueSQuar;
@property(strong, nonatomic)NSNumber *avgFlu;

@property(strong, nonatomic)ActivityObj *hrObj, *hrvObj;

//@property(strong, nonatomic)NSArray <ActivityObj *> * dataArray;

@property(strong, nonatomic)NSDate *date;

@property(strong, nonatomic)UILabel *topDateLbl;
@property(strong, nonatomic)UIImageView *topCalendaImageV;
@property(strong, nonatomic)QMUIButton *topCalendaBtn;

@property(strong, nonatomic)Blebutton *bleBtn;

@property(strong, nonatomic)UIProgressView *syncHisDataProgressView;  // 同步历史使用
@property(strong, nonatomic)OtaRemindView *otaRemindView; // 提醒升级
@property(strong, nonatomic)UIView * topSquarsContentView;

@property(strong, nonatomic)QMUIButton *realtimeMeasureBtn; // goto realtime measure

@end

@implementation MainActivityVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self intUI];
    [self initData];
    
    // 睡眠计算完毕
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifySleepCalcFinish:) name:NOTI_NAME_SLEEP_CALC_FINISH object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(autoLoginSucc:) name:NOTI_NAME_AUTOLOGIN_SUCC object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifyDateChange:) name:NOTI_NAME_SLEEP_DATE_CHANGE object:nil];
//
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifyNeedUpdate:) name:NOTI_NAME_NEED_UPDATE object:nil];
    // NOTI_NAME_ISImperialUint_CAHNGE
    // 睡眠期间的体温差 查询完毕
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifySleepTemperature:) name:NOTI_NAME_SLEEP_TEMPERATURE_QUERY_READY object:nil];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationItem.title  = [ConfigModel appName];

    if (!self.title.length) {
    }
    
    
    self.date = [[DeviceCenter instance] currentQueryDate];;
    [self queryAlldata:self.date];
    
    
//    [self.tableView reloadData];
    // 刷新蓝牙图标
    [DeviceCenter instance].appDataDelegate = self;
    [DeviceCenter instance].appScanDelegate = self;

    if (![DeviceCenter instance].isBleConnected)
    {
        [self.bleBtn setBleState:BLE_BTN_STATE_CONNECTING];
        self.otaRemindView.startBtn.enabled = NO;

        WEAK_SELF
        [[DeviceCenter instance] startAutoConnect:^{
            STRONG_SELF
            if (strongSelf) {
                [strongSelf.view makeToast:_L(L_TIP_SCAN_NO_DEVICE)]; // 自动扫描连接超时
                [strongSelf.bleBtn setBleState:BLE_BTN_STATE_NOT_CONECT];

            }
        }];
        
        return;
    }
    
    if ([DeviceCenter instance].currentDevice.peripheral.state == CBPeripheralStateConnected)
    {
        [self.bleBtn setBleState:BLE_BTN_STATE_CONNECTED];
        [self.bleBtn setBatteryLevel:[DeviceCenter instance].currentBatteryLevel Ischarging:[DeviceCenter instance].isCharging];
        self.otaRemindView.startBtn.enabled = YES;

    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationItem.title  = nil;

}

#pragma mark -- 通知 睡眠计算完毕
-(void)notifySleepCalcFinish:(NSNotification *)noti {

        // 没有睡眠, 单独计算目前的静息心率
    NSDate *begin = [TimeUtils zeroOfDate:self.date];
    NSDate *end = [TimeUtils zeroOfNextDayDate:self.date];
    WEAK_SELF
    [DBHistoryDataSr03 queryueryRestHrBymacAdres:[DeviceCenter instance].bindDevice.macAddress Date:begin CMP:^(NSNumber * _Nonnull restHr) {
        
        STRONG_SELF
        [strongSelf.heartRateValueSQuar updateValueInt:restHr Unit:_L(L_UNIT_HR)];
    }];
    
    
    
    DBSleepData * sleepRes = [DeviceCenter instance].GetSleepDBData.firstObject;
    
    StagingDataV2 *sleepData = [sleepRes stagingData];
    
    if (sleepData) {
        NSDate *beginDate = [NSDate dateWithTimeIntervalSince1970:sleepData.startTime];
        NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:sleepData.endTime];
        [self queryHrv:beginDate End:endDate]; // 头部方形更新
//        [self queryThermemoter:beginDate End:endDate]; //头部方形 体温差

    } else {
        [self.hrvValueSQuar updateText:NONE_VALUE];
        [self.tempValueSQuar updateValueFloat:nil Unit:_L(L_UNIT_TEMP_C)];
      
       
    }
    [self.tableView reloadData];
    
}



-(void)notifyDateChange:(NSNotification *)noti {
    
    self.date = [[DeviceCenter instance] currentQueryDate];
    // TODO: 更新头部日期
    // 重新查询
    [self queryAlldata:self.date];
}

-(void)notifySleepTemperature:(NSNotification *)noti {
    
//    self.otaRemindView.shouldHide = NO;
    [self queryThermemoter];
    [self.tableView reloadData];
}

/// 有更新可用
/// @param noti 通知
-(void)notifyNeedUpdate:(NSNotification *)noti {
    
    self.otaRemindView.shouldHide = NO;
    [self.tableView reloadData];
}

-(void)autoLoginSucc:(NSNotification *)noti
{
    // 自动登录时推动计算睡眠
    self.date = [NSDate date];
    [[DeviceCenter instance] querySleep:self.date];
    [self viewDidAppear:YES]; // 自动登录刷新
}

-(void)intUI {
    [self.view addSubview:self.tableView];
    UIView *slideBar = [UIView new];
    [self.view addSubview:slideBar];
    
    // 头部日期按钮
    [slideBar addSubview:self.topCalendaBtn];
    [slideBar addSubview:self.syncHisDataProgressView];

    [self.topCalendaBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topCalendaBtn.superview.mas_centerX);
        make.top.equalTo(self.topCalendaBtn.superview.mas_top).offset(1);
        
        make.bottom.equalTo(self.topCalendaBtn.superview);
        
    }];
    [self.syncHisDataProgressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self.syncHisDataProgressView.superview);
        make.height.equalTo(@1);
    }];
    self.syncHisDataProgressView.transform = CGAffineTransformMakeScale(1.0, 0.5);
    
    [slideBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(slideBar.superview);
        make.height.equalTo(@44);
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.tableView.superview).offset(VC_ITEM_MARGIN_HOR);
        make.trailing.equalTo(self.tableView.superview).inset(VC_ITEM_MARGIN_HOR);

        make.bottom.equalTo(self.tableView.superview.mas_safeAreaLayoutGuideBottom);
        make.top.equalTo(slideBar.mas_bottom);
    }];
    
    [self initBLeBtn];
    
}

-(void)initBLeBtn
{
    // 右上角蓝牙图标
    CGRect rect = CGRectMake(0, 0, 65, 44);
    UIView *baseView = [[UIView alloc]initWithFrame:rect];
    self.bleBtn = [[Blebutton alloc]initWithFrame:rect];
    [baseView addSubview:self.bleBtn];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:baseView];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    // gotoMydevice
    [ self.bleBtn addTarget:self action:@selector(gotoMydevice) forControlEvents:UIControlEventTouchUpInside];


}

-(void)gotoMydevice {
    
    MydeviceVc *vc = [[MydeviceVc alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

// 有蓝牙操作的
-(void)bleButonClick {
    
    [DeviceCenter instance].appDataDelegate = self;
    [DeviceCenter instance].appScanDelegate = self;
    if (self.bleBtn.bleState == BLE_BTN_STATE_CONNECTING) {
        // 停止扫描
        [[DeviceCenter instance] cancelAutoCOnnect];
        [self.bleBtn setBleState:BLE_BTN_STATE_NOT_CONECT];
        
        return;
    }
    
    // 自动连接
    if (![DeviceCenter instance].currentDevice || [DeviceCenter instance].currentDevice.peripheral.state != CBPeripheralStateConnected)
    {
        //            [[DeviceCenter instance] startBleScan];
        [self.bleBtn setBleState:BLE_BTN_STATE_CONNECTING];
        
        [[DeviceCenter instance] startAutoConnect:^{
            
            //            if (strongSelf) {
            [self.view makeToast:_L(L_TIP_SCAN_NO_DEVICE)]; // 自动扫描连接超时
            [self.bleBtn setBleState:BLE_BTN_STATE_NOT_CONECT];
            
            //            }
        }];
        
    }
    
    if ([DeviceCenter instance].currentDevice.peripheral.state == CBPeripheralStateConnected) {
        // 断开连接
        [[DeviceCenter instance] disconnectCurrentService];
        DebugNSLog(@"delegate = %@ %@",  [DeviceCenter instance].appDataDelegate, self);
        //            [strongSelf.bleBtn setState:BLE_BTN_STATE_NOT_CONECT];
    }
    
}


-(void)initData {
    
    self.hrObj = [[ActivityObj alloc]init];
    self.hrObj.type = ACTIVITYOBJ_TYPE_HR;
    
    self.hrvObj = [[ActivityObj alloc]init];
    self.hrvObj.type = ACTIVITYOBJ_TYPE_HRV;
    
}

-(void)startSyncDeviceChaceDta {
    
    // 同步数据回调
    WEAK_SELF
    [DeviceCenter instance].historySyncCbk = ^(BOOL isComplte, NSInteger totalCount, NSInteger currentCount) {
        STRONG_SELF
        //        DebugNSLog(@"current %ld total %ld", currentCount, totalCount);
        [strongSelf.syncHisDataProgressView setProgress:currentCount * 1.0 / totalCount animated:YES];
//        DebugNSLog(@"totalCount %d, currentCount %d", totalCount, currentCount);
        if (isComplte) {
            strongSelf.syncHisDataProgressView.hidden = YES;
            
            [strongSelf.hrObj queryData:strongSelf.date Macaddress:[DeviceCenter instance].bindDevice.macAddress];
            
            [strongSelf.hrvObj queryData:strongSelf.date Macaddress:[DeviceCenter instance].bindDevice.macAddress];
            
            [strongSelf querySteps:strongSelf.date];
            
            [[DeviceCenter instance] querySleep:strongSelf.date];
            
        }
    };
    
    
    BOOL issend = [[DeviceCenter instance] startSyncDeviceCacheData];
    if (issend) {
        self.syncHisDataProgressView.hidden = NO; //显示进度条
    }
}

-(void)queryAlldata:(NSDate *)date {
    // fresh data
    
    [self querySteps:date];
    
    // 绘图刷新
    [self.hrObj queryData:date Macaddress:[DeviceCenter instance].bindDevice.macAddress];
    [self.hrvObj queryData:date Macaddress:[DeviceCenter instance].bindDevice.macAddress];
    
    
}


/// 头部方形数据查询
/// @param date
-(void)queryHrv:(NSDate *)beginDate End:(NSDate *)endDate {
    // hrvValueSQuar

    
    NSDate *begin = beginDate;// [TimeUtils zeroOfDate:date];
    NSDate *end = endDate;//[TimeUtils zeroOfNextDayDate:date];
    WEAK_SELF
    
    
    [DBHrv queryAverage:[DeviceCenter instance].bindDevice.macAddress Begin:begin End:end Cpmplete:^(NSNumber * _Nullable average, NSNumber * _Nullable maxTime, NSNumber * _Nullable minTime) {
        STRONG_SELF
        NSLog(@"hrv average %@", average);
        strongSelf.hrvObj.maxTimeInDate = maxTime;
        strongSelf.hrvObj.averageInDate = average;
        if (strongSelf.hrvObj.showValueBlk) {
            strongSelf.hrvObj.showValueBlk(strongSelf.hrvObj.averageInDate, strongSelf.hrvObj.maxTimeInDate);
        }
        if (!begin || !end) {
            [strongSelf.hrvValueSQuar updateText:NONE_VALUE];
            
        } else {
            [strongSelf.hrvValueSQuar updateValueInt:average Unit:_L(L_UNIT_MS)];
        }
        
    }];
    
}

-(void)querySteps:(NSDate *)date {
    NSDate *begin = [TimeUtils zeroOfDate:date];
    NSDate *end = [TimeUtils zeroOfNextDayDate:date];
    WEAK_SELF
    [DBSteps queryBy:[DeviceCenter instance].bindDevice.macAddress
               Begin:begin End:end OrderBeTimeDesc:YES Cpmplete:^(NSMutableArray<DBSteps *> * _Nonnull results) {
        STRONG_SELF
        if (results.firstObject) {
            [self.stepValueSQuar updateText:[results.firstObject.value thoundSeperateString]];
//            if (results.firstObject.calorie) {
//                [self.calcrieValueSQuar updateText:[NSString stringWithFormat:@"%@ %@", results.firstObject.calorie, _L(L_UNIT_CAL)]];
//
//            } else {
//                [self.calcrieValueSQuar updateText:NONE_VALUE];
//
//            }
        } else {
            [self.stepValueSQuar updateText:NONE_VALUE];
//            [self.calcrieValueSQuar updateText:NONE_VALUE];

        }
    }];
}

-(void)queryThermemoter
{
    ReadyDrawObj *temperautreFluObj = [DeviceCenter instance].temperautreFluObj;
    if (temperautreFluObj.avgValue) {
        self.avgFlu = temperautreFluObj.avgValue;
        [self.tempValueSQuar updateValueFloat:self.avgFlu Unit:_L(L_UNIT_TEMP_C)];
     
    } else {
        self.avgFlu = nil;
        [self.tempValueSQuar updateValueFloat:nil Unit:_L(L_UNIT_TEMP_C)];
    }

}


-(void)calendaClick:(id)sender {
    
    // 日历选择
    BasicCalendaVc *calendaVc = [[BasicCalendaVc alloc]init];
    calendaVc.hidesBottomBarWhenPushed = YES;
    WEAK_SELF
    calendaVc.selectDateCBK = ^(NSDate *date) {
        STRONG_SELF
        if (date) {
//            strongSelf.date = date;
            [[DeviceCenter instance] querySleep:date];

        }
    };
    
    [self presentViewController:calendaVc animated:YES completion:nil];
    
}



#pragma mark --tablleview

-(UIView *)topSquarsContent {
    if (!self.topSquarsContentView) {
        UIView *head = [UIView new];
        head.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
        [head addSubview:self.heartRateValueSQuar];
        [head addSubview:self.hrvValueSQuar];
        [head addSubview:self.stepValueSQuar];
        [head addSubview:self.tempValueSQuar];
        
        CGFloat margin = 15.f;
        [self.heartRateValueSQuar mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(head.mas_leading);
            make.top.equalTo(head.mas_top).offset(margin);
            
        }];
        
        [self.hrvValueSQuar mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(head);
            make.top.equalTo(self.heartRateValueSQuar.mas_top);
            make.leading.equalTo(self.heartRateValueSQuar.mas_trailing).offset(margin);
            make.width.equalTo(self.heartRateValueSQuar.mas_width);
            make.height.equalTo(self.heartRateValueSQuar.mas_height);
        }];

        [self.tempValueSQuar mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self.heartRateValueSQuar);
            make.top.equalTo(self.heartRateValueSQuar.mas_bottom).offset(margin);
            make.bottom.equalTo(head.mas_bottom).inset(margin);
            make.height.equalTo(self.heartRateValueSQuar.mas_height);
        }];
        
        [self.stepValueSQuar mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self.hrvValueSQuar);
            make.top.bottom.equalTo(self.tempValueSQuar);
        }];
        
        self.topSquarsContentView = head;
    }
   
    return self.topSquarsContentView;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!self.otaRemindView.shouldHide && section == 0) {
        self.otaRemindView.frame = CGRectMake(0, 0, tableView.bounds.size.width, OtaRemindView_HEIGHT);
        self.otaRemindView.leftVersionLbl.text = [[DeviceCenter instance].bindDevice.otherInfo transFirmVersionToRemoteType];
        self.otaRemindView.rightVersionLbl.text = [OTAHelper Instance].imgObj.ver;
        
        return self.otaRemindView;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (!self.otaRemindView.shouldHide && section == 0) {
        return OtaRemindView_HEIGHT;
    }
    return 0;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 280.f;
    }
    if (indexPath.row == 1) {
        return 280.f;
    }
    
    return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class]) ];
        if (!cell) {
            cell = [[ActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
        }
    //    [cell setNeedsLayout];
        
        
        cell.activityObj = self.hrObj;//self.dataArray[indexPath.row];
        
        if (cell.activityObj.type == ACTIVITYOBJ_TYPE_HR) { // 隐藏心率二级
            cell.arrowBtn.hidden = YES;
        } else {
            cell.arrowBtn.hidden = NO;
        }
        
        WEAK_SELF
        cell.arrowClickBLK = ^(ACTIVITYOBJ_TYPE type) {
            STRONG_SELF
            switch (type) {
                case ACTIVITYOBJ_TYPE_HR: // 心率
                {
                    MeasureDataListVc *vc = [[MeasureDataListVc alloc]initWith:MEASURE_LIST_TYPE_HEART_RATE];
                    vc.date = strongSelf.date;
                    vc.hidesBottomBarWhenPushed = YES;
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                    
                }
                    break;
                case ACTIVITYOBJ_TYPE_HRV: // hrv
                {
                    MeasureDataListVc *vc = [[MeasureDataListVc alloc]initWith:MEASURE_LIST_TYPE_HRV];
                    vc.date = strongSelf.date;
                    vc.hidesBottomBarWhenPushed = YES;
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                    
                }
                    break;
                case ACTIVITYOBJ_TYPE_TEMP:  // 体温
                {
                    MeasureDataListVc *vc = [[MeasureDataListVc alloc]initWith:MEASURE_LIST_TYPE_THERMEMOTER_FLU];
                    vc.date = strongSelf.date;
                    vc.hidesBottomBarWhenPushed = YES;
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                    
                }
                    break;
                    
                default:
                    break;
            }
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    cell.timeLabel.text = @"5分钟前";
        return cell;
    }
   
    if (indexPath.row == 1) {
        ActivityLineCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ActivityLineCell class])];
        if (!cell) {
            cell = [[ActivityLineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ActivityLineCell class])];
        }
        cell.activityObj = [DeviceCenter instance].temperautreFluObj;
        

        DBSleepData * sleepRes = [DeviceCenter instance].GetSleepDBData.firstObject;
        StagingDataV2 *sleepData = sleepRes.stagingData;
        WEAK_SELF
        cell.arrowClickBLK = ^(ACTIVITYOBJ_TYPE type) {
            STRONG_SELF
            switch (type) {
                case ACTIVITYOBJ_TYPE_TEMP:  // 体温
                {
                    MeasureDataListVc *vc = [[MeasureDataListVc alloc]initWith:MEASURE_LIST_TYPE_THERMEMOTER_FLU];
                    vc.sleepBeginStamp = @(sleepData.startTime);
                    vc.sleepEndStamp = @(sleepData.endTime);
                    vc.hidesBottomBarWhenPushed = YES;
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                    
                }
                    break;
                    
                default:
                    break;
            }
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    return nil;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[ActivityCell class]]) {
        [((ActivityCell *)cell) fresh];
    }
    
    // ActivityLineCell
    if ([cell isKindOfClass:[ActivityLineCell class]]) {
        ((ActivityLineCell *)cell).activityObj =  [DeviceCenter instance].temperautreFluObj;
    }
}

#pragma mark -- bledelegate
- (void)srBlePowerStateChange:(CBManagerState)state {
    BOOL isOn = NO;
    switch (state) {
        case CBManagerStateUnsupported:// 不支持蓝牙
        {
            //不支持
           
        }
            break;
        case CBManagerStatePoweredOff:// 未启动
        {
     
           
        }
            break;
        case CBManagerStateUnauthorized: // 未授权
        {
            /* Tell user the app is not allowed. */
            
        }
            break;
        case CBManagerStateUnknown: // 未知
        {
            /* Bad news, let's wait for another event. */
            
        }
            break;
        case CBManagerStatePoweredOn:// 开启
        {
            isOn = YES;
        }
            break;
        case CBManagerStateResetting:// 重置中
        {
            break;
        }
    }
    
    if (state == CBManagerStatePoweredOff) { // 蓝牙关闭
        [self showAlertWarningWithTitle:_L(L_TIPS) Msg:_L(L_TIP_OPEN_BLE) btnCancel:_L(L_SURE) Compelete:^{
            
        }];
        return;
    }
    
    if (state == CBManagerStateUnauthorized) {
        // 未授权
        WEAK_SELF
        [self showAlertWarningWithTitle:_L(L_TIPS) Msg:[NSString stringWithFormat:_L(L_TIP_NEED_BLE_AUTH), [ConfigModel appName]] btnOk:_L( L_OK) OkBLk:^{
            
          
            
        } CancelBtn:_L(L_BTN_GO_SETTING) CancelBlk:^{
            // 跳设置
            STRONG_SELF
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            }];
            
        } Compelete:^{
            
        }];
        
     
       
        return;
    }
    
    if (isOn) {
        if (![DeviceCenter instance].isBleConnected) {
            if (![DeviceCenter instance].isBleConnected)
            {
                [self.bleBtn setBleState:BLE_BTN_STATE_CONNECTING];
                self.otaRemindView.startBtn.enabled = NO;

                WEAK_SELF
                [[DeviceCenter instance] startAutoConnect:^{
                    STRONG_SELF
                    if (strongSelf) {
                        [strongSelf.view makeToast:_L(L_TIP_SCAN_NO_DEVICE)]; // 自动扫描连接超时
                        [strongSelf.bleBtn setBleState:BLE_BTN_STATE_NOT_CONECT];

                    }
                }];
                
                return;
            }
        }
    }
}

- (void)srBleCmdExcute:(EXCUTED_CMD)cmd Succ:(BOOL)isSucc {
    
}

- (void)srBleDeviceBatteryLevel:(NSUInteger)batteryLevel IsCharging:(BOOL)isCharging {
    if ([DeviceCenter instance].currentDevice.peripheral != nil &&
        [DeviceCenter instance].currentDevice.peripheral.state == CBPeripheralStateConnected)
    {
        [self.bleBtn setBleState:BLE_BTN_STATE_CONNECTED];
        [self.bleBtn setBatteryLevel:(NSInteger)batteryLevel Ischarging:isCharging];
    }
    
}

- (void)srBleDeviceDidReadyForReadAndWrite:(nonnull SRBLeService *)service {
    [[DeviceCenter instance].sdk functionGetDeviceBattery];
    // 读写服务已初始化完成
    
}

- (void)srBleDeviceInfo:(nonnull SRDeviceInfo *)devInfo {
    
}
-(void)srBleOEMAuthResult:(BOOL)authSucceddful
{
    
    DebugNSLog(@"OEM auth result :%@", authSucceddful? @"yes": @"no");
    if (authSucceddful) {
        [self.view makeToast:@"OEM auth successful"];
        [[DeviceCenter instance].sdk functionGetDeviceBattery];
        // 读写服务已初始化完成
        [self startSyncDeviceChaceDta];
        
    } else {
        [self showAlertWarningWithTitle:@"Tips" Msg:@"Auth failed.Different manufacter!" btnCancel:@"Ok" Compelete:nil];
        return;
    }
    
}
- (void)srBleDeviceRealtimeSteps:(nonnull NSNumber *)steps {
    
}

- (void)srBleDeviceRealtimeTemperature:(nonnull NSNumber *)temperature {
    
}

- (void)srBleDidConnectPeripheral:(nonnull SRBLeService *)service {
//    [self.bleBtn setBleState:BLE_BTN_STATE_CONNECTED];
    self.otaRemindView.startBtn.enabled = YES;

}

- (void)srBleDidDisconnectPeripheral:(nonnull SRBLeService *)service {
    
    [self.bleBtn setBleState:BLE_BTN_STATE_NOT_CONECT];
    self.syncHisDataProgressView.hidden = YES;
    self.otaRemindView.startBtn.enabled = NO;

}


/// call back value of history data SR03 使用

- (void)srBleHistorySr03DataWithCurrentCount:(NSInteger)currentCount IsComplete:(BOOL)isComplete
{
    
}

- (void)srBleHistoryDataCount:(NSInteger)count {
    
}

- (void)srBleHistoryDataTimeout {
    
}

- (void)srBleIsbinded:(BOOL)isBinded {
    
}

-(void)srBleRealtimeSpo:(NSNumber *)spo
{
   
}

-(void)srBleRealtimeHeartRate:(NSNumber *)hr
{
  
}

- (void)srBleSN:(nonnull NSString *)sn {
}





-(void)setDate:(NSDate *)date
{
    _date = date;
  
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];

    formatter.dateFormat = _L(L_TITLE_DATE_BEFORE_THIS_YEAR);
    NSString *str = [formatter stringFromDate:date];
    [self.topCalendaBtn setTitle:str forState:UIControlStateNormal];
    
    return;
    
   
}

-(void)gotoRealtimeMeas:(QMUIButton *)btn
{
    RealtimeMeasureVc *vc = [[RealtimeMeasureVc alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

#pragma mark --lazy


-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [self topSquarsContent];
        _tableView.backgroundColor = [UIColor clearColor];
//        [_tableView registerClass:[ActivityCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0.0f;
        }

    }
    
    return _tableView;
}



-(ValueQuarView *)heartRateValueSQuar
{
    if (!_heartRateValueSQuar) {
        _heartRateValueSQuar = [[ValueQuarView alloc]init];
        _heartRateValueSQuar.titleLbl.text = _L(L_QUAR_TITL_HR);
        _heartRateValueSQuar.valueLbl.text = NONE_VALUE;//@"70 bmp";

    }
    return _heartRateValueSQuar;
}

-(ValueQuarView *)hrvValueSQuar
{
    if (!_hrvValueSQuar) {
        _hrvValueSQuar = [[ValueQuarView alloc]init];
        _hrvValueSQuar.titleLbl.text = _L(L_QUAR_TITL_HRV);
        _hrvValueSQuar.valueLbl.text = NONE_VALUE;//@"--";

    }
    return _hrvValueSQuar;
}

-(ValueQuarView *)tempValueSQuar
{
    if (!_tempValueSQuar) {
        _tempValueSQuar = [[ValueQuarView alloc]init];
        _tempValueSQuar.titleLbl.text = _L(L_QUAR_TITL_TEMP);
        _tempValueSQuar.valueLbl.text =  NONE_VALUE;//@"--";

    }
    return _tempValueSQuar;
}

-(ValueQuarView *)stepValueSQuar
{
    if (!_stepValueSQuar) {
        _stepValueSQuar = [[ValueQuarView alloc]init];
        _stepValueSQuar.titleLbl.text = _L(L_QUAR_TITL_STEP);
        _stepValueSQuar.valueLbl.text = NONE_VALUE;//@"7,788";

    }
    return _stepValueSQuar;
}

-(QMUIButton *)realtimeMeasureBtn
{
    if (!_realtimeMeasureBtn) {
        _realtimeMeasureBtn = [[QMUIButton alloc]init];
        [_realtimeMeasureBtn setImage:[UIImage imageNamed:@"add_greed"] forState:UIControlStateNormal];

        [_realtimeMeasureBtn addTarget:self action:@selector(gotoRealtimeMeas:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _realtimeMeasureBtn;
}

-(QMUIButton *)topCalendaBtn
{
    if (!_topCalendaBtn) {
        _topCalendaBtn = [[QMUIButton alloc]init];
        _topCalendaBtn.tintColor = MAIN_BLUE;
        [_topCalendaBtn setTitleColor:MAIN_BLUE forState:UIControlStateNormal];
//        _topCalendaBtn.titleLabel.textColor = MAIN_BLUE;
        _topCalendaBtn.adjustsImageTintColorAutomatically = YES;
        _topCalendaBtn.imagePosition = QMUIButtonImagePositionRight;
        [_topCalendaBtn setTitle:_L(L_TODAY) forState:UIControlStateNormal];
        _topCalendaBtn.backgroundColor = UIColor.clearColor;
        [_topCalendaBtn setImage:[UIImage imageNamed:@"icon_calenda"] forState:UIControlStateNormal];
        _topCalendaBtn.spacingBetweenImageAndTitle = 3;
        [_topCalendaBtn addTarget:self action:@selector(calendaClick:) forControlEvents:UIControlEventTouchUpInside];
        // 底部添加一条横线
        UIView *line = [UIView new];
        [_topCalendaBtn addSubview:line];
        line.backgroundColor = MAIN_BLUE;
        [line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(_topCalendaBtn);
            make.height.equalTo(@1);
        }];
        
    }
    return _topCalendaBtn;
}

-(UIProgressView *)syncHisDataProgressView
{
    if (!_syncHisDataProgressView) {
        _syncHisDataProgressView = [[UIProgressView alloc]init];
//        _syncHisDataProgressView.transform = CGAffineTransformMakeScale(1.0, 0.5);
        _syncHisDataProgressView.trackTintColor = [UIColor lightGrayColor]; // 轨道颜色
        _syncHisDataProgressView.progressTintColor = MAIN_BLUE; // 进度颜色
        _syncHisDataProgressView.hidden = YES;
    }
    return _syncHisDataProgressView;
}

-(OtaRemindView *)otaRemindView
{
    if (!_otaRemindView) {
        _otaRemindView = [[OtaRemindView alloc]init];
        _otaRemindView.backgroundColor = ITEM_BG_COLOR;
        _otaRemindView.layer.masksToBounds = YES;
        _otaRemindView.layer.cornerRadius = ITEM_CORNOR_RADIUS;
        WEAK_SELF
        _otaRemindView.closeBlk = ^{
            STRONG_SELF
            strongSelf.otaRemindView.shouldHide = YES;
            [strongSelf.tableView reloadData];
            // 缓存
            [[DeviceCenter instance] saveUpdateRemind]; //缓存提醒
        };
        
        _otaRemindView.startBlk = ^{
            STRONG_SELF
            if ([DeviceCenter instance].isBleConnected) {
                OTAVc *otaVc = [[OTAVc alloc]init];
                otaVc.updateImageFileUrl = [OTAHelper Instance].imgObj.sandBoxFileUrl;
                otaVc.hidesBottomBarWhenPushed = YES;
                otaVc.otaFinishBLK = ^(BOOL isSucc) {
                    if (!strongSelf) {
                        return;
                    }
                    if (isSucc) {
                        strongSelf.otaRemindView.shouldHide = YES;
                        [strongSelf.tableView reloadData];
                    }
                    
                };
                [strongSelf.navigationController pushViewController:otaVc animated:YES];
            }
            
        };
        
    }
    return _otaRemindView;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
