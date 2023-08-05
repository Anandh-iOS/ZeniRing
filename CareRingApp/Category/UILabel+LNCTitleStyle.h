//
//  UILabel+HrvTitleStyle.h
//   
//
//  Created by lanzhongping on 2020/11/9.
//  Copyright © 2020 linktop. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define MAINBTNFONT_NAME @"Arial-BoldMT"  //按钮字体
#define NAVTITLEFONT_NAME @"ArialMT"
@interface UILabel (LNCTitleStyle)
 
- (void)hrvTitleStyle;
- (void)hrvValueStyle;
-(void)userNavTitleFont:(NSNumber * _Nullable)fontSize;
-(void)measureValueStyle;  //测量结果样式
- (void)figureTitleStyle;
- (void)hrvHisStyle;
@end

NS_ASSUME_NONNULL_END
