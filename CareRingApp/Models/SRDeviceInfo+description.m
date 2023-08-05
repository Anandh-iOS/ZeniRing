//
//  SRDeviceInfo+description.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/7/26.
//

#import "SRDeviceInfo+description.h"
#import "ConfigModel.h"

@implementation SRDeviceInfo (description)

+(NSString *)colorDesc:(DEV_COLOR)color;
{
   
    switch (color) {
        case DEV_COLOR_SILVER:
        {
            return _L(L_DEV_COLOR_SILVER);
        }
            break;
        case DEV_COLOR_DARK:
        {
            return _L(L_DEV_COLOR_BLACK);

        }
            break;
        case DEV_COLOR_GOLD:
        {
            return _L(L_DEV_COLOR_GOLD);

        }
            break;
        case DEV_COLOR_ROSE_GOLD:
        {
            return _L(L_DEV_COLOR_ROSE_GOLD);
        }
            break;
        default:
            return @"unknow";
            break;
    }
    return @"unknow";
}


+(NSString *)sizeDesc:(int)size
{
    return [NSString stringWithFormat:@"%@%d", _L(L_DEV_SIZE_US), size];
}



@end
