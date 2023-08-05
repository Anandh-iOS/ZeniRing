//
//  HMpdfManager.m
//   
//
//  Created by 兰仲平 on 2021/11/9.
//  Copyright © 2021 linktop. All rights reserved.
//  生成pdf 分享

#import <UIKit/UIKit.h>
#import "HMpdfManager.h"
#import "ConfigModel.h"
#import "NSDate+HMTools.h"
//#import "MeasureUser.h"
//#import "LTHmEcgGridView.h"

// 首先定义了页面的一些常用数据
static const CGFloat A4Width = 595.f; // PDF页面的宽
static const CGFloat A4Height = 842.f; // PDF页面的高
static const CGFloat topSpace = 40.f; // 页眉和页脚的高度
static const CGFloat bottomSpace = 50.f; // 页眉和页脚的高度 // 下边距需要留出来一定间距，不然会很挤
static const CGFloat leftRightSpace = 20.f; // 左右间距的宽度
//static const CGFloat contentHeight = A4Height – topSpace – bottomSpace; // 除去页眉页脚之后的内容高度
//static const CGFloat contentWidth = A4Width – leftRightSpace * 2; // 内容宽度
static const CGFloat targetSpace = 10.f; // 每个词条View的间距
static const CGFloat targetHeight = 14.f; // 词条信息每一行的高度
static const CGFloat favoritesHeight = 100.f; // 收藏夹的高度，也是收藏夹图片的高度

static const CGFloat ECG_PDF_Width = 1000.0f;//792.0f; // ecg PDF页面的宽
static const CGFloat ECG_PDF_Height = 612.f; // ecg PDF页面的高

const CGFloat PDF_WIDTH = 480.0f;
const CGFloat PDF_HEIGHT = 500.0f;

const CGFloat HEAD_HEIGHT = 110.f;

const CGFloat PDF_PAGE_MIN_STARTY = 50.f; //最小的起始位置

NSString *_Nonnull PDF_FLOADER = @"/share";

const CGFloat DRAW_PDF_LINE_SCALE = 1.76; // 比例缩小
const CGFloat ECG_SECOND_TXT_H = 10.f; // 网格下方秒数高度
const CGFloat NO_WIDTH = 60.f;

@implementation HMpdfManager
{
    /*
     self.xSpeed = _xSpeedArray[speedType];
     self.yGain = _yGainArray[vGain];
     */
    NSDictionary<NSNumber *, NSArray<NSString*>*>*_titleDict;
    NSDictionary<NSNumber*, NSString*> *_pdfFileNameDict;
    NSNumber *_xSpeed;
    NSNumber *_yGain;
    const NSArray<NSNumber *> * _xSpeedArray;
    const NSArray<NSNumber *> * _yGainArray;
    NSNumber * _xOffset;
    CGFloat _transEcgValueToYPT;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 文件名
        _pdfFileNameDict = @{
//                            @(DETAIL_HIS_OXY) : @"Oxygen",
                             @(DETAIL_HIS_HEARTRATE) : @"HeartRate",
                             @(DETAIL_HIS_THER) : _L(L_BAR_DRAW_TITLE_TEMP),
//                             @(DETAIL_HIS_GLUCOSE) : @"BloodGlucose",
//                             @(DETAIL_HIS_BLOOD_PRESSURE) : @"BloodPressure",
                            
        };
        // pdf内容标题
        _titleDict = @{
//            @(DETAIL_HIS_OXY) : @[_L(L_PDF_NO), _L(L_PDF_DATETIME), _L(L_PDF_OXYGEN)],
             @(DETAIL_HIS_HEARTRATE) : @[_L(L_PDF_NO), _L(L_PDF_DATETIME), _L(L_BAR_DRAW_TITLE_HR)],
             @(DETAIL_HIS_THER) : @[_L(L_PDF_NO), _L(L_PDF_DATETIME), _L(L_PDF_TEMPERAUURE)],
            /* @(DETAIL_HIS_GLUCOSE) : @[_L(L_PDF_NO), _L(L_PDF_DATETIME), _L(L_BLOODGLUCOSE)],*/
//             @(DETAIL_HIS_BLOOD_PRESSURE) : @[_L(L_PDF_NO), _L(L_PDF_DATETIME), _L(L_PDF_SYS_P), _L(L_PDF_DIA_P), _L(L_BAR_DRAW_TITLE_HR)],
        };
        
        _xSpeedArray = @[@(25.0f), @(50.0f)];           // cannot modify
        _yGainArray = @[@(5.0f), @(10.0f), @(20.0f)];   // cannot modify
        
    }
    return self;
}

