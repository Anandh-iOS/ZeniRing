//
//  SleepDrawLineView.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/21.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import <QMUIKit/QMUIKit.h>
#import "ReadyDrawObj.h"
NS_ASSUME_NONNULL_BEGIN

@interface SleepDrawLineView : UIView
@property(strong, nonatomic)UIView *leftLblArea, *rightLblArea, *xLblArea;
@property(strong, nonatomic)UIView *drawArea;

@property(weak, nonatomic)ReadyDrawObj *drawObj;



-(void)startDraw;
@end

NS_ASSUME_NONNULL_END
