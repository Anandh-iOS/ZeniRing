//
//  goalValues.h
//  CareRingApp
//
//  Created by Anandh Selvam on 02/09/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface goalValues : NSObject <NSSecureCoding>

// Retrieve the values
@property (nonatomic, strong) NSString *sleepValue;
@property (nonatomic, strong) NSString *qualityValue;
@property (nonatomic, strong) NSString *dipPercentage;
@property (nonatomic, strong) NSString *deepValue;

+ (void)storeGoalValues:(goalValues *)values;
+ (void)storeSleepValue:(NSString *)sleepValue;
+ (void)storeQualityValue:(NSString *)qualityValue;
+ (void)storeDipPercentage:(NSString *)dipPercentage;
+ (void)storeDeepValue:(NSString *)deepValue;
+ (goalValues *)retrieveGoalValues;
+(void)setDefaultValue;

@end

NS_ASSUME_NONNULL_END
