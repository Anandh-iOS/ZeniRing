//
//  MydeviceVc.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/27.
//

#import "MydeviceVc.h"
#import <Masonry/Masonry.h>
#import <QMUIKit/QMUIKit.h>
#import "ConfigModel.h"
#import "DeviceCenter.h"
#import "NormalSetCell.h"
#import "UIViewController+Custom.h"
#import "UITableViewCell+Styles.h"
#import "BatteryView.h"
#import "SRDeviceInfo+description.h"
#import "BindeTipsVc.h"
#import "AppDelegate.h"


typedef NS_ENUM(NSUInteger, DEV_SET_TAG) {
    DEV_SET_TAG_SIZE, // 尺寸
    DEV_SET_TAG_FIRMWARE, // 软件
    DEV_SET_TAG_SN, // sn号
    DEV_SET_TAG_MACADDRESS, // Mac地址
    
    DEV_SET_TAG_REBOOT,  //重启
    DEV_SET_TAG_RESET,  // 恢复出厂
    DEV_SET_TAG_BINDNEW,  // 新绑定设备
    DEV_SET_TAG_MEASURE_DURATIONS, // 设置测量时长

    DEV_SET_TAG_USE_AIR_MODE, // 飞行模式

    DEV_SET_TAG_MINTAIN, // 维护
    DEV_SET_TAG_CHARGING,  // 充电
    DEV_SET_TAG_USE_ILLUSTRATE, // 使用说明
};


@interface MydeviceVc ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, SRBleScanProtocal, SRBleDataProtocal>
@property(strong, nonatomic)UITableView *tableView_a, *tableView_b;
@property(strong, nonatomic)NSArray <NSArray<NSNumber *> *> *dataArray_a, *dataArray_b;

@property(strong, nonatomic)UIScrollView *mainScrollView; //主切换
@property(strong, nonatomic)BatteryView *batteryView;

@property(strong, nonatomic)UILabel *connectStateLbl, *batteryLevelLbl;

@property(strong, nonatomic)UIPageControl *pageControl;
@property(assign, nonatomic)BOOL needReconnect;
@end

@implementation MydeviceVc

-(instancetype)init
{
    if (self = [super init]) {
        [self initData];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self arrowback:nil]; //自定义返回
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    [DeviceCenter instance].appDataDelegate = self;
    [DeviceCenter instance].appScanDelegate = self;
    
    if ([DeviceCenter instance].currentDevice && [DeviceCenter instance].currentDevice.peripheral.state == CBPeripheralStateConnected) {
        if ([DeviceCenter instance].isCharging) {
            if ([DeviceCenter instance].currentBatteryLevel == 100) {
                self.connectStateLbl.text = _L(L_DEV_TITLE_DEV_CHARG_FULL);//连接并充满

            } else {
                self.connectStateLbl.text = _L(L_DEV_TITLE_DEV_CHARGING);//连接并充电

            }

        } else {
            self.connectStateLbl.text = _L(L_DEV_TITLE_ALREADY_CONNECT_RING);//已连接
        }
        self.batteryLevelLbl.text = [NSString stringWithFormat:@"%@\n%lu%%", _L(L_DEV_TITLE_BATTERY_POWER), (unsigned long)[DeviceCenter instance].currentBatteryLevel];

    } else {
        self.connectStateLbl.text = _L(L_DEV_TITLE_ALREADY_DISCONNECT_RING); // 断开连接*/
        self.batteryLevelLbl.text = nil;
    }
   
//    // 绑定新戒指未完成返回
//    if ([DeviceCenter instance].readyUnbindDevice != nil && [DeviceCenter instance].bindDevice == nil) {
//        [DeviceCenter instance].bindDevice =  [DeviceCenter instance].readyUnbindDevice;
//        [DeviceCenter instance].readyUnbindDevice = nil;
//    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view setNeedsLayout];
//    [self.batteryView setPercent:90/100.f IsCharging:NO];
    
    [self.tableView_b reloadData];
    [self.tableView_a reloadData];
    
    if (self.needReconnect) {
        // 重新绑定后的自动连接
        if (![DeviceCenter instance].isBleConnected) {
            [[DeviceCenter instance] startAutoConnect:^{
                
            }];
        }
        self.needReconnect = NO;
    }
}

