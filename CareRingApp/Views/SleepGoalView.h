//
//  SleepGoalView.h
//  CareRingApp
//
//  Created by Anandh Selvam on 31/08/23.
//

#import <UIKit/UIKit.h>
#import "GoalsData.h"
#import "CareRingApp-Swift.h"
#import "goalValues.h"

NS_ASSUME_NONNULL_BEGIN


@interface SleepGoalView : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UILabel *boldScoreLabel;
@property (nonatomic, strong) UILabel *boldLabel;
@property (nonatomic, strong) UILabel *infoTitleLabel;
@property (nonatomic, strong) UILabel *infosubtitleLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *infoDayLabel;
@property (nonatomic, strong) UILabel *infoWeekLabel;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSLayoutConstraint *scoreHeight;
@property (nonatomic, strong) UIStepper *stepper;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSString *selectedType;
@property (nonatomic, strong) goalValues *goalData;
@property  double stepperPreviousValue;




-(void)updateUI:(GoalsData *)data :(NSString *)selectedType;
-(void)saveData;

@end

NS_ASSUME_NONNULL_END
