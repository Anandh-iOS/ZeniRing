//
//  MainReadinessVc.m
//  CareRingApp
//
//  Created by Anandh Selvam on 20/08/23.
//

#import "MainReadinessVc.h"
#import "ValueQuarView.h"
#import "ConfigModel.h"
#import "ActivityCell.h"
#import "ActivityObj.h"

#import "DBTables.h"
#import "TimeUtils.h"
#import "MeasureDataListVc.h"
#import "BasicCalendaVc.h"
#import "Blebutton.h"
#import "DeviceCenter.h"
#import "AppDelegate.h"
#import "NotificationNameHeader.h"
#import "NSNumber+formatString.h"
#import "NSNumber+Imperial.h"
#import "OtaRemindView.h"
#import "OTAVc.h"
#import <Toast.h>
#import "OTAHelper.h"
#import "MydeviceVc.h"
#import "UIViewController+Custom.h"
#import "DBHistoryDataSr03.h"
#import "ActivityLineCell.h"
#import "RealtimeMeasureVc.h"
#import "TextInfoCell.h"
#import "SleepDrawLineCell.h"
#import "ReadinessHeaderView.h"
#import "SleepTimeCell.h"
#import "CareRingApp-Swift.h"
#import "goalValues.h"


@interface MainReadinessVc ()<UITableViewDelegate, UITableViewDataSource,SRBleScanProtocal, SRBleDataProtocal>

@property(strong, nonatomic)UITableView *tableView;
@property(strong, nonatomic)ValueQuarView *heartRateValueSQuar, *hrvValueSQuar, *tempValueSQuar, *stepValueSQuar;
@property(strong, nonatomic)NSNumber *avgFlu;
@property(strong, nonatomic)NSNumber *sleepGoal;

@property(strong, nonatomic)NSNumber *hrDipTrend;
@property(strong, nonatomic)NSNumber *hrvTrend;
@property(strong, nonatomic)NSNumber *hrvTrendPat2Weeks;
@property(strong, nonatomic)NSNumber *sleepTrend;
@property(strong, nonatomic)NSNumber *temperatureTrend;

@property(strong, nonatomic)NSNumber *hrDipCont;
@property(strong, nonatomic)NSNumber *hrvCont;
@property(strong, nonatomic)NSNumber *hrvTrendCont;
@property(strong, nonatomic)NSNumber *sleepCont;
@property(strong, nonatomic)NSNumber *temperatureCont;

@property(strong, nonatomic)ActivityObj *hrObj, *hrvObj;

//@property(strong, nonatomic)NSArray <ActivityObj *> * dataArray;

@property(strong, nonatomic)NSDate *date;

@property(strong, nonatomic)UILabel *topDateLbl;
@property(strong, nonatomic)UIImageView *topCalendaImageV;
@property(strong, nonatomic)QMUIButton *topCalendaBtn;

@property(strong, nonatomic)Blebutton *bleBtn;

@property(strong, nonatomic)UIProgressView *syncHisDataProgressView;  // 同步历史使用
@property(strong, nonatomic)OtaRemindView *otaRemindView; // 提醒升级
@property(strong, nonatomic)UIView * topSquarsContentView;

@property(strong, nonatomic)QMUIButton *realtimeMeasureBtn; // goto realtime measure



@end

@implementation MainReadinessVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self intUI];
    [self initData];
    
    // 睡眠计算完毕
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifySleepCalcFinish:) name:NOTI_NAME_SLEEP_CALC_FINISH object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(autoLoginSucc:) name:NOTI_NAME_AUTOLOGIN_SUCC object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifyDateChange:) name:NOTI_NAME_SLEEP_DATE_CHANGE object:nil];
//
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifyNeedUpdate:) name:NOTI_NAME_NEED_UPDATE object:nil];
    // NOTI_NAME_ISImperialUint_CAHNGE
    // 睡眠期间的体温差 查询完毕
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifySleepTemperature:) name:NOTI_NAME_SLEEP_TEMPERATURE_QUERY_READY object:nil];
    [[DeviceCenter instance] bindCurrentDevice];
    _sleepGoal = @0;
    [self makeReadinessContri];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
   
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.date = [NSDate date];
    [[DeviceCenter instance] querySleep:self.date];
    
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

