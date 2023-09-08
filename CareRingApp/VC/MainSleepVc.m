//
//  MainSleepVc.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/2.
//  睡眠界面

#import "MainSleepVc.h"

#import "TextInfoCell.h"
#import "ConfigModel.h"
#import "SleepDrawLineCell.h"
#import "SleepTimeCell.h"
#import "BasicCalendaVc.h"
#import "NotificationNameHeader.h"
#import "DeviceCenter.h"
#import "NapSleepTimeCell.h"

#import "TimeUtils.h"

#import "DBHeartRate.h"
#import "ReadinessHeaderView.h"
#import "goalValues.h"
#import "sleepScoreData.h"

@interface MainSleepVc ()<UITableViewDelegate, UITableViewDataSource>
@property(strong, nonatomic)UITableView *tableView;


@property(strong, nonatomic)QMUIButton *topCalendaBtn;
@property(strong, nonatomic)NSDate *date;

@property(strong, nonatomic)UISegmentedControl *sleepSeg;
@property(assign, nonatomic)BOOL isCurrentShowNap;

//@property(strong, nonatomic)SleepTimeDrawObj *sleepTimeDrawObj;


// 睡眠时长
@property(strong, nonatomic)NSNumber *sleepDuration;
@property(strong, nonatomic)NSNumber *sleepPercent;
@property(assign, nonatomic)CONTRIBUTE_LEVEL sleepDurationLevel;

// 优质睡眠
@property(strong, nonatomic)NSNumber *qualitSleepDuration;
@property(strong, nonatomic)NSNumber *qualitSleepPercent;
@property(assign, nonatomic)CONTRIBUTE_LEVEL qualitySleepDurationLevel;

// 深度睡眠
@property(strong, nonatomic)NSNumber *deepSleepDuration;
@property(strong, nonatomic)NSNumber *deepSleepPercent;
@property(assign, nonatomic)CONTRIBUTE_LEVEL deepSleepDurationLevel;

//沉浸
@property(strong, nonatomic)NSNumber *sleepAvgHr, *immersePercent; //睡眠平均心率 沉浸比例
@property(assign, nonatomic)CONTRIBUTE_LEVEL immerseHrLevel;



@end

@implementation MainSleepVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // 睡眠计算完毕
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifySleepCalcFinish:) name:NOTI_NAME_SLEEP_CALC_FINISH object:nil];
    //
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifyDateChange:) name:NOTI_NAME_SLEEP_DATE_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifySleepHeartQueryFin:) name:NOTI_NAME_SLEEP_HEART_RATE_QUERY_READY object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifySleepHRVQueryFin:) name:NOTI_NAME_SLEEP_HRV_QUERY_READY object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.didLoad.boolValue) {
        [self notifySleepCalcFinish:nil]; // 首次刷新
        [self notifyDateChange:nil];
        [self notifySleepHeartQueryFin:nil];
        [self notifySleepHRVQueryFin:nil];
        self.didLoad = @(YES);
    }

    
    
}

