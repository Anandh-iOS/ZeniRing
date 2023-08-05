//
//  OTAHelper.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/9/7.
//

#import <Foundation/Foundation.h>
#import "OTAHeader.h"
#import "OTAImgObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTAHelper : NSObject
+(OTAHelper *) Instance;
@property(strong, nonatomic)OTAImgObj *imgObj;

-(void)otaQueryUpgrade:(NSString *)host Port:(NSString *)port Version:(NSString *)ver Cat:(NSString *)cat Pid:(NSString *)pid CBK:(void(^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error, NSDictionary* _Nullable resultDict))cbk;


- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
