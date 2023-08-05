//
//  BarDrawView.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/15.
//  主页的柱状图

#import "BarDrawView.h"
#import "Colors.h"
#import "ConfigModel.h"
const int X_LABEL_SHOW_SEP = 6; //每隔6个显示
const CGFloat Y_MARGIN_BOTTOM = 25; // 距离底部

@implementation BarDrawView
{
    __weak UIView *_xContent, *_yContent;  // 横纵坐标标签的容器
    __weak CAShapeLayer *_barLayer, *_lineLayer;
    
    NSMutableArray<UILabel *> *_xLabels, *_yLabels;
    __weak CAShapeLayer *_SepDotLineLayer; // 虚线分割
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.xCoordinates = [NSMutableArray arrayWithCapacity:24];
        for (int i = 0; i < 24; i++) {
            self.xCoordinates[i] = @(i); // 24小时
        }
        
        UIView *xContent = [UIView new];
        UIView *yContent = [UIView new];
        [self addSubview:xContent];
        [self addSubview:yContent];
        _xContent = xContent;
        _yContent = yContent;
        
        self.drawView = [UIView new];
//        self.drawView.backgroundColor = UIColor.redColor;
//        self.drawView.layer.borderColor = DRAW_BORDER_COLOR.CGColor;
//        self.drawView.layer.borderWidth = 1;
        [self addSubview:self.drawView];
        self.layer.cornerRadius = ITEM_CORNOR_RADIUS;
        self.layer.masksToBounds = YES;
        self.backgroundColor = ITEM_BG_COLOR;
        
        [self baseLayout];

    }
    return self;
}

-(void)baseLayout {
    
    [_xContent mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.drawView.mas_leading);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@30);
        make.trailing.equalTo(_yContent.mas_leading);
    }];
    [_yContent mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.mas_trailing);
        make.width.equalTo(@40);
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(_xContent.mas_top);
    }];
    [self.drawView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(10);
        make.top.equalTo(self).offset(20);
        make.bottom.equalTo(_xContent.mas_top);
        make.trailing.equalTo(_yContent.mas_leading);
    }];
    
    
}

-(void)createLabels
{
    DebugNSLog(@"lzp createLabels ");
    if (_yCoordinates.count == 0) {
        NSAssert(YES, @"_yCoordinates must set first!");
    }
    
    [[_xContent subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
   
    
    NSMutableArray *xLabels = [NSMutableArray arrayWithCapacity:_xCoordinates.count];
    [_xCoordinates enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *lbl = [UILabel new];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.adjustsFontSizeToFitWidth = YES;
        xLabels[idx] = lbl;
        if (idx % X_LABEL_SHOW_SEP == 0) {
            lbl.text = [NSString stringWithFormat:@"%.2d", obj.intValue];
        }
        lbl.textColor = UIColor.lightGrayColor;
        [_xContent addSubview:lbl];
    }];
    _xLabels = xLabels;
    
    // 横排
    [xLabels mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [xLabels mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_xContent);
    }];
    
  
    [self reCreateYlabels];
  
    [self setNeedsLayout];
    [self drawSepDottline]; //虚线分割线
}


///  垂直分割虚线
-(void)drawSepDottline {
    [_xContent setNeedsLayout];
    [_SepDotLineLayer removeFromSuperlayer];
    CAShapeLayer *layer = [CAShapeLayer new];
    layer.frame = CGRectMake(_xContent.frame.origin.x, self.drawView.frame.origin.y, _xContent.frame.size.width, self.drawView.frame.size.height + _xContent.frame.size.height);
//    DebugNSLog(@"lzp active cell 虚线layer width = %f height = %f", layer.frame.size.width, layer.frame.size.height);
    [self.layer addSublayer:layer];
    _SepDotLineLayer = layer;
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int i = 0; i < _xLabels.count; i++) {
        if (i % X_LABEL_SHOW_SEP == 0 && i > 0) {
            CGFloat x = _xLabels[i].frame.origin.x;
            [path moveToPoint:CGPointMake(x, 0)];
            [path addLineToPoint:CGPointMake(x, CGRectGetMaxY(layer.frame))];
            
        } if ( i == _xLabels.count -1) {
            CGFloat x = CGRectGetMaxX(_xLabels[i].frame); //_xLabels[i].frame.origin.x;
            [path moveToPoint:CGPointMake(x, 0)];
            [path addLineToPoint:CGPointMake(x, CGRectGetMaxY(layer.frame))];
            
        } else {
            
            continue;
        }
        
    }