#pragma mark -- 通知 睡眠计算完毕
-(void)notifySleepCalcFinish:(NSNotification *)noti {

        // 没有睡眠, 单独计算目前的静息心率
    NSMutableArray<DBSleepData *> *dbsleepArray = [DeviceCenter instance].GetSleepDBData;
    
    [self.tableView reloadData];

}



-(void)notifyDateChange:(NSNotification *)noti {
    
    self.date = [[DeviceCenter instance] currentQueryDate];
    // TODO: 更新头部日期
    // 重新查询
    
}

-(void)notifySleepTemperature:(NSNotification *)noti {
    
//    self.otaRemindView.shouldHide = NO;
    [self queryThermemoter];
    [self.tableView reloadData];
}

/// 有更新可用
/// @param noti 通知
-(void)notifyNeedUpdate:(NSNotification *)noti {
    
    self.otaRemindView.shouldHide = NO;
    [self.tableView reloadData];
}

-(void)autoLoginSucc:(NSNotification *)noti
{
    // 自动登录时推动计算睡眠
    self.date = [NSDate date];
    [[DeviceCenter instance] querySleep:self.date];
    [self viewDidAppear:YES]; // 自动登录刷新
}

-(void)intUI {
    [self.view addSubview:self.tableView];
    UIView *slideBar = [UIView new];
    [self.view addSubview:slideBar];
    

    [slideBar addSubview:self.topCalendaBtn];


    [self.topCalendaBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topCalendaBtn.superview.mas_centerX);
        make.top.equalTo(self.topCalendaBtn.superview.mas_top).offset(1);
        
        make.bottom.equalTo(self.topCalendaBtn.superview);
        
    }];
    
    
    [slideBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(slideBar.superview);
        make.top.equalTo(slideBar.superview.mas_safeAreaLayoutGuideTop);
        make.height.equalTo(@44);
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.leading.equalTo(self.view.mas_leading).offset(VC_ITEM_MARGIN_HOR);
        make.trailing.equalTo(self.view.mas_trailing).inset(VC_ITEM_MARGIN_HOR);
        make.top.equalTo(slideBar.mas_bottom);
    }];
    
    
}




-(void)initData {
    
    self.hrObj = [[ActivityObj alloc]init];
    self.hrObj.type = ACTIVITYOBJ_TYPE_HR;
    
    self.hrvObj = [[ActivityObj alloc]init];
    self.hrvObj.type = ACTIVITYOBJ_TYPE_HRV;
    
}

-(void)startSyncDeviceChaceDta {
    
    // 同步数据回调
    WEAK_SELF
    [DeviceCenter instance].historySyncCbk = ^(BOOL isComplte, NSInteger totalCount, NSInteger currentCount) {
        STRONG_SELF
        //        DebugNSLog(@"current %ld total %ld", currentCount, totalCount);
        [strongSelf.syncHisDataProgressView setProgress:currentCount * 1.0 / totalCount animated:YES];
//        DebugNSLog(@"totalCount %d, currentCount %d", totalCount, currentCount);
        if (isComplte) {
            strongSelf.syncHisDataProgressView.hidden = YES;
            
            [strongSelf.hrObj queryData:strongSelf.date Macaddress:[DeviceCenter instance].bindDevice.macAddress];
            
            [strongSelf.hrvObj queryData:strongSelf.date Macaddress:[DeviceCenter instance].bindDevice.macAddress];
            
            [strongSelf querySteps:strongSelf.date];
            
            [[DeviceCenter instance] querySleep:strongSelf.date];
            
        }
    };
    
    
    BOOL issend = [[DeviceCenter instance] startSyncDeviceCacheData];
    if (issend) {
        self.syncHisDataProgressView.hidden = NO; //显示进度条
    }
}




/// 头部方形数据查询
/// @param date
-(void)queryHrv:(NSDate *)beginDate End:(NSDate *)endDate {
    // hrvValueSQuar

    
    NSDate *begin = beginDate;// [TimeUtils zeroOfDate:date];
    NSDate *end = endDate;//[TimeUtils zeroOfNextDayDate:date];
    WEAK_SELF
    
    
    [DBHrv queryAverage:[DeviceCenter instance].bindDevice.macAddress Begin:begin End:end Cpmplete:^(NSNumber * _Nullable average, NSNumber * _Nullable maxTime, NSNumber * _Nullable minTime) {
        STRONG_SELF
        NSLog(@"hrv average %@", average);
        strongSelf.hrvObj.maxTimeInDate = maxTime;
        strongSelf.hrvObj.averageInDate = average;
        if (strongSelf.hrvObj.showValueBlk) {
            strongSelf.hrvObj.showValueBlk(strongSelf.hrvObj.averageInDate, strongSelf.hrvObj.maxTimeInDate);
        }
        if (!begin || !end) {
            [strongSelf.hrvValueSQuar updateText:NONE_VALUE];
            
        } else {
            [strongSelf.hrvValueSQuar updateValueInt:average Unit:_L(L_UNIT_MS)];
        }
        
    }];
    
}

