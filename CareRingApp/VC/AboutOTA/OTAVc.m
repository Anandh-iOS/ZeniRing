//
//  OTAVc.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/8/30.
//
//  升级流程 :1 初始状态 OTA_STATE_CHECKING_INIT
//  2 检查到充电 OTA_STATE_CHECKING_CHARGE
//  3 下发升级包 OTA_STATE_UPDATING
//  4 等待结束
//  5 重连设备 OTA_STATE_RECONNECTING
//  6 设备重连上, 成功 OTA_STATE_FINISH
//


#import <YYKit/YYKit.h>
#import "OTAVc.h"
#import "ConfigModel.h"
#import "DeviceCenter.h"
#include "BindParameterHeader.h"
#import "SRfileTableViewController.h"
#import "UIViewController+Custom.h"
#import "LTPHud.h"
#import <Masonry/Masonry.h>
#import "NSObject+Tool.h"

typedef NS_ENUM(NSUInteger, OTA_STATE) {
    OTA_STATE_CHECKING_INIT = 1,
    OTA_STATE_CHECKING_CHARGE,
    OTA_STATE_UPDATING,
    OTA_STATE_RECONNECTING, // 升级完成等待重连一次
    OTA_STATE_FINISH,
};

@interface OTAVc ()<SRBleScanProtocal, SRBleDataProtocal, SROTAProtocal>

@property(assign, nonatomic)OTA_STATE otaState;
@property(assign, nonatomic)BOOL otaSucc;
@property (nonatomic,strong) YYAnimatedImageView *YYImageView; // 充电动画

@property(strong, nonatomic)UIProgressView *progressView;
@property(strong, nonatomic)UILabel *tipsLabel;
@property(strong, nonatomic)UILabel *percentLabel;

@end

@implementation OTAVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}
-(void)initUI
{
    self.navigationItem.title = _L(L_OTA_VC_TITLE);
    
    [self arrowback:nil];
    
    [self.view addSubview:self.YYImageView];
    [self.view addSubview:self.tipsLabel];
    
    [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(BINDE_TITLE_TOP_OFFSET);
        make.leading.equalTo(self.view.mas_leading).offset(20);
        make.trailing.equalTo(self.view.mas_trailing).inset(20);
    }];
  
    [self.YYImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.YYImageView.superview.mas_centerX);
        make.centerY.equalTo(self.YYImageView.superview.mas_centerY);
        make.width.equalTo(self.YYImageView.superview.mas_width).multipliedBy(0.6);
        make.height.equalTo(self.YYImageView.mas_width);
    }];
    
    self.otaState = OTA_STATE_CHECKING_INIT; // 初始状态
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([DeviceCenter instance].sdk.bleOtaDelegate != self) {
        [DeviceCenter instance].appDataDelegate = self;
        [DeviceCenter instance].appScanDelegate = self;
        [DeviceCenter instance].sdk.bleOtaDelegate = self;
    }
    
    if ([[DeviceCenter instance] isBleConnected] && [[DeviceCenter instance] isCharging]) {
        self.otaState = OTA_STATE_CHECKING_CHARGE; //变更为充电状态
    }

}

-(void)setOtaState:(OTA_STATE)otaState
{
    
    switch (otaState) {
        case OTA_STATE_CHECKING_INIT:
        {
            if (_otaState != OTA_STATE_CHECKING_INIT) {
                [self arrowback:nil];
                self.tipsLabel.text = _L(L_OTA_CHARG_TIPS);
                
                YYImage *yyimage = [YYImage imageNamed:@"chargeTips"];
                [self.YYImageView setImage:yyimage];
                // 蓝牙指令查是否充电
                [[DeviceCenter instance].sdk functionGetDeviceBattery];
                // 检查充电
                
                
                
            }
        }
            break;
        case OTA_STATE_CHECKING_CHARGE:
        {
            if (_otaState != OTA_STATE_CHECKING_CHARGE && _otaState < OTA_STATE_CHECKING_CHARGE) {
                DebugNSLog(@"充电状态 file:%@", self.updateImageFileUrl);
                self.otaState = OTA_STATE_UPDATING;
                return;
//                [[DeviceCenter instance].sdk functionStartOta:self.updateImageFileUrl];
            }
            
        }
            
            break;
        case OTA_STATE_UPDATING:
        {
            if (_otaState != OTA_STATE_UPDATING) {
                dispatch_async(dispatch_get_main_queue(), ^{
//                    self.navigationItem.leftBarButtonItem = nil;
                    [self cleanLeftBarButon];
                    self.tipsLabel.text = [NSString stringWithFormat:_L(L_OTA_UPDATING_TIPS), [ConfigModel appName]];
                    
                    [self.YYImageView setImage:nil];
                    [self.YYImageView removeFromSuperview];
                    
                    [self.view addSubview:self.progressView];
                    [self.view addSubview:self.percentLabel];
                    [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(self.progressView.superview.mas_centerX);
                        make.centerY.equalTo(self.progressView.superview.mas_centerY);
                        make.width.equalTo(self.progressView.superview.mas_width).multipliedBy(0.8);
                    }];
                    [self.percentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.leading.trailing.equalTo(self.progressView);
                        make.bottom.equalTo(self.progressView.mas_top).inset(3);
                    }];
                    [[DeviceCenter instance].sdk functionStartOta:self.updateImageFileUrl];
                });
                
            }
        }
            break;
            
        case OTA_STATE_FINISH:
        {
            if (_otaState != OTA_STATE_FINISH) {
                dispatch_async(dispatch_get_main_queue(), ^{
//                    self.navigationItem.leftBarButtonItem = nil;
//                    [self cleanLeftBarButon];
                    [self arrowback:nil];
                    [self.YYImageView setImage:nil];
                    self.YYImageView.hidden = YES;
                    [self.YYImageView removeFromSuperview];
                    [self.progressView removeFromSuperview];
                    [self.percentLabel removeFromSuperview];
                    [[LTPHud Instance] hideHud];
                });
               
            }
        }
            break;
