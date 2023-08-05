//
//  SleepPercentView.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/23.
//  睡眠图标的组件 个个睡眠段的百分比

#import "SleepPercentView.h"

@interface SleepPercentView()

@property(strong, nonatomic)UIView *barView;
@property(strong, nonatomic)UILabel *textLabel; // 文字


@end

@implementation SleepPercentView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self layoutBase];
    }
    return self;
}

-(void)setTime:(NSTimeInterval)seconds Alltime:(NSTimeInterval)allSeconds Color:(UIColor *)color TitleString:(NSString *)title IsCustomTitle:(BOOL)isCustomTitle
{
    self.barView.backgroundColor = color;
    self.textLabel.textColor = color;
    if (allSeconds < 1) {
        allSeconds = 1;
    }
    double percent = seconds / allSeconds; // 百分比
    if (isCustomTitle) {
        self.textLabel.text = title;
    } else {
        self.textLabel.text = [NSString stringWithFormat:@"%@ %dh %dm %d%%", title,
                               (int)(seconds/3600), (((int)seconds) % 3600) / 60, (int)(percent * 100) ];
    }
    
    
    [self.barView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@10);
        make.width.equalTo(self.mas_width).multipliedBy(percent/3); // 一半长度的比例
    }];
    
}

-(void)layoutBase {
    [self addSubview:self.barView];
    [self addSubview:self.textLabel];
    
    [self.barView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@20);
    }];
    
    [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.barView.mas_trailing).offset(20);
        make.centerY.equalTo(self.barView.mas_centerY);
    }];
    
    
}

-(UIView *)barView
{
    if (!_barView) {
        _barView = [UIView new];
    }
    return _barView;
}

-(UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.font = [UIFont systemFontOfSize:14];
    }
    
    return _textLabel;
}


+(UIColor *)colorWake
{
    return [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.f];
}
+(UIColor *)colorREMSleep
{
    return [UIColor colorWithRed:32/255.0f green:240/255.0f blue:254/255.0f alpha:1.f];

}
+(UIColor *)colorDeepSleep
{
    return [UIColor colorWithRed:40/255.0f green:57/255.0f blue:148/255.0f alpha:1.f];

}
+(UIColor *)colorLightSleep
{
    return [UIColor colorWithRed:40/255.0f green:109/255.0f blue:250/255.0f alpha:1.f];

}

@end
