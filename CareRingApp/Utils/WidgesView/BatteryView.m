//
//  BatteryView.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/8/4.
//  电池图形

#import "BatteryView.h"

// 绿色
#define BATTERY_COLOR_BEST ([UIColor colorWithRed:40/255.0f green:217/255.0f blue:89/255.0f alpha:1.f])
// 黄色
#define BATTERY_COLOR_WELL ([UIColor colorWithRed:233/255.0f green:125/255.0f blue:57/255.0f alpha:1.f])
// 红色
#define BATTERY_COLOR_ATTECTION ([UIColor colorWithRed:255/255.0f green:62/255.0f blue:41/255.0f alpha:1.f])

@interface BatteryView()

@property(weak, nonatomic)CAShapeLayer *borderLayer; // 圆框
@property(weak, nonatomic)CAShapeLayer *batteryBorderLayer; // 电池框
@property(weak, nonatomic)CAShapeLayer *batteryContentLayer; // 电池内容
@property(weak, nonatomic)CAShapeLayer *flashLayer; // 闪电
@property(weak, nonatomic)CAShapeLayer *disconnctLayer; // 未连接样式

@end

@implementation BatteryView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.highColor = [UIColor colorWithRed:35/255.0f green:254/255.0f blue:97/255.0f alpha:1.0f];//BATTERY_COLOR_BEST;
        self.midColor = [UIColor colorWithRed:255/255.0f green:176/255.0f blue:56/255.0f alpha:1.0f];//BATTERY_COLOR_WELL;
        self.lowColor = [UIColor colorWithRed:255/255.0f green:52/255.0f blue:54/255.0f alpha:1.0f];//BATTERY_COLOR_ATTECTION;
        self.borderColor = [UIColor colorWithRed:215/255.0f green:244/255.0f blue:212/255.0f alpha:1.0f];//UIColor.whiteColor;
        
        self.highLevel = @(80); // 高于80为high
        self.lowLevel = @(20); // 高于20为 middle
        self.borderLineWidth = 3.0f;
        self.batteryBorderLineWidth = 3.0f;
        self.batteryInnerMargin = 4.f;
        self.flashLineWidth = 1.5;
//        self.userInteractionEnabled = YES;
    }
    return self;
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    DebugNSLog(@"batteryview point x=%.1f , y =%.1f event %@", point.x, point.y,event);

    return nil;
}

/// 设置电池百分比
/// @param percent 百分比 0-100
-(void)setPercent:(float)percent IsCharging:(BOOL)isCharging;
{
   
    if (percent > 100.f) {
        percent = 100.0;
    }
    
    if (percent < 0.f) {
        percent = 0.f;
    }
    
    if (self.bounds.size.width < 1 || self.bounds.size.height < 1) {
        return;
    }
    
    UIColor *drawColor = [self chooseColor:percent IsCharging:isCharging];
    
    
    [self drawBorder];
    CGRect squareframe = [self drawBatteryBorder:drawColor];
    [self drawBatteryContent:percent IsCharging:isCharging Color:drawColor BatteryBorderFrame:squareframe];
    if (self.disconnctLayer) {
        [self.disconnctLayer removeFromSuperlayer];
    }
    
}

-(UIColor *)chooseColor:(float)percent IsCharging:(BOOL)isCharging
{
    if (isCharging) {
        return self.highColor;
    }
    if (percent >= self.highLevel.floatValue) {
        return self.highColor;
    }
    
    if (percent >= self.lowLevel.floatValue && percent < self.highLevel.floatValue) {
        return self.midColor;
    }
    
    return self.lowColor;
    
}