-(NSString *)getFloaderPath:(NSString *)pdfName
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
   /*
    let fileManager = FileManager.default
    let filePath = documentPath as String + "/" + Self.folderPath
    let exist = fileManager.fileExists(atPath: filePath)
    if exist != true {
        return nil
    }
    let wholePath = filePath + "/" + (self.recodFileName ?? "")
    */
    NSString *folderPath = [[paths lastObject]stringByAppendingPathComponent:PDF_FLOADER];
    BOOL isExit = [[NSFileManager defaultManager] fileExistsAtPath:folderPath];
    if (!isExit) {
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *wholeName = [NSString stringWithFormat:@"%@/%@.pdf", PDF_FLOADER, pdfName];
    NSString *path =  [[paths lastObject]stringByAppendingPathComponent:wholeName];
    
    BOOL isFileExit = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (!isFileExit) { // 删除上一次分享的内容
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    return path;
}


///
/// @param view
/// @param size 画布大小
- (UIImage *)makeImageWithView:(UIView *)view withSize:(CGSize)size
{
    
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数 [UIScreen mainScreen].scale。
//    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
//    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale * 2);
    UIGraphicsBeginImageContext(size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}


/// 缩放图片
/// @param image
/// @param scaleSize
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

/// pdf的头部
/// @param name 姓名
/// @param birthDate 日期
-(UIView *)createPdfHead:(NSString *)name Frame:(CGRect)contentFrame Birthday:(NSDate *)birthDate SourceText:(NSString *)sourceString
{
    UIView *contentView = [[UIView alloc]init];
    contentView.frame = contentFrame;//CGRectMake(0, 0, A4Width, HEAD_HEIGHT);
    contentView.backgroundColor = [UIColor clearColor];
        
    CGFloat margin_hor = 30.f; //水平间隙
    CGFloat labelHeight = 30.0f;
    // 姓名:
    UILabel *nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(margin_hor, PDF_PAGE_MIN_STARTY, contentView.bounds.size.width/2, labelHeight)];
    
    [contentView addSubview:nameLbl];
    nameLbl.text = name;
    nameLbl.textColor = [UIColor darkTextColor];
    nameLbl.textAlignment = NSTextAlignmentLeft;
    
    
    // 生日
    UILabel *birthLbl = [[UILabel alloc]initWithFrame:CGRectMake(nameLbl.frame.origin.x, CGRectGetMaxY(nameLbl.frame)+ 5, contentView.bounds.size.width - margin_hor*2, labelHeight)];
    [contentView addSubview:birthLbl];
    birthLbl.textColor = UIColor.darkTextColor;
//    birthLbl.backgroundColor = [UIColor blueColor];
    NSString *birthText = nil;
    if (birthDate) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = _L(L_PDF_TIME_BITRH);//@"MM/dd/yyyy";
        NSString *formatDatetext = [formatter stringFromDate:birthDate];
        
        birthText = [NSString stringWithFormat:_L(L_PDF_BITRH_FORMAT), formatDatetext, (int)[birthDate age]];//[NSString stringWithFormat:@"%@:%@(%@:%ld)", _L(L_USR_BIRTHDAY), formatDatetext, _L(L_USR_AGE), (long)[birthDate age]];
    }
    
    
    birthLbl.text = birthText;
    
    // source
    UILabel *sourceLbl = [[UILabel alloc]initWithFrame:CGRectMake(margin_hor, birthLbl.frame.origin.y, contentView.bounds.size.width - margin_hor*2, labelHeight)];
    sourceLbl.textAlignment = NSTextAlignmentRight; //右对齐
    [contentView addSubview:sourceLbl];
    sourceLbl.text = sourceString;
    sourceLbl.textColor = UIColor.darkTextColor;
    // sep line
    UIView *sepLine = [[UIView alloc]initWithFrame:CGRectMake(nameLbl.frame.origin.x,
                                                              CGRectGetMaxY(sourceLbl.frame) + 5,
                                                              contentView.bounds.size.width -
                                                              margin_hor*2,
                                                              2)];
    
    [contentView addSubview:sepLine];
    sepLine.backgroundColor = [UIColor blackColor];
    return contentView;
    
}