-(void)querySteps:(NSDate *)date {
    NSDate *begin = [TimeUtils zeroOfDate:date];
    NSDate *end = [TimeUtils zeroOfNextDayDate:date];
    WEAK_SELF
    [DBSteps queryBy:[DeviceCenter instance].bindDevice.macAddress
               Begin:begin End:end OrderBeTimeDesc:YES Cpmplete:^(NSMutableArray<DBSteps *> * _Nonnull results) {
        STRONG_SELF
        if (results.firstObject) {
            [self.stepValueSQuar updateText:[results.firstObject.value thoundSeperateString]];
//            if (results.firstObject.calorie) {
//                [self.calcrieValueSQuar updateText:[NSString stringWithFormat:@"%@ %@", results.firstObject.calorie, _L(L_UNIT_CAL)]];
//
//            } else {
//                [self.calcrieValueSQuar updateText:NONE_VALUE];
//
//            }
        } else {
            [self.stepValueSQuar updateText:NONE_VALUE];
//            [self.calcrieValueSQuar updateText:NONE_VALUE];

        }
    }];
}

-(void)queryThermemoter
{
    ReadyDrawObj *temperautreFluObj = [DeviceCenter instance].temperautreFluObj;
    if (temperautreFluObj.avgValue) {
        self.avgFlu = temperautreFluObj.avgValue;
        [self.tempValueSQuar updateValueFloat:self.avgFlu Unit:_L(L_UNIT_TEMP_C)];
     
    } else {
        self.avgFlu = nil;
        [self.tempValueSQuar updateValueFloat:nil Unit:_L(L_UNIT_TEMP_C)];
    }

}


-(void)calendaClick:(id)sender {
    
    // 日历选择
    BasicCalendaVc *calendaVc = [[BasicCalendaVc alloc]init];
    calendaVc.hidesBottomBarWhenPushed = YES;
    WEAK_SELF
    calendaVc.selectDateCBK = ^(NSDate *date) {
        STRONG_SELF
        if (date) {
//            strongSelf.date = date;
            [[DeviceCenter instance] querySleep:date];

        }
    };
    
    [self presentViewController:calendaVc animated:YES completion:nil];
    
}



#pragma mark --tablleview

