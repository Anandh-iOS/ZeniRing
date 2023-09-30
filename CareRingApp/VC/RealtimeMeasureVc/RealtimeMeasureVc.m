//
//  RealtimeMeasureVc.m
//  CareRingApp
//
//  Created by 兰仲平 on 2023/3/31.
//

#import <Masonry/Masonry.h>
#import "RealtimeMeasureVc.h"
#import <QMUIKit/QMUIKit.h>
#import "ConfigModel.h"
#import "LTSRingSDK.h"
#import "DeviceCenter.h"

NSString * const prif_temp = @"Skin Temperature: ";
NSString * const prif_hr = @"Heart Rate: ";
NSString * const prif_spo = @"Spo2: ";



@interface RealtimeMeasureVc ()<SRBleScanProtocal, SRBleDataProtocal>

@property(strong, nonatomic)QMUIButton *startBtn;
@property(strong, nonatomic)UISegmentedControl *seg;
@property(strong, nonatomic)UILabel *hrLbl, *spoLbl, *skinTemperatureLbl;


@end

@implementation RealtimeMeasureVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Realtime Measurement";
    [DeviceCenter instance].appScanDelegate = self;
    [DeviceCenter instance].appDataDelegate = self;

    
    WEAK_SELF
    [self arrowback:^{
        
        
        STRONG_SELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    [self initUI];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    // stop measurement
    
    if (self.startBtn.isSelected) { // stop meaaure
        self.seg.enabled = YES;
        if (self.seg.selectedSegmentIndex == 0) {
            [[DeviceCenter instance].sdk functionOxygenOrHeartRate:REALTIME_MEASURE_HR IsOpen:NO];
        }
        
        if (self.seg.selectedSegmentIndex == 1) {
            [[DeviceCenter instance].sdk functionOxygenOrHeartRate:REALTIME_MEASURE_SPO IsOpen:NO];
        }
    }
    
}


-(void)initUI
{
    [self.view addSubview:self.seg];
    [self.seg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(20);
        make.height.equalTo(@44);
        make.width.equalTo(@180);
    }];
    
    [self.view addSubview:self.skinTemperatureLbl];
    [self.view addSubview:self.hrLbl];
    [self.view addSubview:self.spoLbl];
    
    [self.skinTemperatureLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.seg.mas_bottom).offset(30);
        make.centerX.equalTo(self.seg.mas_centerX);
        make.height.equalTo(@40);
        make.width.equalTo(self.view.mas_width);
    }];
    
    [self.hrLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.skinTemperatureLbl.mas_bottom).offset(5);
        make.centerX.equalTo(self.seg.mas_centerX);
        make.height.equalTo(@40);
        make.width.equalTo(self.view.mas_width);
    }];
    
    [self.spoLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hrLbl.mas_bottom).offset(5);
        make.centerX.equalTo(self.seg.mas_centerX);
        make.height.equalTo(@40);
        make.width.equalTo(self.view.mas_width);
    }];
    
    
    [self.view addSubview:self.startBtn];
    
    [self.startBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.leading.equalTo(self.view.mas_leading).offset(30);
        make.trailing.equalTo(self.view.mas_trailing).inset(30);
        make.height.equalTo(@40);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).inset(50);
    }];
    
    [self cleanText];
    
}


-(void)startBtnClick:(QMUIButton *)btn {
    
    if (!btn.isSelected) { // start meaaure
        self.seg.enabled = NO;
        [self cleanText];
        if (self.seg.selectedSegmentIndex == 0) {
            [[DeviceCenter instance].sdk functionOxygenOrHeartRate:REALTIME_MEASURE_HR IsOpen:YES];
        }
        
        if (self.seg.selectedSegmentIndex == 1) {
            [[DeviceCenter instance].sdk functionOxygenOrHeartRate:REALTIME_MEASURE_SPO IsOpen:YES];
        }
        [[DeviceCenter instance].sdk functionGetTemperatureOnce];
        
        
    }
    
    if (btn.isSelected) { // stop meaaure
        self.seg.enabled = YES;
        if (self.seg.selectedSegmentIndex == 0) {
            [[DeviceCenter instance].sdk functionOxygenOrHeartRate:REALTIME_MEASURE_HR IsOpen:NO];
        }
        
        if (self.seg.selectedSegmentIndex == 1) {
            [[DeviceCenter instance].sdk functionOxygenOrHeartRate:REALTIME_MEASURE_SPO IsOpen:NO];
        }
    }
    
    
    btn.selected = !btn.isSelected;
}


-(void)cleanText {
    
    self.hrLbl.text = prif_hr;
    self.skinTemperatureLbl.text = prif_temp;
    self.spoLbl.text = prif_spo;
    
}

-(QMUIButton *)startBtn
{
    if (!_startBtn) {
        _startBtn = [[QMUIButton alloc]init];
        _startBtn.backgroundColor = MAIN_BLUE;
        _startBtn.cornerRadius = ITEM_CORNOR_RADIUS;
        [_startBtn setTitle:@"Start" forState:UIControlStateNormal];
        
        [_startBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_startBtn setTitleColor:UIColor.redColor forState:UIControlStateSelected];

        [_startBtn setTitle:@"Stop" forState:UIControlStateSelected];
        [_startBtn addTarget:self action:@selector(startBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _startBtn;
}

-(void)segSelect:(UISegmentedControl *)seg {
    
}

-(UISegmentedControl *)seg
{
    if (!_seg) {
        NSArray<NSString *> *titles =@[@"Heart Rate", @"SPO2"];

        _seg = [[UISegmentedControl alloc]initWithItems:titles];
        _seg.selectedSegmentIndex = 0; // default
        [_seg addTarget:self action:@selector(segSelect:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _seg;
}

-(UILabel *)hrLbl
{
    if (!_hrLbl) {
        _hrLbl = [UILabel new];
        _hrLbl.textAlignment = NSTextAlignmentCenter;
        
    }
    return _hrLbl;
}

-(UILabel *)spoLbl
{
    if (!_spoLbl) {
        _spoLbl = [UILabel new];
        _spoLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _spoLbl;
}

-(UILabel *)skinTemperatureLbl
{
    if (!_skinTemperatureLbl) {
        _skinTemperatureLbl = [UILabel new];
        _skinTemperatureLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _skinTemperatureLbl;
}

#pragma mark -- SRBleScanProtocal, SRBleDataProtocal

- (void)srBleCmdExcute:(EXCUTED_CMD)cmd Succ:(BOOL)isSucc {
    
}

- (void)srBleDeviceBatteryLevel:(NSUInteger)batteryLevel IsCharging:(BOOL)isCharging {
    
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
    self.skinTemperatureLbl.text = [NSString stringWithFormat:@"%@%.2f%@", prif_temp, temperature.floatValue, _L(L_UNIT_TEMP_C)];

}



- (void)srBleHistoryDataCount:(NSInteger)count {
    
}

- (void)srBleHistoryDataTimeout {
    
}

- (void)srBleHistorySr03DataWithCurrentCount:(NSInteger)currentCount IsComplete:(BOOL)isComplete
{
    
}

- (void)srBleIsbinded:(BOOL)isBinded{
    
}

- (void)srBleRealtimeHeartRate:(nonnull NSNumber *)hr {
    self.hrLbl.text = [NSString stringWithFormat:@"%@%d", prif_hr, hr.intValue];
}

- (void)srBleRealtimeSpo:(nonnull NSNumber *)spo {
    self.spoLbl.text = [NSString stringWithFormat:@"%@%d", prif_spo, spo.intValue];

}

- (void)srBleSN:(nonnull NSString *)sn {
    
}



@end
