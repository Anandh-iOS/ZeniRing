//
//  SleepGoalView.m
//  CareRingApp
//
//  Created by Anandh Selvam on 31/08/23.
//

#import "SleepGoalView.h"
#import <MAsonry/Masonry.h>
#import "LocalizeKeys.h"
#import "ConfigModel.h"
#import "sleepScoreData.h"



@implementation SleepGoalView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Create and configure UI elements
        
        self.goalData = [goalValues retrieveGoalValues];
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        self.titleLabel.textColor = UIColor.whiteColor;
        // Customize titleLabel as needed (e.g., text, font, color)
        
        self.subtitleLabel = [[UILabel alloc] init];
        self.subtitleLabel.textColor = [UIColor.whiteColor colorWithAlphaComponent:0.5];
        self.subtitleLabel.font = [UIFont systemFontOfSize:13.0];
        self.subtitleLabel.textAlignment = NSTextAlignmentLeft;
        // Customize subtitleLabel as needed
        
        self.boldScoreLabel =  [[UILabel alloc] init];
        self.boldScoreLabel.textColor = [UIColor.whiteColor colorWithAlphaComponent:0.5];
        self.boldScoreLabel.font = [UIFont systemFontOfSize:25.0];
        self.boldScoreLabel.textAlignment = NSTextAlignmentCenter;
        
        
        self.boldLabel = [[UILabel alloc] init];
        self.boldLabel.font = [UIFont boldSystemFontOfSize:25.0];
        self.boldLabel.textAlignment = NSTextAlignmentCenter;
        self.boldLabel.textColor = UIColor.whiteColor;
        self.boldLabel.text = self.goalData.sleepValue;
        self.stepper = [[UIStepper alloc] init];
        [self.stepper addTarget:self
                     action:@selector(stepperValueChanged:)
           forControlEvents:UIControlEventValueChanged];
        self.stepper.minimumValue = -DBL_MAX; // Smallest possible negative value
        self.stepper.maximumValue = DBL_MAX;  // Largest possible positive value
        // Create a UISegmentedControl instance
        self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[_L(L_IMMER_SEG_TITL_SPORTMAN), _L(L_IMMER_SEG_TITL_NORMAL), _L(L_IMMER_SEG_TITL_REDUCE),_L(L_IMMER_SEG_TITL_LOWDIP)]];
        // Set the tint color
        self.segmentedControl.selectedSegmentTintColor = [UIColor systemBlueColor];
        self.segmentedControl.hidden = true;
        [self.segmentedControl addTarget:self
                             action:@selector(segmentValueChanged:)
                   forControlEvents:UIControlEventValueChanged];

        UIView *additionalView = [[UIView alloc] init];
        // Customize additionalView as needed
        additionalView.backgroundColor = [UIColor.lightGrayColor colorWithAlphaComponent:0.1];
        additionalView.clipsToBounds = true;
        additionalView.layer.cornerRadius = 10;
        
        
        // Add subviews to the custom view
        [self addSubview:self.titleLabel];
        [self addSubview:self.subtitleLabel];
        [self addSubview:self.boldScoreLabel];
        [self addSubview:self.boldLabel];
        [self addSubview:self.stepper];
        [self addSubview:additionalView];
        [self addSubview:self.segmentedControl];
        
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.boldScoreLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.boldLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.stepper.translatesAutoresizingMaskIntoConstraints = NO;
        additionalView.translatesAutoresizingMaskIntoConstraints = NO;
        self.segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
        
        

        [NSLayoutConstraint activateConstraints:@[
                [self.titleLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:20],
                [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:20],
                [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:20],
                [self.titleLabel.heightAnchor constraintEqualToConstant:20],

            ]];
        
        [NSLayoutConstraint activateConstraints:@[
                [self.subtitleLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:5],
                [self.subtitleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:20],
                [self.subtitleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:20],
                [self.subtitleLabel.heightAnchor constraintEqualToConstant:20],

            ]];
        
        [NSLayoutConstraint activateConstraints:@[
                [self.subtitleLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:5],
                [self.subtitleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:20],
                [self.subtitleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:20],
                [self.subtitleLabel.heightAnchor constraintEqualToConstant:20],

            ]];
        
        
        [NSLayoutConstraint activateConstraints:@[
                [self.boldScoreLabel.topAnchor constraintEqualToAnchor:self.subtitleLabel.bottomAnchor constant:20],
                [self.boldScoreLabel.heightAnchor constraintEqualToConstant:30],
                [self.boldScoreLabel.widthAnchor constraintEqualToConstant:200],
                [self.boldScoreLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor]
            ]];
        
        [NSLayoutConstraint activateConstraints:@[
                [self.boldLabel.topAnchor constraintEqualToAnchor:self.boldScoreLabel.bottomAnchor constant:20],
                [self.boldLabel.heightAnchor constraintEqualToConstant:30],
                [self.boldLabel.widthAnchor constraintEqualToConstant:200],
                [self.boldLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor]
            ]];
        
        [NSLayoutConstraint activateConstraints:@[
                [self.stepper.topAnchor constraintEqualToAnchor:self.boldLabel.bottomAnchor constant:25],
                [self.stepper.heightAnchor constraintEqualToConstant:50],
                [self.stepper.widthAnchor constraintEqualToConstant:100],
                [self.stepper.centerXAnchor constraintEqualToAnchor:self.centerXAnchor]
            ]];
        
        [NSLayoutConstraint activateConstraints:@[
                [self.segmentedControl.topAnchor constraintEqualToAnchor:self.boldLabel.bottomAnchor constant:25],
                [self.segmentedControl.heightAnchor constraintEqualToConstant:40],
                [self.segmentedControl.widthAnchor constraintEqualToConstant:350],
                [self.segmentedControl.centerXAnchor constraintEqualToAnchor:self.centerXAnchor]
            ]];
        
        
        [NSLayoutConstraint activateConstraints:@[
                [additionalView.topAnchor constraintEqualToAnchor:self.stepper.bottomAnchor constant:10],
                [additionalView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:20],
                [additionalView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-20]
            ]];
        
        
        // Create and configure UI elements
        self.infoTitleLabel = [[UILabel alloc] init];
        self.infoTitleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        self.infoTitleLabel.textColor = UIColor.whiteColor;
        
        
        // Create and configure UI elements
        self.infosubtitleLabel = [[UILabel alloc] init];
        self.infosubtitleLabel.font = [UIFont systemFontOfSize:13.0];
        
        self.infosubtitleLabel.textColor = [UIColor.whiteColor colorWithAlphaComponent:0.5];
        self.infosubtitleLabel.numberOfLines = 0;
        
        // Create and configure UI elements
        self.infoDayLabel = [[UILabel alloc] init];
        self.infoDayLabel.font = [UIFont systemFontOfSize:13.0];
        
        self.infoDayLabel.textColor = UIColor.whiteColor;
        self.infoDayLabel.numberOfLines = 0;
        
        // Create and configure UI elements
        self.infoWeekLabel = [[UILabel alloc] init];
        self.infoWeekLabel.font = [UIFont systemFontOfSize:13.0];
        self.infoWeekLabel.textColor = UIColor.whiteColor;
        self.infoWeekLabel.numberOfLines = 0;
        
        // Create and configure UI elements
        self.infoLabel = [[UILabel alloc] init];
        self.infoLabel.font = [UIFont systemFontOfSize:13.0];
        self.infoLabel.textColor = UIColor.whiteColor;
        self.infoLabel.numberOfLines = 0;
        
        
        self.containerView = [[UIView alloc] init];
        UIImageView *image1 = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"moon.zzz"]];
        UIImageView *image2 = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"clock"]];
        
        
        // Add subviews to the custom view
        [additionalView addSubview:self.containerView];
        [additionalView addSubview:self.infoTitleLabel];
        [additionalView addSubview:self.infosubtitleLabel];
        [additionalView addSubview:self.infoLabel];
        
        [self.containerView addSubview:self.infoWeekLabel];
        [self.containerView addSubview:self.infoDayLabel];
        [self.containerView addSubview:image1];
        [self.containerView addSubview:image2];
        self.containerView.clipsToBounds = true;
        
        
        self.infoTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.infosubtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.infoLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.infoWeekLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.infoDayLabel.translatesAutoresizingMaskIntoConstraints = NO;
        image1.translatesAutoresizingMaskIntoConstraints = NO;
        image2.translatesAutoresizingMaskIntoConstraints = NO;
        self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [NSLayoutConstraint activateConstraints:@[
                [self.infoTitleLabel.topAnchor constraintEqualToAnchor:additionalView.topAnchor constant:20],
                [self.infoTitleLabel.trailingAnchor constraintEqualToAnchor:additionalView.trailingAnchor constant:-20],
                [self.infoTitleLabel.leadingAnchor constraintEqualToAnchor:additionalView.leadingAnchor constant:20],
                [self.infoTitleLabel.heightAnchor constraintEqualToConstant:20],
                
            ]];
        
        [NSLayoutConstraint activateConstraints:@[
                [self.infosubtitleLabel.topAnchor constraintEqualToAnchor:self.infoTitleLabel.bottomAnchor constant:10],
                [self.infosubtitleLabel.trailingAnchor constraintEqualToAnchor:additionalView.trailingAnchor constant:-20],
                [self.infosubtitleLabel.leadingAnchor constraintEqualToAnchor:additionalView.leadingAnchor constant:20],
            ]];
        

        [NSLayoutConstraint activateConstraints:@[
                [self.containerView.topAnchor constraintEqualToAnchor:self.infosubtitleLabel.bottomAnchor constant:10],
                [self.containerView.trailingAnchor constraintEqualToAnchor:additionalView.trailingAnchor constant:-20],
                [self.containerView.leadingAnchor constraintEqualToAnchor:additionalView.leadingAnchor constant:20],
            ]];
 
        
        [NSLayoutConstraint activateConstraints:@[
                [self.infoDayLabel.topAnchor constraintEqualToAnchor:self.containerView.topAnchor constant:10],
                [self.infoDayLabel.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor constant:-20],
                [self.infoDayLabel.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor constant:40],
            ]];
        
        [NSLayoutConstraint activateConstraints:@[
                [image1.topAnchor constraintEqualToAnchor:self.infoDayLabel.topAnchor],
                
                [image1.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor constant:0],
                [image1.widthAnchor constraintEqualToConstant:20],
                [image1.heightAnchor constraintEqualToConstant:20]
            ]];
           
        [NSLayoutConstraint activateConstraints:@[
                [self.infoWeekLabel.topAnchor constraintEqualToAnchor:self.infoDayLabel.bottomAnchor constant:15],
                [self.infoWeekLabel.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor constant:-20],
                [self.infoWeekLabel.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor constant:40],
                [self.infoWeekLabel.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor constant:-10],
            ]];
        
        [NSLayoutConstraint activateConstraints:@[
                [image2.topAnchor constraintEqualToAnchor:self.infoWeekLabel.topAnchor],
                [image2.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor constant:0],
                [image2.widthAnchor constraintEqualToConstant:20],
                [image2.heightAnchor constraintEqualToConstant:20]
            ]];
           
        
        [NSLayoutConstraint activateConstraints:@[
            [self.infoLabel.topAnchor constraintEqualToAnchor:self.containerView.bottomAnchor constant:10],
            [self.infoLabel.trailingAnchor constraintEqualToAnchor:additionalView.trailingAnchor constant:-20],
            [self.infoLabel.leadingAnchor constraintEqualToAnchor:additionalView.leadingAnchor constant:20],
            [self.infoLabel.bottomAnchor constraintEqualToAnchor:additionalView.bottomAnchor constant:-10],
            ]];
        

        // Add constraints to pin the bottom of additionalView to the bottom of the last label
        NSLayoutConstraint *additionalViewBottomConstraint = [additionalView.heightAnchor constraintEqualToConstant:100];
        additionalViewBottomConstraint.priority = UILayoutPriorityDefaultLow; // Lower priority
        additionalViewBottomConstraint.active = YES;
        
        
        self.scoreHeight = [self.boldScoreLabel.heightAnchor constraintEqualToConstant:20];
        self.scoreHeight.active = YES;
        
        

    }
    return self;
}

