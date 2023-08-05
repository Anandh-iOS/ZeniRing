//
//  TextInfoCell.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/13.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import <QMUIKit/QMUIKit.h>
#import "TextInfoView.h"


NS_ASSUME_NONNULL_BEGIN


@interface TextInfoCell : UITableViewCell
@property(strong, nonatomic)TextInfoView *infoView;

@end



NS_ASSUME_NONNULL_END
