//
//  SleepTimeDrawView.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/24.
//

#import "NapSleepTimeDrawView.h"
#import "SleepPercentView.h"
#import <Masonry/Masonry.h>

#import "TimeUtils.h"
#import "constants.h"
#import "DBSleepData.h"

extern const CGFloat SLEEP_LAYER_HEIGHT;
extern const CGFloat SQUAR_HEIGHT;// = 28.0f; // 方形高度

@implementation NapSleepTimeDrawView
{
    __weak CAShapeLayer *_borderLayer;
    
    __weak CAShapeLayer *_suqrtContentLayer; // 画方块的layer
    
    __weak CALayer *_gradientContentLayer;
    
     CGFloat _wakeY, _remY, _lightY, _deepY;

    
//    NSMutableArray<SleepObj *> * _sleepObjArray;
//    NSNumber * _startSleepTimeInterval;
//    NSNumber * _endSleepTimeInterval;
    
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
    [self addSubview:self.xLabelArea];
    [self addSubview:self.drawView];
    
//    self.xLabelArea.backgroundColor = UIColor.blueColor;
    
    [self.xLabelArea mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@25);
    }];
    
    [self.drawView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.mas_leading).offset(25);
        make.trailing.equalTo(self.mas_trailing).inset(25);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.xLabelArea.mas_top);
    }];
    
}


/// 无睡眠时的样式
-(void)drawNone {
    //边框
   
    
    [_suqrtContentLayer removeFromSuperlayer]; // 画方块的layer
    
    [_gradientContentLayer removeFromSuperlayer];
    [self drawBorder];
    
}


-(void)startDraw:(NSMutableArray<DBSleepData *> * ) sleepObjArray
      SleepStart:(NSNumber *)  startSleepTimeInterval
        SleepEnd:(NSNumber *)endSleepTimeInterval
{
    [self setNeedsLayout];
    
    [self drawTime:sleepObjArray SleepStart:startSleepTimeInterval SleepEnd:endSleepTimeInterval];
    [self layOutXlabels:startSleepTimeInterval EndTime:endSleepTimeInterval];
    //边框
    [self drawBorder];
}

-(void)drawTime:(NSMutableArray<DBSleepData *> * ) sleepObjArray SleepStart:(NSNumber *)  startSleepTimeInterval  SleepEnd:(NSNumber *)endSleepTimeInterval
{
    [_suqrtContentLayer removeFromSuperlayer]; // 垂直最高
//    [_remLayer removeFromSuperlayer];
//    [_lightLayer removeFromSuperlayer];
//    [_deepLayer removeFromSuperlayer];  // 垂直最低
    
    if (!sleepObjArray.count) {
        return;
    }
    
    // 确定起始Y
    CGFloat layerStartY = self.drawView.bounds.size.height - SLEEP_LAYER_HEIGHT * 4;
    
//    CGFloat layerW = self.drawView.bounds.size.width;
    
    _wakeY = layerStartY;
    _remY = layerStartY + SLEEP_LAYER_HEIGHT;
    _lightY = layerStartY + SLEEP_LAYER_HEIGHT*2;
    _deepY = layerStartY + SLEEP_LAYER_HEIGHT*3;
    
    // 渐变色
    
    [_gradientContentLayer removeFromSuperlayer];
    
    CALayer *gradientContentLayer = [CALayer layer];
    gradientContentLayer.frame = CGRectMake(0, layerStartY, self.drawView.bounds.size.width, self.drawView.bounds.size.height - layerStartY);
    [self.drawView.layer addSublayer:gradientContentLayer];
    _gradientContentLayer = gradientContentLayer;

    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc]init];
    gradientLayer.frame = gradientContentLayer.bounds;
    gradientLayer.colors = @[ (__bridge id)[SleepPercentView colorWake].CGColor,
                               (__bridge id)[SleepPercentView colorLightSleep].CGColor,
                               (__bridge id)[SleepPercentView colorLightSleep].CGColor,
                               (__bridge id)[SleepPercentView colorWake].CGColor,
    ];
//    gradientLayer.locations = @[@(0.24f),@(0.5f),@(0.75f),@(1.f)];
    
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.type = kCAGradientLayerAxial;
    [_gradientContentLayer addSublayer:gradientLayer];
