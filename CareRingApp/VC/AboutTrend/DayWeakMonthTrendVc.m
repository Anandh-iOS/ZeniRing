//
//  DayWeakMonthTrendVc.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/10/10.
//  二级界面 日 周 月 分级趋势图

#import <Masonry/Masonry.h>
#import <QMUIKit/QMUIKit.h>
#import "DayWeakMonthTrendVc.h"
#import "Colors.h"
#import "ConfigModel.h"
#import "TimeUtils.h"

#import "TrendCollectionVc.h"

@interface DayWeakMonthTrendVc ()

@property(strong, nonatomic) UIView *segmentContent; //
@property(strong, nonatomic) UIView *cllecViewContent; // 趋势图
@property(strong, nonatomic) UIView *aboutContent;
@property(strong, nonatomic) UIView *targetContent;

@property(strong, nonatomic) UIView *mainContent;

@property(strong, nonatomic) UILabel *aboutInfoLbl, *targetInfoLbl;
@property(strong, nonatomic) UIScrollView *mainScrollView;
@property(strong, nonatomic) UISegmentedControl *topSegment;

@property(strong, nonatomic)TrendCollectionVc *collectionWeekPageVc;

@end

@implementation DayWeakMonthTrendVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    formatter.dateFormat = @"yyyy-MM-dd";
//
//    NSDate *date = [formatter dateFromString:@"2022-1-1"];
//
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekOfYear;
//    NSDateComponents * beginComponents = [calendar components:unitFlags fromDate:date];
//    DebugNSLog(@"一年中 第 %ld 周", (long)beginComponents.weekOfYear); // 中文 周一 =2 ,
//    DebugNSLog(@"周 %ld ", (long)beginComponents.weekday); // 中文 周一 =2 ,
//
//    NSDateComponents *components = [[NSDateComponents alloc] init];
////    components.year = 2022;
//    components.yearForWeekOfYear = 2022;
//    components.weekOfYear = 1;
//    calendar.firstWeekday = 1;
//    [components setWeekday:1]; // monday
//
//    NSDate *weekDate = [calendar dateFromComponents:components];
//
//    [components setWeekday:7]; // monday
//    NSDate *weekDate2 = [calendar dateFromComponents:components];


}

-(void)viewDidLayoutSubviews
{
    
    [super viewDidLayoutSubviews];
    self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.bounds.size.width, CGRectGetMaxY(self.mainContent.frame));
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.targetInfoLbl.attributedText = [self targetAttString];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    [TimeUtils everyWeekDatesOfYearGroupByWeak:2022 FirstDayOfWeek:1];
    [TimeUtils serverialWeekRangeDatesOfYear:2022 FirstDayOfWeek:1];
    [TimeUtils monthRangeDateofYear:2022];
}

-(void)initUI {
    [self arrowback:nil];
    self.navigationItem.title = self.navTitleString;
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        
    }];
    
    self.mainContent = [UIView new];
    [self.mainScrollView addSubview:self.mainContent];
    [self.mainContent mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self.mainScrollView);
        make.width.equalTo(self.mainScrollView.mas_width);
    }];
    
    
    [self.mainContent addSubview: self.segmentContent];
    [self.mainContent addSubview: self.cllecViewContent];

    [self.mainContent addSubview: self.aboutContent];
    
    CGFloat margin = 15.f;
    
    [self.segmentContent mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentContent.superview.mas_top).offset(8);
        make.leading.equalTo(self.segmentContent.superview.mas_leading).offset(margin);
        make.trailing.equalTo(self.segmentContent.superview.mas_trailing).inset(margin);
        make.height.equalTo(@40);
    }];
    [self.segmentContent addSubview:self.topSegment];
    [self.topSegment mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(self.segmentContent);
    }];
    
    [self.cllecViewContent mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.segmentContent);
        make.top.equalTo(self.segmentContent.mas_bottom).offset(margin);
        make.height.equalTo(@250);
    }];
    // 添加collectionview
    [self.cllecViewContent addSubview:self.collectionWeekPageVc.view];
    [self.collectionWeekPageVc.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(self.collectionWeekPageVc.view.superview);
    }];
    
    // 由内部决定高度
    [self.aboutContent mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.segmentContent);
        make.top.equalTo(self.cllecViewContent.mas_bottom).offset(margin);
        if (![self needTarget]) { // 不需要目标的情况
            make.bottom.equalTo(self.aboutContent.superview.mas_bottom).inset(margin);

        }
    }];
    
    [self layoutAboutContent];
    
    if ([self needTarget]) {
        [self.mainContent addSubview: self.targetContent];
        // 由内部决定高度
        [self.targetContent mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self.segmentContent);
            make.top.equalTo(self.aboutContent.mas_bottom).offset(margin);
            make.bottom.equalTo(self.aboutContent.superview.mas_bottom).inset(margin);
        }];
        
        [self layoutTargetContent];
    }
 
}