- (void)segmentValueChanged:(UISegmentedControl *)sender {
    // Get the selected segment index
    NSInteger selectedSegmentIndex = sender.selectedSegmentIndex;
    NSArray *range = [[sleepScoreData sharedInstance] sleepRanges];
    // Perform actions based on the selected segment index
    self.boldLabel.text = range[selectedSegmentIndex];
    self.goalData.dipPercentage = self.boldLabel.text;
}

- (void)stepperValueChanged:(UIStepper *)sender {
    // Get the current value of the stepper
    
    if ([self.selectedType isEqualToString:_L(L_SEG_TITL_SLEEP)]) {
        
        self.goalData.sleepValue = [self adjustTimeBy15Minutes:self.boldLabel.text increment:self.stepperPreviousValue < sender.value ? YES:NO];
        self.boldLabel.text = self.goalData.sleepValue;
        
        
    } else if ([self.selectedType isEqualToString: _L(L_SEG_TITL_QUALITY)]) {
        
        self.goalData.qualityValue = [self adjustTimeBy15Minutes:self.boldLabel.text increment:self.stepperPreviousValue < sender.value ? YES:NO];
        self.boldLabel.text = self.goalData.qualityValue;
        self.boldScoreLabel.text = [NSString stringWithFormat:@"%ld%%", [self calculatePercentageForTime:self.goalData.qualityValue]];
        
    }  else {
        self.goalData.deepValue = [self adjustTimeBy15Minutes:self.boldLabel.text increment:self.stepperPreviousValue < sender.value ? YES:NO];
        self.boldLabel.text = self.goalData.deepValue;
        self.boldScoreLabel.text = [NSString stringWithFormat:@"%ld%%", [self calculatePercentageForTime:self.goalData.deepValue]];
    }
    
    self.stepperPreviousValue = sender.value;
    
    
}