/// 创建表格抬头
/// @param titles
/// @param size
-(UIView *)createTableTitles:(NSArray<NSString *> *)titles Size:(CGRect)frame
{
    UIView *titleContent = [[UIView alloc]initWithFrame:frame];
    titleContent.backgroundColor = UIColor.whiteColor;
    CGFloat marginH = 25.f; //两边空白

    CGFloat total_w = frame.size.width -  marginH*2;
    
    NSInteger count = titles.count;
    CGFloat startX = marginH;
    CGFloat noWidth = NO_WIDTH;
    for (int i = 0; i < titles.count; i++) {
        CGFloat tmpW = 0;
        if (i == 0) {
            tmpW = noWidth;
        } else {
            tmpW = (total_w - noWidth) / (count - 1);
        }
        
        CGFloat realStartX =0;// startX + noWidth + total_w/count * (i-1);
        if (i == 0) {
            realStartX = startX;
        } else {
            realStartX = startX + noWidth + (total_w - noWidth)/(count - 1) * (i-1);
        }
        
       
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(realStartX, frame.origin.y, tmpW, frame.size.height)];
        [titleContent addSubview:lbl];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.text = titles[i];
        lbl.textColor = UIColor.darkTextColor;
        if (titles.count > 3) {
            lbl.font = [UIFont systemFontOfSize:13];
        }
        
//        if (i == 0) {
//            lbl.backgroundColor = UIColor.redColor;
//        }
//        if (i == 1) {
//            lbl.backgroundColor = UIColor.greenColor;
//        }
//        if (i == 2) {
//            lbl.backgroundColor = UIColor.blueColor;
//        }
    }
    
    
    return titleContent;
}

/// 创建表格单个item
/// @param titles
/// @param size
-(UIView *)createTableitems:(NSArray<NSString *> *)itemStrings Size:(CGRect)frame
{
    UIView *itemContent = [[UIView alloc]initWithFrame:frame];
    itemContent.backgroundColor = UIColor.whiteColor;
    CGFloat marginH = 25.f; //两边空白

    CGFloat total_w = frame.size.width -  marginH*2;
    
    NSInteger count = itemStrings.count;
    CGFloat startX = marginH;
    CGFloat noWidth = NO_WIDTH;
    for (int i = 0; i < itemStrings.count; i++) {
        CGFloat tmpW = 0;
        if (i == 0) {
            tmpW = noWidth;
        } else {
            tmpW = (total_w - noWidth) / (count - 1);
        }
        
        CGFloat realStartX =0;// startX + noWidth + total_w/count * (i-1);
        if (i == 0) {
            realStartX = startX;
        } else {
            realStartX = startX + noWidth + (total_w - noWidth)/(count - 1) * (i-1);
        }
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(realStartX, frame.origin.y, tmpW, frame.size.height)];
        lbl.textColor = UIColor.darkTextColor;
        [itemContent addSubview:lbl];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.text = itemStrings[i];
        if (itemStrings.count > 3) {
            lbl.font = [UIFont systemFontOfSize:13];
        }
    }
    
    
    return itemContent;
}


