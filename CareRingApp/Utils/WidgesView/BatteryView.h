//
//  BatteryView.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/8/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BatteryView : UIView

@property(strong, nonatomic)UIColor *borderColor;
@property(strong, nonatomic)UIColor *highColor, *midColor, *lowColor;
// 变色分界
@property(strong, nonatomic)NSNumber *highLevel, *lowLevel;

@property(assign, nonatomic)CGFloat borderLineWidth; // 外部圆框的宽度
@property(assign, nonatomic)CGFloat batteryBorderLineWidth; // 电池外框的宽度
@property(assign, nonatomic)CGFloat flashLineWidth; // 闪电的外线宽度


@property(assign, nonatomic)CGFloat batteryInnerMargin; // 电池内容和电池边框的间距




/// 设置百分比
/// @param percent 范围 0-100
/// @param isCharging  是否在充电
-(void)setPercent:(float)percent IsCharging:(BOOL)isCharging;
-(void)clean;
-(void)showDisconnect:(BOOL)isDisconnect;

- (void)beginAnimation;
- (void)removeAnimation;

@end

NS_ASSUME_NONNULL_END
