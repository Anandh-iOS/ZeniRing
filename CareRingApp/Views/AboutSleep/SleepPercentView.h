//
//  SleepPercentView.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/23.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
NS_ASSUME_NONNULL_BEGIN

@interface SleepPercentView : UIView



///
/// @param seconds 当前时段的秒数
/// @param allSeconds 总睡眠的秒数
/// @param color 颜色
/// @param title 文字
-(void)setTime:(NSTimeInterval)seconds Alltime:(NSTimeInterval)allSeconds Color:(UIColor *)color TitleString:(NSString *)title IsCustomTitle:(BOOL)isCustomTitle;

+(UIColor *)colorWake;
+(UIColor *)colorREMSleep;
+(UIColor *)colorDeepSleep;
+(UIColor *)colorLightSleep;

@end

NS_ASSUME_NONNULL_END