-(void)updateUI:(GoalsData *)data :(NSString *)selectedType
{
    self.selectedType = selectedType;
    //Hide and show score label
    if([selectedType isEqualToString:_L(L_SEG_TITL_QUALITY)] || [selectedType isEqualToString:_L(L_SEG_TITL_DEEP)])
    {
        self.scoreHeight.constant = 20.0;
    }
    else
    {
        self.scoreHeight.constant = 0.0;
    }
    
    //Hide and show the segment control
    if([selectedType isEqualToString:_L(L_SEG_TITL_IMMERSE)])
    {
        self.segmentedControl.hidden = false;
        self.stepper.hidden = true;
    }
    else
    {
        self.segmentedControl.hidden = true;
        self.stepper.hidden = false;
    }

    
    if ([self.selectedType isEqualToString:_L(L_SEG_TITL_SLEEP)]) {
        
        self.boldLabel.text = self.goalData.sleepValue;
        
        
    } else if ([self.selectedType isEqualToString: _L(L_SEG_TITL_QUALITY)]) {
        
        self.boldLabel.text = self.goalData.qualityValue;
        
    } else if ([self.selectedType isEqualToString:_L(L_SEG_TITL_IMMERSE)]) {
        
        self.boldLabel.text = self.goalData.dipPercentage;
        
        
    } else {
        
        self.boldLabel.text = self.goalData.deepValue;
        self.boldScoreLabel.text = [NSString stringWithFormat:@"%ld%%", [self calculatePercentageForTime:self.goalData.deepValue]];
        
    }
    
    [self layoutIfNeeded];
    
    self.titleLabel.text = data.title;
    self.subtitleLabel.text = data.subtitle;
    self.infoTitleLabel.text = data.infoTitle;
    self.infosubtitleLabel.text =  data.infoSubtitle;
    self.infoWeekLabel.text =  data.infoTrendWeek;
    self.infoDayLabel.text = data.infoTrendDay;
    self.infoLabel.text = data.infoText;
    
}

