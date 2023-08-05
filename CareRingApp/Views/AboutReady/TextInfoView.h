//
//  TextInfoView.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/7/29.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import <QMUIKit/QMUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TextInfoView : UIView

@property(strong, nonatomic)UILabel *titleLabel, *subLabelA, *subLabelB;
@property(strong, nonatomic)QMUIButton *arrowBtn;
@property(copy, nonatomic)void (^ _Nullable arrowClickCbk)(void);

-(void)setTextAndBarColor:(UIColor *)textColor;
-(void)setBarColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
