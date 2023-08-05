//
//  ReadyToBindVc.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/14.
//  准备绑定

#import "ReadyToBindVc.h"
#import "BindDeviceListVc.h"
#import <YYKit/YYKit.h>
#include "BindParameterHeader.h"
#import "DeviceCenter.h"

#import "UIViewController+Custom.h"

@interface ReadyToBindVc ()
@property(strong, nonatomic)UILabel *titleLabel, *tipsLabel;
@property(strong, nonatomic)QMUIButton *startBtn;

@property (nonatomic,strong) YYAnimatedImageView *YYImageView;

@end

@implementation ReadyToBindVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
}

-(void)initUI {
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.tipsLabel];
    [self.view addSubview:self.startBtn];
    
    
    UIView *gifContent = [UIView new];
    
    [self.view addSubview:gifContent];
    [gifContent addSubview:self.YYImageView];

    
    [self.startBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).inset(40);
        make.height.equalTo(@44);
        make.leading.equalTo(self.view.mas_leading).offset(30);
        make.trailing.equalTo(self.view.mas_trailing).inset(30);
    }];
    
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(BINDE_TITLE_TOP_OFFSET);
        make.leading.equalTo(self.view.mas_leading).offset(20);
        make.trailing.equalTo(self.view.mas_trailing).inset(20);
    }];
    
    [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(30);
    }];
    
    [gifContent mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(10);
        
        make.leading.trailing.equalTo(self.titleLabel);
        make.bottom.equalTo(self.startBtn.mas_top).inset(10);
    }];
    
    [self.YYImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.YYImageView.superview.mas_centerX);
        make.centerY.equalTo(self.YYImageView.superview.mas_centerY);
        make.width.equalTo(self.YYImageView.superview.mas_width).multipliedBy(0.6);
        make.height.equalTo(self.YYImageView.mas_width);
    }];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    


}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    YYImage *yyimage = [YYImage imageNamed:@"chargeTips"];
    [self.YYImageView setImage:yyimage];
    
    [[DeviceCenter instance] disconnectCurrentService];
}

-(void)gotoNext:(UIButton *)btn {
    // 检查蓝牙
    CBManagerState state = [[DeviceCenter instance].sdk bleCenterManagerState];
    if (state == CBManagerStatePoweredOff) {
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
    
    BindDeviceListVc *vc = [BindDeviceListVc new];
    vc.isBindeNew = self.isBindeNew;

    [self.navigationController pushViewController:vc animated:YES];
}



-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = _L(L_TIP_BIND_TITLE);
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
        _tipsLabel.text = _L(L_TIP_BIND_CONT);
        _tipsLabel.numberOfLines = 0;
    }
    return _tipsLabel;
        
}

-(QMUIButton *)startBtn
{
    if (!_startBtn) {
        _startBtn = [[QMUIButton alloc]init];
        [_startBtn setTitle:_L(L_BTN_BIND) forState:UIControlStateNormal];
        [_startBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_startBtn setBackgroundColor:MAIN_BLUE];
        _startBtn.cornerRadius = ITEM_CORNOR_RADIUS;
        [_startBtn addTarget:self action:@selector(gotoNext:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}




-(YYAnimatedImageView *)YYImageView
{
    if (!_YYImageView) {
        _YYImageView = [[YYAnimatedImageView alloc]init];
    }
    return _YYImageView;
}

@end