- (NSInteger)calculatePercentageForTime:(NSString *)timeString {
    // Convert the timeString to hours and minutes
    NSArray *components = [timeString componentsSeparatedByString:@" "];
    NSInteger hours = 0;
    NSInteger minutes = 0;

    if (components.count >= 2) {
        hours = [[components objectAtIndex:0] integerValue];
        minutes = [[components objectAtIndex:1] integerValue];
    }

    // Calculate the total time in minutes
    NSInteger totalTimeInMinutes = (hours * 60) + minutes;

    // Define the range from "6h 0m" (75%) to "8h 15m" (100%)
    NSInteger minTimeInMinutes = (6 * 60);  // 6 hours
    NSInteger maxTimeInMinutes = (8 * 60) + 15;  // 8 hours 15 minutes

    // Calculate the percentage
    CGFloat percentage = ((CGFloat)(totalTimeInMinutes - minTimeInMinutes) / (maxTimeInMinutes - minTimeInMinutes)) * 25 + 75;

    // Round the percentage to an integer value
    NSInteger roundedPercentage = lround(percentage);

    return roundedPercentage;
}

- (NSString *)adjustTimeBy15Minutes:(NSString *)timeString increment:(BOOL)shouldIncrement {
    // Split the time string into hours and minutes
    
    
    NSArray *components = [timeString componentsSeparatedByString:@" "];
    NSInteger hours = 0;
    NSInteger minutes = 0;

    if (components.count >= 2) {
        hours = [[components objectAtIndex:0] integerValue];
        minutes = [[components objectAtIndex:1] integerValue];
    }

    if (shouldIncrement) {
        // Add 15 minutes
        minutes += 15;

        // Handle carryover to hours if minutes exceed 59
        if (minutes >= 60) {
            hours += 1;
            minutes -= 60;
        }
    } else {
        // Subtract 15 minutes
        minutes -= 15;

        // Handle borrowing from hours if minutes become negative
        if (minutes < 0) {
            hours -= 1;
            minutes += 60;
        }
    }
    
    // Format the time string back to "Xh Ym" format
    NSString *formattedTime = [NSString stringWithFormat:@"%ldh %ldm", (long)hours, (long)minutes];
    
    if ([self.selectedType isEqualToString:_L(L_SEG_TITL_SLEEP)]) {
        
        
        // Enforce the time limits (05h 00m - 12h 00m)
        if (hours < 5) {
            hours = 5;
            minutes = 0;
        } else if (hours >= 12) {
            hours = 12;
            minutes = 0;
        }
        
        formattedTime = [NSString stringWithFormat:@"%ldh %ldm", (long)hours, (long)minutes];
        
        return formattedTime;
        
        
    } else if ([self.selectedType isEqualToString: _L(L_SEG_TITL_QUALITY)]) {
        
        NSInteger percent = [self calculatePercentageForTime:formattedTime];
        if(percent>=20 && percent<=100)
        {
            return formattedTime;
        }
        else
        {
            return  timeString;
        }

    } else {
        
        NSInteger percent = [self calculatePercentageForTime:formattedTime];
        if(percent>=25 && percent<=100)
        {
            return formattedTime;
        }
        else
        {
            return  timeString;
        }
        
    }
}


-(void)saveData
{
    [goalValues storeGoalValues:self.goalData];
}




@end
