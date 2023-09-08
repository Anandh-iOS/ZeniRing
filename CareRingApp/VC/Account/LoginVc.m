//
//  LoginVc.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/6.
//  登录

#import <Toast.h>
#import <QMUIKit/QMUIKit.h>
#import "LoginVc.h"
#import "ConfigModel.h"
#import "UIViewController+Custom.h"

#import "DeviceCenter.h"
#import "BindeTipsVc.h"

#import "SleepStageHeader.h"
#import "NSString+Check.h"
#import "SRDeviceInfo+description.h"
#import "DeviceCell.h"
#import "DBDevices.h"
#import "UITableViewCell+Styles.h"
#import <YYKit/YYKit.h>

@interface LoginVc ()<UITableViewDelegate, UITableViewDataSource>


@property(strong, nonatomic)QMUIButton *activeDeviceBtn;
@property(strong, nonatomic)UITableView *tableView;
@property(strong, nonatomic)NSMutableArray<DBDevices *> *deviceArray;
@property(strong, nonatomic)UILabel *sdkVersionLbl;

@end

@implementation LoginVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.userInteractionEnabled = YES;
    [self initUI];
    [self mainStyle];
   
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[DeviceCenter instance] disconnectCurrentService];
    [self freshBindedDevices];
    self.sdkVersionLbl.text = [NSString stringWithFormat:@"SDK Version:%@", [[DeviceCenter instance].sdk functionGetSdkVersion]];

}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}
-(void)initUI {

    self.navigationController.navigationBar.translucent = NO;
    [self.view addSubview:self.activeDeviceBtn];
    
    [self.activeDeviceBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).offset(20);
        make.trailing.equalTo(self.view.mas_trailing).inset(20);
        make.height.equalTo(@44);
        make.top.equalTo(self.view.mas_top).offset(30);
    }];
    
    UILabel *txtLabel = [UILabel new];
    txtLabel.textAlignment = NSTextAlignmentLeft;
    txtLabel.text = @"Have been binded devices:";
    [self.view addSubview:txtLabel];
    
    [txtLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.activeDeviceBtn.mas_leading);
        make.top.equalTo(self.activeDeviceBtn.mas_bottom).offset(5);
        make.height.equalTo(@30);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.activeDeviceBtn);
        make.top.equalTo(txtLabel.mas_bottom);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).inset(40);
    }];
    
    UILabel *sdkVersionLbl = [UILabel new];
    sdkVersionLbl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:sdkVersionLbl];
    self.sdkVersionLbl = sdkVersionLbl;
    [sdkVersionLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.height.equalTo(@30);
    }];
}


-(void)freshBindedDevices {
    
    WEAK_SELF
    [DBDevices queryAllByCpmplete:^(NSMutableArray<DBDevices *> * _Nonnull results) {
        STRONG_SELF
        strongSelf.deviceArray = results;
        [strongSelf.tableView reloadData];
        
    }];
    
}



-(void)loginFunction:(UIButton *)btn {
   
    // go to active new device
    BindeTipsVc *vc = [BindeTipsVc new];
    [self.navigationController pushViewController:vc animated:YES];
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
   
}

#pragma mark --tableview


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.deviceArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.f;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Delete";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        DBDevices *delDev = self.deviceArray[indexPath.row];
        [self.deviceArray removeObjectAtIndex: indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
        [delDev deleteFromTable:^{
            
        }];
        
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[DeviceCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([self class])];
    }
    cell.imageView.image = [UIImage imageNamed:@"dev_ring"];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    DBDevices *device = self.deviceArray[indexPath.row];

    NSString *colorDesc = [SRDeviceInfo colorDesc:device.otherInfo.color];
    NSString *sizeDesc = [SRDeviceInfo sizeDesc:device.otherInfo.size];

    cell.textLabel.text = [NSString stringWithFormat:@"%@%@%@",colorDesc, _L(L_COMMA), sizeDesc ];//device.advDataLocalName;
    cell.textLabel.font = [UIFont fontWithName:FONT_ARIAL_BOLD size:19];
    cell.textLabel.textColor = UIColor.whiteColor;
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    // 临时
    cell.detailTextLabel.text = device.macAddress;

    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        cell.layer.mask = nil;
        [cell addTopBottomCornerRadius:ITEM_BG_COLOR IndexPath:indexPath TableView:tableView CornerRadius:ITEM_CORNOR_RADIUS]; // 首位单元格加圆角
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // 选中设备 准备进入连接流程
    [DeviceCenter instance].bindDevice = self.deviceArray[indexPath.row];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma makr --lazy
-(QMUIButton *)activeDeviceBtn
{
    if(!_activeDeviceBtn)
    {
        _activeDeviceBtn = [[QMUIButton alloc]init];
        [_activeDeviceBtn setTitle:@"Active New Ring" forState:UIControlStateNormal];
        _activeDeviceBtn.backgroundColor = MAIN_BLUE;
        [_activeDeviceBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_activeDeviceBtn addTarget:self action:@selector(loginFunction:) forControlEvents:UIControlEventTouchUpInside];
        _activeDeviceBtn.cornerRadius = ITEM_CORNOR_RADIUS;
    }
    
    return _activeDeviceBtn;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;

        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;
        [_tableView registerClass:[DeviceCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
        
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0.0f;
        }
    }
    
    return _tableView;
}

@end