-(void)initUI {
    [self.view addSubview:self.tableView];
    // 头部日期按钮
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

-(void)sleepSegSelect:(UISegmentedControl *)seg {
    // 睡眠切换
    if(seg.selectedSegmentIndex == 0) {
        self.isCurrentShowNap = NO;
    } else {
        self.isCurrentShowNap = YES;
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

#pragma mark -- 通知 睡眠计算完毕

-(void)notifySleepHeartQueryFin:(NSNotification *)noti {
    [self.tableView reloadData];
    
}

-(void)notifySleepHRVQueryFin:(NSNotification *)noti {
    
    [self.tableView reloadData];

    
}

-(void)notifySleepCalcFinish:(NSNotification *)noti {
    
    NSMutableArray<DBSleepData *> *dbsleepArray = [DeviceCenter instance].GetSleepDBData;
    NSMutableArray<DBSleepData *> *dNapsleepArray = [DeviceCenter instance].GetNapSleepDBData;
    
    if (dbsleepArray.count && dNapsleepArray.count) {
        self.isCurrentShowNap = NO;
    }
    
    if (dbsleepArray.count && !dNapsleepArray.count) {
        self.isCurrentShowNap = NO;
    }
    if (!dbsleepArray.count && dNapsleepArray.count) {
        self.isCurrentShowNap = YES;
    }
    if (!dbsleepArray.count && !dNapsleepArray.count) {
        self.isCurrentShowNap = NO;
    }
    self.sleepSeg.selectedSegmentIndex = 0;
    [self.tableView reloadData];

}

-(void)notifyDateChange:(NSNotification *)noti {
    
    self.date = [[DeviceCenter instance] currentQueryDate];
    // TODO: 更新头部日期
    
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


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 || indexPath.section == 3) {
        return 95.f;
    }
    
    if (indexPath.section == 2) {
        return 450.f; // 睡眠分期图
    }
    
    if (indexPath.section == 4) {
        return 350.f; // 睡眠的心率 hrv 折线图
    }
    
    return 0.1;
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *content = [UIView new];
    
    if (section == 0) {
        
        ReadinessHeaderView *headerView = [[ReadinessHeaderView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
        [content addSubview:headerView];
        NSNumber *score = [sleepScoreData sharedInstance].calculateScore;
        [headerView setScoreTitle:@"SLEEP SCORE" :[score stringValue]];
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
        label.text = _L(L_TITLE_SLEEP_CON);// 就绪贡献
    }
    if ( section == 2 ) {
        label.text = _L(L_TITLE_SLEEP_DETAIL); // 详情
    }
    
    if (section == 3) {
        label.text = _L(L_TITLE_HEALTH);
    }
    
    if (section == 4) {
        label.text = _L(L_TITEL_READY_DETAIL);
    }
    label.adjustsFontSizeToFitWidth = YES;
    
    
    [label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(label.superview);
    }];
    
    BOOL showNap = [DeviceCenter instance].GetNapSleepDBData.count > 0 && [DeviceCenter instance].GetSleepDBData.count; // 两种都有才显示切换
    
    if (section == 2 &&  showNap) {
        label.frame = CGRectMake(0, 0, SCREEN_WIDTH, 80);
        [content addSubview:self.sleepSeg];
        [label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.equalTo(label.superview);
            make.height.equalTo(label.superview.mas_height).multipliedBy(0.5);
        }];
        [self.sleepSeg mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.sleepSeg.superview.mas_centerX);
            make.width.equalTo(@200);
            make.top.equalTo(label.mas_bottom);
            make.bottom.equalTo(self.sleepSeg.superview.mas_bottom).inset(5);
        }];
    }
  
    
    return content;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 180;
    }
    
    BOOL showNap = [DeviceCenter instance].GetNapSleepDBData.count > 0; // 需要显示小睡切换seg
    if (section == 2) {
        if (showNap) {
            return 80;
        }
    }
    
    return 40;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 4;
    }
    if (section == 2) { // 睡眠分期图
        if (!self.isCurrentShowNap) {
            NSUInteger count = [DeviceCenter instance].GetSleepDBData.count;
            return count > 0 ? count : 1;
        
        } else {
            NSUInteger count = [DeviceCenter instance].GetNapSleepDBData.count > 0 ? 1 : 0;
            return count; // 小睡
        }
      
    }
    
    if (section == 3) { // 血氧+呼吸率
        return 2;
    }
    
    if (section == 4) { // 折线图
        return 2;
    }
    
    return 0;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBSleepData *dbsleep = [[DeviceCenter instance].GetSleepDBData firstObject];
    StagingDataV2 *sleepData = dbsleep.stagingData;
    
    
    if (indexPath.section == 1 ) {
        
        TextInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TextInfoCell class])];
        if (!cell) {
            cell = [[TextInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([TextInfoCell class])];
        }
       
        switch (indexPath.row) {
            case 0: // sleep duration
            {

                [cell.infoView.titleLabel setText:_L(L_TITEL_SLEEP_DURATION)];
                [cell.infoView setTextAndBarColor:HEALTH_COLOR_BEST];
                NSDictionary *ComputedData=[[DeviceCenter instance] getSleepData:CONTRI_TOTAL_SLEEP];
                cell.infoView.subLabelA.text = [ComputedData valueForKey:@"labelA"];
                cell.infoView.subLabelB.text = [ComputedData valueForKey:@"labelB"];
                self.sleepPercent = [ComputedData valueForKey:@"percentage"];
                
                if (!sleepData) {
                    cell.infoView.subLabelA.text = NONE_VALUE;
                    [cell.infoView setTextAndBarColor:HEALTH_COLOR_BEST];
                }
               
            }
                break;
            case 1: // quality sleep duration
            {
                [cell.infoView.titleLabel setText:_L(L_TITLE_QUALITY_SLEEP)];
                [cell.infoView setTextAndBarColor:HEALTH_COLOR_BEST];
                NSDictionary *ComputedData=[[DeviceCenter instance] getSleepData:CONTRI_QUALITY_SLEEP];
                cell.infoView.subLabelA.text = [ComputedData valueForKey:@"labelA"];
                cell.infoView.subLabelB.text = [ComputedData valueForKey:@"labelB"];
                self.qualitSleepPercent = [ComputedData valueForKey:@"percentage"];
                
                
                if (!sleepData) {
                    cell.infoView.subLabelA.text = NONE_VALUE;
                    [cell.infoView setTextAndBarColor:HEALTH_COLOR_BEST];
                }
                

             
            }
                break;
            case 2: // heart dip
            {
              
                [cell.infoView.titleLabel setText:_L(L_TITEL_AVG_HR_INSLEEP)];
                [cell.infoView setTextAndBarColor:HEALTH_COLOR_BEST];
                NSDictionary *ComputedData=[[DeviceCenter instance] getSleepData:CONTRI_AVERAGE_HR];
                cell.infoView.subLabelA.text = [ComputedData valueForKey:@"labelA"];
                cell.infoView.subLabelB.text = [ComputedData valueForKey:@"labelB"];
                self.immersePercent = [ComputedData valueForKey:@"percentage"];
            
            
            if (!sleepData) {
                cell.infoView.subLabelA.text = NONE_VALUE;
                [cell.infoView setTextAndBarColor:HEALTH_COLOR_BEST];
            }
           
               
            }
                break;
            case 3: // deep sleep duration
            {
                
                [cell.infoView.titleLabel setText:_L(L_TITLE_DEEP_SLEEP)];
                [cell.infoView setTextAndBarColor:HEALTH_COLOR_BEST];
                
                NSDictionary *ComputedData=[[DeviceCenter instance] getSleepData:CONTRI_DEEP_SLEEP];
                cell.infoView.subLabelA.text = [ComputedData valueForKey:@"labelA"];
                cell.infoView.subLabelB.text = [ComputedData valueForKey:@"labelB"];
                self.deepSleepPercent = [ComputedData valueForKey:@"percentage"];
                
                if (!sleepData) {
                    cell.infoView.subLabelA.text = NONE_VALUE;
                    [cell.infoView setTextAndBarColor:HEALTH_COLOR_BEST];

                }
                
            }
                break;
                
            default:
                break;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    
    if ( indexPath.section == 3) {
        
        TextInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TextInfoCell class])];
        if (!cell) {
            cell = [[TextInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([TextInfoCell class])];
        }
       
        switch (indexPath.row) {
            case 0:
            {
                [cell.infoView.titleLabel setText:_L(L_TITLE_OXYGEN_INSLEEP)];
             
                cell.infoView.subLabelB.text = [NSString stringWithFormat:_L(L_TITLE_SPO2_SUB_B), @"95%", @"97%"];
                if (dbsleep == nil || dbsleep.spo2.floatValue < 92) {
                    [cell.infoView setTextAndBarColor:HEALTH_COLOR_BEST];
                    cell.infoView.subLabelA.text = NONE_VALUE;

                }
               
                if (dbsleep.spo2.floatValue >= 92) {
                    
                    if (dbsleep.spo2.floatValue >= 95) {
                        [cell.infoView setTextAndBarColor:HEALTH_COLOR_BEST];
                    }
                    if (dbsleep.spo2.floatValue < 95) {
                        [cell.infoView setTextAndBarColor:HEALTH_COLOR_WELL];
                    }
                    
                    if (dbsleep.spo2.floatValue < 90) {
                        [cell.infoView setTextAndBarColor:HEALTH_COLOR_ATTECTION];
                    }
                    
                    cell.infoView.subLabelA.text = [NSString stringWithFormat:_L(L_FMT_OXYGEN_NORMAL), dbsleep.spo2.floatValue];
                }

            }
                break;
            case 1:
            {
                [cell.infoView.titleLabel setText:_L(L_TITLE_BREATH_RATE)];
                cell.infoView.subLabelB.text = [NSString stringWithFormat:_L(L_TITLE_BREATH_SUB_B), @"12", @"20"];
                if (!sleepData) {
                    [cell.infoView setTextAndBarColor:HEALTH_COLOR_BEST];
                    cell.infoView.subLabelA.text = NONE_VALUE;
                } else {
                    
                    double breath =  dbsleep.br.floatValue;
                    if (breath < 12 || breath > 24) {
                        [cell.infoView setTextAndBarColor:HEALTH_COLOR_ATTECTION];
                        if (breath < 12 ) {
                            cell.infoView.subLabelA.text = [NSString stringWithFormat:_L(L_FMT_BREATH_LOW), breath];

                        }
                        if ( breath > 24){
                            cell.infoView.subLabelA.text = [NSString stringWithFormat:_L(L_FMT_BREATH_HIGH), breath];

                        }
                    }
                    if (breath >= 20 && breath <= 24) {
                        [cell.infoView setTextAndBarColor:HEALTH_COLOR_WELL];
                        cell.infoView.subLabelA.text = [NSString stringWithFormat:_L(L_FMT_BREATH_NORMAL), breath];
                    }
                    if (breath >= 12 && breath <= 20) {
                        [cell.infoView setTextAndBarColor: HEALTH_COLOR_BEST];
                        cell.infoView.subLabelA.text = [NSString stringWithFormat:_L(L_FMT_BREATH_NORMAL), breath];
                    }
                    //
                  
                }

            }
                break;
           
                
            default:
                break;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
        
    }
    
    if (indexPath.section == 2) { // 睡眠分期图
        if (!self.isCurrentShowNap) {
            SleepTimeCell *cell = [[SleepTimeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([SleepTimeCell class])];
            // 块状图
            if ([DeviceCenter instance].GetSleepDBData.count) {
                cell.sleepData = [[DeviceCenter instance].GetSleepDBData[indexPath.row] stagingData];//sleepData;

            } else {
                cell.sleepData = nil;//sleepData;
            }

            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
        }
       
        if (self.isCurrentShowNap) {
            NapSleepTimeCell *cell = [[NapSleepTimeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([NapSleepTimeCell class])];
            cell.sleepDataArray = [DeviceCenter instance].GetNapSleepDBData;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
      
    }
    
    if (indexPath.section == 4) {
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

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[SleepDrawLineCell class]]) {
        SleepDrawLineCell *linecell = (SleepDrawLineCell *)(cell);
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
    
    if ([cell isKindOfClass:[SleepTimeCell class]]) {
        DBSleepData * sleepRes = [[DBSleepData alloc] init];
        if ([DeviceCenter instance].GetSleepDBData.count) {
            sleepRes = [DeviceCenter instance].GetSleepDBData[indexPath.row];
        }
        StagingDataV2 *sleepData = [sleepRes stagingData];
        [(SleepTimeCell *)(cell) setSleepData:sleepData];
    }
    
    if ([cell isKindOfClass:[NapSleepTimeCell class]]) {
        ((NapSleepTimeCell *)cell).sleepDataArray = [DeviceCenter instance].GetNapSleepDBData;
    }
    
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

-(UISegmentedControl *)sleepSeg
{
    if (!_sleepSeg) {
        NSArray<NSString *> *titles =@[_L(L_SEG_SLEEP), _L(L_SEG_NAP)];

        _sleepSeg = [[UISegmentedControl alloc]initWithItems:titles];
        _sleepSeg.selectedSegmentIndex = 0; // 默认选中
        [_sleepSeg addTarget:self action:@selector(sleepSegSelect:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _sleepSeg;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