-(void)layoutAboutContent {
    
    UILabel *lbl = [UILabel new];
    lbl.textColor = UIColor.whiteColor;
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.text = _L(L_TITLE_ABOUT);
    
    [self.aboutContent addSubview:lbl];
    
    UILabel *label = [UILabel new];
    self.aboutInfoLbl = label;
    [self.aboutContent addSubview:label];
    
    CGFloat margin = 15.f;
    QMUIButton *readBtn = [[QMUIButton alloc]init];
    [readBtn setTitle:_L(L_TREND_KNOW) forState:UIControlStateNormal];
    
    [readBtn addTarget:self action:@selector(gotoReadAbout:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.aboutContent addSubview:readBtn];
    
    [lbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(self.aboutContent).offset(margin);
        
    }];
    
    [readBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.aboutContent).inset(margin);
        make.centerY.equalTo(lbl.mas_centerY);
        
    }];
    
    [self.aboutInfoLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(lbl.mas_leading);
        make.trailing.equalTo(readBtn.mas_trailing);
        make.top.equalTo(lbl.mas_bottom).offset(margin);
        make.bottom.equalTo(self.aboutContent.mas_bottom).inset(margin);
    }];
    self.aboutInfoLbl.numberOfLines = 0;
    self.aboutInfoLbl.attributedText = [self aboutAttString];
}

-(void)layoutTargetContent {
    UILabel *lbl = [UILabel new];
    lbl.textColor = UIColor.whiteColor;
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.text = _L(L_TREND_TITLE_GOAL);
    
    [self.targetContent addSubview:lbl];
    
    QMUIButton *goalBtn = [[QMUIButton alloc]init];
    [goalBtn setTitle:_L(L_TREND_EDIT) forState:UIControlStateNormal];

    [goalBtn addTarget:self action:@selector(gotoEditGoal:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.targetContent addSubview:goalBtn];
    
    UILabel *label = [UILabel new];
    self.targetInfoLbl = label;
    self.targetInfoLbl.numberOfLines = 0;
    [self.targetContent addSubview:label];
    
    CGFloat margin = 15.f;
   
    [lbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(self.targetContent).offset(margin);
        
    }];
    
    [goalBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.targetContent).inset(margin);
        make.top.equalTo(lbl);
        
    }];
    
    [self.targetInfoLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(lbl.mas_leading);
        make.trailing.equalTo(goalBtn.mas_trailing);
        make.top.equalTo(lbl.mas_bottom).offset(margin);
        make.bottom.equalTo(self.targetContent.mas_bottom).inset(margin);
    }];
}

// 了解
-(void)gotoReadAbout:(QMUIButton *)btn {
    
    
}

// 设置目标
-(void)gotoEditGoal:(QMUIButton *)btn {
    
    
}

-(void)segSelect:(UISegmentedControl *)seg {
   
    
    
}