//-(void)setHorizonalSpeed:(HORIZONTAL_SPEED)speedType VertialGain:(VERTIAL_GAIN)vGain
//{
//    if (speedType >= _xSpeedArray.count) {
//        speedType = HORIZONTAL_SPEED_DEFAULT;
//    }
//
//    if (vGain >= _yGainArray.count) {
//        vGain = VERTIAL_GAIN_DEFAULT;
//    }
//    _xSpeed = _xSpeedArray[speedType];
//    _yGain = _yGainArray[vGain];
//
//    //计算水平走纸速度 单位 pt
//    CGFloat xspeedPT = _xSpeed.floatValue / VALUE_UPDATE_SPEED * TRANS_MM_TO_PT / DRAW_PDF_LINE_SCALE;
//    _xOffset = @(xspeedPT);
//
//    CGFloat transEcgValueToYPT =  (18.3f / 128.0f / 100.0f) * _yGain.floatValue * TRANS_MM_TO_PT * 0.1 / DRAW_PDF_LINE_SCALE;
//    _transEcgValueToYPT = transEcgValueToYPT;
//}

///
/// @param seconds 绘制几秒的长度
//-(CGSize)getPdfShareSize:(NSInteger)seconds {
//    CGFloat width = [self calcHistoryWidth:VALUE_UPDATE_SPEED * seconds] ;
//    CGFloat height = TRANS_MM_TO_PT * (5 * 6)/ DRAW_PDF_LINE_SCALE; // 6大格, 每格5小格
//    return CGSizeMake(width, height);
//}

-(CGFloat)calcHistoryWidth:(NSInteger)count
{
    CGFloat width = _xOffset.floatValue * count;
    return width;
}

/// 阻塞画图
/// @param allData
-(void)drawAllDataSync:(NSArray<NSNumber *> *)allData Frame:(CGRect)frame Scale:(CGFloat)scale
{
    if (allData.count == 0) {
        return;
    }
    
    CGFloat startY = frame.origin.y + frame.size.height / 2;
    CGFloat startX = frame.origin.x;
    
    UIBezierPath *bezPath = [[UIBezierPath alloc]init];
    CGPoint startPoint = CGPointMake(startX, startY);
    [bezPath moveToPoint:startPoint];

    [allData enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat pointX = startX + _xOffset.floatValue * idx;
        CGFloat pointY = startY + obj.floatValue * _transEcgValueToYPT;
        if (pointY > (frame.origin.y + frame.size.height) ) { // 下限
            pointY = (frame.origin.y + frame.size.height);
        } else if (pointY < frame.origin.y) { //上限
            pointY = frame.origin.y;
        }
        CGPoint point = CGPointMake(pointX, pointY);
        [bezPath addLineToPoint:point];
        [bezPath moveToPoint:point];
        if (idx == allData.count - 1) {
//            NSLog(@"lzp point %f" , point.x);
        }
    }];
    bezPath.lineWidth = 1.f /scale ;
    bezPath.lineCapStyle = kCGLineCapSquare;
    [[UIColor redColor] setStroke]; // 折线颜色
    [bezPath stroke]; // 折线绘图
    
    
}