-(UIView *)topSquarsContent {
    if (!self.topSquarsContentView) {
        UIView *head = [UIView new];
        head.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
        [head addSubview:self.heartRateValueSQuar];
        [head addSubview:self.hrvValueSQuar];
        [head addSubview:self.stepValueSQuar];
        [head addSubview:self.tempValueSQuar];
        
        CGFloat margin = 15.f;
        [self.heartRateValueSQuar mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(head.mas_leading);
            make.top.equalTo(head.mas_top).offset(margin);
            
        }];
        
        [self.hrvValueSQuar mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(head);
            make.top.equalTo(self.heartRateValueSQuar.mas_top);
            make.leading.equalTo(self.heartRateValueSQuar.mas_trailing).offset(margin);
            make.width.equalTo(self.heartRateValueSQuar.mas_width);
            make.height.equalTo(self.heartRateValueSQuar.mas_height);
        }];

        [self.tempValueSQuar mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self.heartRateValueSQuar);
            make.top.equalTo(self.heartRateValueSQuar.mas_bottom).offset(margin);
            make.bottom.equalTo(head.mas_bottom).inset(margin);
            make.height.equalTo(self.heartRateValueSQuar.mas_height);
        }];
        
        [self.stepValueSQuar mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self.hrvValueSQuar);
            make.top.bottom.equalTo(self.tempValueSQuar);
        }];
        
        self.topSquarsContentView = head;
    }
   
    return self.topSquarsContentView;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return 95.f;
    }
    
    if (indexPath.section == 2) {
        return 450.f; // 睡眠分期图
    }
    
    
    return 0.1;
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *content = [UIView new];
    
    if (section == 0) {
        
        NSString *readinessScore = [[self makeReadinessScore] stringValue];
        ReadinessHeaderView *headerView = [[ReadinessHeaderView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
        [headerView setScoreTitle:@"READINESS SCORE" :readinessScore];
        [content addSubview:headerView];
        
        [headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(headerView.superview).centerOffset(CGPointMake(-75, -75));
        }];
        return content;
        
    }
    
    
    
    
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont fontWithName:FONT_ARIAL_BOLD size:20];
    label.textColor = UIColor.whiteColor;
    [content addSubview:label];
    
    if (section == 1) {
        label.text = _L(L_TITEL_READYSTATE_CONTRIBUE);// 就绪贡献
    }
    if ( section == 2 ) {
        label.text = _L(L_TITEL_READY_DETAIL); // 详情
    }
    
    label.adjustsFontSizeToFitWidth = YES;
    
    
    [label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(label.superview);
    }];
    
    
    
  
    
    return content;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 180;
    }
    return 40;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 4;
    }
    if (section == 2) { // 睡眠分期图
        return 2;
      
    }
    
    return 0;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section == 1 ) {
        
        TextInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TextInfoCell class])];
        if (!cell) {
            cell = [[TextInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([TextInfoCell class])];
        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    if(indexPath.section == 2)
    {
       
            SleepDrawLineCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SleepDrawLineCell class])];
            if (!cell) {
                cell = [[SleepDrawLineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([SleepDrawLineCell class])];
            }
            
            if (indexPath.row == 0) {
                cell.drawObj = [DeviceCenter instance].heartRateObj;

            }
            
            if (indexPath.row == 1) {
                cell.drawObj = [DeviceCenter instance].hrvObj;

            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            return cell;
        
    }
    
    
    return nil;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
//    if(indexPath.section==1)
//    {
//        TextInfoCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
//
//        switch(indexPath.row)
//        {
//            case 0:{
//
//                TrendViewData *infoData1 = [[TrendViewData alloc] initWithTitle:_L(L_TITLE_ABOUT) description:_L(L_TREND_ABT_IMMERSE) subDescription:_L(L_TREND_ABT_IMMERSE_B) infoLabel:_L(L_TREND_KNOW)];
//                TrendViewData *infoData2 = [[TrendViewData alloc] initWithTitle:_L(L_TREND_TITLE_GOAL) description:_L(L_TREND_GOAL_IMMERSE) subDescription:@"" infoLabel:_L(L_TREND_EDIT)];
//                NSArray *infoViewDataArray = @[infoData1, infoData2];
//
//                HRDipTrendVC *HRDip = [HRDipTrendVC new];
//                HRDip.pageContent = [[TrendDataWrapper alloc] initWithPageTitle:_L(L_READINESS_TITLE_HR)  infoText:selectedCell.infoView.subLabelA.text infoViewData:infoViewDataArray];
//
//                HRDip.pageType = TrendPageTypeHrd;
//                HRDip.hidesBottomBarWhenPushed = true;
//                [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//                [self.navigationController setNavigationBarHidden:NO animated:NO];
//                [self.navigationController pushViewController:HRDip animated:YES];
//
//                UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//                self.navigationItem.backBarButtonItem = backButton;
//
//
//            }
//                break;
//            case 1:{
//
//
//                TrendViewData *infoData1 = [[TrendViewData alloc] initWithTitle:_L(L_TITLE_ABOUT) description:_L(L_TREND_ABT_HRV) subDescription:_L(L_TREND_ABT_HRV_B) infoLabel:_L(L_TREND_KNOW)];
//                NSArray *infoViewDataArray = @[infoData1];
//                HRDipTrendVC *HRDip = [HRDipTrendVC new];
//                HRDip.pageContent = [[TrendDataWrapper alloc] initWithPageTitle:_L(L_READINESS_TITLE_HRV) infoText: selectedCell.infoView.subLabelA.text infoViewData:infoViewDataArray];
//                HRDip.pageType = TrendPageTypeHrv;
//                UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//                self.navigationItem.backBarButtonItem = backButton;
//                HRDip.hidesBottomBarWhenPushed = true;
//                [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//                [self.navigationController setNavigationBarHidden:NO animated:NO];
//                [self.navigationController pushViewController:HRDip animated:YES];
//
//            }
//                break;
//            case 2:{
//
//
//                TrendViewData *infoData1 = [[TrendViewData alloc] initWithTitle:_L(L_TITLE_ABOUT) description:_L(L_TREND_ABT_SLEEPTIME) subDescription:@"" infoLabel:_L(L_TREND_KNOW)];
//                TrendViewData *infoData2 = [[TrendViewData alloc] initWithTitle:_L(L_TREND_TITLE_GOAL) description:_L(L_TREND_GOAL_SLEEPTIME) subDescription:@"" infoLabel:_L(L_TREND_EDIT)];
//                NSArray *infoViewDataArray = @[infoData1, infoData2];
//                HRDipTrendVC *HRDip = [HRDipTrendVC new];
//                HRDip.pageContent = [[TrendDataWrapper alloc] initWithPageTitle:_L(L_READINESS_TITLE_TOTALSLEEP) infoText:selectedCell.infoView.subLabelA.text infoViewData:infoViewDataArray];
//                HRDip.pageType = TrendPageTypeSleep;
//                UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//                self.navigationItem.backBarButtonItem = backButton;
//                HRDip.hidesBottomBarWhenPushed = true;
//                [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//                [self.navigationController setNavigationBarHidden:NO animated:NO];
//                [self.navigationController pushViewController:HRDip animated:YES];
//            }
//                break;
//            case 3:{
//
//                HRDipTrendVC *HRDip = [HRDipTrendVC new];
//                HRDip.pageContent = [[TrendDataWrapper alloc] initWithPageTitle:_L(L_READINESS_TITLE_THERMEMOTER) infoText:selectedCell.infoView.subLabelA.text infoViewData:@[]];
//                HRDip.pageType = TrendPageTypeTemperature;
//                UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//                self.navigationItem.backBarButtonItem = backButton;
//                HRDip.hidesBottomBarWhenPushed = true;
//                [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//                [self.navigationController setNavigationBarHidden:NO animated:NO];
//                [self.navigationController pushViewController:HRDip animated:YES];
//
//            }
//                break;
//            default:
//                break;
//        }
        
        
//    }
    
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    if(indexPath.section == 1)
    {
        if([cell isKindOfClass:[TextInfoCell class]])
        {
            TextInfoCell *infoCell = (TextInfoCell *)(cell);
            
            switch (indexPath.row) {
                case 0: // hear rate dip
                {
                    
                    [infoCell.infoView.titleLabel setText:_L(L_READINESS_TITLE_HR)];
                    [infoCell.infoView setTextAndBarColor:HEALTH_COLOR_BEST];
                    
                    goalValues *goalData = [goalValues retrieveGoalValues];
                    infoCell.infoView.subLabelB.text = [NSString stringWithFormat:_L(L_TIEM_DETAIL_TARGET_HRIMMERSE),
                                                        goalData.dipPercentage
                    ];
                    
                    
                    NSString *dipPercentage = [NSString stringWithFormat:@"%.1f%%",isinf([self.hrDipTrend floatValue]) ? 0.0 : [self.hrDipTrend floatValue]];
                    
                    NSMutableArray<DBSleepData *> *dbsleepArray = [DeviceCenter instance].GetSleepDBData;
                    
                    NSNumber *totalHr = @0;
                    NSNumber *avgSleepHeartRate = [dbsleepArray firstObject].hr;

                    // Iterate through the array of DBSleepData objects
                    for (DBSleepData *sleepData in dbsleepArray) {
                        // Add the hrDip value of each object to the total
                        totalHr = @([totalHr floatValue] + [sleepData.hr floatValue]);
                    }

                    // Calculate the average hrDip value as a rounded integer
                    NSNumber *averageSleepHr = @(round([totalHr floatValue] / [dbsleepArray count]));
                    
                    infoCell.infoView.subLabelA.text = [NSString stringWithFormat:@"%@ %@(%@)",isnan([averageSleepHr floatValue]) ? @"--" : averageSleepHr,_L(L_UNIT_HR), dipPercentage];
                    
                    infoCell.infoView.titleLabel.text = [NSString stringWithFormat:@"%@ (%@%%)",_L(L_READINESS_TITLE_HR),[self.hrDipCont stringValue]];
                    
                }
                    break;
                case 1: // HRV
                {
                    

                    [infoCell.infoView.titleLabel setText:_L(L_READINESS_TITLE_HRV)];
                    [infoCell.infoView setTextAndBarColor:HEALTH_COLOR_WELL];
                    NSString *hrvAvg = [NSString stringWithFormat:@"%f", isfinite([self.hrvTrend floatValue]) ? 0.0 : [self.hrvTrend floatValue]];
                    infoCell.infoView.subLabelA.text = [NSString stringWithFormat:@"%@ %@", hrvAvg, _L(L_UNIT_MS)];
                    
                    NSDate *begin = [TimeUtils zeroOfDate:self.date];

                    // Calculate two weeks before the given date
                    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
                    [dateComponents setWeekOfYear:-2]; // Two weeks before
                    NSDate *end = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:begin options:0];
                    
                    [DBHrv queryAverage:[DeviceCenter instance].bindDevice.macAddress Begin:begin End:end Cpmplete:^(NSNumber * _Nullable average, NSNumber * _Nullable maxTime, NSNumber * _Nullable minTime) {

                        infoCell.infoView.subLabelB.text = [NSString stringWithFormat:_L(L_TIEM_DETAIL_TARGET_HRV),
                                                            average
                        ];

                    }];
                    
                    infoCell.infoView.titleLabel.text = [NSString stringWithFormat:@"%@ (%@%%)",_L(L_READINESS_TITLE_HRV),[self.hrvCont stringValue]];
                    
                }
                    break;
                case 2: // Sleep
                {
                    
                    
                    [infoCell.infoView setTextAndBarColor:HEALTH_COLOR_ATTECTION];
                    NSMutableArray<DBSleepData *> *dbsleepArray = [DeviceCenter instance].GetSleepDBData;
                    NSNumber *sleepDuration = [dbsleepArray firstObject].duration;
                    NSString *sleepPctg = [NSString stringWithFormat:@"%f%%",[self.sleepTrend floatValue]];
                    infoCell.infoView.subLabelA.text = [NSString stringWithFormat:@"%@ hr(--%@)",sleepDuration,sleepPctg];
                    goalValues *goalData = [goalValues retrieveGoalValues];
                    infoCell.infoView.subLabelB.text = [NSString stringWithFormat:_L(L_TIEM_DETAIL_TARGET_SLEEP_DURATION),
                                                        goalData.sleepValue
                    ];
                    
                    infoCell.infoView.titleLabel.text = [NSString stringWithFormat:@"%@ (%@%%)",_L(L_READINESS_TITLE_TOTALSLEEP),[self.sleepCont stringValue]];
                    
                }
                    break;
                case 3: // Temperature
                {
                    
                    [infoCell.infoView.titleLabel setText:_L(L_READINESS_TITLE_THERMEMOTER)];
                    [infoCell.infoView setTextAndBarColor:HEALTH_COLOR_BEST];
                    infoCell.infoView.subLabelA.text = [NSString stringWithFormat:@"%f %@",[self.temperatureTrend floatValue],_L(L_UNIT_TEMP_C)];
                    infoCell.infoView.subLabelB.text = [NSString stringWithFormat:_L(L_TIEM_DETAIL_TARGET_THERMOEMTER),
                                                                            1.0 , _L(L_UNIT_TEMP_C),
                                                                            1.0 , _L(L_UNIT_TEMP_C)
                                            ];
                    
                    infoCell.infoView.titleLabel.text = [NSString stringWithFormat:@"%@ (%@%%)",_L(L_READINESS_TITLE_THERMEMOTER),[self.temperatureCont stringValue]];
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
        
    }
    
    if ([cell isKindOfClass:[SleepDrawLineCell class]]) {
        SleepDrawLineCell *linecell = (SleepDrawLineCell *)(cell);
        
        DBSleepData * sleepRes = [[DBSleepData alloc] init];
        if ([DeviceCenter instance].GetSleepDBData.count) {
            sleepRes = [DeviceCenter instance].GetSleepDBData[indexPath.row];
        }
        
        switch (indexPath.row) {
            case 0:
            {
                linecell.drawObj = [DeviceCenter instance].heartRateObj;
            }
                break;
            case 1:
            {
                linecell.drawObj = [DeviceCenter instance].hrvObj;


            }
                break;

            default:
                break;
        }
    }

  
    
}


-(void)makeReadinessContri
{
    NSDate *begin = [TimeUtils zeroOfDate:self.date];
    NSDate *end = [TimeUtils zeroOfBeforeDayDate:self.date];
    
    [DBHeartRate queryBy:[DeviceCenter instance].bindDevice.macAddress Begin:begin End:end OrderBeTimeDesc:YES Cpmplete:^(NSMutableArray<DBHeartRate *> * _Nonnull results, NSNumber *maxHr, NSNumber *minHr,NSNumber *avgHr) {
        
        NSMutableArray<DBSleepData *> *dbsleepArray = [DeviceCenter instance].GetSleepDBData;
        
        NSNumber *totalHr = @0;
        NSNumber *avgSleepHeartRate = [dbsleepArray firstObject].hr;

        // Iterate through the array of DBSleepData objects
        for (DBSleepData *sleepData in dbsleepArray) {
            // Add the hrDip value of each object to the total
            totalHr = @([totalHr floatValue] + [sleepData.hr floatValue]);
        }

        double hrDipPercentage = ([avgHr doubleValue] - [avgSleepHeartRate doubleValue])/[avgHr doubleValue];
        self.hrDipTrend = @(hrDipPercentage);
        
    }];
    
    
    [DBHrv queryAverage:[DeviceCenter instance].bindDevice.macAddress Begin:begin End:end Cpmplete:^(NSNumber * _Nullable average, NSNumber * _Nullable maxTime, NSNumber * _Nullable minTime) {

        self.hrvTrend = average;

    }];
    
    NSMutableArray<DBSleepData *> *dbsleepArray = [DeviceCenter instance].GetSleepDBData;
    NSNumber *sleepDuration = [dbsleepArray firstObject].duration;
    // Calculate the sleep percentage
    double percentage = ([sleepDuration doubleValue] / [self.sleepGoal doubleValue]) * 100.0;
    self.sleepTrend = @(percentage);
    
    
    [DBThermemoter queryBy:[DeviceCenter instance].bindDevice.macAddress Begin:begin EndDate:end OrderBeTimeDesc:YES Cpmplete:^(NSMutableArray<DBThermemoter *> * _Nonnull results,  NSNumber *maxThermemoter, NSNumber *minThermemoter, NSNumber *avgThermemoter) {
        
        self.temperatureTrend = avgThermemoter;
        
        
        
    }];
    
    // Create a calendar instance
    NSCalendar *calendar = [NSCalendar currentCalendar];

    // Calculate the beginning date as two weeks ago
    NSDateComponents *twoWeeksAgoComponents = [[NSDateComponents alloc] init];
    twoWeeksAgoComponents.day = -14; // Subtract 14 days (two weeks)
    NSDate *beginningDate = [calendar dateByAddingComponents:twoWeeksAgoComponents toDate:begin options:0];

    
    [DBHrv queryAverage:[DeviceCenter instance].bindDevice.macAddress Begin:beginningDate End:begin Cpmplete:^(NSNumber * _Nullable average, NSNumber * _Nullable maxTime, NSNumber * _Nullable minTime) {

        self.hrvTrendPat2Weeks = average;

    }];
    
}


-(NSNumber *)makeReadinessScore
{
    NSString *selectedDipValue = [goalValues retrieveGoalValues].dipPercentage;
    NSNumber *hrdip = @0;
    if([selectedDipValue isEqualToString:@"10 - 15%"])
    {
        if ([self.hrDipTrend floatValue] >= 10) {
            
            hrdip = @25;
            
        } else if ([self.hrDipTrend floatValue] >= 0.1 && [self.hrDipTrend floatValue] < 9.9) {
            
            hrdip = [NSNumber numberWithDouble:25.0 * ([self.hrDipTrend floatValue]/9.9)];
            
            
        } else if([self.hrDipTrend floatValue] <= 0.1) {
            
            hrdip = @0;
            
        }
    }
    else if([selectedDipValue isEqualToString:@"15 - 20%"])
    {
        if ([self.hrDipTrend floatValue] >= 15) {
            
            hrdip = @25;
            
        } else if ([self.hrDipTrend floatValue] >= 0.1 && [self.hrDipTrend floatValue] < 14.9) {
            
            hrdip = [NSNumber numberWithDouble:25.0 * ([self.hrDipTrend floatValue]/14.9)];
            
            
        } else if([self.hrDipTrend floatValue] <= 0.1) {
            
            hrdip = @0;
            
        }
    }
    else if([selectedDipValue isEqualToString:@"5 - 10%"])
    {
        if ([self.hrDipTrend floatValue] >= 5) {
            
            hrdip = @25;
            
        } else if ([self.hrDipTrend floatValue] >= 0.1 && [self.hrDipTrend floatValue] < 4.9) {
            
            hrdip = [NSNumber numberWithDouble:25.0 * ([self.hrDipTrend floatValue]/4.9)];
            
        } else if([self.hrDipTrend floatValue] <= 0.1) {
            hrdip = @0;
            
        }
    }
    else if([selectedDipValue isEqualToString:@"0 - 5%"])
    {
        hrdip = @25;
        
    }
    self.hrDipCont = hrdip;
    
    NSNumber *hrv = @0;
    float difference = [self.hrvTrendPat2Weeks floatValue] - [self.hrvTrend floatValue];
    if(([self.hrvTrend floatValue]+ 5.0) >  [self.hrvTrendPat2Weeks floatValue])
    {
        hrv = @25;
    }
    else if([self.hrvTrend floatValue] >  0 && [self.hrvTrend floatValue] <  5 )
    {
        hrv = @(25 * 0.75);
    }
    else if(difference >=5 && difference <15)
    {
        hrv = @(25 * 0.5);
    }
    else if(difference >=15 && difference <25)
    {
        hrv = @(25 * 0.25);
    }
    else if ([self.hrvTrend floatValue] < ([self.hrvTrendPat2Weeks floatValue] - 25.0))
    {
        hrv = @(25.0 * 0.0);
    }
    
    self.hrvCont = hrv;
    
    NSNumber *sleepCont = @0;
    goalValues *goalData = [goalValues retrieveGoalValues];
    if ([self.sleepTrend floatValue] >= [goalData.sleepValue floatValue]) {
        // If achieved sleep duration is equal to or higher than the sleep goal, contribution is 25x100%
        sleepCont = @25;
        
    } else if ([self.sleepTrend floatValue] >= 0.0 && [self.sleepTrend floatValue] < 99.0) {
        // If achieved sleep duration is zero, contribution is zero
        sleepCont = @(25.0 * [self.sleepTrend floatValue]);
        
    }
    
    self.sleepCont = sleepCont;
    
    NSNumber *tempCont = @0;
        
    // Add up the contributions
    double totalContributions = [hrdip doubleValue] +
                                [hrv doubleValue] +
                                [sleepCont doubleValue] +
                                [tempCont doubleValue];
    
    self.temperatureCont = tempCont;

    // Return the total as an NSNumber
    return @(totalContributions);
}


-(void)setDate:(NSDate *)date
{
    _date = date;
  
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];

    formatter.dateFormat = _L(L_TITLE_DATE_BEFORE_THIS_YEAR);
    NSString *str = [formatter stringFromDate:date];
    [self.topCalendaBtn setTitle:str forState:UIControlStateNormal];
    
    return;
    
}


-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[SleepDrawLineCell class] forCellReuseIdentifier:NSStringFromClass([SleepDrawLineCell class])];
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0.0f;
        }
        
    }
    
    return _tableView;
}


