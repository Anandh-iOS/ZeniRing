//
//  SRDeviceInfo+description.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/7/26.
//

#import "SRDeviceInfo.h"

NS_ASSUME_NONNULL_BEGIN


@interface SRDeviceInfo (description)

+(NSString *)colorDesc:(DEV_COLOR)color;
+(NSString *)sizeDesc:(int)size;

@end

NS_ASSUME_NONNULL_END
