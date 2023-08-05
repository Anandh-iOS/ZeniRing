//
//  MainSettingVc.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/2.
//

#import "MainSettingVc.h"
#import "ConfigModel.h"
#import <Masonry/Masonry.h>
#import <QMUIKit/QMUIKit.h>

#import "MydeviceVc.h"

#import "OtherSettingVc.h"

#import "OTAHelper.h"
#import "DeviceCenter.h"
#import "OTAVc.h"
#import "UIViewController+Custom.h"
#import "LTPHud.h"


typedef NS_ENUM(NSUInteger, SET_TAG) {
    SET_TAG_MYDEVICE,
    SET_TAG_MYSET,
    SET_TAG_UPGRADE_DEVICE,
};

@interface MainSettingVc ()<UITableViewDelegate, UITableViewDataSource, SRBleScanProtocal, SRBleDataProtocal>

@property(strong, nonatomic)UITableView *tableView;
@property(strong, nonatomic)NSArray <NSArray<NSNumber *> *> *dataArray;

@end

@implementation MainSettingVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self initData];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = _L(L_SET_MAIN_TITLE);
    [DeviceCenter instance].appDataDelegate = self;
    [DeviceCenter instance].appScanDelegate = self;

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.navigationItem.title = nil;// _L(L_SET_MAIN_TITLE);

}

-(void)initUI {
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(15);
        make.leading.equalTo(self.view).offset(VC_ITEM_MARGIN_HOR);
        make.trailing.equalTo(self.view).inset(VC_ITEM_MARGIN_HOR);

        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
    
}