/// 创建分享 体温,血氧,血压, 血糖,心率通用
/// @param type 测量类型
/// @param objArray 测量数据
/// @param user 用户
/// @param cmpBlk 完成
-(void)createSharePdf:(DETAIL_HIS_TYPE)type ObjArray:(NSArray <HMPdfShareProtoal> *)objArray  User:(id)user Cmp:(void(^)(NSURL *pdfUrl))cmpBlk
{
    if (!objArray.count) {
        // 4 回调
        if (cmpBlk) {
            cmpBlk(nil);
        }
        return;
    }
    
    /* 1 创建pdf */
    
    NSString *pdfPath = [self getFloaderPath:_pdfFileNameDict[@(type)]];
    //开始pdf的上下文
    UIGraphicsBeginPDFContextToFile(pdfPath, CGRectMake(0, 0, A4Width, A4Height), nil);
    //获取当前的绘图上下文
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 2 组合内容生成图片 写入pdf
    //开始pdf新的一页
    UIGraphicsBeginPDFPage();
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    // 头部
    UIView *headView = [self createPdfHead:@"" Frame:CGRectMake(0, 0, A4Width, HEAD_HEIGHT) Birthday:nil SourceText:[NSString stringWithFormat:@"Source: %@", [ConfigModel appName]]];
  
   
    [headView.layer renderInContext:pdfContext];
    
    // 标题
    CGFloat tempy = CGRectGetMaxY(headView.frame);
    UIView *titleView = [self createTableTitles:_titleDict[@(type)] Size:CGRectMake(0, tempy + 10, headView.bounds.size.width, 44.0f)];
    [titleView.layer renderInContext:pdfContext];
    
    // item布局填充
    CGFloat startY = CGRectGetMaxY(titleView.frame);
    CGFloat itemHeight = 40.0f; //item 高度
    for (int i = 0; i < objArray.count; i++) {
        if (startY + itemHeight > A4Height) {
            // 翻页
            //开始pdf新的一页
            UIGraphicsBeginPDFPage();
//            pdfContext = UIGraphicsGetCurrentContext();
            startY = PDF_PAGE_MIN_STARTY; //每一页的初始值
        }
        
        CGRect itemFrame = CGRectMake(0, startY, A4Width, itemHeight);
        UIView *itemView = [self createTableitems:[objArray[i] pdfShowValuerStrings:i+1] Size:itemFrame];
        [itemView.layer renderInContext:pdfContext]; // 绘制
        startY = CGRectGetMaxY(itemFrame);
    }
    
   
    // 3 pdf关闭
    //结束pdf的上下文
    UIGraphicsEndPDFContext();
    
    // 4 回调
    if (cmpBlk) {
        
        cmpBlk([NSURL fileURLWithPath:pdfPath]);
    }
}




