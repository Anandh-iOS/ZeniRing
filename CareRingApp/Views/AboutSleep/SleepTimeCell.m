//
//  SleepTimeCell.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/24.
//  睡眠时段分布

#import "SleepTimeCell.h"
#import "SleepPercentView.h"
#import "ConfigModel.h"


@implementation SleepTimeCell
{
    UIView *_drawArea, *_percentArea;
    
    NSMutableArray <SleepPercentView *> *_percentViewArray;
    
    __weak SleepPercentView *_wakePercentView, *_remPercentView, *_lightPercentView, *_deepPercentView;
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
    
    [self.drawView drawNone];
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
    
//    [self.mainLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.contentView).offset(15);
//        make.top.equalTo(self.contentView).offset(5);
////        make.height.equalTo(@40);
//    }];
//
//    [self.arrowImage mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.trailing.equalTo(self.contentView);
//        make.height.equalTo(self.mainLabel.mas_height);
//    }];
//
//    [self.subTitlA mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.mainLabel.mas_leading);
//        make.top.equalTo(self.mainLabel.mas_bottom).offset(2);
////        make.height.equalTo(@30);
//    }];
//
//    [self.subTitlB mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.subTitlA.mas_leading);
//        make.top.equalTo(self.subTitlA.mas_bottom).offset(2);
////        make.height.equalTo(@30);
//    }];
    _drawArea = [UIView new];
    _percentArea = [UIView new];
    
    [self.contentView addSubview:_drawArea];
    [self.contentView addSubview:_percentArea];
    
    [_drawArea mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.contentView);
        make.top.equalTo(self.infoView.mas_bottom).offset(15);
        make.bottom.equalTo(_percentArea.mas_top).inset(20);
    }];
    
    if (!self.drawView) {
        self.drawView = [[SleepTimeDrawView alloc]init];
        [_drawArea addSubview:self.drawView];
        [self.drawView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.trailing.bottom.equalTo(self.drawView.superview);
        }];
    }
//    [_drawArea setBackgroundColor:UIColor.greenColor];
    [_drawArea layoutIfNeeded];
//    _drawArea.backgroundColor = [UIColor redColor];
//    self.drawView.backgroundColor = UIColor.greenColor;
    
    [_percentArea mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(25);
        make.trailing.equalTo(self.contentView).inset(25);
        make.bottom.equalTo(self.contentView).inset(15);
        make.height.equalTo(@80);
    }];
    
    [self layoutPercentArea];
    
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
    _percentViewArray = [NSMutableArray arrayWithCapacity:4];
    for (int i = 0; i < 4; i++) {
        SleepPercentView *percentView = [[SleepPercentView alloc]init];
        _percentViewArray[i] = percentView;
        [_percentArea addSubview:percentView];
    }
    _wakePercentView = _percentViewArray[0];
    _remPercentView = _percentViewArray[1];
    _lightPercentView = _percentViewArray[2];
    _deepPercentView = _percentViewArray[3];
    // 布局
    [_percentViewArray mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:10 leadSpacing:0 tailSpacing:0];
    
    [_percentViewArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(_percentArea);
    }];

    
}



-(void)setSleepData:(StagingDataV2 *)sleepData
{
    
    _sleepData = sleepData;
    
    [self startDraw];
    [self showTextInfo];
}

-(void)showTextInfo {
  
    
    if (!_sleepTimeFormatter) {
        _sleepTimeFormatter = [[NSDateFormatter alloc]init];
        _sleepTimeFormatter.dateFormat = @"HH:mm";
    }
    NSDate *beginDate = [NSDate dateWithTimeIntervalSince1970:self.sleepData.startTime];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:self.sleepData.endTime];
    NSString *beginStr = [_sleepTimeFormatter stringFromDate:beginDate];
    NSString *endStr = [_sleepTimeFormatter stringFromDate:endDate];
    self.infoView.subLabelA.text = [NSString stringWithFormat:@"%@-%@", beginStr, endStr];
    
    // calc sleep time
    NSTimeInterval sleepTime = self.sleepData.endTime - self.sleepData.startTime;
    int hour = (int)(sleepTime / 3600);
    int minnutes = ((int)sleepTime) % 3600 / 60;
    // L_SLEEP_CELL_SUBB_FMT
    __block NSTimeInterval sleepTimeTemp = sleepTime;
    [self.sleepData.ousideStagingList enumerateObjectsUsingBlock:^(StagingSubObj * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.type == NONE || obj.type == WAKE) {
            NSMutableArray<StagingListObj *> * dictArray = obj.list;
            NSTimeInterval diff = fabs([dictArray.firstObject.time doubleValue] - [dictArray.lastObject.time doubleValue]);
            
            
            sleepTimeTemp -= diff;
        }
    }];
    
    if (sleepTime != 0) {
        double sleepEffectPercent = sleepTimeTemp / sleepTime * 100;
        self.infoView.subLabelB.text = [NSString stringWithFormat:_L(L_SLEEP_CELL_SUBB_FMT), hour, minnutes, (int)sleepEffectPercent];
        if (sleepEffectPercent >= 85) {
            [self.infoView setTextAndBarColor:HEALTH_COLOR_BEST];
        }
        if (sleepEffectPercent >= 70 && sleepEffectPercent < 85) {
            [self.infoView setTextAndBarColor:HEALTH_COLOR_WELL];

        }
        
        if (sleepEffectPercent < 70) {
            [self.infoView setTextAndBarColor:HEALTH_COLOR_ATTECTION];

        }

    } else {
        self.infoView.subLabelB.text = NONE_VALUE;
    }
    
    if (!self.sleepData) {
        [self showNoneInfo];
    }
    