-(void)initData {
    
    NSArray *secction_one = @[ @(SET_TAG_MYDEVICE),  @(SET_TAG_MYSET),];
    NSArray *secction_two = @[@(SET_TAG_UPGRADE_DEVICE)];
    
    self.dataArray = @[secction_one, secction_two];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray[section].count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    }
    
    return 15.0f;;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section > 0) {
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 15.0f)];
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([self class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    
  
    
    switch (self.dataArray[indexPath.section][indexPath.row].intValue) {
        case SET_TAG_MYSET:
        {
            cell.textLabel.text = _L(L_SET_ITEM_TITLE_MYSET);
            cell.imageView.image = [UIImage imageNamed:@"setting_mysetting"];
            cell.textLabel.textColor = UIColor.whiteColor;

        }
            break;
        case SET_TAG_MYDEVICE :
        {
            cell.textLabel.text = _L(L_SET_ITEM_TITLE_MYDEVICE);
            cell.imageView.image = [UIImage imageNamed:@"setting_mydevice"];
            cell.textLabel.textColor = UIColor.whiteColor;
        }
            break;
        
        case SET_TAG_UPGRADE_DEVICE: // 升级
        {
            cell.textLabel.text = _L(L_SET_ITEM_TITLE_UPDATE_DEV);
            cell.imageView.image = [UIImage imageNamed:@"setting_update_firm"];
            if ([DeviceCenter instance].isBleConnected) {
                cell.textLabel.textColor = UIColor.whiteColor;
            } else {
                cell.textLabel.textColor = [UIColor grayColor];
            }

        }
            break;
        default:
            break;
    }
    
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.dataArray[indexPath.section][indexPath.row].intValue) {

        case SET_TAG_MYDEVICE : // 我的设备
        {
            MydeviceVc *vc = [[MydeviceVc alloc]init];
            vc.hidesBottomBarWhenPushed = YES; //隐藏tabbar
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;

        case SET_TAG_MYSET : // 设置
        {
            OtherSettingVc *vc = [[OtherSettingVc alloc]init];
            vc.hidesBottomBarWhenPushed = YES; //隐藏tabbar
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;

        case SET_TAG_UPGRADE_DEVICE:
        {
            if (![DeviceCenter instance].isBleConnected) { //未连接不可用
                break;
            }
            NSString *ver = [[DeviceCenter instance].bindDevice.otherInfo transFirmVersionToRemoteType];
            [[LTPHud Instance] showHud];
            WEAK_SELF
            [[OTAHelper Instance] otaQueryUpgrade:OTA_HOST Port:[NSString stringWithFormat:@"%d", SR03_OTA_PORT] Version:ver Cat:SR03_CAT Pid:SR03_PID CBK:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error, NSDictionary * _Nullable resultDict) {
                STRONG_SELF
                /* 返回值
                 {
                     desc = "SR03 V1.0.0 TEST";  版本描述
                     sign = fa5e262f7c91464c6627a4c700f176c1; 文件的md5签名
                     size = 37156; 文件长度，单位字节
                     uri = "http://hccvin.com:9037/ota/6af1c8c4c0"; 该版本下载地址，为http格式，支持断点续传
                     ver = "1.0.0"; 最新版本
                 }
                 */
                DebugNSLog(@"ota 请求 %@", resultDict);
                BOOL needUpdate = [[DeviceCenter instance] checkNeedUpdate:resultDict[@"ver"]];
                if (needUpdate) {
                    if (resultDict) {
                        [OTAHelper Instance].imgObj = [[OTAImgObj alloc]initWithDict:resultDict];
                        [OTAHelper Instance].imgObj.downLoadCBK = ^(NSURL * _Nonnull imgFileUrl) {
                            [[LTPHud Instance] hideHud];
                            if (imgFileUrl) {
                                [strongSelf tipsToUpdrade:imgFileUrl];
                            } else {
                                // 下载失败
                                [strongSelf showAlertWarningWithTitle:_L(L_TIPS) Msg:_L(L_OTA_DWN_FAIL) btnCancel:_L(L_OK) Compelete:nil];
                            }
                            
                        };
                        [[OTAHelper Instance].imgObj download];
                        
                    } else {
                        [[LTPHud Instance] hideHud];
                    }
                } else {
                    [[LTPHud Instance] hideHud];

                    // 无需升级
                    [strongSelf showAlertWarningWithTitle:_L(L_TIPS) Msg:_L(L_OTA_ALREDY_NEW) btnCancel:_L(L_OK) Compelete:nil];
                }
                
              
                
            }];
        }
            break;
        default:
            break;
    }
}

-(void)tipsToUpdrade:(NSURL * _Nonnull )imgFileUrl {
    [self showAlertWarningWithTitle:_L(L_TIPS) Msg:_L(L_OTA_ALERT_MSG_NEW) btnOk:_L(L_OTA_UPDATE_NOW) OkBLk:^{
        OTAVc *otaVc = [[OTAVc alloc]init];
        otaVc.updateImageFileUrl = imgFileUrl;
        otaVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:otaVc animated:YES];
        
    } CancelBtn:_L(L_CANCEL) CancelBlk:nil Compelete:nil];
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 圆角弧度半径
    CGFloat cornerRadius = ITEM_CORNOR_RADIUS;
    // 设置cell的背景色为透明，如果不设置这个的话，则原来的背景色不会被覆盖
    cell.backgroundColor = UIColor.clearColor;
    
    // 创建一个shapeLayer
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    //        CAShapeLayer *backgroundLayer = [[CAShapeLayer alloc] init]; //显示选中
    // 创建一个可变的图像Path句柄，该路径用于保存绘图信息
    CGMutablePathRef pathRef = CGPathCreateMutable();
    // 获取cell的size
    // 第一个参数,是整个 cell 的 bounds, 第二个参数是距左右两端的距离,第三个参数是距上下两端的距离
    CGRect bounds = CGRectInset(cell.bounds,0, 0);
    
    if (indexPath.row == 0
        && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
        // 仅有一条
        UIBezierPath *backBezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:cornerRadius];
        
        layer.path = backBezierPath.CGPath;
        cell.layer.mask = layer;
    } else if (indexPath.row == 0) {
        // 初始起点为cell的左下角坐标
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 终点坐标为右下角坐标点，把绘图信息都放到路径中去,根据这些路径就构成了一块区域了
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
        CGPathCloseSubpath(pathRef);
        layer.path = pathRef;
        cell.layer.mask = layer;
    } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
        // 初始起点为cell的左上角坐标
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 添加一条直线，终点坐标为右下角坐标点并放到路径中去
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        layer.path = pathRef;
        cell.layer.mask = layer;
    }
    // 把已经绘制好的可变图像路径赋值给图层，然后图层根据这图像path进行图像渲染render
    //           layer.path = pathRef;
    //        backgroundLayer.path = pathRef;
    // 注意：但凡通过Quartz2D中带有creat/copy/retain方法创建出来的值都必须要释放
    //           CFRelease(pathRef);
    //       if (indexPath.row == 0 || indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
    //           cell.layer.mask = layer;
    //
    //       }
    cell.backgroundColor = ITEM_BG_COLOR;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
//        _tableView.tableHeaderView = [self tableViewHead];
//        [_tableView registerClass:[ActivityCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0.0f;
        }
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark --蓝牙
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
    
}

- (void)srBleDidConnectPeripheral:(nonnull SRBLeService *)service {
    [self.tableView reloadData];
}

- (void)srBleDidDisconnectPeripheral:(nonnull SRBLeService *)service {
    [self.tableView reloadData];

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





@end
