//
//  ActivityCell.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/13.
//

#import "ActivityCell.h"
#import "BarDrawView.h"
#import "ConfigModel.h"
#import "TimeUtils.h"

@implementation ActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUi];
    }
    return self;
   
}

-(void)initUi {
    
    self.contentView.backgroundColor = UIColor.clearColor;
    self.backgroundColor = self.contentView.backgroundColor;
    self.title = [UILabel new];
    self.valuelabel = [UILabel new];
    self.UnitLabel = [UILabel new];
    self.timeLabel = [UILabel new];
    self.arrowBtn = [[QMUIButton alloc]init];
    [self.arrowBtn addTarget:self action:@selector(arrowClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.arrowBtn setImage:[UIImage imageNamed:@"bing_arrow"] forState:UIControlStateNormal];
    self.bottomImage = [UIImageView new];
    self.bottomImage.contentMode = UIViewContentModeScaleAspectFit;
    
    self.drawView = [[BarDrawView alloc]init];
    self.title.font = [UIFont fontWithName:FONT_ARIAL_BOLD size:20];
    self.valuelabel.font = [UIFont fontWithName:FONT_ARIAL_BOLD size:40];//[UIFont systemFontOfSize:40];
    
    [self.contentView addSubview: self.title];
    [self.contentView addSubview: self.valuelabel];
    [self.contentView addSubview: self.UnitLabel];
    [self.contentView addSubview: self.timeLabel];
    [self.contentView addSubview: self.arrowBtn];
    [self.contentView addSubview:  self.bottomImage];
    [self.contentView addSubview: self.drawView];

    
    [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(self.contentView);
        make.height.equalTo(@35);
    }];
    [self.arrowBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.contentView.mas_trailing).inset(5);
        make.top.equalTo(self.contentView.mas_top);
        make.height.equalTo(self.title.mas_height);
//        make.width.equalTo(@80);
    }];
    
    [self.bottomImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView);
        make.width.equalTo(self.bottomImage.mas_height);
        make.height.equalTo(@45);
        make.bottom.equalTo(self.contentView.mas_bottom).inset(20);
    }];
    
    [ self.valuelabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomImage.mas_trailing).offset(3);
        make.top.bottom.equalTo(self.bottomImage);
    }];
    
    [self.UnitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.valuelabel.mas_trailing).offset(5);
        make.top.equalTo(self.valuelabel.mas_top);
    }];
    
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.UnitLabel.mas_leading);
        make.bottom.equalTo(self.valuelabel.mas_bottom);
        make.top.equalTo(self.UnitLabel.mas_bottom);
        make.height.equalTo(self.UnitLabel.mas_height);
    }];
    
    [self.drawView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.contentView);
        make.top.equalTo(self.title.mas_bottom);
        make.bottom.equalTo(self.bottomImage.mas_top).inset(15);
        
    }];
    
}


-(void)arrowClick:(UIButton *)btn {

    if (self.arrowClickBLK) {
        self.arrowClickBLK(self.activityObj.type);
    }
    
    
}

-(void)createLabels {
//    [self.drawView createLabels];// 横纵坐标标签

}