//    _SepDotLineLayer.backgroundColor = UIColor.redColor.CGColor;
    [_SepDotLineLayer setLineDashPattern:@[@(5), @(3)]];
    _SepDotLineLayer.path = path.CGPath;
    _SepDotLineLayer.lineWidth = 0.5;
    _SepDotLineLayer.lineCap = kCALineCapRound;
    _SepDotLineLayer.strokeColor = SEPLINE_COLOR(0.5).CGColor;
    _SepDotLineLayer.fillColor = UIColor.clearColor.CGColor;
    
//    _SepDotLineLayer.backgroundColor = UIColor.lightGrayColor.CGColor;
}

-(void)reCreateYlabels
{
    NSArray<UIView *> *subView = [_yContent subviews];
    [subView enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    NSMutableArray *yLabels = [NSMutableArray arrayWithCapacity:_yCoordinates.count];
    [_yCoordinates enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *lbl = [UILabel new];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.textColor = UIColor.lightGrayColor;
        yLabels[idx] = lbl;
        lbl.adjustsFontSizeToFitWidth = YES;
        switch (self.formatType) {
            case Y_VALUE_FORMAT_HR:
            {
                lbl.text = [NSString stringWithFormat:@"%d", obj.intValue];
            }
                break;
            case Y_VALUE_FORMAT_HRV:
            {
                lbl.text = [NSString stringWithFormat:@"%d", obj.intValue];

            }
                break;
            case Y_VALUE_FORMAT_THERMEMOTER:
            {
                NSString *ylabelFormat = @"%d"; // 纵坐标显示数值格式
                if (obj.floatValue > 0) {
                    ylabelFormat = @"+%.1f";
                } else {
                    ylabelFormat = @"%.1f";
                }
                lbl.text = [NSString stringWithFormat:ylabelFormat, obj.floatValue];

            }
                break;
                
            default:
                break;
        }
        
        [_yContent addSubview:lbl];
    }];
    _yLabels = yLabels;
    CGFloat labelHeight = 15;
    // 确定头尾
    UILabel *firstLabel = yLabels.firstObject;
    UILabel *lastlabel = yLabels.lastObject;
    firstLabel.frame = CGRectMake(0, 0, _yContent.bounds.size.width, labelHeight);
    firstLabel.center = CGPointMake(_yContent.bounds.size.width / 2, self.drawView.frame.origin.y);
    
    lastlabel.frame = CGRectMake(0, 0, _yContent.bounds.size.width, labelHeight);
    
    lastlabel.center = CGPointMake(_yContent.bounds.size.width / 2, CGRectGetMaxY(self.drawView.frame) - Y_MARGIN_BOTTOM);
    
    CGFloat startCentY = firstLabel.center.y;
    CGFloat distance = lastlabel.center.y -  firstLabel.center.y;
    
    CGFloat everyY = distance / fabs(self.yCoordinates.firstObject.floatValue -  self.yCoordinates.lastObject.floatValue);
    for (int i = 1; i < yLabels.count - 1; i++) {
        
        CGFloat centY = fabs(self.yCoordinates[i].floatValue - self.yCoordinates.firstObject.floatValue) * everyY + startCentY;
        UILabel *tmpLable = yLabels[i];
        tmpLable.bounds = CGRectMake(0, 0, firstLabel.bounds.size.width, firstLabel.bounds.size.height);
        tmpLable.center = CGPointMake(firstLabel.center.x, centY);
    }

    
    
}