//    self.infoView.subLabelB.text = [NSString stringWithFormat:_L(L_SLEEP_CELL_SUBB_FMT), hour, minnutes, ];
}

-(void)showNoneInfo {
    [self.infoView setTextAndBarColor:HEALTH_COLOR_BEST];
    self.infoView.subLabelA.text = NONE_VALUE;
    self.infoView.subLabelB.text = NONE_VALUE;
}

-(void)drawPercent {
    // 计算分类的时长
    NSTimeInterval wakeTime, remTime, lightTime, deepTime;
    wakeTime = remTime = lightTime =deepTime = 0;
    NSTimeInterval allTime = fabs( self.sleepData.startTime - self.sleepData.endTime);

//    NSDictionary *lastObj;
    for (int i = 0; i < self.sleepData.ousideStagingList.count; i++) {
        StagingSubObj *obj = self.sleepData.ousideStagingList[i]; // 分期数据
//        NSNumber *tempEndTime;
        NSTimeInterval tempInteval = 0;
        if (i == 0) {
            tempInteval = obj.list.lastObject.time.doubleValue -  obj.list.firstObject.time.doubleValue;
        } else {
            
            tempInteval = obj.list.lastObject.time.doubleValue -  self.sleepData.ousideStagingList[i-1].list.lastObject.time.doubleValue;

            
        }
        
//        if (i < self.sleepData.stagingList.count - 1) {
//            NSDictionary *nexSleepObj = self.sleepData.stagingList[i + 1];
//
//            tempEndTime = nexSleepObj.list.firstObject.time;
//        } else {
//            tempEndTime = obj.list.lastObject.time;
//        }
        
//        NSTimeInterval tempInteval = fabs(obj.list.firstObject.time.doubleValue -  tempEndTime.doubleValue);
        switch (obj.type) {
            case WAKE:  // 醒来
            {
                wakeTime += tempInteval;
            }
                break;
            case NREM1: // 浅度
            case  NREM2: // 重度
            {
                lightTime += tempInteval;
            }
                break;
            case  NREM3: // 深度
            {
                deepTime += tempInteval;

            }
                break;
            case  REM:   // REM
            {
                remTime += tempInteval;

            }
                break;
           
            default:
                break;
        }
    }
    
    [_wakePercentView setTime:wakeTime Alltime:allTime Color:[SleepPercentView colorWake] TitleString:_L(L_TXT_WAKETIME) IsCustomTitle:NO];
    [_remPercentView setTime:remTime Alltime:allTime Color:[SleepPercentView colorREMSleep] TitleString:_L(L_TXT_REMSLEEP) IsCustomTitle:NO];
    [_lightPercentView setTime:lightTime Alltime:allTime Color:[SleepPercentView colorLightSleep] TitleString:_L(L_TXT_LIGHTSLEEP) IsCustomTitle:NO];
    [_deepPercentView setTime:deepTime Alltime:allTime Color:[SleepPercentView colorDeepSleep] TitleString:_L(L_TXT_DEEPSLEEP) IsCustomTitle:NO];
}

-(void)startDraw {
    [self layoutIfNeeded]; //强刷
    
    if (self.sleepData) {
        [self.drawView startDraw:self.sleepData.ousideStagingList SleepStart:@(self.sleepData.startTime)
                        SleepEnd:@(self.sleepData.endTime)];
        
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
