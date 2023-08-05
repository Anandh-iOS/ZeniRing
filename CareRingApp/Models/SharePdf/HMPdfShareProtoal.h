//
//  HMPdfShareProtoal.h
//   
//
//  Created by 兰仲平 on 2021/11/10.
//  Copyright © 2021 linktop. All rights reserved.
//

#ifndef HMPdfShareProtoal_h
#define HMPdfShareProtoal_h

#import "NSDate+HMTools.h"

@protocol HMPdfShareProtoal <NSObject>

@required

/// 分享的文字
/// @param index 数组索引
-(NSArray<NSString *> *)pdfShowValuerStrings:(NSInteger)index;

@end

#endif /* HMPdfShareProtoal_h */