//        case OTA_STATE_CHOOSE_FILE:
//        {
//            if (_otaState != OTA_STATE_CHOOSE_FILE) {
//                // 选择文件
//                SRfileTableViewController *fileVc = [[SRfileTableViewController alloc]init];
//                WEAK_SELF
//                fileVc.fileCHooseCallBLK = ^(NSURL * _Nullable fileUrl) {
//                    STRONG_SELF
//                    if (fileUrl != nil) {
//                        strongSelf.updateImageFileUrl = fileUrl;
//                        strongSelf.otaState = OTA_STATE_UPDATING;
//                        [[DeviceCenter instance].sdk functionStartOta:strongSelf.updateImageFileUrl];
//
//                    }
//                };
//                [self.navigationController pushViewController:fileVc animated:YES];
//            }
//        }
//            break;
        case OTA_STATE_RECONNECTING:
        {
          
            if (_otaState != OTA_STATE_RECONNECTING) {
                [[LTPHud Instance] showHud:_L(L_OTA_WAIT_RING)]; // 菊花转
//                [[DeviceCenter instance] disconnectCurrentService];
                WEAK_SELF
                [self mainThreadDelayAfter:1 Blk:^{
                    // 自动连接
                    [[DeviceCenter instance] startAutoConnect:^{
                        STRONG_SELF
                        // 超时处理
                        [[LTPHud Instance] hideHud];
                        [strongSelf showAlertWarningWithTitle:_L(L_TIPS) Msg:_L(L_TIP_SCAN_NO_DEVICE) btnCancel:_L(L_OK) Compelete:^{
                            [strongSelf.navigationController popViewControllerAnimated:YES];
                        }];
                    }];
                }];
              
            }
           
           
        }
            break;
        default:
        {}
            break;
    }
    _otaState = otaState;

}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.otaState != OTA_STATE_CHECKING_CHARGE) { // 防止滑动退出
        return NO;
    }
    return YES;
}

#pragma mark --蓝牙代理

- (void)srBleCmdExcute:(EXCUTED_CMD)cmd Succ:(BOOL)isSucc {
    
}

- (void)srBleDeviceBatteryLevel:(NSUInteger)batteryLevel IsCharging:(BOOL)isCharging {
    
    if (isCharging) {
        self.otaState = OTA_STATE_CHECKING_CHARGE;
    }
    
}

- (void)srBleDeviceDidReadyForReadAndWrite:(nonnull SRBLeService *)service {
    if (self.otaState == OTA_STATE_RECONNECTING) {
        [[LTPHud Instance] hideHud];
        // 提示升级成功
        WEAK_SELF
        [self showAlertWarningWithTitle:_L(L_TIPS) Msg:_L(L_OTA_SUCC) btnOk:_L(L_OK) OkBLk:^{
            STRONG_SELF
            strongSelf.otaState = OTA_STATE_FINISH;
            if (strongSelf.otaFinishBLK) {
                strongSelf.otaFinishBLK(YES);
            }
            
            [strongSelf.navigationController popViewControllerAnimated:YES];
        } CancelBtn:nil CancelBlk:nil Compelete:nil];
        
        [[DeviceCenter instance].sdk functionSetBindeDevice:YES];
    }
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
    
  
}

- (void)srBleDidDisconnectPeripheral:(nonnull SRBLeService *)service {
    
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

-(void)srBleRealtimeSpo:(NSNumber *)spo
{
   
}

-(void)srBleRealtimeHeartRate:(NSNumber *)hr
{
  
}

- (void)srBleSN:(nonnull NSString *)sn {
    
}




#pragma mark --OTA delegete
- (void)srOtaError:(uint8_t)errorCode {
    
    WEAK_SELF
    [self showAlertWarningWithTitle:_L(L_TIPS) Msg:_L(L_OTA_FAIL) btnOk:_L(L_OK) OkBLk:^{
        STRONG_SELF
        strongSelf.otaState = OTA_STATE_FINISH;
        if (strongSelf.otaFinishBLK) {
            strongSelf.otaFinishBLK(NO);
        }
        [strongSelf.navigationController popViewControllerAnimated:YES];
    } CancelBtn:nil CancelBlk:nil Compelete:nil];
}

- (void)srOtaFinish:(BOOL)isSuccessful {
    if (!isSuccessful) {
        [self srOtaError:0];
        return;
    }
    
    if (isSuccessful) {
        self.otaState = OTA_STATE_RECONNECTING;
        
        return;
    }
}

- (void)srOtaUpdateProgress:(float)progress {
    
    [self.progressView setProgress:progress animated:YES];
    [self.percentLabel setText:[NSString stringWithFormat:@"%d%%",(int)(progress*100)]];
}

#pragma mark --lazy
-(YYAnimatedImageView *)YYImageView
{
    if (!_YYImageView) {
        _YYImageView = [[YYAnimatedImageView alloc]init];
    }
    return _YYImageView;
}
-(UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel = [UILabel new];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.font = [UIFont fontWithName:FONT_ARIAL_BOLD size:20];

    }
    return _tipsLabel;
}
-(UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]init];
    }
    return _progressView;
}

-(UILabel *)percentLabel
{
    if (!_percentLabel) {
        _percentLabel = [UILabel new];
        _percentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _percentLabel;
    
}

@end