/// 直接在pdf画图
/// @param ecgModel
/// @param pointArray
/// @param user
/// @param cmpBlk
//-(void)createEcgSharePdfDrawInPdf:(ECGModel *)ecgModel
//                           Points:(NSArray<NSNumber *> *)pointArray
//                             User:(MeasureUser *)user
//                              Cmp:(void(^)(NSURL *pdfUrl))cmpBlk
//{
//    if (!pointArray.count) {
//        // 4 回调
//        if (cmpBlk) {
//            cmpBlk(nil);
//        }
//        return;
//    }
//    
//    /* 1 创建pdf */
//    
//    NSString *pdfPath = [self getFloaderPath:@"Ecg"];
//    //开始pdf的上下文
//    UIGraphicsBeginPDFContextToFile(pdfPath, CGRectMake(0, 0, ECG_PDF_Width, ECG_PDF_Height), nil);
//    //获取当前的绘图上下文
//    
////    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    // 2 组合内容生成图片 写入pdf
//    //开始pdf新的一页
////    UIGraphicsBeginPDFPage();
//    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, ECG_PDF_Width, ECG_PDF_Height), nil);
//    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
//
//    NSString *ecgHeadTimeStr = [NSString stringWithFormat:@"%@: %@", _L(L_PDF_RECORD_TIME), [ecgModel.time formatPdfShareTime:_L(L_PDF_ECG_TIME_FORMAT)]];
//    
//    // 头部
//    UIView *headView = [self createPdfHead:user.name Frame:CGRectMake(0, 0, ECG_PDF_Width, HEAD_HEIGHT) Birthday:user.birthDay SourceText:ecgHeadTimeStr];
//  
//   
//    [headView.layer renderInContext:pdfContext];
//    
//    // 时间
//    NSString *durationStr = [NSString stringWithFormat:@"%@%ld%@", _L(L_SHARE_DURATION), (long)[ecgModel durationCalc], _L(L_UNIT_SECOND)];//;
//    
//    // rrmax
//    NSString *rrmaxStr = [NSString stringWithFormat:@"%@%d%@", _L(L_SHARE_RRI_MAX), ecgModel.rrMax, _L(L_UNIT_M_SECOND)];
//    // rrmin
//    NSString *rrminStr = [NSString stringWithFormat:@"%@%d%@", _L(L_SHARE_RRI_MIN), ecgModel.rrMin, _L(L_UNIT_M_SECOND)];
//
//    // hrv
//    NSString *hrValueString = [NSString stringWithFormat:@"%@%d%@", _L(L_HRV), ecgModel.hrv, _L(L_UNIT_M_SECOND)];
//    
//    // 心率
//    NSString *heartString = [NSString stringWithFormat:@"%@:%d%@", _L(L_HEARTRATE), ecgModel.heartRate, _L(L_UNITBPM_BIG)];
//    
//    // 呼吸
//    NSString *respRateStr = [NSString stringWithFormat:@"%@%d%@", _L(L_SHARE_RESP_RATE), ecgModel.br, _L(L_UNITBPM_BIG)];
//    
//    // 心情
//    NSString *moodStr = [NSString stringWithFormat:@"%@%@", _L(L_MOOD) , [ecgModel moodStr]];
//    // 第一行
//    NSString *arguString_first = [NSString stringWithFormat:@"%@, %@, %@, %@, %@", durationStr, rrmaxStr, rrminStr, hrValueString, heartString];
//    // 第二行
//    NSString *arguString_second = [NSString stringWithFormat:@"%@, %@", respRateStr, moodStr];
//
//    CGRect hrFrame_first = CGRectMake(headView.frame.origin.x+30, CGRectGetMaxY(headView.frame) + 20, headView.frame.size.width - 30*2, 20);
//    
//    CGRect hrFrame_second = CGRectMake(hrFrame_first.origin.x, CGRectGetMaxY(hrFrame_first) + 3, headView.frame.size.width - 30*2, 20);
//
//    
//    [arguString_first drawInRect:hrFrame_first withAttributes:@{
//        NSFontAttributeName: [UIFont systemFontOfSize:15],
//        NSForegroundColorAttributeName:[UIColor darkTextColor]
//                          
//    }];
//    
//    [arguString_second drawInRect:hrFrame_second withAttributes:@{
//        NSFontAttributeName: [UIFont systemFontOfSize:15],
//        NSForegroundColorAttributeName:[UIColor darkTextColor]
//                          
//    }];
//    
//    
//    // ecg折线图
//    NSInteger secondPerPage = 10;
//    NSUInteger lineViewCount = (pointArray.count/VALUE_UPDATE_SPEED)/secondPerPage +
//    (pointArray.count%VALUE_UPDATE_SPEED > 0 ? 1 : 0);// 每张画secondPerPage秒,需要画几张
//    
//    if (lineViewCount > (30 / secondPerPage)) {
//        lineViewCount = 30 / secondPerPage; // 不超过30秒数据
//    }
//    
//    CGFloat startY = CGRectGetMaxY(hrFrame_second) + 25; //PDF_PAGE_MIN_STARTY;
//    CGFloat scale = DRAW_PDF_LINE_SCALE;
//    CGRect lineframe;
//    for (int i = 0; i < lineViewCount; i++) {
//        
//        CGSize lineViewSize = [self getPdfShareSize:secondPerPage];
//        CGRect frame = CGRectMake((ECG_PDF_Width - lineViewSize.width)/2, startY, lineViewSize.width , lineViewSize.height); // 已缩小的frame
//        lineframe = frame;
//        NSMutableArray<NSValue *> *secondTxtFrameArray = [self drawGrid:frame Contex:pdfContext Scale:scale]; // 网格
//        // 时间
//        [secondTxtFrameArray enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (idx == secondTxtFrameArray.count - 1) {
//                *stop = YES;
//                return;
//            }
//            NSString *timeStr = [NSString stringWithFormat:@"%lu%@", (idx + i * 10), _L(L_UNIT_SECOND)];
//            CGRect timeFrame = CGRectMake(obj.CGRectValue.origin.x + 5, obj.CGRectValue.origin.y, obj.CGRectValue.size.width, obj.CGRectValue.size.height);
//            [timeStr drawInRect:timeFrame
//                 withAttributes:@{
//                NSFontAttributeName: [UIFont systemFontOfSize:10],
//                NSForegroundColorAttributeName:[UIColor lightGrayColor]
//                                  
//                                }];
//        }];
//
//        
//        NSUInteger step = VALUE_UPDATE_SPEED * secondPerPage;
//        if ((step * i + step) >  pointArray.count) { // 处理最后一张图剩余的点
//            step = pointArray.count - (step * i);
//        }
//        NSArray<NSNumber *> *subPoints = [pointArray subarrayWithRange:NSMakeRange(step * i, step)];
//        [self drawAllDataSync:subPoints Frame:frame Scale:scale]; // 折线
//        startY = startY + frame.size.height + 20;
//    }
//    
//    
//    
//    // 数值label
//    NSString *infoString = [NSString stringWithFormat:@"%@%@, %@%@, %@ I, 512%@, %@",_xSpeed,@"mm/s", _yGain, @"mm/mV", _L(L_LEAD), _L(L_UNIT_HZ), @"Linktop Health Monitor"];
//    
//    CGRect infoFrame = CGRectMake(lineframe.origin.x, CGRectGetMaxY(lineframe) + 20, lineframe.size.width, 20);
//    
//    [infoString drawInRect:infoFrame withAttributes:@{
//        NSFontAttributeName: [UIFont systemFontOfSize:12],
//        NSForegroundColorAttributeName:[UIColor lightGrayColor]
//                          
//    }];
//    // 3 pdf关闭
//    //结束pdf的上下文
//    UIGraphicsEndPDFContext();
//    
//    // 4 回调
//    if (cmpBlk) {
//        cmpBlk([NSURL fileURLWithPath:pdfPath]);
//    }
//    
//}


