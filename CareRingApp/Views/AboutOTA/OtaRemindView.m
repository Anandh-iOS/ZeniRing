//
//  OtaRemindView.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/8/30.
//

#import "OtaRemindView.h"
#import "ConfigModel.h"
#import <Masonry/Masonry.h>
const CGFloat OtaRemindView_HEIGHT = 180.0f;
@implementation OtaRemindView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self layoutBase];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self layoutBase];

    }
    return self;
}

-(void)layoutBase {
    self.shouldHide = YES; //默认隐藏
    [self addSubview:self.titleLbl];

    [self addSubview:self.closeBtn ];
    [self addSubview:self.startBtn ];

    [self.titleLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self.closeBtn.mas_centerY);
        
    }];
    [self.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).inset(15);
        make.top.equalTo(self.mas_top).offset(15);
//        make.width.equalTo(self.closeBtn.mas_height);
//        make.height.equalTo(@30);
    }];
    
    UIView *midContent = [UIView new];
    [self addSubview:midContent];
    [midContent addSubview:self.leftVersionLbl ];
    [midContent addSubview:self.rightVersionLbl ];
    [midContent addSubview:self.arrowImageView ];
    [midContent mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self.titleLbl.mas_bottom).offset(8);
        make.bottom.equalTo(self.startBtn.mas_top).inset(8);
    }];
    
    [self.arrowImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(midContent.mas_centerX);
        make.centerY.equalTo(midContent.mas_centerY);
        make.width.equalTo(@40);
        make.height.equalTo(@25);
    }];
    
    [self.leftVersionLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.arrowImageView.mas_leading).inset(10);
        make.centerY.equalTo(self.arrowImageView.mas_centerY);
    }];
    
    [self.rightVersionLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.arrowImageView.mas_trailing).offset(10);
        make.centerY.equalTo(self.arrowImageView.mas_centerY);
    }];
    
    // 底部开始
    [self.startBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).inset(20);
        make.width.equalTo(@130);
        make.height.equalTo(@35);
    }];
    
}


-(void)start:(QMUIButton *)sender {
    if (self.startBlk) {
        self.startBlk();
    }
    
}


-(void)close:(QMUIButton *)sender {
    self.shouldHide = NO;
    if (self.closeBlk) {
        self.closeBlk();
    }
    
}

#pragma makr --lazy


-(UILabel *)titleLbl
{
    if (!_titleLbl) {
        _titleLbl = [UILabel new];
        _titleLbl.textAlignment = NSTextAlignmentLeft;
        _titleLbl.text = _L(L_OTA_NEW_FIRM_TITLE);
    }
    return _titleLbl;
}

-(UILabel *)rightVersionLbl
{
    if (!_rightVersionLbl) {
        _rightVersionLbl = [UILabel new];
        _rightVersionLbl.textAlignment = NSTextAlignmentLeft;
    }
    return _rightVersionLbl;
}

-(UILabel *)leftVersionLbl
{
    if (!_leftVersionLbl) {
        _leftVersionLbl = [UILabel new];
        _leftVersionLbl.textAlignment = NSTextAlignmentRight;
    }
    return _leftVersionLbl;
}

-(UIImageView *)arrowImageView
{
    if (!_arrowImageView) {
        _arrowImageView = [UIImageView new];
        _arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
        _arrowImageView.image = [UIImage imageNamed:@"bing_arrow"];
    }
    return _arrowImageView;
}

-(QMUIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [[QMUIButton alloc]init];
        [_closeBtn setImage:[UIImage imageNamed:@"close_btn"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _closeBtn;
}

-(QMUIButton *)startBtn
{
    if (!_startBtn) {
        _startBtn = [[QMUIButton alloc]init];
        [_startBtn setTitle:_L(L_OTA_UPDATE_NOW) forState:UIControlStateNormal];
        [_startBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_startBtn setBackgroundColor:MAIN_BLUE];
        _startBtn.cornerRadius = ITEM_CORNOR_RADIUS;
        [_startBtn addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}

@end
