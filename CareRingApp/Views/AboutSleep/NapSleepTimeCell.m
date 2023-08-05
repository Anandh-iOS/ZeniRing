//
//  SleepTimeCell.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/24.
//  睡眠时段分布

#import "NapSleepTimeCell.h"
#import "SleepPercentView.h"
#import "ConfigModel.h"

#import "DBSleepData.h"
#import "TimeUtils.h"

@implementation NapSleepTimeCell
{
    UIView *_drawArea, *_percentArea;
    
    NSMutableArray <SleepPercentView *> *_percentViewArray;
    
//    __weak SleepPercentView *_wakePercentView, *_remPercentView, *_lightPercentView, *_deepPercentView;
    NSDateFormatter *_sleepTimeFormatter;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutBase];
    }
    
    return self;
}


-(void)drawNone {
    
    [self.napDrawView drawNone];
}


-(void)layoutBase {
    self.contentView.backgroundColor = [UIColor clearColor];
    

    [self.contentView addSubview:self.infoView];
    self.infoView.titleLabel.text = _L(L_TITLE_SLEEP_ANALYZE);
    [self.infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(15);
        make.leading.equalTo(self.mas_leading).offset(15);
        make.trailing.equalTo(self.mas_trailing).inset(15);
        make.height.equalTo(@90);
    }];
    
    [self.infoView setTextAndBarColor:HEALTH_COLOR_BEST]; // 默认颜色
    

    _drawArea = [UIView new];
    _percentArea = [UIView new];
    
    [self.contentView addSubview:_drawArea];
    [self.contentView addSubview:_percentArea];
    
    [_drawArea mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.contentView);
        make.top.equalTo(self.infoView.mas_bottom).offset(15);
        make.bottom.equalTo(_percentArea.mas_top).inset(20);
    }];
    
    if (!self.napDrawView) {
        self.napDrawView = [[NapSleepTimeDrawView alloc]init];
        [_drawArea addSubview:self.napDrawView];
        [self.napDrawView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.trailing.bottom.equalTo(self.napDrawView.superview);
        }];
    }
    [_drawArea layoutIfNeeded];

    
    [_percentArea mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(25);
        make.trailing.equalTo(self.contentView).inset(25);
        make.bottom.equalTo(self.contentView).inset(15);
        make.height.equalTo(@80);
    }];
    
//    [self layoutPercentArea];
    
//    [self.drawArea mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.leading.trailing.equalTo(self.contentView);
//        make.top.equalTo(self.subTitlB.mas_bottom).offset(10);
//        make.bottom.equalTo(self.contentView).inset(15);
//    }];
//
////    self.drawArea.backgroundColor = UIColor.greenColor;
//    [self.drawView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.leading.trailing.top.bottom.equalTo(self.drawView.superview);
//    }];
//
}

-(void)layoutPercentArea {
    if (_percentViewArray.count) {
        return;
    }
    _percentViewArray = [NSMutableArray arrayWithCapacity:self.sleepDataArray.count];
    for (int i = 0; i < self.sleepDataArray.count; i++) {
        SleepPercentView *percentView = [[SleepPercentView alloc]init];
        _percentViewArray[i] = percentView;
        [_percentArea addSubview:percentView];
    }
//    _wakePercentView = _percentViewArray[0];
//    _remPercentView = _percentViewArray[1];
//    _lightPercentView = _percentViewArray[2];
//    _deepPercentView = _percentViewArray[3];
    // 布局
    
    for (int i = 0; i < _percentViewArray.count; i++) {
        SleepPercentView *curView = _percentViewArray[i];
        [curView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            if (i == 0) {
                make.top.equalTo(curView.superview.mas_top);
            } else {
                make.top.equalTo(_percentViewArray[i-1].mas_bottom);
            }
            
            make.trailing.equalTo(curView.superview.mas_trailing);
            make.leading.equalTo(curView.superview.mas_leading);
            
            if (i == _percentViewArray.count -1) {
                make.bottom.equalTo(curView.superview.mas_bottom);
            }
        }];
        
    }
    
//    [_percentViewArray mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:10 leadSpacing:0 tailSpacing:0];
//
//    [_percentViewArray mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.trailing.equalTo(_percentArea);
//    }];

    
}


-(void)setSleepDataArray:(NSMutableArray<DBSleepData *> *)sleepDataArray
{
    _sleepDataArray = sleepDataArray;
    [self layoutPercentArea];
    [self startDraw];
    [self showTextInfo];
}