-(void)initData {
    
    NSArray *b_secction_one = @[@(DEV_SET_TAG_SIZE),
                              @(DEV_SET_TAG_FIRMWARE),
                              @(DEV_SET_TAG_SN),
                              @(DEV_SET_TAG_MACADDRESS),];
    
    NSArray *b_secction_two = @[ @(DEV_SET_TAG_REBOOT),
                               @(DEV_SET_TAG_RESET),
                               @(DEV_SET_TAG_BINDNEW), @(DEV_SET_TAG_MEASURE_DURATIONS),];
    
    
//    NSArray *a_secction_one = @[ @(DEV_SET_TAG_USE_AIR_MODE),
//                                 ];
//    NSArray *a_secction_two = @[ @(DEV_SET_TAG_MINTAIN),
//                                 @(DEV_SET_TAG_CHARGING),
//                                 @(DEV_SET_TAG_USE_ILLUSTRATE),];
    
    self.dataArray_a = @[ ];
    
    self.dataArray_b = @[b_secction_one,  b_secction_two];
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
        UILabel *label = [UILabel new];
        label.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont fontWithName:FONT_ARIAL_BOLD size:18];
        label.textColor = UIColor.whiteColor;
        
    if (tableView == self.tableView_a) {
        if ( section == 0 ) {
            label.text = _L(L_DEV_TITLE_WEAR); //佩戴
            return label;
        }
    }
    
    if (tableView == self.tableView_b) {
        if ( section == 1 ) {
            label.text = _L(L_DEV_TITLE_TOOLS); //工具
            return label;
        }
    }
    return nil;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView_b)
    {
        if (section == 1) {
            return 40;
        }
    }
   
    
    if (tableView == self.tableView_a)
    {
        if (section == 0) {
            return 40;
        }
    }
    
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView_a) {
        return self.dataArray_a.count;

    }
    if (tableView == self.tableView_b) {
        return self.dataArray_b.count;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    if (tableView == self.tableView_a) {
        return self.dataArray_a[section].count;

    }
    if (tableView == self.tableView_b) {
        return self.dataArray_b[section].count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NormalSetCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NormalSetCell class]) forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = UIColor.whiteColor;
    if (tableView == self.tableView_a) {
        switch (self.dataArray_a[indexPath.section][indexPath.row].integerValue) {
            case DEV_SET_TAG_USE_AIR_MODE: // 飞行模式
            {
                cell.textLabel.text = _L(L_DEV_TITLE_AIR_MODE);
            }
                break;
            case  DEV_SET_TAG_MINTAIN: // 维护
            {
                cell.textLabel.text = _L(L_DEV_MAINTAIN);
            }
                break;
            case  DEV_SET_TAG_CHARGING: // 充电
            {
                
                cell.textLabel.text = _L(L_DEV_CHARGING);
            }
                break;
            case  DEV_SET_TAG_USE_ILLUSTRATE: // 使用说明
            {
                cell.textLabel.text = _L(L_DEV_ILLSUSTRATE);
            }
                break;
                
            default:
            {
                cell.textLabel.text = nil;
            }
                break;
        }
    }
    
    if (tableView == self.tableView_b) {
        DeviceOtherInfo *info = [DeviceCenter instance].bindDevice.otherInfo;
        switch (self.dataArray_b[indexPath.section][indexPath.row].integerValue) {
            case DEV_SET_TAG_SIZE:
            {
                cell.textLabel.text = _L(L_DEV_MODEL_AND_SIZE);
               
                
                NSString *colorDesc = [SRDeviceInfo colorDesc:info.color];
                NSString *sizeDesc = [SRDeviceInfo sizeDesc:(int)info.size];

                cell.rightLabel.text = [NSString stringWithFormat:@"%@%@%@",colorDesc, @",", sizeDesc ];//device.advDataLocalName;
            }
                break;
            case  DEV_SET_TAG_FIRMWARE:
            {
                cell.textLabel.text = _L(L_DEV_FIRMWARE_VER);
                cell.rightLabel.text = info.fireWareVersion;
            }
                break;
            case  DEV_SET_TAG_SN:
            {
                cell.textLabel.text = _L(L_DEV_SN);
                cell.rightLabel.text = info.sn;
            }
                break;
            case  DEV_SET_TAG_MACADDRESS:
            {
                cell.textLabel.text = _L(L_DEV_MAC_ADDRESS);
                cell.rightLabel.text = [DeviceCenter instance].bindDevice.macAddress;
            }
                break;
                
            case  DEV_SET_TAG_REBOOT:
            {
                cell.textLabel.text = _L(L_DEV_REBOOT);
                cell.rightLabel.text = nil;
                if (![DeviceCenter instance].isBleConnected) {
                    cell.textLabel.textColor = UIColor.grayColor;
                }
            }
                break;
            case  DEV_SET_TAG_RESET:
            {
                cell.textLabel.text = _L(L_DEV_RESET);
                cell.rightLabel.text = nil;
                if (![DeviceCenter instance].isBleConnected) {
                    cell.textLabel.textColor = UIColor.grayColor;
                }
            }
                break;
            case  DEV_SET_TAG_BINDNEW: // 新绑定设备
            {
                cell.textLabel.text = _L(L_DEV_BINDNEW);
                cell.rightLabel.text = nil;
                if (![DeviceCenter instance].isBleConnected) {
                    cell.textLabel.textColor = UIColor.grayColor;
                }
            }
                break;
            case DEV_SET_TAG_MEASURE_DURATIONS:
            {
                cell.textLabel.text = _L(L_DEV_MEASURE_DURA);
                
                cell.rightLabel.text = [NSString stringWithFormat:@"%lds", [DeviceCenter instance].currentDevice.hrMeasureDurations];
                if (![DeviceCenter instance].isBleConnected) {
                    cell.textLabel.textColor = UIColor.grayColor;
                }
                
            }
                break;
            default:
            {
                cell.textLabel.text = nil;
                cell.rightLabel.text = nil;
            }
                break;
        }
    }
  
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell addTopBottomCornerRadius:ITEM_BG_COLOR IndexPath:indexPath TableView:tableView CornerRadius:ITEM_CORNOR_RADIUS];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAK_SELF
    if (tableView == self.tableView_a) {
        switch (self.dataArray_a[indexPath.section][indexPath.row].integerValue) {
            case  DEV_SET_TAG_MINTAIN: // 维护
            {

            }
                break;
            case  DEV_SET_TAG_CHARGING: // 充电
            {

            }
                break;
            case  DEV_SET_TAG_USE_ILLUSTRATE: // 使用说明
            {
               

            }
                break;
                
            default:
                break;
        }
    }
    
    if (tableView == self.tableView_b) {
        switch (self.dataArray_b[indexPath.section][indexPath.row].integerValue) {
            case  DEV_SET_TAG_SIZE:
            case  DEV_SET_TAG_FIRMWARE:
            case  DEV_SET_TAG_SN:
            case  DEV_SET_TAG_MACADDRESS:
                break;
                
            case  DEV_SET_TAG_REBOOT:
            {
                if ([DeviceCenter instance].isBleConnected) {
                    [self showAlertWarningWithTitle:_L(L_TIPS) Msg:_L(L_DEV_TIPS_REBOOT_RING) btnOk:_L(L_SURE) OkBLk:^{
                        STRONG_SELF
                        [[DeviceCenter instance].sdk functionRebootDevice]; // 重启
                        
                    } CancelBtn:_L(L_CANCEL) CancelBlk:nil Compelete:nil];
                }
                
            }
                break;
            case  DEV_SET_TAG_RESET:
            {
                if ([DeviceCenter instance].isBleConnected) {
                    [self showAlertWarningWithTitle:_L(L_TIPS) Msg:_L(L_DEV_TIPS_FACTORY_RESET_RING) btnOk:_L(L_SURE) OkBLk:^{
                        STRONG_SELF
                        
                        [[DeviceCenter instance].sdk functionSetBindeDevice:NO];
                        [[DeviceCenter instance].sdk functionDeviceReset]; // 出厂设置
                        
                        [[DeviceCenter instance] unbindCurrentDevice:^{
                            STRONG_SELF
                            [((AppDelegate *)([UIApplication sharedApplication].delegate) ) checkBindedDevice];
                        }];
                        
                    } CancelBtn:_L(L_CANCEL) CancelBlk:nil Compelete:nil];
                }
            }
                break;
            case  DEV_SET_TAG_BINDNEW: // 新绑定设备
            {
                if ([DeviceCenter instance].isBleConnected) {
                    [[DeviceCenter instance] disconnectCurrentService];
                    [[DeviceCenter instance] stopBleScan];
                    
                    BindeTipsVc *vc = [BindeTipsVc new];
                    vc.canGestPop = YES;
                    vc.isBindeNew = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    self.needReconnect = YES;

                }
                
            }
                break;
            case DEV_SET_TAG_MEASURE_DURATIONS:
            {
                if ([DeviceCenter instance].isBleConnected) {
                    WEAK_SELF
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Input new measure durations, uint(s)" preferredStyle:UIAlertControllerStyleAlert];
                    
            
                    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        STRONG_SELF
                        
                    }]];
                    
              
                    [alertController addAction:[UIAlertAction actionWithTitle:@"Sure" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        STRONG_SELF
                        UITextField *userNameTextField = alertController.textFields.firstObject;
                        [[DeviceCenter instance].sdk functionSetDeviceMeasureDuration:[userNameTextField.text integerValue]];
                        [[DeviceCenter instance].sdk functionGetDeviceMeasureDuration];
                        
                        
                    }]];
                    
                   
                    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                        
                        textField.placeholder = @"uint:second";
                        
                        textField.secureTextEntry = NO;
                        
                    }];
                    
                    
                    
                    [self presentViewController:alertController animated:true completion:nil];
                    
                }
            }
                break;
            default:
                break;
        }
    }
    
   
    
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    

    if (self.mainScrollView.delegate == nil) {
        self.mainScrollView.delegate = self;
        self.tableView_a.superview.frame = CGRectMake(0, 0, self.mainScrollView.bounds.size.width, self.mainScrollView.bounds.size.height);
        self.tableView_b.superview.frame = CGRectMake(CGRectGetMaxX(self.tableView_a.superview.frame), 0, self.mainScrollView.bounds.size.width, self.mainScrollView.bounds.size.height);

        self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.bounds.size.width *2, self.mainScrollView.bounds.size.height);
        
       
    }
    if ([DeviceCenter instance].currentDevice && [DeviceCenter instance].currentDevice.peripheral.state == CBPeripheralStateConnected) {
        [self.batteryView showDisconnect:NO];

        [self.batteryView setPercent:[DeviceCenter instance].currentBatteryLevel IsCharging:[DeviceCenter instance].isCharging];

    } else {

        [self.batteryView clean];
        [self.batteryView showDisconnect:YES];

    }
    
}


