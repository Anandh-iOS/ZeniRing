//
//  MeasureDataListVc.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/7/4.
//  测量数据列表

#import <Masonry/Masonry.h>
#import "MeasureDataListVc.h"
#import "ConfigModel.h"
#import "DBTables.h"
#import "NormalSetCell.h"

#import "TimeUtils.h"
#import "Toast.h"
#import "HMpdfManager.h"

@interface MeasureDataListVc ()<UITableViewDelegate, UITableViewDataSource>
@property(strong, nonatomic)UITableView *tableView;

@property(assign, nonatomic)MEASURE_LIST_TYPE type;
@property(strong, nonatomic)NSMutableArray <DBValueSuper *> *dataArray;
@property(strong, nonatomic)NSDateFormatter *dateFormatter;
@property(strong, nonatomic)HMpdfManager *pdfManager;

@end

@implementation MeasureDataListVc

-(instancetype)initWith:(MEASURE_LIST_TYPE)type {
    if (self = [super init]) {
        self.type = type;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    [self arrowback:nil];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self queryData];
}

-(void)initUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.leading.equalTo(self.view).offset(VC_ITEM_MARGIN_HOR);
        make.trailing.equalTo(self.view).inset(VC_ITEM_MARGIN_HOR);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
    
    NSString *title;
    switch (self.type) {
        case MEASURE_LIST_TYPE_HEART_RATE:
        {
            title = _L(L_RECORD_TITLE_HR);
        }
            break;
        case MEASURE_LIST_TYPE_HRV:
        {
            title = _L(L_RECORD_TITLE_HRV);

        }
            break;
        case MEASURE_LIST_TYPE_THERMEMOTER_FLU:
        {
            title = _L(L_RECORD_TITLE_THERMEMOTER);

        }
            break;
            
        default:
            break;
    }
    self.navigationItem.title = title;
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(0, 0, 60, 44);
//    [shareBtn setTitle:@"Share" forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"shareIcon"] forState:UIControlStateNormal];
    [shareBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    [shareBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = item;
}

-(void)share:(UIButton *)btn
{

    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

    // 圆角弧度半径
    CGFloat cornerRadius = ITEM_CORNOR_RADIUS;
    // 设置cell的背景色为透明，如果不设置这个的话，则原来的背景色不会被覆盖
    cell.backgroundColor = UIColor.clearColor;
    
    // 创建一个shapeLayer
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    //        CAShapeLayer *backgroundLayer = [[CAShapeLayer alloc] init]; //显示选中
    // 创建一个可变的图像Path句柄，该路径用于保存绘图信息
    CGMutablePathRef pathRef = CGPathCreateMutable();
    // 获取cell的size
    // 第一个参数,是整个 cell 的 bounds, 第二个参数是距左右两端的距离,第三个参数是距上下两端的距离
    CGRect bounds = CGRectInset(cell.bounds,0, 0);
    
    if (indexPath.row == 0
        && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
        // 仅有一条
        UIBezierPath *backBezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:cornerRadius];
        
        layer.path = backBezierPath.CGPath;
        cell.layer.mask = layer;
    } else if (indexPath.row == 0) {
        // 初始起点为cell的左下角坐标
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 终点坐标为右下角坐标点，把绘图信息都放到路径中去,根据这些路径就构成了一块区域了
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
        CGPathCloseSubpath(pathRef);
        layer.path = pathRef;
        cell.layer.mask = layer;
    } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
        // 初始起点为cell的左上角坐标
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 添加一条直线，终点坐标为右下角坐标点并放到路径中去
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        layer.path = pathRef;
        cell.layer.mask = layer;
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
    cell.backgroundColor = ITEM_BG_COLOR;
    
}

