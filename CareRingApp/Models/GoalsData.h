//
//  GoalsData.h
//  CareRingApp
//
//  Created by Anandh Selvam on 01/09/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoalsData : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *percentage;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *infoTitle;
@property (nonatomic, strong) NSString *infoSubtitle;
@property (nonatomic, strong) NSString *infoTrendDay;
@property (nonatomic, strong) NSString *infoTrendWeek;
@property (nonatomic, strong) NSString *infoText;

@end

NS_ASSUME_NONNULL_END
