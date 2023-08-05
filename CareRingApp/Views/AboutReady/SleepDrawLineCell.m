//
//  SleepDrawLineCell.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/21.
//

#import "SleepDrawLineCell.h"
#import "ConfigModel.h"

@implementation SleepDrawLineCell

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

-(void)setDrawObj:(ReadyDrawObj *)drawObj
{
    _drawObj = drawObj;
    WEAK_SELF
    dispatch_async(dispatch_get_main_queue(), ^{
        STRONG_SELF
        strongSelf.drawView.drawObj = strongSelf->_drawObj;
        [strongSelf.drawView startDraw];
    });

    
    switch (_drawObj.readyDrawObjType) {
        case ReadyDrawObjType_heareRate:
        {
            self.mainLabel.text = _L(L_TITEL_MIN_HR);
            if (_drawObj.minValue) {
                self.subTitlA.text = [NSString stringWithFormat:@"%@ %@",_drawObj.minValue, _L(L_UNIT_HR)];
            } else {
                self.subTitlA.text = NONE_VALUE;
            }
            
            if (_drawObj.avgValue) {
                self.subTitlB.text = [NSString stringWithFormat:_L(L_FORMAT_SLEEP_AVG_HEART), (int)(_drawObj.avgValue.intValue)];
            } else {
                self.subTitlB.text = NONE_VALUE;
            }
            
        }
            break;
        case ReadyDrawObjType_hrv:
        {
            self.mainLabel.text = _L(L_TITEL_AVG_HRV);
            if (_drawObj.avgValue) {
                self.subTitlA.text = [NSString stringWithFormat:@"%d %@",_drawObj.avgValue.intValue, _L(L_UNIT_MS)];
            } else {
                self.subTitlA.text = NONE_VALUE;
            }
            
            if (_drawObj.maxValue) {
                self.subTitlB.text = [NSString stringWithFormat:_L(L_FORMAT_SLEEP_MAX_HRV), _drawObj.maxValue.intValue];
            } else {
                self.subTitlB.text = NONE_VALUE;
            }
        }
            break;
            
        default:
            break;
    }
    
    
    
    
//    WEAK_SELF
//    _drawObj.readyDrawDataBlk = ^(NSMutableArray<NSDictionary *> * _Nonnull objArray) {
//        STRONG_SELF
//        [strongSelf.drawView startDraw];
//
//    };
}


-(void)layoutBase {
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = UIColor.clearColor;
    // 背景色块 最底下
    UIView *bgView = [UIView new];
    [self.contentView addSubview: bgView];
    bgView.layer.cornerRadius = ITEM_CORNOR_RADIUS;
    bgView.layer.masksToBounds = YES;
    bgView.backgroundColor = ITEM_BG_COLOR;
    
    [self.contentView addSubview: self.mainLabel];
    [self.contentView addSubview: self.subTitlA];
    [self.contentView addSubview: self.subTitlB];
    [self.contentView addSubview: self.arrowImage];
   
    
    UIView *drawarea = [UIView new];
    [self.contentView addSubview:drawarea];
    self.drawArea = drawarea;
//    self.drawArea.backgroundColor = UIColor.lightGrayColor;
    
    [self.drawArea addSubview: self.drawView];
    
   

    [bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(bgView.superview);
        make.bottom.equalTo(self.drawArea);
    }];
    
  
    
    [self.mainLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.leading.equalTo(self.contentView).offset(15);
//        make.height.equalTo(@35);
    }];
    
    [self.arrowImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mainLabel.mas_centerY);
        make.trailing.equalTo(self.contentView).inset(15);

        make.height.equalTo(self.mainLabel.mas_height);
    }];
    
    [self.subTitlA mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mainLabel.mas_leading);
        make.top.equalTo(self.mainLabel.mas_bottom).offset(5);
//        make.height.equalTo(@30);
    }];
    
    [self.subTitlB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.subTitlA.mas_leading);
        make.top.equalTo(self.subTitlA.mas_bottom).offset(5);
//        make.height.equalTo(@30);
    }];
    
    [self.drawArea mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.contentView);
        make.top.equalTo(self.subTitlB.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).inset(15);
    }];
    
//    self.drawArea.backgroundColor = UIColor.greenColor;
    [self.drawView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self.drawView.superview);
        make.bottom.equalTo(self.drawView.superview.mas_bottom).inset(15);
    }];
    
}

-(UILabel *)mainLabel
{
    if (!_mainLabel) {
        _mainLabel = [UILabel new];
        _mainLabel.text = @"最低心率";
        _mainLabel.font = [UIFont systemFontOfSize:18];
    }
    return _mainLabel;
}

-(UILabel *)subTitlA
{
    if (!_subTitlA) {
        _subTitlA = [UILabel new];
        _subTitlA.text = @"56 bpm";
    }
    return _subTitlA;
}
-(UILabel *)subTitlB
{
    if (!_subTitlB) {
        _subTitlB = [UILabel new];
        _subTitlB.text = @"平均心率 56 bpm";
        _subTitlB.textColor = MAIN_BLUE;
        _subTitlB.font = [UIFont systemFontOfSize:14];
    }
    return _subTitlB;
}

-(UIImageView *)arrowImage
{
    if (!_arrowImage) {
        _arrowImage = [UIImageView new];
        _arrowImage.contentMode = UIViewContentModeScaleAspectFit;
        _arrowImage.image = [UIImage imageNamed:@"bing_arrow"];
    }
    return _arrowImage;
}

-(SleepDrawLineView *)drawView
{
    if (!_drawView) {
        _drawView = [[SleepDrawLineView alloc]init];
        
    }
    
    return _drawView;
}


@end