-(void)initUI {
    
    self.navigationItem.title = _L(L_SET_ITEM_TITLE_MYDEVICE);
    
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        
    }];
    
    [self.mainScrollView setNeedsLayout];
    UIView *contentA = [UIView new];
    UIView *contentB = [UIView new];
    [contentA addSubview:self.tableView_a];
    [contentB addSubview:self.tableView_b];
    
    [self.mainScrollView addSubview:contentA];
    [self.mainScrollView addSubview:contentB];
    DebugNSLog(@"%f", contentA.superview.bounds.size.height);
//    [contentA mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.leading.top.equalTo(contentA.superview);
//        make.width.equalTo(contentA.superview.mas_width);
//        make.bottom.equalTo(contentA.superview.mas_bottom);
//    }];
//
//    [contentB mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(contentA);
//        make.leading.equalTo(contentA.mas_trailing);
//        make.width.equalTo(contentA.mas_width);
////        make.height.equalTo(@(contentB.superview.bounds.size.height));
//        make.bottom.equalTo(contentA.superview.mas_bottom);
//
//
//    }];
    
    [contentA addSubview:self.tableView_a];
    [contentB addSubview:self.tableView_b];
    
  
    
 

    [self.tableView_a mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.tableView_a.superview);
        make.leading.equalTo(self.tableView_a.superview).offset(VC_ITEM_MARGIN_HOR);
        make.trailing.equalTo(self.tableView_a.superview).inset(VC_ITEM_MARGIN_HOR);
    }];
    
    [self.tableView_b mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.tableView_b.superview);
        make.leading.equalTo(self.tableView_b.superview).offset(VC_ITEM_MARGIN_HOR);
        make.trailing.equalTo(self.tableView_b.superview).inset(VC_ITEM_MARGIN_HOR);
    }];
    
    self.pageControl = [[UIPageControl alloc]init];
    [self.view addSubview:self.pageControl];
    [self.pageControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.pageControl.superview.mas_centerX);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).inset(10);
    }];
    self.pageControl.numberOfPages = 2;
    self.pageControl.currentPage = 0;
}