-(void)setActivityObj:(ActivityObj *)activityObj
{
    ActivityObj *lastObj = _activityObj;
    _activityObj = activityObj;
    
    self.title.text = _activityObj.titleString;
    self.UnitLabel.text = _activityObj.unitString;
    self.bottomImage.image = _activityObj.typeImage;
    self.valuelabel.text = @"00";
   
    if (!activityObj) { // 补丁 防止横坐标混乱
        self.valuelabel.text = NONE_VALUE;// @"--";
    }
    
    self.drawView.yCoordinates = _activityObj.barDrawVerticalCoordinate;
    if (lastObj != _activityObj) {
        [self.drawView createLabels];// 横纵坐标标签

    }
    
    WEAK_SELF
    
    _activityObj.readyDrawDataBlk = ^(NSMutableArray<BarDrawObj *> * _Nullable objArray, NSNumber * _Nullable allMax, NSNumber * _Nullable allMin) {
        STRONG_SELF
        strongSelf.drawView.drawObjArray = objArray;
        
        strongSelf.drawView.allMaxValue = allMax;
        strongSelf.drawView.allMixValue = allMin;
        if (allMax && allMin) {
//            DebugNSLog(@"allMax =%@  allMin= %@ drawobjcount = %d thread:%@", allMax, allMin, strongSelf.drawView.drawObjArray.count, [NSThread currentThread]);
        }
        strongSelf.drawView.formatType = [strongSelf transType:strongSelf.activityObj.type];
        // 动态计算赋值
        strongSelf.drawView.yCoordinates = [strongSelf.activityObj calcRealVerticalCoordinate:allMax Min:allMin];
        
        [strongSelf.drawView startDraw];
        
       
    };
    
    _activityObj.showValueBlk = ^(NSNumber * _Nullable averageInDate, NSNumber * _Nonnull maxTimeInDate) {
        STRONG_SELF
        switch (strongSelf->_activityObj.type) {
        
            case ACTIVITYOBJ_TYPE_HR:
            {
                //            self.valuelabel.text = @"78";
                if (averageInDate && maxTimeInDate) {
                    strongSelf.valuelabel.text = [NSString stringWithFormat:@"%.2d", strongSelf->_activityObj.averageInDate.intValue];
                    strongSelf.timeLabel.text = [strongSelf timeString:activityObj.maxTimeInDate];
                }
                else {
                    strongSelf.valuelabel.text = NONE_VALUE;
                    strongSelf.timeLabel.text = NONE_VALUE;
                }
            }
                break;
            case ACTIVITYOBJ_TYPE_HRV:
            {
                //            self.valuelabel.text = @"50";
                if (averageInDate && maxTimeInDate) {
                    strongSelf.valuelabel.text = [NSString stringWithFormat:@"%.2d", strongSelf->_activityObj.averageInDate.intValue];
                    strongSelf.timeLabel.text = [strongSelf timeString:activityObj.maxTimeInDate];
                }
                else {
                    strongSelf.valuelabel.text = NONE_VALUE;
                    strongSelf.timeLabel.text = NONE_VALUE;
                }

            }
                break;
            case ACTIVITYOBJ_TYPE_TEMP:
            {
    //            self.valuelabel.text = @"0.5";
                if (averageInDate && maxTimeInDate) {
                    strongSelf.valuelabel.text = [NSString stringWithFormat:@"%.1f", strongSelf->_activityObj.averageInDate.floatValue];
                    strongSelf.timeLabel.text = [strongSelf timeString:activityObj.maxTimeInDate];
                } else {
                    strongSelf.valuelabel.text = NONE_VALUE;
                    strongSelf.timeLabel.text = NONE_VALUE;
                }
             

            }
                break;
                
            default:
                break;
        }
    };
    
    _activityObj.showValueBlk(_activityObj.averageInDate, _activityObj.maxTimeInDate);
    
//    _activityObj.readyDrawDataBlk = ^(NSMutableArray<BarDrawObj *> * _Nonnull objArray) {
//    STRONG_SELF
//        strongSelf.drawView.drawObjArray = objArray;
//        [strongSelf.drawView startDraw];
//    };
    _activityObj.readyDrawDataBlk(_activityObj.cacheObjArray, _activityObj.allMaxValue, _activityObj.allMinVaue);
    
}

-(NSString *)timeString:(NSNumber * _Nullable )time {
    if (!time) {
        return NONE_VALUE;
    }
    
    NSDate *zeroDate = [TimeUtils zeroOfDate:[NSDate date]];
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval timeInterval = time.doubleValue;
    NSTimeInterval timeDiff = [zeroDate timeIntervalSince1970] - timeInterval;
    if (timeDiff  > 0) {
        // 0点以前的数据
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = _L(L_BAR_DRAW_FORMAT_HOUR_MIN);
        return [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval] ];
          
    } else {
        timeDiff = now - timeInterval;
        if (timeDiff < 60) {
            return _L(L_BAR_DRAW_JUST_NOW);
        }
        
        if (timeDiff < 60 * 60) { // 几分钟前
            return [NSString stringWithFormat:@"%d %@", ((int)timeDiff) / 60 , _L(L_BAR_DRAW_MIN_AGO)];
        }
        
        if (timeDiff < 60 * 60 * 24) { // 几小时前
            return [NSString stringWithFormat:@"%d %@", ((int)timeDiff) / 3600 , _L(L_BAR_DRAW_HOUR_AGO)];
        }
        
    }
    
    return NONE_VALUE;
    
    
    
}

-(Y_VALUE_FORMAT)transType:(ACTIVITYOBJ_TYPE)type {
    
    Y_VALUE_FORMAT formatType;
    switch (type) {
        case ACTIVITYOBJ_TYPE_HR:
        {
            formatType = Y_VALUE_FORMAT_HR;
        }
            break;
        case ACTIVITYOBJ_TYPE_HRV:
        {
            formatType = Y_VALUE_FORMAT_HRV;

        }
            break;
        case ACTIVITYOBJ_TYPE_TEMP:
        {
            formatType = Y_VALUE_FORMAT_THERMEMOTER;

        }
            break;
           
        default:
        {
            formatType = Y_VALUE_FORMAT_HR;
        }
            break;
    }
    
    return formatType;
}

-(void)fresh {
    
    if ( _activityObj.readyDrawDataBlk) {
        _activityObj.readyDrawDataBlk(_activityObj.cacheObjArray, _activityObj.allMaxValue, _activityObj.allMinVaue);

    }
    
    if ( _activityObj.showValueBlk) {
    _activityObj.showValueBlk(_activityObj.averageInDate, _activityObj.maxTimeInDate);
    }
}

@end