// 画圆框
-(void)drawBorder {
    CGPoint center = CGPointMake(self.bounds.size.width / 2.f, self.bounds.size.height / 2.f);
    
    [self.borderLayer removeFromSuperlayer];
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.frame = self.bounds;
    [self.layer addSublayer:borderLayer];
    self.borderLayer = borderLayer;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat lineWidth = self.borderLineWidth;//3.0/51 * self.bounds.size.height;
    CGFloat margin =  1+lineWidth;
    CGFloat radius = self.bounds.size.height / 2 - margin;
    [path addArcWithCenter:center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    self.borderLayer.path = path.CGPath;
    self.borderLayer.strokeColor = self.borderColor.CGColor;
    self.borderLayer.fillColor = UIColor.clearColor.CGColor;
    self.borderLayer.lineWidth = lineWidth;
    
    
}

// 画电池外框
-(CGRect)drawBatteryBorder:(UIColor *)color {
    CGFloat sqarWidth = self.bounds.size.height * 3 / 5.3;
    CGFloat sqarHeight = self.bounds.size.height / 3.f;
    CGPoint center = CGPointMake(self.bounds.size.width / 2.f, self.bounds.size.height / 2.f);
    
    CGFloat batteryLineWidth = self.batteryBorderLineWidth;//3.0/51.f * self.bounds.size.width;
    CGFloat cornerRad = sqarHeight / 10;
    
    CGRect squareframe = CGRectMake(center.x - sqarWidth/2, center.y - sqarHeight/2, sqarWidth, sqarHeight);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:squareframe cornerRadius:cornerRad];
    [self.batteryBorderLayer removeFromSuperlayer];
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.frame = self.bounds;
    [self.layer addSublayer:borderLayer];
    self.batteryBorderLayer = borderLayer;
    
    self.batteryBorderLayer.path = path.CGPath;
    self.batteryBorderLayer.strokeColor = color.CGColor;
    self.batteryBorderLayer.fillColor = UIColor.clearColor.CGColor;
    self.batteryBorderLayer.lineWidth = batteryLineWidth;
    
    // 电池头
    CGFloat head_height = sqarHeight / 3.5f;

    CGFloat head_width = head_height / 1.8;

    CGRect headFrame = CGRectMake(center.x + sqarWidth/2, center.y - head_height/2, head_width, head_height);
    UIBezierPath *pathHead = [UIBezierPath bezierPathWithRoundedRect:headFrame byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(1, 1)];
//    [self.batteryBorderLayer removeFromSuperlayer];
    
    CAShapeLayer *batteryHeadLayer = [CAShapeLayer layer];
    batteryHeadLayer.frame = self.batteryBorderLayer.bounds;
    [self.batteryBorderLayer addSublayer:batteryHeadLayer];
   
    
    
    batteryHeadLayer.path = pathHead.CGPath;
    batteryHeadLayer.strokeColor = UIColor.clearColor.CGColor;
    batteryHeadLayer.fillColor = color.CGColor;
    batteryHeadLayer.lineWidth = 0;
    
    return squareframe;
    
}


///
/// @param percent 百分比
/// @param isCharge 充电状态
-(void)drawBatteryContent:(float)percent IsCharging:(BOOL)isCharge Color:(UIColor *)color BatteryBorderFrame:(CGRect)batteryBorderFrame
{
    
    CGFloat margin = self.batteryInnerMargin;//4.f/51.f * self.bounds.size.width; // 与边框间隔
    
    [self.batteryContentLayer removeFromSuperlayer];
    
    CAShapeLayer *contentLayer = [CAShapeLayer layer];
    contentLayer.frame = self.bounds;
    [self.layer addSublayer:contentLayer];
    self.batteryContentLayer = contentLayer;
    if (isCharge) {
        percent = 100.0f;
    }
    
    CGRect contetFrame = CGRectMake(batteryBorderFrame.origin.x + margin,
                                    batteryBorderFrame.origin.y + margin,
                                    (batteryBorderFrame.size.width - margin*2) * (percent/100.0f),
                                    batteryBorderFrame.size.height - margin*2);
    CGFloat cornerRadius = batteryBorderFrame.size.height /10;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:contetFrame cornerRadius:cornerRadius];
    
    self.batteryContentLayer.path = path.CGPath;
    self.batteryContentLayer.strokeColor = UIColor.clearColor.CGColor;
    self.batteryContentLayer.fillColor = color.CGColor;
    self.batteryContentLayer.lineWidth = 0;
    
    // 画闪电
    [self.flashLayer removeFromSuperlayer];
    
    if (isCharge) {
        
        CAShapeLayer *flashLayer = [CAShapeLayer layer];
        flashLayer.frame = self.bounds;
        [self.layer addSublayer:flashLayer];
        self.flashLayer = flashLayer;
        
        UIBezierPath *flashPath = [UIBezierPath bezierPath];
        
        CGPoint point_one, point_two, point_three,point_four, point_five,point_six;
//        DebugNSLog(@"width = %f, height = %f", batteryBorderFrame.size.width, batteryBorderFrame.size.height);
        // 逆时针画点
        CGFloat xLeave = 12/51.0 * batteryBorderFrame.size.width;
        CGFloat xLeaveShort = -1 * batteryBorderFrame.size.width /100 ;//xLeave/ 4.0;
        
        CGFloat YcenterLeave = 3.0/30.0 * batteryBorderFrame.size.height;
        
        CGFloat xTopLeave = 5/51.0 * batteryBorderFrame.size.width;//5;
        if (xTopLeave > 5) {
            xTopLeave = 5;
        }
        
        CGFloat yTopLeave = 3.0/30.0 * batteryBorderFrame.size.height;//3;
        if (yTopLeave > 3) {
            yTopLeave = 3;
        }
        
        CGFloat centerY = batteryBorderFrame.origin.y + batteryBorderFrame.size.height /2;
        CGFloat centerX = batteryBorderFrame.origin.x + batteryBorderFrame.size.width /2;
        point_one = CGPointMake(centerX + xTopLeave, batteryBorderFrame.origin.y - yTopLeave);
//        DebugNSLog(@"x = %f, y = %f", point_one.x, point_one.y);

        point_two = CGPointMake(centerX - xLeave, centerY + YcenterLeave);
//        DebugNSLog(@"x = %f, y = %f", point_two.x, point_two.y);

        
        point_three = CGPointMake(centerX - xLeaveShort , centerY + YcenterLeave );
//        DebugNSLog(@"x = %f, y = %f", point_three.x, point_three.y);

        point_four = CGPointMake(centerX - xTopLeave , CGRectGetMaxY(batteryBorderFrame) + yTopLeave );
//        DebugNSLog(@"x = %f, y = %f", point_four.x, point_four.y);

        point_five = CGPointMake(centerX + xLeave, centerY - YcenterLeave);
//        DebugNSLog(@"x = %f, y = %f", point_five.x, point_five.y);

        point_six = CGPointMake(centerX + xLeaveShort, centerY - YcenterLeave);
//        DebugNSLog(@"x = %f, y = %f", point_six.x, point_six.y);


        [flashPath moveToPoint:point_one];
        [flashPath addLineToPoint:point_two ];
        [flashPath addLineToPoint: point_three];
        [flashPath addLineToPoint: point_four];

        [flashPath addLineToPoint: point_five];

        [flashPath addLineToPoint: point_six];

        [flashPath addLineToPoint: point_one];

        [flashPath closePath];
        self.flashLayer.path = flashPath.CGPath;
        self.flashLayer.strokeColor = UIColor.grayColor.CGColor;
        self.flashLayer.fillColor = UIColor.whiteColor.CGColor;
        self.flashLayer.lineJoin = kCALineJoinRound;
        self.flashLayer.lineCap = kCALineCapRound;
        self.flashLayer.lineWidth = self.flashLineWidth;
    }
    
}

