//
//  BindSuccVc.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/14.
//

#import "BindSuccVc.h"
#include "BindParameterHeader.h"
#import "MydeviceVc.h"

@interface BindSuccVc ()
@property(strong, nonatomic)UILabel *titleLabel, *tipsLabel;
@property(strong, nonatomic)QMUIButton *startBtn;
@property(strong, nonatomic)UIImageView *idImageV;

@end

@implementation BindSuccVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

-(void)initUI {
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.tipsLabel];
    [self.view addSubview:self.startBtn];
    self.idImageV = [UIImageView new];
    self.idImageV.contentMode = UIViewContentModeScaleAspectFit;
    self.idImageV.image = [UIImage imageNamed:@"id_SR03"];
    [self.view addSubview:self.idImageV];

    
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
        make.bottom.equalTo(self.startBtn.mas_top).inset(30);
    }];
    
    [self.idImageV mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.width.equalTo(self.idImageV.mas_height);
        make.height.equalTo(@170);
    }];
    
    
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}

-(void)gotoNext:(UIButton *)btn {
    
//    ReadyToBindVc *vc = [ReadyToBindVc new];
//    [self.navigationController pushViewController:vc animated:YES];
//    if (self.isBindeNew) {
//        WEAK_SELF
//        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            STRONG_SELF
//            if ([obj isKindOfClass:[MydeviceVc class]]) {
//                [strongSelf.navigationController popToViewController:obj animated:YES];
//                *stop = YES;
//            }
//        }];
//
//    } else {
    
        [self.navigationController popToRootViewControllerAnimated:YES];
    
//    }
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = _L(L_TIP_BIND_SUCC);
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
        _tipsLabel.text = _L(L_TIP_BEFORE_USE);
        _tipsLabel.numberOfLines = 0;
    }
    return _tipsLabel;
        
}

-(QMUIButton *)startBtn
{
    if (!_startBtn) {
        _startBtn = [[QMUIButton alloc]init];
        [_startBtn setTitle:_L(L_BTN_START_USE) forState:UIControlStateNormal];
        [_startBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_startBtn setBackgroundColor:MAIN_BLUE];
        _startBtn.cornerRadius = ITEM_CORNOR_RADIUS;
        [_startBtn addTarget:self action:@selector(gotoNext:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}


@end
