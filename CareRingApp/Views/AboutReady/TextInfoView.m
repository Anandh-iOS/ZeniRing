//
//  TextInfoView.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/7/29.
//

#import "TextInfoView.h"
#import "Colors.h"
#import "ConfigModel.h"

@implementation TextInfoView
{
    UIView *_vBar;  // 颜色竖线
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self layoutBase];
        
    }
    return self;
}

-(void)layoutBase {
    self.backgroundColor = UIColor.clearColor;
    _vBar = [UIView new];
  
    
    [self addSubview:_vBar];
    [self addSubview:self.titleLabel];
    [self addSubview:self.subLabelA];
    [self addSubview:self.subLabelB];
    [self addSubview:self.arrowBtn];
    
    CGFloat inset = 8;
    [_vBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLabel);
        make.width.equalTo(@4);
        make.top.equalTo(self.subLabelA.mas_top);
        make.bottom.equalTo(self.subLabelB.mas_bottom);
        
    }];
    _vBar.layer.cornerRadius = 2/2.0;
    _vBar.layer.masksToBounds = YES;
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.top.equalTo(self).offset(inset);
//        make.height.greaterThanOrEqualTo(@30);
    }];
    
    [self.arrowBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.trailing.equalTo(self.mas_trailing).inset(0);
        make.height.equalTo(self.titleLabel.mas_height);
    }];
    
    [self.subLabelA mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(inset);
        make.trailing.equalTo(self.mas_trailing).inset(inset);
        make.leading.equalTo(_vBar.mas_trailing).offset(5);
        make.height.greaterThanOrEqualTo(self.subLabelB.mas_height);
//        make.height.equalTo(self.subLabelB);

    }];
    [self.subLabelB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.subLabelA);
        make.trailing.equalTo(self.subLabelA);
        make.top.equalTo(self.subLabelA.mas_bottom).offset(3);
        make.bottom.equalTo(self.mas_bottom).inset(inset);
        make.height.equalTo(@18);
    }];
    
}

-(void)setBarColor:(UIColor *)color
{
    
    _vBar.backgroundColor = color;
}

-(void)showDefault {
    
    
}

-(void)setTextAndBarColor:(UIColor *)textColor
{
    self.subLabelA.textColor = textColor;
    _vBar.backgroundColor = textColor;
}

-(void)arrowClick:(id)sender {
    
    if (self.arrowClickCbk) {
        self.arrowClickCbk();
    }
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont fontWithName:FONT_ARIAL_BOLD size:17.f];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.text = NONE_VALUE;
    }
    return _titleLabel;
  
}
-(UILabel *)subLabelA
{
    if (!_subLabelA) {
        _subLabelA = [UILabel new];
        _subLabelA.font = [UIFont systemFontOfSize:15];
        _subLabelA.textAlignment = NSTextAlignmentLeft;
        _subLabelA.numberOfLines = 0;
        _subLabelA.text = NONE_VALUE;
    }
    return _subLabelA;
}

-(UILabel *)subLabelB
{
    if (!_subLabelB) {
        _subLabelB = [UILabel new];
        _subLabelB.font = [UIFont systemFontOfSize:13];
        _subLabelB.textAlignment = NSTextAlignmentLeft;
        _subLabelB.text = NONE_VALUE;
    }
    return _subLabelB;
}

-(QMUIButton *)arrowBtn
{
    if (!_arrowBtn) {
        _arrowBtn = [[QMUIButton alloc]init];
        [_arrowBtn setImage:[UIImage imageNamed:@"bing_arrow"] forState:UIControlStateNormal];
        [_arrowBtn addTarget:self action:@selector(arrowClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _arrowBtn;
}

@end
