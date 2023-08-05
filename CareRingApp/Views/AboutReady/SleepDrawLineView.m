//
//  SleepDrawLineView.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/21.
//  就绪和睡眠的折线图

#import "SleepDrawLineView.h"
#import "Colors.h"



const CGFloat SLEEP_DRAW_HOR_MARGIN = 40.0f; // 左右留白
const CGFloat SLEEP_DRAW_VAR_MARGIN = 30.0f; // 左右留白

const CGFloat Y_LABELS_HEIGHT = 25.0f;  // y轴的label高度


@implementation SleepDrawLineView
{
    __weak CAShapeLayer *_borderLayer; // 边框
    
    __weak CAShapeLayer *_avgValueLineLayer;  // 平均值虚线
    __weak CAShapeLayer *_lineLayer;  // 折线图
    
    __weak CAShapeLayer *_ylabelSepDotLayer; // 右侧数值的虚线分割
    CGFloat _minY;  // 最低点
    CGFloat _maxY;  // 最高点
    
    NSNumber *_drawMaValue, *_drawMinValue;
    NSArray<NSNumber *> * _yCoordinates;
    NSArray<UILabel *> *_yLabels;
    UIColor *_borderColor;
    __weak CAShapeLayer *_minValuePointlayer; //最低点的圆点
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self layoutBase];
        
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        [self layoutBase];
    }
    return self;
}

-(void)layoutBase {
    _borderColor = [UIColor colorWithRed:91/255.0 green:91/255.0 blue:91/255.0 alpha:0.7];
    self.leftLblArea = [UIView new];
    self.rightLblArea = [UIView new];
    self.xLblArea = [UIView new];
    self.drawArea = [UIView new];
    
    [self addSubview:self.leftLblArea];
    [self addSubview:self.rightLblArea];
    [self addSubview:self.xLblArea];
    [self addSubview:self.drawArea];
    

    [self.leftLblArea mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(self);
        make.width.equalTo(@(SLEEP_DRAW_HOR_MARGIN));
        make.bottom.equalTo(self.mas_bottom).inset(SLEEP_DRAW_VAR_MARGIN);
        
    }];
    
    [self.rightLblArea mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.equalTo(self);
        make.width.equalTo(@(SLEEP_DRAW_HOR_MARGIN));
        make.bottom.equalTo(self.mas_bottom).inset(SLEEP_DRAW_VAR_MARGIN);
        
    }];
    
    [self.xLblArea mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self);
        make.height.equalTo(@(SLEEP_DRAW_VAR_MARGIN));
    }];
    
    [self.drawArea mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.leading.equalTo(self.leftLblArea.mas_trailing);
        make.trailing.equalTo(self.rightLblArea.mas_leading);
        make.bottom.equalTo(self.xLblArea.mas_top);
    }];
}

-(void)startDraw
{
    [self layoutIfNeeded];
    
//    _minY = CGRectGetMaxY(self.rightLblArea.frame) - Y_LABELS_HEIGHT / 2 - 10;
//    _maxY =  Y_LABELS_HEIGHT / 2;
    
    [_avgValueLineLayer removeFromSuperlayer];  // 平均值虚线
    [_lineLayer removeFromSuperlayer];  // 折线图
    _avgValueLineLayer = nil;
    _lineLayer = nil;

    
    
    [self drawBorder]; // 画边框
    [self layoutYlabels];
    // 分割虚线
    [self drawYlabesSepDottline];
//    if (!self.drawObj.valuesArray.count) {
//        return;
//    }
    
    [self drawAvgDottline];

    [self drawLine];
    // 横坐标
    NSDate *startDate = self.drawObj.valuesArray.firstObject[@"time"];
    NSDate *endDate = self.drawObj.valuesArray.lastObject[@"time"];
    [self layOutXlabels:startDate
                EndTime:endDate];
    
    
}