-(UIView *)tableViewHead:(UITableView *)tableView {
    if (tableView == self.tableView_a) {
        UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 270)];
        [head setNeedsLayout];
        [head addSubview:self.connectStateLbl];
        [head addSubview:self.batteryLevelLbl];

//        self.batteryView = [[BatteryView alloc]init];
        
//        self.batteryView.backgroundColor = UIColor.blueColor;
        [head addSubview:self.batteryView];
        
        [self.connectStateLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self.connectStateLbl.superview);
            make.top.equalTo(self.connectStateLbl.superview.mas_top).offset(5);
            
        }];
        
        [self.batteryView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.connectStateLbl.mas_bottom).offset(15);
            make.bottom.equalTo(self.batteryLevelLbl.mas_top).inset(15);
            make.width.equalTo(self.batteryView.mas_height);
            make.centerX.equalTo(self.batteryView.superview.mas_centerX);
        }];
        
        [self.batteryLevelLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self.connectStateLbl.superview);
            make.bottom.equalTo(self.connectStateLbl.superview.mas_bottom).inset(8);
            make.height.equalTo(@60);
        }];
        
//        head.backgroundColor = UIColor.greenColor;
        return head;

    }
    
    if (tableView == self.tableView_b) {
        UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
//        head.backgroundColor = UIColor.whiteColor;
        
        UIImageView *imageV = [UIImageView new];
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        [head addSubview:imageV];
        [imageV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(imageV.superview.mas_centerX);
            make.centerY.equalTo(imageV.superview.mas_centerY);
            make.width.equalTo(imageV.superview.mas_width);
            make.height.equalTo(imageV.superview.mas_height).multipliedBy(2.0/3);
        }];
        imageV.image = [UIImage imageNamed:@"id_SR03"];

        return head;
    }
    
    return nil;
}