-(BOOL)needTarget {
    
    BOOL need = NO;
    switch (self.trendVcType) {
        case   TREDNVC_IMMERSE :
        {
            need = YES;
        }
            break;     // 沉浸
        case   TREDNVC_HRV:
        {
          
        }
            break;
        case   TREDNVC_SLEEP_DURATION :
        {
            need = YES;
        }
            break;   // 睡眠时长
        case    TREDNVC_QUALITY_SLEEP:
        {
            need = YES;

        }
            break;      //优质睡眠
        case   TREDNVC_DEEP_SLEEP :
        {
            need = YES;

        }
            break;       //深度睡眠
        case   TREDNVC_OXYGEN :
        {
        }
            break;           // 血氧
        case  TREDNVC_BREATH_RATE :
        {
        }
            break;      // 呼吸率
        default:
            break;
    }
    
    return need;
}

-(NSAttributedString *)aboutAttString {
    
    NSMutableAttributedString *attString;
    NSString *baseString;
    NSString *baseSubString = nil;
    switch (self.trendVcType) {
        case   TREDNVC_IMMERSE :
        {
            baseString = _L(L_TREND_ABT_IMMERSE);
            baseSubString = _L(L_TREND_ABT_IMMERSE_B);
        }
            break;     // 沉浸
        case   TREDNVC_HRV:
        {
            baseString = _L(L_TREND_ABT_HRV);
            baseSubString = _L(L_TREND_ABT_HRV_B);
        }
            break;
        case   TREDNVC_SLEEP_DURATION :
        {
            baseString = _L(L_TREND_ABT_SLEEPTIME);
        }
            break;   // 睡眠时长
        case    TREDNVC_QUALITY_SLEEP:
        {
            baseString = _L(L_TREND_ABT_QUALITYSLEEP);

        }
            break;      //优质睡眠
        case   TREDNVC_DEEP_SLEEP :
        {
            baseString = _L(L_TREND_ABT_DEEPSLEEP);
            baseSubString = _L(L_TREND_ABT_DEEPSLEEP_B);

        }
            break;       //深度睡眠
        case   TREDNVC_OXYGEN :
        {
            baseString = _L(L_TREND_ABT_OXYGEN);
            baseSubString = _L(L_TREND_ABT_OXYGEN_B);

        }
            break;           // 血氧
        case  TREDNVC_BREATH_RATE :
        {
            baseString = _L(L_TREND_ABT_BREATH_RATE);
            
        }
            break;      // 呼吸率
        default:
            break;
    }
    
    attString = [self resultDesc:baseString B:baseSubString];
    
    return attString;
}

-(NSAttributedString *)targetAttString {
    
    NSMutableAttributedString *attString;
    NSString *baseString;
    NSString *baseSubString = nil;
    switch (self.trendVcType) {
        case   TREDNVC_IMMERSE :
        {
            baseString = _L(L_TREND_GOAL_IMMERSE);
            baseSubString = _L(L_TREND_GOAL_COMMON_FMT);
        }
            break;     // 沉浸
        case   TREDNVC_SLEEP_DURATION :
        {
            baseString = _L(L_TREND_GOAL_SLEEPTIME);
            baseSubString = _L(L_TREND_GOAL_COMMON_FMT);

        }
            break;   // 睡眠时长
        case    TREDNVC_QUALITY_SLEEP:
        {
            baseString = _L(L_TREND_GOAL_QUALITY_SLEEP);
            baseSubString = _L(L_TREND_GOAL_COMMON_FMT);

        }
            break;      //优质睡眠
        case   TREDNVC_DEEP_SLEEP :
        {
            baseString = _L(L_TREND_GOAL_DEEP_SLEEP);
            baseSubString = _L(L_TREND_GOAL_COMMON_FMT);

        }
            break;       //深度睡眠
      
        default:
            break;
    }
    
    attString = [self resultDesc:baseString B:baseSubString];
    
    return attString;
}


