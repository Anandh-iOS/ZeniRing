//
//  SetGoalVC.m
//  CareRingApp
//
//  Created by Anandh Selvam on 31/08/23.
//


#import "SetGoalVC.h"
#import "SleepGoalView.h"
#import <Masonry/Masonry.h>
#import "GoalsData.h"




@interface SetGoalVC ()
{
    SleepGoalView *customView;
    NSMutableArray *data;
    NSArray *segmentItems;
}

@end

@implementation SetGoalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeData];
    
    segmentItems =  @[_L(L_SEG_TITL_SLEEP), _L(L_SEG_TITL_QUALITY), _L(L_SEG_TITL_IMMERSE), _L(L_SEG_TITL_DEEP)];
    WEAK_SELF
    [self customNavStyleNormal:_L(L_VC_TITLE_SET_GOAL) BackBlk:^{
        STRONG_SELF
        [strongSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    //Adding segment controller
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentItems];
    segmentedControl.selectedSegmentIndex = 0; // Set the initial selected segment
    [segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:segmentedControl];
 
    //Adding container view for page content
    customView = [[SleepGoalView alloc] init];
    customView.translatesAutoresizingMaskIntoConstraints = NO;
    [customView updateUI:data.firstObject :_L(L_SEG_TITL_SLEEP)];
    [self.view addSubview:customView];
    
    //Segment control and containverview constraints
    [segmentedControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.leading.equalTo(self.view);
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(20.0);
        make.height.equalTo(@40);
    }];
    
    [customView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.leading.equalTo(self.view);
        make.top.equalTo(segmentedControl.mas_bottom);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [customView saveData];
}


-(void)makeData
{
    data = [[NSMutableArray alloc] init];
    GoalsData *sleepGoal = [[GoalsData alloc] init];
    sleepGoal.title = _L(L_TITEL_TARGET_SLEEP);
    sleepGoal.subtitle = _L(L_SUBTITL_TARGET_SLEEP);
    
    sleepGoal.percentage = _L(L_TITEL_TARGET_SLEEP);
    sleepGoal.time = _L(L_TITEL_TARGET_SLEEP);
    
    sleepGoal.infoTitle = _L(L_TITLE_ABOUT);
    sleepGoal.infoSubtitle = _L(L_TXT_TRGT_ABOUT_SLEEP_A);
    sleepGoal.infoTrendDay = _L(L_TXT_TRGT_ABOUT_SLEEP_A1);
    sleepGoal.infoTrendWeek = _L(L_TXT_TRGT_ABOUT_SLEEP_A2);
    sleepGoal.infoText = _L(L_TXT_TRGT_ABOUT_SLEEP_B);
    [data addObject:sleepGoal];
    
    GoalsData *qualityGoal = [[GoalsData alloc] init];
    qualityGoal.title = _L(L_TITEL_TARGET_GOODSLEEP);
    qualityGoal.subtitle = _L(L_SUBTITL_GOODSLEEP);
    
    qualityGoal.percentage = @"";
    qualityGoal.time = @"";
    
    qualityGoal.infoTitle = _L(L_TITLE_ABOUT);
    qualityGoal.infoSubtitle = _L(L_TXT_TRGT_ABOUT_QUA_SLEEP_A);
    qualityGoal.infoTrendDay = _L(L_TXT_TRGT_ABOUT_QUA_SLEEP_A1);
    qualityGoal.infoTrendWeek = _L(L_TXT_TRGT_ABOUT_QUA_SLEEP_A2);
    qualityGoal.infoText = _L(L_TXT_TRGT_ABOUT_QUA_SLEEP_B);
    [data addObject:qualityGoal];
    
    GoalsData *dipGoal = [[GoalsData alloc] init];
    dipGoal.title = _L(L_TITEL_TARGET_IMMERSE);
    dipGoal.subtitle = _L(L_SUBTITL_TARGET_IMMERSE);
    
    dipGoal.percentage = @"";
    dipGoal.time = @"";
    
    dipGoal.infoTitle = _L(L_TITLE_ABOUT);
    dipGoal.infoSubtitle = _L(L_TXT_TRGT_ABOUT_IMMERSE_A);
    dipGoal.infoTrendDay = _L(L_TXT_TRGT_ABOUT_IMMERSE_A1);
    dipGoal.infoTrendWeek = _L(L_TXT_TRGT_ABOUT_IMMERSE_A2);
    dipGoal.infoText = _L(L_TXT_TRGT_ABOUT_IMMERSE_A);
    [data addObject:dipGoal];
    
    GoalsData *deepGoal = [[GoalsData alloc] init];
    deepGoal.title = _L(L_TITEL_TARGET_DEEPSLEEP);
    deepGoal.subtitle = _L(L_SUBTITL_TARGET_DEEPSLEEP);
    
    deepGoal.percentage = @"";
    deepGoal.time = @"";
    
    deepGoal.infoTitle = _L(L_TITLE_ABOUT);
    deepGoal.infoSubtitle = _L(L_TXT_TRGT_ABOUT_DEEPSLEEP_A);
    deepGoal.infoTrendDay = _L(L_TXT_TRGT_ABOUT_DEEPSLEEP_A1);
    deepGoal.infoTrendWeek = _L(L_TXT_TRGT_ABOUT_DEEPSLEEP_A2);
    deepGoal.infoText = _L(L_TXT_TRGT_ABOUT_DEEPSLEEP_B);
    [data addObject:deepGoal];
    
}

- (void)segmentedControlValueChanged:(UISegmentedControl *)sender {
    
    [customView updateUI:[data objectAtIndex:sender.selectedSegmentIndex] :[segmentItems objectAtIndex:sender.selectedSegmentIndex]];
    
    
}


@end
