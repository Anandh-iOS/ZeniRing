//
//  Blebutton.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/7/6.
//  蓝牙状态和连接按钮

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "BatteryView.h"

typedef NS_ENUM(NSInteger, BLE_BTN_STATE) {
    BLE_BTN_STATE_NOT_CONECT,   // 未连接
    BLE_BTN_STATE_CONNECTING,   // 连接中
    BLE_BTN_STATE_CONNECTED,    // 已连接
};

NS_ASSUME_NONNULL_BEGIN

@interface Blebutton : UIButton

@property(assign, nonatomic)BLE_BTN_STATE bleState;
//@property(copy, nonatomic)void (^tapCBK)(void);

- (instancetype)init;

//@property(assign, nonatomic)NSInteger batterylevel;  //电量

-(void)setBatteryLevel:(NSInteger)batterylevel Ischarging:(BOOL)charging;

@end

NS_ASSUME_NONNULL_END
