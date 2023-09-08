//
//  scoreData.h
//  CareRingApp
//
//  Created by Anandh Selvam on 05/09/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface sleepScoreData : NSObject

@property (nonatomic, strong) NSNumber *achievedSleepDurationPercentage;
@property (nonatomic, strong) NSNumber *achievedQualitSleepDurationPercentage;
@property (nonatomic, strong) NSNumber *achievedDipPercent;
@property (nonatomic, strong) NSNumber *achievedDeepSleepPercentage;

@property (nonatomic, strong) NSNumber *sleepGoalPercent;
@property (nonatomic, strong) NSNumber *qualitySleepGoalPercent;
@property (nonatomic, strong) NSNumber *dipGoalPercentage;
@property (nonatomic, strong) NSNumber *deepSleepGoalPercent;

@property (nonatomic, strong) NSNumber *sleepScoreContribution;
@property (nonatomic, strong) NSNumber *qualitySleepScoreContribution;
@property (nonatomic, strong) NSNumber *dipGoalContribution;
@property (nonatomic, strong) NSNumber *deepGoalContribution;

@property (nonatomic, strong) NSArray<NSString *> *sleepRanges;


+ (instancetype)sharedInstance;

- (NSNumber*)calculateScore;
-(void)makeSleepContributorScore;

@end



NS_ASSUME_NONNULL_END
