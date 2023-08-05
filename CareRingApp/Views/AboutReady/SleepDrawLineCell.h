//
//  SleepDrawLineCell.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/21.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import <QMUIKit/QMUIKit.h>
#import "SleepDrawLineView.h"
#import "ReadyDrawObj.h"
NS_ASSUME_NONNULL_BEGIN

@interface SleepDrawLineCell : UITableViewCell

@property(strong, nonatomic)UILabel *mainLabel, *subTitlA, *subTitlB;
@property(strong, nonatomic)UIImageView *arrowImage;
@property(weak, nonatomic)UIView *drawArea;
@property(strong, nonatomic)SleepDrawLineView *drawView;

@property(weak, nonatomic)ReadyDrawObj *drawObj;

@end

NS_ASSUME_NONNULL_END
