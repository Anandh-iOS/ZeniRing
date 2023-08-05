//
//  ReadyDrawObj.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/22.
//  就绪和画图的控制模型

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ReadyDrawObjType) {
    ReadyDrawObjType_heareRate,
    ReadyDrawObjType_hrv,
    ReadyDrawObjType_TEMPERATURE,
};

NS_ASSUME_NONNULL_BEGIN

@interface ReadyDrawObj : NSObject
@property(assign, nonatomic)ReadyDrawObjType readyDrawObjType;
@property(strong, nonatomic, nullable)NSNumber *maxValue, *minValue, *avgValue;
@property(strong, nonatomic, nullable)NSNumber *maxIndex, *minIndex;

@property(strong, nonatomic, nullable)NSMutableArray<NSDictionary * > *valuesArray;//字典 @"value" @"time"

//@property(copy, nonatomic) void (^readyDrawDataBlk)(NSMutableArray<NSDictionary *> * _Nullable objArray);

- (instancetype)initWithType:(ReadyDrawObjType)type;

//-(void)startDraw;
//-(void)createTestData; // 测试使用

-(void)queryHeartRateData:(NSDate *)begin End:(NSDate *)end;
-(void)queryHRVData:(NSDate *)begin End:(NSDate *)end;

-(void)queryTemperatureFluData:(NSDate *)begin End:(NSDate *)end; //体温查询

-(void)clean;

@end

NS_ASSUME_NONNULL_END