//    _gradientLayer = gradientLayer;
    
    
    
    CAShapeLayer *suqrtContentLayer = [[CAShapeLayer alloc]init];
    suqrtContentLayer.frame = self.drawView.bounds;
    [self.drawView.layer addSublayer:suqrtContentLayer];
    _suqrtContentLayer = suqrtContentLayer;
    

    
    

    // 对分段数据画矩形
    
    // 1 睡眠时间跨度
    NSTimeInterval totalInterval =  endSleepTimeInterval.doubleValue - startSleepTimeInterval.doubleValue;
    NSTimeInterval ZeroStartTime = startSleepTimeInterval.doubleValue;
    CGFloat totalWidth = self.drawView.bounds.size.width;
    if (totalWidth < 1) {
        return;
    }
    
    NSMutableArray<CALayer *> *layerArray = [NSMutableArray new];
    
    for (int i = 0; i < sleepObjArray.count; i++) {
        DBSleepData *sleepObj = sleepObjArray[i];
        // 此段睡眠的时间
        NSNumber *tempStartTime = sleepObj.sleepStart;
        NSNumber *tempEndTime = sleepObj.sleepEnd;

        // 确定在哪个layer
        NSNumber *tempStartY =  [self chooseStartY:NREM1];
       
        if (!tempStartY) {
            continue;
        }
        
        CGFloat startX = (tempStartTime.doubleValue - ZeroStartTime) / totalInterval * totalWidth;
        CGFloat endX = (tempEndTime.doubleValue - ZeroStartTime) / totalInterval * totalWidth;
        UIColor *color = [self chooseColor:NREM1]; // 方块颜色
        
        CALayer *sqarLayer = [[CALayer alloc]init];
        sqarLayer.frame = CGRectMake(startX, tempStartY.floatValue, endX - startX, SQUAR_HEIGHT);
        sqarLayer.backgroundColor = color.CGColor;
//        [_suqrtContentLayer addSublayer:sqarLayer];
        [layerArray addObject:sqarLayer];
    }
    
    // 连线遮罩
    CGFloat lingWidth = 0.1f;
    UIBezierPath *lineBez = [[UIBezierPath alloc]init];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = gradientLayer.bounds;
//    [lineBez addArcWithCenter:CGPointMake(gradientLayer.bounds.size.width /2, gradientLayer.bounds.size.height /2) radius:20 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    CGFloat diff = 1.5;
    for (int i = 0; i < layerArray.count; i++) {
        // 每个尾巴和下一个开始连线
        CALayer *curlayer = layerArray[i];
        // 挖方块
        CGPoint squarpoint_one, squarpoint_two, squarpoint_three, squarpoint_four;
        squarpoint_one = CGPointMake(curlayer.frame.origin.x, curlayer.frame.origin.y- layerStartY);
        squarpoint_two = CGPointMake(CGRectGetMaxX(curlayer.frame), curlayer.frame.origin.y- layerStartY);
        squarpoint_three = CGPointMake(CGRectGetMaxX(curlayer.frame), self.drawView.bounds.size.height);
        squarpoint_four = CGPointMake(curlayer.frame.origin.x, self.drawView.bounds.size.height);
//        123
//        squarpoint_three = CGPointMake(CGRectGetMaxX(curlayer.frame), CGRectGetMaxY(curlayer.frame)- layerStartY);
//        squarpoint_four = CGPointMake(curlayer.frame.origin.x, CGRectGetMaxY(curlayer.frame)- layerStartY);
        [lineBez moveToPoint:squarpoint_one];
        [lineBez addLineToPoint:squarpoint_two];
        [lineBez addLineToPoint:squarpoint_three];
        [lineBez addLineToPoint:squarpoint_four];


       
        
    }
    [lineBez closePath];
//    maskLayer.lineWidth = lingWidth;
    maskLayer.path = lineBez.CGPath;
    maskLayer.lineCap = kCALineCapSquare;
//    maskLayer.strokeColor = UIColor.clearColor.CGColor;
//    maskLayer.fillColor = UIColor.clearColor.CGColor;
    gradientLayer.mask = maskLayer;
    
    
    
}

-(NSNumber *)chooseStartY :(SleepStagingType)type {
    NSNumber *startY = nil;
    switch (type) {
        case NONE:
        {}
            break;
        case WAKE:
        {
            startY = @(_wakeY); //醒来

        }
            break;
        case NREM1: // 浅度
        case NREM2:
        {
            startY = @(_lightY);
        }
            break;
        case NREM3:
        {
            startY = @(_deepY);// 深度
        }
            break;
        case REM:
        {
            startY = @(_remY); // rem
        }
            break;
        default:
            break;
    }
    return startY;
}