-(void)showDisconnect:(BOOL)isDisconnect {
    [self.disconnctLayer removeAllAnimations];
    [self.disconnctLayer removeFromSuperlayer];
    
    if (!isDisconnect) {
        return;
    }
    
    CGPoint center = CGPointMake(self.bounds.size.width / 2.f, self.bounds.size.height / 2.f);
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.frame = self.bounds;
    [self.layer addSublayer:borderLayer];
    self.disconnctLayer = borderLayer;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat lineWidth = self.borderLineWidth;//3.0/51 * self.bounds.size.height;
    CGFloat margin =  1+lineWidth;
    CGFloat radius = self.bounds.size.height / 2 - margin;
    [path addArcWithCenter:center radius:radius startAngle:0 endAngle:M_PI * 2  clockwise:YES];
   
    if (radius < 0) {
        [self.disconnctLayer removeAllAnimations];

        [self.disconnctLayer removeFromSuperlayer];
        return;
    }
    self.disconnctLayer.lineDashPhase = 1.0;
    
    CGFloat dotLength = 32.0/80 * radius; //30: 80
    CGFloat dotSpace = 8.0/20 * dotLength; //8: 20

    [self.disconnctLayer setLineDashPattern:@[@(dotLength), @(dotSpace)]];

    self.disconnctLayer.path = path.CGPath;
    self.disconnctLayer.strokeColor = self.borderColor.CGColor;
    self.disconnctLayer.fillColor = UIColor.clearColor.CGColor;
    self.disconnctLayer.lineWidth = lineWidth;
    self.disconnctLayer.lineCap = kCALineCapRound;


    
}

-(void)removeAnimation {
    [self.disconnctLayer removeAllAnimations];
}
- (void)beginAnimation {
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //旋转必须在前面加上transform
//    animation1.keyPath = @"transform.rotation.x";
//    animation1.fromValue = @(M_PI * 2);
    animation1.toValue =  @(M_PI * 2);//@(0);
    animation1.duration = 3.f;
//    animation1.beginTime = 0.f;
//    animation1.delegate = self;
    animation1.removedOnCompletion = NO;
    animation1.repeatCount = MAXFLOAT;
    animation1.fillMode = kCAFillModeForwards;
   //设置blueView的锚点anchorPoint为右下角
//    self.disconnctLayer.anchorPoint = CGPointMake(0.5, 0.5);
//   //设置blueView的position为右下角
//    self.disconnctLayer.position = CGPointMake(self.disconnctLayer.bounds.size.width / 2, self.disconnctLayer.bounds.size.height / 2);
    [self.disconnctLayer addAnimation:animation1 forKey:@"animateTransform"];

}

-(void)clean
{
    @synchronized (self) {
        @try {
//            NSArray<CALayer *> * subLayers = self.layer.sublayers;
//            [subLayers enumerateObjectsUsingBlock:^(__kindof CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                [obj removeFromSuperlayer];
//            }];
            [self.borderLayer removeFromSuperlayer]; // 圆框
            [self.batteryBorderLayer removeFromSuperlayer]; // 电池框
            [self.batteryContentLayer removeFromSuperlayer]; // 电池内容
            [self.flashLayer removeFromSuperlayer]; // 闪电
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    }
}

@end