//-(void)createtstEcgPdf:(UIView *)drawView  Cmp:(void(^)(NSURL *pdfUrl))cmpBlk
//{
//  
//    
//    /* 1 创建pdf */
//    
//    NSString *pdfPath = [self getFloaderPath:@"Ecg"];
//    //开始pdf的上下文
//    UIGraphicsBeginPDFContextToFile(pdfPath, CGRectMake(0, 0, ECG_PDF_Width, ECG_PDF_Height), nil);
//    //获取当前的绘图上下文
//    
////    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    // 2 组合内容生成图片 写入pdf
//    //开始pdf新的一页
////    UIGraphicsBeginPDFPage();
//    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, ECG_PDF_Width  , ECG_PDF_Height), nil);
//    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
//
////    CGContextMoveToPoint(pdfContext, 0, ECG_PDF_Height/2);
////    CGContextAddLineToPoint(pdfContext, TRANS_MM_TO_PT * 50 / 1.76, ECG_PDF_Height/2);
////    CGContextSetStrokeColorWithColor(pdfContext, [UIColor blueColor].CGColor);
////    CGContextStrokePath(pdfContext);
//    //
//    UIBezierPath *path = [[UIBezierPath alloc]init];
//
//    [path moveToPoint:CGPointMake(0, ECG_PDF_Height/2)];
//    [path addLineToPoint:CGPointMake(TRANS_MM_TO_PT, ECG_PDF_Height/2)];
//    [path setLineWidth:1];
//
//    [[UIColor blueColor] setStroke];
//
//    [path stroke];
//
//    UIBezierPath *path2 = [[UIBezierPath alloc]init];
//
//    [path2 moveToPoint:CGPointMake(TRANS_MM_TO_PT/2, ECG_PDF_Height/2 -10)];
//    [path2 addLineToPoint:CGPointMake(TRANS_MM_TO_PT/2, ECG_PDF_Height/2 + 10)];
//    [path2 setLineWidth:1];
//
//    [[UIColor redColor] setStroke];
//
//    [path2 stroke];
//    // 数值label
//   
//    // 3 pdf关闭
//    //结束pdf的上下文
//    UIGraphicsEndPDFContext();
//    
//    // 4 回调
//    if (cmpBlk) {
//        cmpBlk([NSURL fileURLWithPath:pdfPath]);
//    }
//    
//}


