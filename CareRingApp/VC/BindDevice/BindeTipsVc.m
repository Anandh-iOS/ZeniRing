//
//  BindeTipsVc.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/14.
//  提示可以开始绑定

#import "BindeTipsVc.h"
#import "ReadyToBindVc.h"
#include "BindParameterHeader.h"

@interface BindeTipsVc ()
@property(strong, nonatomic)UILabel *titleLabel, *tipsLabel;
@property(strong, nonatomic)QMUIButton *startBtn;

@end

@implementation BindeTipsVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    self.navigationController.navigationBarHidden = YES;
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return self.canGestPop;
}

-(void)initUI {
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.tipsLabel];
    [self.view addSubview:self.startBtn];
    
    
    [self.startBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).inset(30);
        make.height.equalTo(@BIND_START_BTN_HEIGHT);
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
    
    
}

-(void)gotoNext:(UIButton *)btn {
    
    ReadyToBindVc *vc = [ReadyToBindVc new];
    vc.isBindeNew = self.isBindeNew;
    [self.navigationController pushViewController:vc animated:YES];
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = _L(L_TIP_CONGRA_TITLE);
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
        _tipsLabel.text = _L(L_TIP_CONGRA_CONT);
        _tipsLabel.numberOfLines = 0;
    }
    return _tipsLabel;
        
}

-(QMUIButton *)startBtn
{
    if (!_startBtn) {
        _startBtn = [[QMUIButton alloc]init];
        [_startBtn setTitle:_L(L_BTN_START_BINT) forState:UIControlStateNormal];
        [_startBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_startBtn setBackgroundColor:MAIN_BLUE];
        _startBtn.cornerRadius = ITEM_CORNOR_RADIUS;
        [_startBtn addTarget:self action:@selector(gotoNext:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}

@end
