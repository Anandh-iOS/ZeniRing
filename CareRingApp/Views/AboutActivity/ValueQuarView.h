//
//  ValueQuarView.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/13.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import <QMUIKit/QMUIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ValueQuarView : UIView

@property(strong, nonatomic, readonly)UILabel *titleLbl, *valueLbl;

-(void)updateValueInt:(NSNumber * _Nullable)value Unit:(NSString *)unit;
-(void)updateValueFloat:(NSNumber * _Nullable)value Unit:(NSString *)unit;
-(void)updateText:(NSString *)text;


@end

NS_ASSUME_NONNULL_END
