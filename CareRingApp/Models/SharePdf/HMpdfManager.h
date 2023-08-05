//
//  HMpdfManager.h
//   
//
//  Created by 兰仲平 on 2021/11/9.
//  Copyright © 2021 linktop. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "HMPdfShareProtoal.h"



NS_ASSUME_NONNULL_BEGIN
@class MeasureUser;

typedef NS_ENUM(NSUInteger, DETAIL_HIS_TYPE) {
//    DETAIL_HIS_BLOOD_PRESSURE = 1, // 血压
    DETAIL_HIS_HEARTRATE = 2, // 心率
    DETAIL_HIS_THER = 3, // 体温
//    DETAIL_HIS_OXY = 4, // 血样
//    DETAIL_HIS_ECG = 5, // ecg
//    DETAIL_HIS_GLUCOSE, //血糖
};


@interface HMpdfManager : NSObject

//-(void)setHorizonalSpeed:(HORIZONTAL_SPEED)speedType VertialGain:(VERTIAL_GAIN)vGain;



//-(NSString *)getFloaderPath;
- (UIImage *)makeImageWithView:(UIView *)view withSize:(CGSize)size;

//-(UIView *)createPdfHead:(NSString *)name Birthday:(NSDate *)birthDate SourceText:(NSString *)sourceString;
-(UIView *)createTableTitles:(NSArray<NSString *> *)titles Size:(CGRect)frame;

/// 创建分享
/// @param type 测量类型
/// @param objArray 测量数据
/// @param user 用户
/// @param cmpBlk 完成
-(void)createSharePdf:(DETAIL_HIS_TYPE)type ObjArray:(NSArray <HMPdfShareProtoal> *)objArray  User:(id )user Cmp:(void(^)(NSURL *pdfUrl))cmpBlk;

///// 直接在pdf画图
///// @param ecgModel
///// @param pointArray
///// @param user
///// @param cmpBlk
//-(void)createEcgSharePdfDrawInPdf:(ECGModel *)ecgModel
//                           Points:(NSArray<NSNumber *> *)pointArray
//                             User:(MeasureUser *)user
//                              Cmp:(void(^)(NSURL *pdfUrl))cmpBlk;
@end

NS_ASSUME_NONNULL_END