-(void)queryData {
    NSDate *begin;// = [TimeUtils zeroOfDate:self.date];
    NSDate *end;// = [TimeUtils zeroOfNextDayDate:self.date];
    if (self.date) {
        begin = [TimeUtils zeroOfDate:self.date];
        end = [TimeUtils zeroOfNextDayDate:self.date];
        
    } else if (self.sleepBeginStamp && self.sleepEndStamp) {
        begin = [NSDate dateWithTimeIntervalSince1970:self.sleepBeginStamp.doubleValue];
        end = [NSDate dateWithTimeIntervalSince1970:self.sleepEndStamp.doubleValue];

    } else {
        return;
    }
    
  
    WEAK_SELF
    switch (self.type) {
        case MEASURE_LIST_TYPE_HEART_RATE:
        {
            [DBHeartRate queryBy:nil Begin:begin End:end OrderBeTimeDesc:YES Cpmplete:^(NSMutableArray<DBHeartRate *> * _Nonnull results, NSNumber *maxHr, NSNumber *minHr,NSNumber *avgHr) {
                STRONG_SELF
                strongSelf.dataArray = results;
                [strongSelf.tableView reloadData];
                if (!results.count) {
                    [strongSelf noDataTips];
                }
            }];
        }
            break;
        case MEASURE_LIST_TYPE_HRV:
        {
            [DBHrv queryBy:nil Begin:begin End:end OrderBeTimeDesc:YES Cpmplete:^(NSMutableArray<DBHrv *> * _Nonnull results, NSNumber *maxHrv, NSNumber *minHrv, NSNumber *avgHrv) {
                STRONG_SELF
                strongSelf.dataArray = results;
                [strongSelf.tableView reloadData];
                if (!results.count) {
                    [strongSelf noDataTips];
                }
            }];
        }
            break;
        case MEASURE_LIST_TYPE_THERMEMOTER_FLU:
        {
            [DBThermemoter queryBy:nil Begin:begin EndDate:end OrderBeTimeDesc:YES Cpmplete:^(NSMutableArray<DBThermemoter *> * _Nonnull results,  NSNumber *maxThermemoter, NSNumber *minThermemoter, NSNumber *avgThermemoter) {
                STRONG_SELF
                strongSelf.dataArray = results;
                [strongSelf.tableView reloadData];
                if (!results.count) {
                    [strongSelf noDataTips];
                }
            }];
        }
            break;
            
        default:
            break;
    }
}


-(void)shareUrl:(NSURL *)fileUrl {
    if (fileUrl == nil) {
        return;
    }
    
    NSArray *activityItems = @[fileUrl];
    UIActivityViewController *activityVc = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityVc.excludedActivityTypes = @[UIActivityTypePrint];
    [self presentViewController:activityVc animated:YES completion:nil];
    WEAK_SELF
    activityVc.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
//        STRONG_SELF
//        if (completed) {
//            [[LTPHud Instance] showText:@"share finish" Lasting:1.0];
//        }
        [[NSFileManager defaultManager] removeItemAtURL:fileUrl error:nil];
    };
}

-(void)noDataTips {
    
    [self.view makeToast:_L(L_NO_MORE_RECORDS)];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = @"";
    if (section == 0) {
        switch (self.type) {
            case MEASURE_LIST_TYPE_HEART_RATE:
            {
                title = _L(L_UNIT_HR);
            }
                break;
            case MEASURE_LIST_TYPE_HRV:
            {
                title = _L(L_UNIT_HR);

            }
                break;
            case MEASURE_LIST_TYPE_THERMEMOTER_FLU:
            {
             
                title = _L(L_UNIT_TEMP_C);
                

            }
                break;
                
            default:
                break;
        }
    }
    
    return title;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NormalSetCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MeasureDataListVc class])];
    if (!cell) {
        cell = [[NormalSetCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([MeasureDataListVc class])];
    }
    
    switch (self.type) {
        case MEASURE_LIST_TYPE_HEART_RATE:
        {
            cell.textLabel.text = [NSString stringWithFormat:@"%d", self.dataArray[indexPath.row].value.intValue];

        }
            break;
        case MEASURE_LIST_TYPE_HRV:
        {
            cell.textLabel.text = [NSString stringWithFormat:@"%d", self.dataArray[indexPath.row].value.intValue];

        }
            break;
        case MEASURE_LIST_TYPE_THERMEMOTER_FLU:
        {
            DBThermemoter *thermoemter = (DBThermemoter *)(self.dataArray[indexPath.row]);
            
            cell.textLabel.text = [NSString stringWithFormat:@"%.2f", thermoemter.value.floatValue];

        }
            break;
            
        default:
            break;
    }
    
    // 时间
    
    cell.rightLabel.text = [self.dateFormatter stringFromDate:self.dataArray[indexPath.row].time];
    
    return cell;
    
}




-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
//        _tableView.tableHeaderView = [self tableViewHead];
//        [_tableView registerClass:[ActivityCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
//        _tableView.scrollEnabled = NO;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0.0f;
        }
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}

-(NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc]init];
        _dateFormatter.dateFormat = _L(L_DATEFORMAT_MEASURE_LIST);//@"MMdd,yyyy,hh:mm";
    }
    return _dateFormatter;
}

-(HMpdfManager *)pdfManager
{
    if (!_pdfManager) {
        _pdfManager = [[HMpdfManager alloc]init];
    }
    return _pdfManager;
}


@end
