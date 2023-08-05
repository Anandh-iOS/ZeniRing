//
//  BarDrawView.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/15.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

typedef NS_ENUM(NSUInteger, Y_VALUE_FORMAT) {
    Y_VALUE_FORMAT_HR,
    Y_VALUE_FORMAT_HRV,
    Y_VALUE_FORMAT_THERMEMOTER,
};

NS_ASSUME_NONNULL_BEGIN

@class BarDrawObj;

@interface BarDrawView : UIView

@property(strong, nonatomic)NSMutableArray<NSNumber *> *xCoordinates;// 横坐标,纵坐标的数值
@property(strong, nonatomic)NSArray<NSNumber *> *yCoordinates;
@property(strong, nonatomic)UIView *drawView;// 画图区域, 横坐标标签, 纵坐标标签

@property(strong, nonatomic)NSNumber *allMaxValue, *allMixValue;
@property(strong, nonatomic)NSMutableArray <BarDrawObj *> *drawObjArray;
@property(assign, nonatomic)Y_VALUE_FORMAT formatType;

-(void)startDraw;
-(void)createLabels;

@end


@interface BarDrawObj : NSObject

@property(strong, nonatomic)NSNumber *minValue, *maxValue, *avgValue;
@property(assign, nonatomic)int hour;
@property(strong, nonatomic)NSMutableArray<NSNumber *> * valueArrayOfHour;

-(void)sortValueAsc:(BOOL)isAsc;

@end


NS_ASSUME_NONNULL_END