-(void)drawLine {
    
    if (!self.drawObj || !self.drawObj.valuesArray.count) {
        [_lineLayer removeFromSuperlayer];
        return;
    }
    // 时间差
    NSDate *startDate = self.drawObj.valuesArray.firstObject[@"time"];
    NSDate *endDate = self.drawObj.valuesArray.lastObject[@"time"];

    NSTimeInterval timeAll = [endDate timeIntervalSinceDate:startDate]; // 秒为单位
    CGFloat widthAll = self.drawArea.bounds.size.width;
    CGFloat everyX = widthAll / timeAll;
    
//    CGFloat everyY = (_minY - _maxY) / (self.drawObj.maxValue.floatValue - self.drawObj.minValue.floatValue);
    CGFloat distance = _yLabels.lastObject.center.y -  _yLabels.firstObject.center.y;
    if (distance < 1) {
        return;
    }
    CGFloat everyY = distance / fabs(_yCoordinates.firstObject.floatValue - _yCoordinates.lastObject.floatValue);
    
    [_lineLayer removeFromSuperlayer];
    CAShapeLayer *lineLayer = [[CAShapeLayer alloc]init];
    lineLayer.frame = self.drawArea.bounds;
    
    [self.drawArea.layer addSublayer:lineLayer];
    _lineLayer = lineLayer;
    
    UIBezierPath *path = [[UIBezierPath alloc]init];
    
    CGPoint startPoint, endPoint;
    // _minValuePointlayer
    for (int i  = 0; i < self.drawObj.valuesArray.count; i++) {
        
        NSDate *currentDate = self.drawObj.valuesArray[i][@"time"];
        NSTimeInterval timeSep = [currentDate timeIntervalSinceDate:startDate];
        NSNumber *currVal = self.drawObj.valuesArray[i][@"value"];
        
        CGPoint point = CGPointMake(everyX * timeSep,
                                    _minY - (currVal.floatValue - _yCoordinates.lastObject.floatValue) * everyY );
        if (i == 0) {
            [path moveToPoint:point];
            startPoint = point;
        } else {
            [path addLineToPoint:point];
        }
        
        if (i == self.drawObj.valuesArray.count - 1) {
            endPoint = point;
        }
        // 画最低点
        if (self.drawObj.readyDrawObjType == ReadyDrawObjType_heareRate) { // 心率画最低点
            if (i == self.drawObj.minIndex.intValue) {
                [self drawMinValuePoint:_lineLayer Center:point];
            }
        }
        
    }
    
    // 开始结尾加圆头
    UIBezierPath *roundPath = [[UIBezierPath alloc]init];

    [roundPath addArcWithCenter:startPoint radius:2.5 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    [roundPath addArcWithCenter:endPoint radius:2.5 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    
    CAShapeLayer *roundLayer = [[CAShapeLayer alloc]init];
    roundLayer.frame = _lineLayer.bounds;
    
    [_lineLayer addSublayer:roundLayer];
    roundLayer.path = roundPath.CGPath;
    roundLayer.fillColor = MAIN_BLUE.CGColor;
    _lineLayer.fillColor = MAIN_BLUE.CGColor;
    
    
    _lineLayer.path = path.CGPath;
    _lineLayer.lineCap = kCALineCapSquare;
    _lineLayer.lineWidth = 1;
    _lineLayer.fillColor = UIColor.clearColor.CGColor;
    _lineLayer.strokeColor = MAIN_BLUE.CGColor;
}

-(void)drawMinValuePoint:(CALayer *)superLayer Center:(CGPoint)pointCenter {
    [_minValuePointlayer removeFromSuperlayer];
    _minValuePointlayer = nil;
//    if (_minValuePointlayer != nil) {
//        return;
//    }
    CGFloat radiusBig = 9;// 半径
    CGFloat radiusSmall = radiusBig * 0.7;// 半径

    CAShapeLayer *minValuePointlayer = [CAShapeLayer layer];
    [superLayer addSublayer:minValuePointlayer];
    _minValuePointlayer = minValuePointlayer;
//    _minValuePointlayer.backgroundColor = UIColor.greenColor.CGColor;
    minValuePointlayer.frame = CGRectMake(pointCenter.x - radiusBig/2, pointCenter.y - radiusBig/2, radiusBig, radiusBig);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(minValuePointlayer.bounds.size.width/2, minValuePointlayer.bounds.size.height/2) radius:radiusSmall startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    _minValuePointlayer.path = path.CGPath;
    _minValuePointlayer.lineCap = kCALineCapSquare;
    _minValuePointlayer.lineWidth = radiusBig - radiusSmall;
    _minValuePointlayer.fillColor = UIColor.whiteColor.CGColor;
    _minValuePointlayer.strokeColor = _borderColor.CGColor;
    
    
}

-(void)drawBorder {
    [_borderLayer removeFromSuperlayer];
    _borderLayer = nil;
    if (_borderLayer == nil) {
        CAShapeLayer *borderlayer = [[CAShapeLayer alloc]init];
        borderlayer.frame = self.drawArea.bounds;
        [self.drawArea.layer addSublayer:borderlayer];
        _borderLayer = borderlayer;
//        _borderLayer.backgroundColor = UIColor.greenColor.CGColor;
//        DebugNSLog(@"折线 创建边框 x = %f, y = %f w = %f h = %f", borderlayer.frame.origin.x, borderlayer.frame.origin.y, borderlayer.frame.size.width, borderlayer.frame.size.height);
    } else {
//        DebugNSLog(@"折线 边框已存在 x = %f, y = %f w = %f h = %f", _borderLayer.frame.origin.x, _borderLayer.frame.origin.y, _borderLayer.frame.size.width, _borderLayer.frame.size.height);
    }
    
//    DebugNSLog(@"折线 边框画图 x = %f, y = %f w = %f h = %f", _borderLayer.frame.origin.x, _borderLayer.frame.origin.y, _borderLayer.frame.size.width, _borderLayer.frame.size.height);
//    _borderLayer.backgroundColor = [UIColor whiteColor].CGColor;
   
    UIBezierPath *borderPath = [[UIBezierPath alloc]init];
    [borderPath moveToPoint:CGPointMake(_borderLayer.frame.origin.x, _borderLayer.frame.origin.y)];
    [borderPath addLineToPoint:CGPointMake(_borderLayer.frame.origin.x, CGRectGetMaxY(_borderLayer.frame))];
    [borderPath addLineToPoint:CGPointMake(CGRectGetMaxX(_borderLayer.frame), CGRectGetMaxY(_borderLayer.frame))];
    [borderPath addLineToPoint:CGPointMake(CGRectGetMaxX(_borderLayer.frame), _borderLayer.frame.origin.y)];
    
    _borderLayer.path = borderPath.CGPath;
    _borderLayer.strokeColor = _borderColor.CGColor;
    _borderLayer.fillColor = UIColor.clearColor.CGColor;
    _borderLayer.lineWidth = 1.0f;
    _borderLayer.lineCap = kCALineCapSquare;
    
}

-(void)drawYlabesSepDottline {
    [_ylabelSepDotLayer removeFromSuperlayer];
    _ylabelSepDotLayer = nil;
    CAShapeLayer *dotLayer = [[CAShapeLayer alloc]init];
    dotLayer.frame = self.drawArea.bounds;
    
    [self.drawArea.layer addSublayer:dotLayer];
    _ylabelSepDotLayer = dotLayer;
    UIBezierPath *path = [[UIBezierPath alloc]init];
    CGFloat maxX = CGRectGetMaxX(dotLayer.frame);
    for(int i = 0; i < _yLabels.count; i++) {
        
        CGFloat lineY = _yLabels[i].center.y;
        CGPoint startPoint = CGPointMake(0, lineY);
        CGPoint endPoint = CGPointMake(maxX, lineY);
        [path moveToPoint:startPoint];
        [path addLineToPoint:endPoint];
        
    }
    
    
    _ylabelSepDotLayer.path = path.CGPath;
    _ylabelSepDotLayer.fillColor = UIColor.clearColor.CGColor;
    _ylabelSepDotLayer.strokeColor = _borderColor.CGColor;
    _ylabelSepDotLayer.lineWidth = 1;
    _ylabelSepDotLayer.lineDashPattern = @[@(6), @(3)]; //3 线段宽度 1间距
    _ylabelSepDotLayer.lineCap = kCALineCapSquare;

}

-(void)drawAvgDottline {
    [_avgValueLineLayer removeFromSuperlayer];
    _avgValueLineLayer = nil;
    // label
    [self.leftLblArea.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    if (self.drawObj.maxValue == nil || self.drawObj.minValue == nil) {
        return;
    }
    
    CAShapeLayer *dotLayer = [[CAShapeLayer alloc]init];
    dotLayer.frame = self.drawArea.bounds;
    [self.drawArea.layer addSublayer:dotLayer];
    _avgValueLineLayer = dotLayer;

    UIBezierPath *path = [[UIBezierPath alloc]init];
    
    // 平均值虚线
    CGFloat everyY = (_minY - _maxY) / (_yCoordinates.firstObject.floatValue - _yCoordinates.lastObject.floatValue);
    CGFloat Y = _minY - (self.drawObj.avgValue.floatValue - _yCoordinates.lastObject.floatValue) * everyY ;
    CGPoint point = CGPointMake(0, Y);
    [path moveToPoint:point];
    [path addLineToPoint:CGPointMake(_avgValueLineLayer.bounds.size.width, Y)];

    
    _avgValueLineLayer.path = path.CGPath;
    _avgValueLineLayer = dotLayer;
    _avgValueLineLayer.fillColor = UIColor.clearColor.CGColor;
    _avgValueLineLayer.strokeColor = MAIN_BLUE.CGColor;
    _avgValueLineLayer.lineWidth = 1;
    _avgValueLineLayer.lineDashPattern = @[@(6), @(3)]; //3 线段宽度 1间距
    
  
    UILabel *lbl = [UILabel new];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.frame = CGRectMake(0, Y - (Y_LABELS_HEIGHT / 2), self.leftLblArea.bounds.size.width, Y_LABELS_HEIGHT);
    if (self.drawObj.readyDrawObjType == ReadyDrawObjType_TEMPERATURE) {
        lbl.text = [NSString stringWithFormat:@"%.1f", self.drawObj.avgValue.floatValue];

    } else {
        lbl.text = [NSString stringWithFormat:@"%d", self.drawObj.avgValue.intValue];

    }

    [self.leftLblArea addSubview:lbl];
    
}


-(void)layoutYlabels {
    [self.rightLblArea.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    _yCoordinates = [self calcRealVerticalCoordinate:self.drawObj.maxValue Min:self.drawObj.minValue];
    NSMutableArray *yLabels = [NSMutableArray arrayWithCapacity:_yCoordinates.count];
    [_yCoordinates enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *lbl = [UILabel new];
        lbl.textAlignment = NSTextAlignmentCenter;
        yLabels[idx] = lbl;
        lbl.adjustsFontSizeToFitWidth = YES;
        lbl.textColor = UIColor.lightGrayColor;
        switch (self.drawObj.readyDrawObjType) {
            case ReadyDrawObjType_heareRate:
            {
                lbl.text = [NSString stringWithFormat:@"%d", obj.intValue];
            }
                break;
            case ReadyDrawObjType_hrv:
            {
                lbl.text = [NSString stringWithFormat:@"%d", obj.intValue];

            }
                break;
            case ReadyDrawObjType_TEMPERATURE:
            {
                NSString *charac = @"";
                if (obj.floatValue > 0) {
                    charac = @"+";
                }
                if (obj.floatValue < 0) {
                    charac = @"";
                }
               
                
                lbl.text = [NSString stringWithFormat:@"%@%.1f", charac , obj.floatValue];

            }
                break;
            default:
                break;
        }
        
        [self.rightLblArea addSubview:lbl];
    }];
    _yLabels = yLabels;
    CGFloat labelHeight = Y_LABELS_HEIGHT;
    CGFloat y_margin_bottom = 15; //距离底部
    // 确定头尾
    UILabel *firstLabel = yLabels.firstObject;
    UILabel *lastlabel = yLabels.lastObject;
    firstLabel.frame = CGRectMake(0, 0, self.rightLblArea.bounds.size.width, labelHeight);
    firstLabel.center = CGPointMake(self.rightLblArea.bounds.size.width / 2, self.drawArea.frame.origin.y + y_margin_bottom);
    
    lastlabel.frame = CGRectMake(0, 0, self.rightLblArea.bounds.size.width, labelHeight);
    
    lastlabel.center = CGPointMake(self.rightLblArea.bounds.size.width / 2, CGRectGetMaxY(self.drawArea.frame) - y_margin_bottom);
    
    CGFloat startCentY = firstLabel.center.y;
    CGFloat distance = lastlabel.center.y -  firstLabel.center.y;
    
    CGFloat everyY = distance / fabs(_yCoordinates.firstObject.floatValue -  _yCoordinates.lastObject.floatValue);
    for (int i = 1; i < yLabels.count - 1; i++) {
        
        CGFloat centY = fabs(_yCoordinates[i].floatValue - _yCoordinates.firstObject.floatValue) * everyY + startCentY;
        UILabel *tmpLable = yLabels[i];
        tmpLable.bounds = CGRectMake(0, 0, firstLabel.bounds.size.width, firstLabel.bounds.size.height);
        tmpLable.center = CGPointMake(firstLabel.center.x, centY);
    }
    _minY = lastlabel.center.y;//CGRectGetMaxY(self.rightLblArea.frame) - Y_LABELS_HEIGHT / 2 - 10;
    _maxY =  firstLabel.center.y;//Y_LABELS_HEIGHT / 2;
    // _drawMaxalue  _drawMin
//    if (self.drawObj.maxValue && self.drawObj.minValue) {
//        UILabel *maxLabel = [UILabel new];
//        maxLabel.textAlignment = NSTextAlignmentCenter;
//        maxLabel.frame = CGRectMake(0, 0, self.rightLblArea.bounds.size.width, Y_LABELS_HEIGHT);
//        [self.rightLblArea addSubview:maxLabel];
//        maxLabel.text = [NSString stringWithFormat:@"%@", self.drawObj.maxValue];
//
//        UILabel *minLabel = [UILabel new];
//        minLabel.textAlignment = NSTextAlignmentCenter;
//        minLabel.frame = CGRectMake(0, _minY - Y_LABELS_HEIGHT/2.0f, self.rightLblArea.bounds.size.width, Y_LABELS_HEIGHT);
//        [self.rightLblArea addSubview:minLabel];
//        minLabel.text = [NSString stringWithFormat:@"%@", self.drawObj.minValue];
//    }
   
    
    
}

-(NSMutableArray<NSNumber * > *)calcRealVerticalCoordinate:(NSNumber *)max Min:(NSNumber *)min {
    NSMutableArray *res = [NSMutableArray new];
    if (max == nil || min == nil || self.drawObj.valuesArray.count == 0) {
        return [self barDrawVerticalCoordinate];
    }
    switch (self.drawObj.readyDrawObjType) {
        case ReadyDrawObjType_heareRate:
        {
            int step = 0;
            if (max.intValue - min.intValue >= 100) {
                step = 50;
            } else {
                step = 25;
            }
            // 按跨度上下取整
            
            int labelMax = max.intValue % step == 0 ? max.intValue : (max.intValue + step)/step * step;
            int labelMin = min.intValue / step * step;
            
            for (int i = labelMax;  i >= labelMin; i-= step) {
                [ res addObject:@(i)];
                
            }
//            [res insertObject:max atIndex:0];
//            [res addObject:@(min.intValue/10 * 10)];
            
        }
            break;
        case ReadyDrawObjType_hrv:
        {
            int step = 50;
            int labelMax = max.intValue % step == 0 ? max.intValue : (max.intValue + step)/step * step;
            int labelMin = min.intValue / step * step;
            for (int i = labelMax;  i >= labelMin; i-= step) {
                [ res addObject:@(i)];
                
            }
//            [res insertObject:max atIndex:0];
//            [res addObject:@(min.intValue/10 * 10)];
        }
            break;
        case ReadyDrawObjType_TEMPERATURE:
        {
            float step = 1;
           
            for (int i = (int)(max.floatValue + step);  i >= (int)(min.floatValue - step); i-= step) {
                [ res addObject:@(i)];
                
            }
            
        }
            break;
            
        default:
            break;
    }
    
    return res;
}

-(NSMutableArray<NSNumber *> *)barDrawVerticalCoordinate
{
   
    // 纵坐标
    NSArray *res = nil;
    switch (self.drawObj.readyDrawObjType) {
        case ReadyDrawObjType_heareRate:
        {
            res = @[@(100), @(40), ];
        }
            break;
        case ReadyDrawObjType_hrv:
        {
            
            res = @[@(150), @(100), @(50),];
        }
            break;
        case ReadyDrawObjType_TEMPERATURE:
        {
            res = @[@(1.0),@(0.0), @(-1.0)];
        }
            break;
        default:
            break;
    }
    NSMutableArray *resAll = [NSMutableArray arrayWithArray:res];
    
    return resAll;
}


-(void)layOutXlabels:(NSDate *)beginDate EndTime:(NSDate *)endDate {
    
    [[self.xLblArea subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    if (!beginDate || !endDate) {
        return;
    }
    
    NSNumber *beginTime = @([beginDate timeIntervalSince1970]);
    NSNumber *endTime = @([endDate timeIntervalSince1970]);
//    NSArray<NSString *> *xtitles = @[@"23:00",
//                                     @"00:00",
//                                     @"02:00",
//                                     @"04:00",
//                                     @"06:00",
//                                     @"07:30", ];
    NSTimeInterval allDiff = endTime.doubleValue - beginTime.doubleValue; //总时间差
    NSMutableArray <NSNumber *> *timeArray = [NSMutableArray new];
    
//    NSTimeInterval beginTimeIntervalFix = ((NSInteger)(beginTime.doubleValue + 30 *60))/3600 * 3600;
//    NSTimeInterval temp = beginTimeIntervalFix + 60 * 60 * 1;
    NSTimeInterval temp = beginTime.doubleValue + 60 * 60 * 2; // 首个加2小时
    int i = 1;
    while (temp < endTime.doubleValue) {
        [timeArray addObject:@(temp)];
        i += 2;
        temp = beginTime.doubleValue + i * 60 * 60;
        
    }
    
    if (endTime.doubleValue - timeArray.lastObject.doubleValue > 1 * 60 * 60) {
        // 1-2 小时内
        [timeArray removeLastObject];
        [timeArray addObject:@(endTime.doubleValue - 60 * 60)];
    }
    else if (endTime.doubleValue - timeArray.lastObject.doubleValue < 1 * 60 * 60) {
        [timeArray removeLastObject];
        [timeArray addObject:@(endTime.doubleValue - 60 * 60)];
    }
    
    // 头尾加上
    [timeArray insertObject:beginTime atIndex:0];
    [timeArray addObject:endTime];
    
    
    CGFloat startX = self.drawArea.frame.origin.x;
//    CGFloat endX = CGRectGetMaxX(self.drawArea.frame);
    CGFloat xStep = self.drawArea.bounds.size.width /(allDiff);
    
    CGFloat centY = self.xLblArea.bounds.size.height / 2;
    
    NSDateFormatter *foramtter = [[NSDateFormatter alloc]init];
    foramtter.dateFormat = @"HH";
    
    NSDateFormatter *foramtterHeadTail = [[NSDateFormatter alloc]init];
    foramtterHeadTail.dateFormat = @"HH:mm";
    
    for (int i  = 0; i < timeArray.count; i++) {
        
        UILabel *xLbl = [UILabel new];
//        xLbl.backgroundColor = UIColor.greenColor;
        xLbl.textAlignment = NSTextAlignmentCenter;
        xLbl.textColor = UIColor.lightGrayColor;
        xLbl.font = [UIFont systemFontOfSize:15];
        NSString *hourStr;// = [foramtter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeArray[i].doubleValue]];

       
        NSTimeInterval hourInterval;
        if (i == 0 || i == timeArray.count - 1) {
            xLbl.backgroundColor = SLEEP_READY_XLABEL_HEAD_TAIL_BG_COLOR;
            hourInterval = timeArray[i].doubleValue;
            hourStr = [foramtterHeadTail stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeArray[i].doubleValue]];
        } else {
            hourInterval = timeArray[i].integerValue / 3600 * 3600.0f; // 去除分 秒
            hourStr = [foramtter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeArray[i].doubleValue]];
            xLbl.backgroundColor = UIColor.clearColor;
        }
        xLbl.text = hourStr;
        [xLbl sizeToFit];
        [self.xLblArea addSubview:xLbl];
        CGFloat centX = startX + (hourInterval - beginTime.doubleValue) * xStep;
        
        xLbl.center = CGPointMake(centX, centY);
        
    }
    
    
    
}


//-(void)layOutXlabels {
//    
//    [[self.xLblArea subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [obj removeFromSuperview];
//    }];
//    
//    NSArray<NSString *> *xtitles = @[@"23:00",
//                                     @"00:00",
//                                     @"02:00",
//                                     @"04:00",
//                                     @"06:00",
//                                     @"07:30", ];
//    
//    CGFloat startX = self.drawArea.frame.origin.x;
////    CGFloat endX = CGRectGetMaxX(self.drawArea.frame);
//    CGFloat xStep = self.drawArea.bounds.size.width /(xtitles.count-1);
//    
//    CGFloat centY = self.xLblArea.bounds.size.height / 2;
//    
//    for (int i  = 0; i < xtitles.count; i++) {
//        
//        UILabel *xLbl = [UILabel new];
////        xLbl.backgroundColor = UIColor.greenColor;
//        xLbl.textAlignment = NSTextAlignmentCenter;
//        xLbl.textColor = UIColor.lightGrayColor;
//        xLbl.font = [UIFont systemFontOfSize:15];
//        xLbl.text = xtitles[i];
//        [xLbl sizeToFit];
//        [self.xLblArea addSubview:xLbl];
//        
//        CGFloat centX = startX + i *xStep;
//        
//        xLbl.center = CGPointMake(centX, centY);
//        
//    }
//    
//    
//    
//}


@end