-(UITableView *)tableView_a
{
    if (!_tableView_a) {
        _tableView_a = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView_a.delegate = self;
        _tableView_a.dataSource = self;
        _tableView_a.tableFooterView = [UIView new];
        _tableView_a.tableHeaderView = [self tableViewHead:_tableView_a];
//        _tableView.tableHeaderView = [self tableViewHead];
//        [_tableView registerClass:[ActivityCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
        _tableView_a.showsVerticalScrollIndicator = NO;
        _tableView_a.showsHorizontalScrollIndicator = NO;
//        _tableView.scrollEnabled = NO;
        [_tableView_a registerClass:[NormalSetCell class] forCellReuseIdentifier:NSStringFromClass([NormalSetCell class])];
        if (@available(iOS 15.0, *)) {
            _tableView_a.sectionHeaderTopPadding = 0.0f;
        }
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView_a;
}



-(UITableView *)tableView_b
{
    if (!_tableView_b) {
        _tableView_b = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView_b.delegate = self;
        _tableView_b.dataSource = self;
        _tableView_b.tableFooterView = [UIView new];
        _tableView_b.tableHeaderView = [self tableViewHead:_tableView_b];
//        _tableView.tableHeaderView = [self tableViewHead];
//        [_tableView registerClass:[ActivityCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
        _tableView_b.showsVerticalScrollIndicator = NO;
        _tableView_b.showsHorizontalScrollIndicator = NO;
//        _tableView.scrollEnabled = NO;
        [_tableView_b registerClass:[NormalSetCell class] forCellReuseIdentifier:NSStringFromClass([NormalSetCell class])];
        if (@available(iOS 15.0, *)) {
            _tableView_b.sectionHeaderTopPadding = 0.0f;
        }
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView_b;
}

-(UIScrollView *)mainScrollView
{
    if (!_mainScrollView) {
        _mainScrollView = [UIScrollView new];
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.pagingEnabled = YES;
//        _mainScrollView.delegate = self;
        
        
    }
    return  _mainScrollView;
    
}

-(UILabel *)connectStateLbl
{
    if (!_connectStateLbl) {
        _connectStateLbl = [UILabel new];
        _connectStateLbl.textAlignment = NSTextAlignmentCenter;
        _connectStateLbl.font = [UIFont fontWithName:FONT_ARIAL_BOLD size:20];
//        _connectStateLbl.text = _L(L_DEV_TITLE_ALREADY_CONNECT_RING);
    }
    return _connectStateLbl;
}
-(UILabel *)batteryLevelLbl
{
    if (!_batteryLevelLbl) {
        _batteryLevelLbl = [UILabel new];
        _batteryLevelLbl.textAlignment = NSTextAlignmentCenter;
        _batteryLevelLbl.font = [UIFont fontWithName:FONT_ARIAL_BOLD size:20];
        _batteryLevelLbl.text = _L(L_DEV_TITLE_BATTERY_POWER);
        _batteryLevelLbl.numberOfLines = 0;

    }
    return _batteryLevelLbl;
}
-(BatteryView *)batteryView
{
    if (!_batteryView) {
        _batteryView = [[BatteryView alloc]init];
        _batteryView.borderLineWidth = 4.f;
        _batteryView.batteryBorderLineWidth = 3.f;
        _batteryView.batteryInnerMargin = 6.f;
    }
    return _batteryView;
}

#pragma mark --UIScrollViewDelegate
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView == self.mainScrollView) {
        NSInteger selectedIndex = floor((scrollView.contentOffset.x - scrollView.bounds.size.width / 2) / scrollView.bounds.size.width) + 1;
        self.pageControl.currentPage = selectedIndex;
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 手势滑动回调
    if (scrollView == self.mainScrollView) {
//        DebugNSLog(@"scrollView.contentOffset.x = %f", scrollView.contentOffset.x);
        NSInteger selectedIndex = floor((scrollView.contentOffset.x - scrollView.bounds.size.width / 2) / scrollView.bounds.size.width) + 1;
        self.pageControl.currentPage = selectedIndex;
    }
   
}

#pragma mark --蓝牙协议回调

- (void)srBleCmdExcute:(EXCUTED_CMD)cmd Succ:(BOOL)isSucc {
    
}

- (void)srBleDeviceBatteryLevel:(NSUInteger)batteryLevel IsCharging:(BOOL)isCharging {
    
    // 电量更新
    if ([DeviceCenter instance].currentDevice.peripheral != nil &&
        [DeviceCenter instance].currentDevice.peripheral.state == CBPeripheralStateConnected)
    {
        
        self.batteryLevelLbl.text = [NSString stringWithFormat:@"%@\n%lu%%", _L(L_DEV_TITLE_BATTERY_POWER), (unsigned long)batteryLevel];
        [self.batteryView setPercent:batteryLevel IsCharging:isCharging];
        
        if (isCharging) {
            if (batteryLevel < 100) {
                // L_DEV_TITLE_DEV_CHARGING
                
                self.connectStateLbl.text = _L(L_DEV_TITLE_DEV_CHARGING); // 充电中
            } else {
                self.connectStateLbl.text = _L(L_DEV_TITLE_DEV_CHARG_FULL);// 充满
            }
        } else {
            self.connectStateLbl.text = _L(L_DEV_TITLE_ALREADY_CONNECT_RING);//已连接

        }
        
    }
    
}

- (void)srBleDeviceDidReadyForReadAndWrite:(nonnull SRBLeService *)service {
    
}

- (void)srBleDeviceInfo:(nonnull SRDeviceInfo *)devInfo {
    
}
-(void)srBleOEMAuthResult:(BOOL)authSucceddful
{
    
}
- (void)srBleDeviceRealtimeSteps:(nonnull NSNumber *)steps {
    
}

- (void)srBleDeviceRealtimeTemperature:(nonnull NSNumber *)temperature {
    
}

- (void)srBleDidConnectPeripheral:(nonnull SRBLeService *)service {
    self.connectStateLbl.text = _L(L_DEV_TITLE_ALREADY_CONNECT_RING);//已连接
    [self.tableView_b reloadData];
}

- (void)srBleDidDisconnectPeripheral:(nonnull SRBLeService *)service {
    self.connectStateLbl.text = _L(L_DEV_TITLE_ALREADY_DISCONNECT_RING); // 断开连接
    self.batteryLevelLbl.text = nil;

    [self.batteryView clean]; //清空内容
    [self.batteryView showDisconnect:YES];
}


/// call back value of history data SR03 使用
/// @param isComplete YES = translate finish
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

-(void)srBleMeasureDuration:(NSInteger)seconds
{
    [self.tableView_b reloadData];
}


@end