-(NSMutableAttributedString *)resultDesc:(NSString *)desc_a B:(NSString *)desc_b  {


    // 链接
    NSMutableAttributedString *allString = [[NSMutableAttributedString alloc]init];

    //privacy label 富文本
    UIFont *privacyFont =  [UIFont systemFontOfSize:17.0];
    NSString *str_sub_a = desc_a;//@"Agree to Nexchair`s ";
    NSMutableAttributedString *privacyAttString = [[NSMutableAttributedString alloc]init];
    
    if (desc_a.length) {
        NSAttributedString *sub_a = [[NSAttributedString alloc] initWithString:str_sub_a attributes:@{NSFontAttributeName : privacyFont,
                                                                                                      NSForegroundColorAttributeName : [UIColor lightGrayColor],}
                                     ];
        [privacyAttString appendAttributedString:sub_a];

    }
    
    if (desc_b.length) {
        NSAttributedString *sub_b = [[NSAttributedString alloc] initWithString:desc_b attributes:@{NSFontAttributeName : privacyFont,
                                                                                                      NSForegroundColorAttributeName : [UIColor whiteColor],}
                                     ];
        [privacyAttString appendAttributedString:sub_b];

    }
    // 设置段落
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = 5.0;
    paragraphStyle.paragraphSpacing = 8.0;
    [privacyAttString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, privacyAttString.string.length)];

    [allString appendAttributedString:privacyAttString];
   

    return allString;
}


-(UIView *)segmentContent
{
    if (!_segmentContent) {
        _segmentContent = [UIView new];
        _segmentContent.backgroundColor = ITEM_BG_COLOR;
        _segmentContent.layer.masksToBounds = YES;
        _segmentContent.layer.cornerRadius = ITEM_CORNOR_RADIUS;
    }
    return _segmentContent;
}

-(UIView *)cllecViewContent
{
    if (!_cllecViewContent) {
        _cllecViewContent = [UIView new];
        _cllecViewContent.backgroundColor = ITEM_BG_COLOR;
        _cllecViewContent.layer.masksToBounds = YES;
        _cllecViewContent.layer.cornerRadius = ITEM_CORNOR_RADIUS;
    }
    return _cllecViewContent;
}

-(UIView *)aboutContent
{
    if (!_aboutContent) {
        _aboutContent = [UIView new];
        _aboutContent.backgroundColor = ITEM_BG_COLOR;
        _aboutContent.layer.masksToBounds = YES;
        _aboutContent.layer.cornerRadius = ITEM_CORNOR_RADIUS;
    }
    return _aboutContent;
}

-(UIView *)targetContent
{
    if (!_targetContent) {
        _targetContent = [UIView new];
        _targetContent.backgroundColor = ITEM_BG_COLOR;
        _targetContent.layer.masksToBounds = YES;
        _targetContent.layer.cornerRadius = ITEM_CORNOR_RADIUS;
    }
    return _targetContent;
}

-(UIScrollView *)mainScrollView
{
    if (!_mainScrollView) {
        _mainScrollView = [UIScrollView new];
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        

    }
    return _mainScrollView;
}

-(TrendCollectionVc *)collectionWeekPageVc
{
    if (!_collectionWeekPageVc) {
        _collectionWeekPageVc = [[TrendCollectionVc alloc]init];
        _collectionWeekPageVc.trendVcType = self.trendVcType;
        _collectionWeekPageVc.timeType = TrendDrawTIME_TYPE_EVERY_WEEK_PREPAGE; // 一周一页
    }
    
    return _collectionWeekPageVc;
}

-(UISegmentedControl *)topSegment
{
    if (!_topSegment) {
        
        NSArray<NSString *> *titles =@[_L(L_TREND_SEG_DAY), _L(L_TREND_SEG_WEEK), _L(L_TREND_SEG_MONTH),];
        
//        WEAK_SELF
//        [self.indexArray enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            STRONG_SELF
//            titles[idx] = [strongSelf typeTitle:obj.unsignedIntegerValue];
//
//        }];
        _topSegment = [[UISegmentedControl alloc]initWithItems:titles];
        _topSegment.selectedSegmentIndex = 0; // 默认选中
        [_topSegment addTarget:self action:@selector(segSelect:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _topSegment;
}

@end
