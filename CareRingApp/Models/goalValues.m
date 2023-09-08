//
//  goalValues.m
//  CareRingApp
//
//  Created by Anandh Selvam on 02/09/23.
//

#import "goalValues.h"

@implementation goalValues


+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.sleepValue forKey:@"sleepValue"];
    [coder encodeObject:self.qualityValue forKey:@"qualityValue"];
    [coder encodeObject:self.dipPercentage forKey:@"dipPercentage"];
    [coder encodeObject:self.deepValue forKey:@"deepValue"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _sleepValue = [coder decodeObjectForKey:@"sleepValue"];
        _qualityValue = [coder decodeObjectForKey:@"qualityValue"];
        _dipPercentage = [coder decodeObjectForKey:@"dipPercentage"];
        _deepValue = [coder decodeObjectForKey:@"deepValue"];
    }
    return self;
}

+ (void)storeGoalValues:(goalValues *)values {
    NSError *error = nil;
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:values
                                             requiringSecureCoding:YES
                                                             error:&error];
    if (error) {
        NSLog(@"Error archiving goalValues object: %@", error);
        return;
    }

    [[NSUserDefaults standardUserDefaults] setObject:archivedData forKey:@"goalValues"];
    
    // Also store individual values
    [[NSUserDefaults standardUserDefaults] setObject:values.sleepValue forKey:@"sleepValue"];
    [[NSUserDefaults standardUserDefaults] setObject:values.qualityValue forKey:@"qualityValue"];
    [[NSUserDefaults standardUserDefaults] setObject:values.dipPercentage forKey:@"dipPercentage"];
    [[NSUserDefaults standardUserDefaults] setObject:values.deepValue forKey:@"deepValue"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)storeSleepValue:(NSString *)sleepValue {
    
    // Retrieve the existing goalValues object (if any)
    goalValues *values = [self retrieveGoalValues];
    
    // Update the sleepValue in the goalValues object
    values.sleepValue = sleepValue;
    
    // Store the updated goalValues object
    [self storeGoalValues:values];
}

+ (void)storeQualityValue:(NSString *)qualityValue {

    // Retrieve the existing goalValues object (if any)
    goalValues *values = [self retrieveGoalValues];
    
    // Update the qualityValue in the goalValues object
    values.qualityValue = qualityValue;
    
    // Store the updated goalValues object
    [self storeGoalValues:values];
}

+ (void)storeDipPercentage:(NSString *)dipPercentage {
    
    // Retrieve the existing goalValues object (if any)
    goalValues *values = [self retrieveGoalValues];
    
    // Update the dipPercentage in the goalValues object
    values.dipPercentage = dipPercentage;
    
    // Store the updated goalValues object
    [self storeGoalValues:values];
}

+ (void)storeDeepValue:(NSString *)deepValue {
    
    // Retrieve the existing goalValues object (if any)
    goalValues *values = [self retrieveGoalValues];
    
    // Update the deepValue in the goalValues object
    values.deepValue = deepValue;
    
    // Store the updated goalValues object
    [self storeGoalValues:values];
}

+ (goalValues *)retrieveGoalValues {
    // Retrieve and unarchive the goalValues object from UserDefaults
    NSData *archivedData = [[NSUserDefaults standardUserDefaults] objectForKey:@"goalValues"];
    
    NSError *error = nil;
    goalValues *values = [NSKeyedUnarchiver unarchivedObjectOfClass:[goalValues class]
                                                           fromData:archivedData
                                                              error:&error];
    
    if (error) {
        NSLog(@"Error unarchiving goalValues object: %@", error);
        return nil;
    }
    
    if (!values) {
        // If the goalValues object doesn't exist, create a new one
        values = [[goalValues alloc] init];
    }
    
    return values;
}

+(void)setDefaultValue{
    
    goalValues *vale = [[goalValues alloc] init];
    vale.sleepValue = @"8h 0m";
    vale.qualityValue = @"6h 0m";
    vale.dipPercentage = @"10 - 15%";
    vale.deepValue = @"8h 0m";
    [self storeGoalValues:vale];
}


@end
