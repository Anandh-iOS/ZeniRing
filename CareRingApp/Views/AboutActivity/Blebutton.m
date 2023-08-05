//
//  Blebutton.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/7/6.
//

#import "Blebutton.h"

@interface Blebutton()

//@property(strong, nonatomic)UIImageView *imageView;
@property(strong, nonatomic)BatteryView *batteryView;
//@property(strong, nonatomic)UIActivityIndicatorView *hud;

@property(strong, nonatomic)UIView *baseView; // 用于从内部撑住大小

@end

@implementation Blebutton

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.backgroundColor = UIColor.clearColor;
        [self layoutBase];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = UIColor.clearColor;
//        self.baseView = [UIView new];
//        self.baseView.backgroundColor = UIColor.clearColor;
//        [self addSubview:self.baseView];
//        [self.baseView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.width.equalTo(@(frame.size.width));
//            make.height.equalTo(@(frame.size.height));
//            make.top.leading.trailing.bottom.equalTo(self);
//
//        }];
//        self.baseView.userInteractionEnabled = NO;
        
        [self layoutBase];

    }
    return self;
}

-(void)layoutBase {
//    self.imageView = [UIImageView new];
//    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    [self addSubview:self.imageView];
    
    [self addSubview:self.batteryView];

//    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.mas_centerX);
//        make.centerY.equalTo(self.mas_centerY);
//        make.width.equalTo(self.imageView.mas_height);
//        make.height.equalTo(self.mas_height).multipliedBy(0.5);
//
//    }];
    [self.batteryView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.equalTo(self);
//        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(self.mas_height).multipliedBy(0.9);
        make.trailing.equalTo(self.mas_trailing).inset(5);
        make.width.equalTo(self.batteryView.mas_height);
        make.centerY.equalTo(self.mas_centerY);
//        make.width.equalTo(@(40));
//        make.height.equalTo(@40);
//        make.centerX.equalTo(self.mas_centerX);
        
    }];
    self.batteryView.userInteractionEnabled = YES;
    
//    self.hud = [[UIActivityIndicatorView alloc]init];
//    [self addSubview:self.hud];
//
//    if (@available(iOS 13.0, *)) {
//        self.hud.activityIndicatorViewStyle = UIActivityIndicatorViewStyleMedium;
//
//    } else {
//        self.hud.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
//
//    }
//    self.hud.hidden = YES;
//    self.hud.userInteractionEnabled = NO;
//    [self.hud mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.batteryView.mas_centerX);
//        make.centerY.equalTo(self.batteryView.mas_centerY);
//
//    }];
//
//    [self addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
    
//    [self.baseView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
}
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    
    DebugNSLog(@"blebutton point x=%.1f , y =%.1f event %@", point.x, point.y,event);
    return self;
}

//-(void)tap:(UIButton *)btn {
//    if (self.tapCBK) {
//        self.tapCBK();
//    }
//}

-(void)setBleState:(BLE_BTN_STATE)state
{
    _bleState = state;
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (state) {
            case BLE_BTN_STATE_NOT_CONECT:
            {
                [self.batteryView removeAnimation];
                [self.batteryView showDisconnect:YES];
//                self.imageView.hidden = NO;
//                self.batteryView.hidden = YES;
//                self.imageView.image = [UIImage imageNamed:@"ble_disconnect"];
                [self.batteryView clean];
            }
                break;
            case BLE_BTN_STATE_CONNECTING:
            {
//                self.imageView.image = nil;
                [self.batteryView showDisconnect:YES];

//                self.hud.hidden = NO;
                [self.batteryView clean];
                [self.batteryView beginAnimation];


            }
                break;
                
            case BLE_BTN_STATE_CONNECTED:
            {
                [self.batteryView removeAnimation];

                [self.batteryView showDisconnect:NO];

//                self.imageView.hidden = YES;
//                self.batteryView.hidden = NO;

//                self.imageView.image = [UIImage imageNamed:@"battery_power_full"];


            }
                break;
                
                
            default:
                break;
        }
    });
   
}

-(void)setBatteryLevel:(NSInteger)batterylevel Ischarging:(BOOL)charging
{
    [self.batteryView setPercent:batterylevel IsCharging:charging];
//    if (charging) {
//        self.imageView.image = [UIImage imageNamed:@"battery_charging"];
//        return;
//    }
//
//    if (batterylevel >= 100) {
//        self.imageView.image = [UIImage imageNamed:@"battery_power_full"];
//    }
//    if (batterylevel < 100) {
//        self.imageView.image = [UIImage imageNamed:@"battery_power_less_100"];
//
//    }
//
//    if (batterylevel < 80) {
//        self.imageView.image = [UIImage imageNamed:@"battery_power_less_80"];
//
//    }
//
//    if (batterylevel < 50) {
//        self.imageView.image = [UIImage imageNamed:@"battery_power_less_50"];
//
//    }
//
//    if (batterylevel < 20) {
//        self.imageView.image = [UIImage imageNamed:@"battery_power_less_20"];
//
//    }
    
    
}

-(BatteryView *)batteryView
{
    if (!_batteryView) {
        _batteryView = [[BatteryView alloc]init];
        _batteryView.borderLineWidth = 1.f;
        _batteryView.batteryBorderLineWidth = 1.0f;
        _batteryView.batteryInnerMargin = 2;
        _batteryView.flashLineWidth = 0.5; // 闪电线宽
//        _batteryView.backgroundColor = UIColor.clearColor;
    }
    
    return _batteryView;
}

@end