-(void)showTextInfo {
  
    
    if (!_sleepTimeFormatter) {
        _sleepTimeFormatter = [[NSDateFormatter alloc]init];
        _sleepTimeFormatter.dateFormat = @"HH:mm";
    }
    
    [self.infoView setTextAndBarColor:HEALTH_COLOR_BEST];

    
    self.infoView.subLabelA.text = [NSString stringWithFormat:@"%@",_L(L_SEG_NAP)];
    
    // 计算睡眠时间

    __block NSTimeInterval sleepTimeTemp = 0;
    [self.sleepDataArray enumerateObjectsUsingBlock:^(DBSleepData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSTimeInterval time = fabs(obj.stagingData.startTime - obj.stagingData.endTime);
        sleepTimeTemp += time;
    }];
    
    self.infoView.subLabelB.text = [NSString stringWithFormat:_L(L_NAP_SLEEP_CELL_SUBB_FMT), (int)(sleepTimeTemp/60)];
    

}

-(void)showNoneInfo {
    [self.infoView setTextAndBarColor:HEALTH_COLOR_BEST];
    self.infoView.subLabelA.text = NONE_VALUE;
    self.infoView.subLabelB.text = NONE_VALUE;
}

-(void)drawPercent {
    // 计算分类的时长
    WEAK_SELF
    [self.sleepDataArray enumerateObjectsUsingBlock:^(DBSleepData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        STRONG_SELF
        NSTimeInterval time = fabs(obj.sleepStart.doubleValue - obj.sleepEnd.doubleValue);
        
        NSString *beginStr = [strongSelf->_sleepTimeFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:obj.sleepStart.doubleValue]];
        NSString *endStr = [strongSelf->_sleepTimeFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:obj.sleepEnd.doubleValue]];
        
        
        NSString *title = [NSString stringWithFormat:@"%@ %dm %@-%@", _L(L_SEG_NAP), (int)(time/60),beginStr,endStr];
        
//        DebugNSLog(@"index %d  start %@ end %@", idx, obj.stagingData.startTime, obj.stagingData.endTime)
        
        [strongSelf->_percentViewArray[idx] setTime:time Alltime:60 * 60 Color:[SleepPercentView colorLightSleep] TitleString:title IsCustomTitle:YES];
    }];
    
  
}

-(void)startDraw {
    [self layoutIfNeeded]; //强刷
    
    // 前后间隔
    double timeDura = fabs(self.sleepDataArray.lastObject.sleepEnd.doubleValue - self.sleepDataArray.firstObject.sleepStart.doubleValue);
    int  i = 1;
    if (timeDura < 1 * 3600) {
        i = 4;
    } else if (timeDura < 4 * 3600) {
        i = 3;
    } else if (timeDura < 8 * 3600) {
        i = 1;
    }
    if (self.sleepDataArray.count) {
        [self.napDrawView startDraw:self.sleepDataArray SleepStart:@(self.sleepDataArray.firstObject.sleepStart.doubleValue - 3600 * i)
                        SleepEnd:@(self.sleepDataArray.lastObject.sleepEnd.doubleValue + 3600 * i)];
        
        [self drawPercent];
        
    } else {
        
        [self drawNone];
        [self drawPercent];
    }
    
   
}

//-(UILabel *)mainLabel
//{
//    if (!_mainLabel) {
//        _mainLabel = [UILabel new];
//        _mainLabel.text = _L(L_TITLE_SLEEP_ANALYZE);//@"睡眠分析";
//        _mainLabel.font = [UIFont fontWithName:FONT_ARIAL_BOLD size:22];
//    }
//    return _mainLabel;
//}
//
//-(UILabel *)subTitlA
//{
//    if (!_subTitlA) {
//        _subTitlA = [UILabel new];
//        _subTitlA.text = NONE_VALUE;
//    }
//    return _subTitlA;
//}
//-(UILabel *)subTitlB
//{
//    if (!_subTitlB) {
//        _subTitlB = [UILabel new];
//        _subTitlB.text = NONE_VALUE;//@"睡眠7h 00m 98%效率";
//        _subTitlB.textColor = UIColor.lightGrayColor;
//    }
//    return _subTitlB;
//}
//
//-(UIImageView *)arrowImage
//{
//    if (!_arrowImage) {
//        _arrowImage = [UIImageView new];
//        _arrowImage.contentMode = UIViewContentModeScaleAspectFit;
//        _arrowImage.image = [UIImage imageNamed:@"bing_arrow"];
//    }
//    return _arrowImage;
//}

-(TextInfoView *)infoView
{
    if (!_infoView) {
        _infoView = [[TextInfoView alloc]init];
        
    }
    return _infoView;
}

@end
