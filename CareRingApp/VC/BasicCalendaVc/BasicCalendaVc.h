//
//  BasicViewController.h
//  Example
//
//  Created by Jonathan Tribouharet.
//

#import <UIKit/UIKit.h>
#import "NAVTemplateViewController.h"

#import <JTCalendar/JTCalendar.h>

@interface BasicCalendaVc : NAVTemplateViewController<JTCalendarDelegate>

@property (strong, nonatomic) JTCalendarMenuView *calendarMenuView;
@property (strong, nonatomic)  JTHorizontalCalendarView *calendarContentView;

@property (strong, nonatomic) JTCalendarManager *calendarManager;

@property (copy, nonatomic) void (^selectDateCBK)(NSDate *date);

//@property (strong, nonatomic)  NSLayoutConstraint *calendarContentViewHeight;

@end
