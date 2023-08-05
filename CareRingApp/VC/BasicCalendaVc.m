//
//  BasicViewController.m
//  Example
//
//  Created by Jonathan Tribouharet.
//

#import "BasicCalendaVc.h"
#import <QMUIKit/QMUIKit.h>
#import <Masonry/Masonry.h>
#import "ConfigModel.h"
#import "TimeUtils.h"

@interface BasicCalendaVc (){
    NSMutableDictionary *_eventsByDate;
    
    NSDate *_todayDate;
    NSDate *_minDate;
    NSDate *_maxDate;
    NSDate *_dateSelected;
    
}

@property(strong, nonatomic)QMUIButton *cancelBtn, *sureBtn, *todayBtn;


@end

@implementation BasicCalendaVc



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    
    // Generate random events sort by date using a dateformatter for the demonstration
    //    [self createRandomEvents];
    
    // Create a min and max date for limit the calendar, optional
    [self createMinAndMaxDate];
    
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:_todayDate];
}

-(void)initUI {
    
    [self.view addSubview:self.cancelBtn];
    [self.view addSubview:self.sureBtn];
    self.calendarMenuView = [[JTCalendarMenuView alloc]init];
    self.calendarContentView = [[JTHorizontalCalendarView alloc]init];
    
    [self.view addSubview: self.calendarMenuView];
    [self.view addSubview:self.calendarContentView];
//    [self.view addSubview:self.todayBtn];
    
    [self.cancelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(self.view);
        make.height.equalTo(@44);
    }];
    
    [self.sureBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.equalTo(self.view);
        make.height.equalTo(self.cancelBtn);

    }];
    [self.calendarMenuView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.cancelBtn.mas_bottom);
        make.height.equalTo(@44);
    }];
    [self.calendarContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.height.equalTo(@300);
        make.top.equalTo(self.calendarMenuView.mas_bottom);
    }];
    
//    [self.todayBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.view).offset(15);
//        make.top.equalTo(self.calendarContentView.mas_bottom).offset(15);
//    }];
    
}

#pragma mark - Buttons callback

- (void)didGoTodayTouch
{
    [_calendarManager setDate:_todayDate]; // 跳转到今天
}



#pragma mark - CalendarManager delegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    // Today
    if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor blueColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor redColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Other month
    else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    
    //    if([self haveEventForDay:dayView.date]){
    //        dayView.dotView.hidden = NO;
    //    }
    //    else{
    //        dayView.dotView.hidden = YES;
    //    }
    
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    if (dayView.date != _todayDate) {
        _dateSelected = dayView.date;

    }
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    WEAK_SELF
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
        STRONG_SELF
        dayView.circleView.transform = CGAffineTransformIdentity;
        [strongSelf->_calendarManager reload];
        
    } completion:nil];
    
    
    // Don't change page in week mode because block the selection of days in first and last weeks of the month
    if(_calendarManager.settings.weekModeEnabled){
        return;
    }
    
    // Load the previous or next page if touch a day from another month
    
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
}

#pragma mark - CalendarManager delegate - Page mangement

// Used to limit the date for the calendar, optional
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    return [_calendarManager.dateHelper date:date isEqualOrAfter:_minDate andEqualOrBefore:_maxDate];
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Next page loaded");
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Previous page loaded");
}

#pragma mark - Fake data

- (void)createMinAndMaxDate
{
    _todayDate = [TimeUtils zeroOfDate:[NSDate date]];
//    _dateSelected = _todayDate;
    
    // Min date will be 2 month before today
    _minDate = [_calendarManager.dateHelper addToDate:_todayDate months:-36];
    
    // Max date will be 2 month after today
    _maxDate = [_calendarManager.dateHelper addToDate:_todayDate months:0];
}

// Used only to have a key for _eventsByDate
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}

- (BOOL)haveEventForDay:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(_eventsByDate[key] && [_eventsByDate[key] count] > 0){
        return YES;
    }
    
    return NO;
    
}

//- (void)createRandomEvents
//{
//    _eventsByDate = [NSMutableDictionary new];
//
//    for(int i = 0; i < 30; ++i){
//        // Generate 30 random dates between now and 60 days later
//        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
//
//        // Use the date as key for eventsByDate
//        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
//
//        if(!_eventsByDate[key]){
//            _eventsByDate[key] = [NSMutableArray new];
//        }
//
//        [_eventsByDate[key] addObject:randomDate];
//    }
//}

-(void)btnClick:(id)sender {
    
    if (sender == self.cancelBtn) {
    }
    
    
    if (sender == self.sureBtn) {
        if (self.selectDateCBK) {
//            _dateSelected 为每天00点
            if (_dateSelected == nil) {
                self.selectDateCBK([NSDate date]);
            } else {
                NSDate *backDate = [_dateSelected dateByAddingTimeInterval:24*3600 -1];
                self.selectDateCBK(backDate);
            }
        }
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];

    
}

-(QMUIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [[QMUIButton alloc]init];
        _cancelBtn.titleLabel.textColor = UIColor.whiteColor;
        _cancelBtn.backgroundColor = UIColor.clearColor;
        [_cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setTitle:_L(L_CANCEL) forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];

    }
    return _cancelBtn;
}

-(QMUIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn =  [[QMUIButton alloc]init];
        _sureBtn.titleLabel.textColor = UIColor.whiteColor;
        _sureBtn.backgroundColor = UIColor.clearColor;
        [_sureBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_sureBtn setTitle:_L(L_OK) forState:UIControlStateNormal];
        [_sureBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];

    }
    return _sureBtn;
}

-(QMUIButton *)todayBtn
{
    if (!_todayBtn) {
        _todayBtn =  [[QMUIButton alloc]init];
        [_todayBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];

        _todayBtn.backgroundColor = UIColor.clearColor;
//        [_todayBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_todayBtn setTitle:_L(L_TODAY) forState:UIControlStateNormal];
        [_todayBtn addTarget:self action:@selector(didGoTodayTouch) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _todayBtn;
}

@end