-(QMUIButton *)topCalendaBtn
{
    if (!_topCalendaBtn) {
        _topCalendaBtn = [[QMUIButton alloc]init];
        _topCalendaBtn.tintColor = MAIN_BLUE;
        [_topCalendaBtn setTitleColor:MAIN_BLUE forState:UIControlStateNormal];
//        _topCalendaBtn.titleLabel.textColor = MAIN_BLUE;
        _topCalendaBtn.adjustsImageTintColorAutomatically = YES;
        _topCalendaBtn.imagePosition = QMUIButtonImagePositionRight;
        [_topCalendaBtn setTitle:_L(L_TODAY) forState:UIControlStateNormal];
        _topCalendaBtn.backgroundColor = UIColor.clearColor;
        [_topCalendaBtn setImage:[UIImage imageNamed:@"icon_calenda"] forState:UIControlStateNormal];
        _topCalendaBtn.spacingBetweenImageAndTitle = 3;
        [_topCalendaBtn addTarget:self action:@selector(calendaClick:) forControlEvents:UIControlEventTouchUpInside];
        // 底部添加一条横线
        UIView *line = [UIView new];
        [_topCalendaBtn addSubview:line];
        line.backgroundColor = MAIN_BLUE;
        [line mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(_topCalendaBtn);
            make.height.equalTo(@1);
        }];
        
    }
    return _topCalendaBtn;
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

@end
