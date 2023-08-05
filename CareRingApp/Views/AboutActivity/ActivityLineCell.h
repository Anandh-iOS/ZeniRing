//
//  ActivityCell.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/13.
//  活动页面上的cell

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import <QMUIKit/QMUIKit.h>
#import "ActivityObj.h"
#import "ReadyDrawObj.h"

@class SleepDrawLineView;

NS_ASSUME_NONNULL_BEGIN

@interface ActivityLineCell : UITableViewCell
@property(strong, nonatomic) UILabel *title;
@property(strong, nonatomic) QMUIButton *arrowBtn;

@property(strong, nonatomic) UIImageView *bottomImage;
@property(strong, nonatomic) UILabel *valuelabel, *UnitLabel;

@property(strong, nonatomic) SleepDrawLineView *drawView;

@property(weak, nonatomic)ReadyDrawObj *activityObj;

@property(copy, nonatomic)void (^arrowClickBLK)(ACTIVITYOBJ_TYPE type);

-(void)createLabels;
-(void)fresh;
@end

NS_ASSUME_NONNULL_END
