//
//  UITableViewCell+Styles.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/7/26.
//

#import "UITableViewCell+Styles.h"


@implementation UITableViewCell (Styles)
/// 首尾单元格加圆角
-(void)addTopBottomCornerRadius:(UIColor *)bgColor IndexPath:(NSIndexPath *)indexPath TableView:(UITableView *)tableView CornerRadius:(CGFloat)cornerRadius
{
    // 圆角弧度半径
//    CGFloat cornerRadius = cornerRadius;
    // 设置cell的背景色为透明，如果不设置这个的话，则原来的背景色不会被覆盖
//    self.backgroundColor = UIColor.clearColor;
    self.layer.mask = nil;
    // 创建一个shapeLayer
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    //        CAShapeLayer *backgroundLayer = [[CAShapeLayer alloc] init]; //显示选中
    // 创建一个可变的图像Path句柄，该路径用于保存绘图信息
    CGMutablePathRef pathRef = CGPathCreateMutable();
    // 获取cell的size
    // 第一个参数,是整个 cell 的 bounds, 第二个参数是距左右两端的距离,第三个参数是距上下两端的距离
    CGRect bounds = CGRectInset(self.bounds,0, 0);
    
    if (indexPath.row == 0
        && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
        // 仅有一条
        UIBezierPath *backBezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:cornerRadius];
        
        layer.path = backBezierPath.CGPath;
        self.layer.mask = layer;
    } else if (indexPath.row == 0) {
        // 初始起点为cell的左下角坐标
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 终点坐标为右下角坐标点，把绘图信息都放到路径中去,根据这些路径就构成了一块区域了
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
        CGPathCloseSubpath(pathRef);
        layer.path = pathRef;
        self.layer.mask = layer;
    } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
        // 初始起点为cell的左上角坐标
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 添加一条直线，终点坐标为右下角坐标点并放到路径中去
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        layer.path = pathRef;
        self.layer.mask = layer;
    }
    // 把已经绘制好的可变图像路径赋值给图层，然后图层根据这图像path进行图像渲染render
    //           layer.path = pathRef;
    //        backgroundLayer.path = pathRef;
    // 注意：但凡通过Quartz2D中带有creat/copy/retain方法创建出来的值都必须要释放
    //           CFRelease(pathRef);
    //       if (indexPath.row == 0 || indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
    //           cell.layer.mask = layer;
    //
    //       }
    self.backgroundColor = bgColor;
}


@end
