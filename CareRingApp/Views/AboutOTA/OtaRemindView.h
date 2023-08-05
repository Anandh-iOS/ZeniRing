//
//  OtaRemindView.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/8/30.
//

#import <UIKit/UIKit.h>
#import <QMUIKit/QMUIKit.h>
NS_ASSUME_NONNULL_BEGIN
extern const CGFloat OtaRemindView_HEIGHT;
@interface OtaRemindView : UIView

@property(strong, nonatomic)UILabel *titleLbl, *leftVersionLbl, *rightVersionLbl;
@property(strong, nonatomic)UIImageView *arrowImageView;
@property(strong, nonatomic)QMUIButton *closeBtn, *startBtn;
@property(assign, nonatomic)BOOL shouldHide;

@property(copy, nonatomic)void (^ _Nullable closeBlk)(void);

@property(copy, nonatomic)void (^ _Nullable startBlk)(void);



@end

NS_ASSUME_NONNULL_END