//画网格  draw grid
//- (NSMutableArray<NSValue *>*)drawGrid:(CGRect)frame Contex:(CGContextRef)pdfContext Scale:(CGFloat)scale
//{
//
//
//    CGFloat width = frame.size.width;
//    CGFloat height = frame.size.height;
//
//    //Horizontal line count (横线数量)
//    NSInteger horizontalLineCount = ((NSInteger)((height) * 25.4f/ 163.0f * scale));//LINE_OR_BAR_COUNTS(height);
//    //vertical bar count (竖线数量)
//    NSInteger vertialBarCount = ((NSInteger)((width) * 25.4f/ 163.0f * scale));//LINE_OR_BAR_COUNTS(width);
//
//    // draw Horizontal line
//    UIBezierPath *gridPath = [[UIBezierPath alloc] init];
//
//    // draw Horizontal line
//    UIBezierPath *gridPathBold = [[UIBezierPath alloc] init];
//
//    CGFloat startX = frame.origin.x;
//    CGFloat startY = frame.origin.y;
//
//    for (int i = 0 ; i <= horizontalLineCount; i++) {
//        if (i % 5 != 0) {
//            [gridPath moveToPoint:CGPointMake(startX,  startY + i * TRANS_MM_TO_PT / scale)];
//            [gridPath addLineToPoint:CGPointMake(startX + width, startY + i * TRANS_MM_TO_PT / scale)];
//        }
//
//        if (i % 5 == 0) {
//            [gridPathBold moveToPoint:CGPointMake(startX,  startY + i * TRANS_MM_TO_PT/ scale)];
//            // _xSpeed
//
//            [gridPathBold addLineToPoint:CGPointMake(startX + width, startY + i * TRANS_MM_TO_PT/ scale)];
//        }
//
//    }
//    NSMutableArray *timeLabelFrameArray = [NSMutableArray new];
//    //draw vertical bar
//    for (int i = 0 ; i <= vertialBarCount; i++) {
//        if (i % 5 != 0) {
//            [gridPath moveToPoint:CGPointMake(startX + i * TRANS_MM_TO_PT/ scale, startY)];
//            [gridPath addLineToPoint:CGPointMake(startX + i * TRANS_MM_TO_PT/scale, startY
//                                                 +height)];
//        }
//        if (i % 5 == 0) {
//            [gridPathBold moveToPoint:CGPointMake(startX + i * TRANS_MM_TO_PT/scale, startY)];
//            int secondSepCount = (int)(_xSpeed.floatValue);
//            CGFloat y = startY + height;
//            if (i % secondSepCount == 0) { // 折线图底部的突出, 放时间label
//                CGFloat beforeAddy = y;
//                y += ECG_SECOND_TXT_H;
//                CGRect timeTxtFrame = CGRectMake(startX + i * TRANS_MM_TO_PT/scale,
//                                                 beforeAddy,
//                                                 TRANS_MM_TO_PT/scale * _xSpeed.floatValue,
//                                                 ECG_SECOND_TXT_H);
//                [timeLabelFrameArray addObject:[NSValue valueWithCGRect:timeTxtFrame]];
//            }
//            [gridPathBold addLineToPoint:CGPointMake(startX + i * TRANS_MM_TO_PT/scale, y)];
//        }
//
//    }
//    gridPath.lineWidth = ECG_GRID_LINE_WIDTH / scale;
//    gridPathBold.lineWidth = ECG_GRID_LINE_WIDTH*4/scale;
//
//    UIColor *lineColor = [UIColor colorWithRed:197/255.0 green:197/255.0 blue:197/255.0 alpha:1]; // GRIDLINE_COLOR_DEFAULT //  [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1]
//
//    [lineColor setStroke];
//    [gridPath stroke];
////    [[UIColor blueColor] setStroke];
//    [gridPathBold stroke];
//
//
//    return timeLabelFrameArray;
//
//}


@end
