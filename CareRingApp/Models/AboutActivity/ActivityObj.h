//
//  ActivityObj.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/16.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BarDrawObj;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ACTIVITYOBJ_TYPE) {
    ACTIVITYOBJ_TYPE_HR,    // 心率
    ACTIVITYOBJ_TYPE_HRV,   // hrv
    ACTIVITYOBJ_TYPE_TEMP, // 体温
};

@interface ActivityObj : NSObject

@property(assign, nonatomic)ACTIVITYOBJ_TYPE type;

@property(strong, nonatomic)NSNumber *allMaxValue, *allMinVaue;
@property(strong, nonatomic)NSMutableArray<BarDrawObj *> *cacheObjArray; //缓存数据


@property(copy, nonatomic) void (^readyDrawDataBlk)(NSMutableArray<BarDrawObj *> * _Nullable objArray, NSNumber * _Nullable allMax, NSNumber * _Nullable allMin);

@property(strong, nonatomic, nullable) NSNumber *averageInDate;
@property(strong, nonatomic, nullable) NSNumber *maxTimeInDate;

@property(copy, nonatomic) void (^showValueBlk)(NSNumber * _Nullable averageInDate, NSNumber *maxTimeInDate); // 显示数值使用



-(void)queryData:(NSDate *)date Macaddress:(NSString *)macAddress; // 查询,绘图驱动


-(NSString *)titleString;
-(UIImage *)typeImage;
-(NSString *)unitString;

// 柱状图纵坐标
-(NSMutableArray<NSNumber *> *)barDrawVerticalCoordinate;
-(NSMutableArray<NSNumber * > *)calcRealVerticalCoordinate:(NSNumber *)max Min:(NSNumber *)min;

@end

NS_ASSUME_NONNULL_END