-(UIColor *)chooseColor :(SleepStagingType)type {

    UIColor *color = nil;
    switch (type) {
        case NONE:
        {}
            break;
        case WAKE:
        {
            color = [SleepPercentView colorWake]; //醒来

        }
            break;
        case NREM1: // 浅度
        case NREM2:
        {
            color = [SleepPercentView colorLightSleep];
        }
            break;
        case NREM3:
        {
            color = [SleepPercentView colorDeepSleep];// 深度
        }
            break;
        case REM:
        {
            color = [SleepPercentView colorREMSleep];; // rem
        }
            break;
        default:
            break;
    }
    return color;
}

//-(CAShapeLayer *)addLayerToDrawView:(CGRect)frame {
//
//    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
//    layer.frame = frame;
//    [self.drawView.layer addSublayer:layer];
//    return layer;
//}


-(void)drawBorder {
    
    if (self.drawView.bounds.size.width< 1 ||  self.drawView.bounds.size.height < 1) {
        return;
    }
    
    [_borderLayer removeFromSuperlayer];
    
    if (_borderLayer == nil) {
        CAShapeLayer *borderlayer = [[CAShapeLayer alloc]init];
        borderlayer.frame = self.drawView.bounds;
//        DebugNSLog(@"lzp %s  width =%f, height = %f", __FILE__,self.drawView.bounds.size.width, self.drawView.bounds.size.height);
        [self.drawView.layer addSublayer:borderlayer];
        _borderLayer = borderlayer;
    }
    
//    _borderLayer.backgroundColor = [UIColor whiteColor].CGColor;
   
    UIBezierPath *borderPath = [[UIBezierPath alloc]init];
    [borderPath moveToPoint:CGPointMake(_borderLayer.frame.origin.x, _borderLayer.frame.origin.y)];
    [borderPath addLineToPoint:CGPointMake(_borderLayer.frame.origin.x, CGRectGetMaxY(_borderLayer.frame))];
    [borderPath addLineToPoint:CGPointMake(CGRectGetMaxX(_borderLayer.frame), CGRectGetMaxY(_borderLayer.frame))];
    [borderPath addLineToPoint:CGPointMake(CGRectGetMaxX(_borderLayer.frame), _borderLayer.frame.origin.y)];
    
    _borderLayer.path = borderPath.CGPath;
    _borderLayer.strokeColor = UIColor.lightGrayColor.CGColor;
    _borderLayer.fillColor = UIColor.clearColor.CGColor;
    _borderLayer.lineWidth = 1.0f;
    _borderLayer.lineCap = kCALineCapSquare;
    
}

-(void)layOutXlabels:(NSNumber *)beginTime EndTime:(NSNumber *)endTime {
    
    [[self.xLabelArea subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    if (!beginTime || !endTime) {
        return;
    }
    
//    NSArray<NSString *> *xtitles = @[@"23:00",
//                                     @"00:00",
//                                     @"02:00",
//                                     @"04:00",
//                                     @"06:00",
//                                     @"07:30", ];
    NSTimeInterval allDiff = endTime.doubleValue - beginTime.doubleValue; //总时间差
    NSMutableArray <NSNumber *> *timeArray = [NSMutableArray new];
    
    NSTimeInterval beginTimeIntervalFix = ((NSInteger)(beginTime.doubleValue + 30 *60))/3600 * 3600;
    NSTimeInterval temp = beginTimeIntervalFix + 60 * 60 * 2;//beginTime.doubleValue + 60 * 60 *2; // 首个加2小时
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
    
    
    CGFloat startX = self.drawView.frame.origin.x;
//    CGFloat endX = CGRectGetMaxX(self.drawArea.frame);
    CGFloat xStep = self.drawView.bounds.size.width /(allDiff);
    
    CGFloat centY = self.xLabelArea.bounds.size.height / 2;
    
    NSDateFormatter *foramtter = [[NSDateFormatter alloc]init];
    foramtter.dateFormat = @"HH";
    
    NSDateFormatter *foramtterHeadTail = [[NSDateFormatter alloc]init];
    foramtterHeadTail.dateFormat = @"HH";
    
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
        [self.xLabelArea addSubview:xLbl];
        CGFloat centX = startX + (hourInterval - beginTime.doubleValue) * xStep;
        
        xLbl.center = CGPointMake(centX, centY);
        
    }
    
    
    
}

-(UIView *)drawView
{
    if (!_drawView) {
        _drawView = [UIView new];
    }
    
    return _drawView;
}


-(UIView *)xLabelArea
{
    if (!_xLabelArea) {
        _xLabelArea = [UIView new];
    }
    return _xLabelArea;
}

@end
