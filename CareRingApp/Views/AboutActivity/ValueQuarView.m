//
//  ValueQuarView.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/13.
//  首页头部的数据展示

#import "ValueQuarView.h"
#import "ConfigModel.h"

@implementation ValueQuarView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _titleLbl = [UILabel new];
        _valueLbl = [UILabel new];
        
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        _valueLbl.textAlignment = NSTextAlignmentCenter;
        
        _titleLbl.textColor = [UIColor lightGrayColor];
        _valueLbl.textColor = [UIColor whiteColor];
        _valueLbl.font = [UIFont fontWithName:FONT_ARIAL_BOLD size:20.f];
        
        [self addSubview:_titleLbl];
        [self addSubview:_valueLbl];
        [_titleLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self);
            make.top.equalTo(self).offset(5);
            make.height.equalTo(_valueLbl.mas_height);
        }];
        [_valueLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self);
            make.bottom.equalTo(self).inset(5);
            make.top.equalTo(_titleLbl.mas_bottom);
        }];
      
        self.layer.cornerRadius = ITEM_CORNOR_RADIUS;
        self.layer.masksToBounds = YES;
        self.backgroundColor = ITEM_BG_COLOR;

    }
    return self;
}

-(void)updateText:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.valueLbl.text = text;
    });
}

-(void)updateValueInt:(NSNumber * _Nullable)value Unit:(NSString *)unit
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (value) {
            self.valueLbl.text = [NSString stringWithFormat:@"%d %@", value.intValue, unit ? unit : @"" ];
        } else {
            self.valueLbl.text = [NSString stringWithFormat:@"%@ %@",NONE_VALUE, unit ? unit : @"" ];

        }
    });
    
    
}

-(void)updateValueFloat:(NSNumber * _Nullable)value Unit:(NSString *)unit
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (value) {
            self.valueLbl.text = [NSString stringWithFormat:@"%.1f %@",value.floatValue, unit ? unit : @"" ];

        } else {
            self.valueLbl.text = [NSString stringWithFormat:@"%@ %@",NONE_VALUE, unit ? unit : @"" ];

        }
    });
    
    
}

@end
