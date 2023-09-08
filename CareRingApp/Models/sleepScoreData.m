//
//  scoreData.m
//  CareRingApp
//
//  Created by Anandh Selvam on 05/09/23.
//

#import "sleepScoreData.h"
#import "goalValues.h"
#import "DeviceCenter.h"

@implementation sleepScoreData

+ (instancetype)sharedInstance {
    static sleepScoreData *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.sleepRanges = @[
                    @"15 - 20%",
                    @"10 - 15%",
                    @"5 - 10%",
                    @"0 - 5%"
                ];
    });
    return sharedInstance;
}



- (NSNumber*)calculateScore {
    
    if ([self.achievedSleepDurationPercentage floatValue] >= [self.sleepGoalPercent floatValue]) {
        // If achieved sleep duration is equal to or higher than the sleep goal, contribution is 25x100%
        [sleepScoreData sharedInstance].sleepScoreContribution = @25;
        
    } else if ([self.achievedSleepDurationPercentage floatValue] <= 0) {
        // If achieved sleep duration is zero, contribution is zero
        [sleepScoreData sharedInstance].sleepScoreContribution = @0;
        
    } else {
        // Otherwise, contribution is 25 times the achieved sleep duration percentage
        [sleepScoreData sharedInstance].sleepScoreContribution = @([self.achievedSleepDurationPercentage floatValue] * 25);
        
    }
    
    if ([self.achievedQualitSleepDurationPercentage floatValue] >= [self.qualitySleepGoalPercent floatValue]) {
        // If achieved sleep duration is equal to or higher than the sleep goal, contribution is 25x100%
        [sleepScoreData sharedInstance].sleepScoreContribution = @25;
        
    } else if ([self.achievedSleepDurationPercentage floatValue] <= 0) {
        // If achieved sleep duration is zero, contribution is zero
        [sleepScoreData sharedInstance].sleepScoreContribution = @0;
        
    } else {
        // Otherwise, contribution is 25 times the achieved sleep duration percentage
        [sleepScoreData sharedInstance].sleepScoreContribution = @([self.achievedQualitSleepDurationPercentage floatValue] * 25);
        
    }
    
    
    NSString *selectedDipValue = [goalValues retrieveGoalValues].dipPercentage;
    
    if([selectedDipValue isEqualToString:@"10 - 15%"])
    {
        if ([self.achievedDipPercent floatValue] >= 10) {
            
            [sleepScoreData sharedInstance].dipGoalContribution = @25;
            
        } else if ([self.achievedDipPercent floatValue] >= 0.1 && [self.achievedDipPercent floatValue] < 9.9) {
            
            [sleepScoreData sharedInstance].dipGoalContribution = [NSNumber numberWithDouble:25.0 * ([self.achievedDipPercent floatValue]/9.9)];
            
            
        } else if([self.achievedDipPercent floatValue] <= 0.1) {
            
            [sleepScoreData sharedInstance].dipGoalContribution = @0;
            
        }
    }
    else if([selectedDipValue isEqualToString:@"15 - 20%"])
    {
        if ([self.achievedDipPercent floatValue] >= 15) {
            
            [sleepScoreData sharedInstance].dipGoalContribution = @25;
            
        } else if ([self.achievedDipPercent floatValue] >= 0.1 && [self.achievedDipPercent floatValue] < 14.9) {
            
            [sleepScoreData sharedInstance].dipGoalContribution = [NSNumber numberWithDouble:25.0 * ([self.achievedDipPercent floatValue]/14.9)];
            
            
        } else if([self.achievedDipPercent floatValue] <= 0.1) {
            
            [sleepScoreData sharedInstance].dipGoalContribution = @0;
            
        }
    }
    else if([selectedDipValue isEqualToString:@"5 - 10%"])
    {
        if ([self.achievedDipPercent floatValue] >= 5) {
            
            [sleepScoreData sharedInstance].dipGoalContribution = @25;
            
        } else if ([self.achievedDipPercent floatValue] >= 0.1 && [self.achievedDipPercent floatValue] < 4.9) {
            
            [sleepScoreData sharedInstance].dipGoalContribution = [NSNumber numberWithDouble:25.0 * ([self.achievedDipPercent floatValue]/4.9)];
            
        } else if([self.achievedDipPercent floatValue] <= 0.1) {
            [sleepScoreData sharedInstance].dipGoalContribution = @0;
            
        }
    }
    else if([selectedDipValue isEqualToString:@"0 - 5%"])
    {
        [sleepScoreData sharedInstance].dipGoalContribution = @25;
        
    }
    
    
    
    if ([self.achievedDeepSleepPercentage floatValue] >= [self.deepSleepGoalPercent floatValue]) {
        // If achieved sleep duration is equal to or higher than the sleep goal, contribution is 25x100%
        [sleepScoreData sharedInstance].deepGoalContribution = @25;
        
    } else if ([self.achievedDeepSleepPercentage floatValue] <= 0) {
        // If achieved sleep duration is zero, contribution is zero
        [sleepScoreData sharedInstance].deepGoalContribution = @0;
        
    } else {
        // Otherwise, contribution is 25 times the achieved sleep duration percentage
        [sleepScoreData sharedInstance].deepGoalContribution = @([self.achievedDeepSleepPercentage floatValue] * 25);
        
    }
     
    sleepScoreData *scoreData = [sleepScoreData sharedInstance];
    // Add up the contributions
    double totalContributions = [scoreData.sleepScoreContribution doubleValue] +
                                [scoreData.qualitySleepScoreContribution doubleValue] +
                                [scoreData.dipGoalContribution doubleValue] +
                                [scoreData.deepGoalContribution doubleValue];

    // Return the total as an NSNumber
    return @(totalContributions);
        
}


-(void)makeSleepContributorScore
{
    [[DeviceCenter instance] getSleepData:CONTRI_TOTAL_SLEEP];
    [[DeviceCenter instance] getSleepData:CONTRI_QUALITY_SLEEP];
    [[DeviceCenter instance] getSleepData:CONTRI_AVERAGE_HR];
    [[DeviceCenter instance] getSleepData:CONTRI_DEEP_SLEEP];
}



@end