-(void)startDraw {
  
    // 开始绘图
    [self setNeedsLayout];
    
//    DebugNSLog(@"主页表格画 : width = %f height = %f", self.frame.size.width, self.frame.size.height);
    // 重新排Y坐标
    [self reCreateYlabels];
    [self drawSepDottline]; //虚线分割线
    [_barLayer removeFromSuperlayer];
    [_lineLayer removeFromSuperlayer];
    
    if (self.drawObjArray.count == 0) { // 没数据画
        return;
    }
    
    CAShapeLayer *barLayer = [[CAShapeLayer alloc]init];
    barLayer.frame = _drawView.bounds;
    [_drawView.layer addSublayer:barLayer];
    _barLayer = barLayer;
    
    // 折线图 平均值
    CAShapeLayer *lineLayer = [[CAShapeLayer alloc]init];
    lineLayer.frame = _drawView.bounds;
//    DebugNSLog(@"lzp active cell 折线layer width = %f height = %f", lineLayer.frame.size.width, lineLayer.frame.size.height);

    [_drawView.layer addSublayer:lineLayer];
    _lineLayer = lineLayer;
    
//    _lineLayer.backgroundColor = UIColor.greenColor.CGColor;
    
    // 画柱子
    CGFloat startY = _yLabels.lastObject.center.y;
    CGFloat distance = _yLabels.lastObject.center.y -  _yLabels.firstObject.center.y;
    if (distance < 1) {
        return;
    }
    CGFloat everyY = distance / (_yCoordinates.firstObject.floatValue - _yCoordinates.lastObject.floatValue);
    
    UIBezierPath *barBez = [[UIBezierPath alloc]init];
    UIBezierPath *lineBez = [[UIBezierPath alloc]init];
    CGFloat lineWidth = _xLabels.firstObject.bounds.size.width / 2;
    
//    float rectHeight = everyY *4;
    BOOL isFirstAvg = YES;
    for (BarDrawObj *obj in self.drawObjArray) {
        if (!obj.valueArrayOfHour.count) {
            continue;
        }
        int index = obj.hour;
        
        CGFloat x = _xLabels[index].center.x;
        
        UIBezierPath *mostPath = [UIBezierPath bezierPath];
        CGFloat yLow = startY - (obj.minValue.floatValue - _yCoordinates.lastObject.floatValue) * everyY - lineWidth;
        [mostPath moveToPoint:CGPointMake(x, yLow)];
        
        NSNumber *lastValue = obj.valueArrayOfHour.firstObject;
        for (NSNumber *value in obj.valueArrayOfHour) {
            CGFloat centerY = startY - (value.floatValue - _yCoordinates.lastObject.floatValue) * everyY - lineWidth;
//            CGPoint pointCenter = CGPointMake(x, centerY);
          
            if (fabs(lastValue.floatValue - value.floatValue) >= 35) {
                [barBez appendPath:mostPath];
                mostPath = [UIBezierPath bezierPath];
                [mostPath moveToPoint:CGPointMake(x, centerY + lineWidth/4)];
                [mostPath addLineToPoint:CGPointMake(x, centerY - lineWidth/4)];
//                [barBez appendPath:singlePath];
                
            } else {
                
                [mostPath addLineToPoint:CGPointMake(x, centerY - lineWidth/4)];

            }
            lastValue = value;

        }
        [barBez appendPath:mostPath];
        

        // 平均值折线
        CGFloat lineY = startY -  (obj.avgValue.floatValue - _yCoordinates.lastObject.floatValue) * everyY- lineWidth;
        CGFloat lineX = x;
        if (isFirstAvg) {
            [lineBez moveToPoint:CGPointMake(lineX, lineY)];
            isFirstAvg = NO;
        } else {
            [lineBez addLineToPoint:CGPointMake(lineX, lineY)];
        }
        
    }
    
    
    _barLayer.path = barBez.CGPath;
    _barLayer.lineCap = kCALineCapRound;
    _barLayer.lineWidth = lineWidth;
    _barLayer.strokeColor = MAIN_BLUE.CGColor;
    _barLayer.fillColor = UIColor.clearColor.CGColor;
    
    _lineLayer.path = lineBez.CGPath;
    _lineLayer.lineCap = kCALineCapSquare;
    _lineLayer.lineWidth = 1;
    _lineLayer.strokeColor = UIColor.greenColor.CGColor;
    _lineLayer.fillColor = UIColor.clearColor.CGColor;
}

-(void)setFormatType:(Y_VALUE_FORMAT)formatType
{
    _formatType = formatType;
   
}


@end


@implementation BarDrawObj

-(void)sortValueAsc:(BOOL)isAsc {
    if (!self.valueArrayOfHour.count)
    {
        return;
    }
    if (isAsc) {
        [self.valueArrayOfHour sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];
    } else {
        [self.valueArrayOfHour sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj2 compare:obj1];
        }];
    }
    
}

-(NSArray<NSNumber *> *)valueArrayOfHour
{
    if (!_valueArrayOfHour) {
        _valueArrayOfHour = [NSMutableArray new];
    }
    return _valueArrayOfHour;
}

-(NSNumber *)avgValue
{
    if (self.valueArrayOfHour.count > 0) {
        return [self.valueArrayOfHour valueForKeyPath:@"@avg.intValue"];
    }
    return nil;
}

-(NSNumber *)minValue {
    if (self.valueArrayOfHour.count > 0) {
        return [self.valueArrayOfHour valueForKeyPath:@"@min.intValue"];
    }
    return nil;
}

-(NSNumber *)maxValue
{
    if (self.valueArrayOfHour.count > 0) {
        return [self.valueArrayOfHour valueForKeyPath:@"@max.intValue"];
    }
    return nil;
    
}

@end
