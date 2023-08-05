//
//  DeviceSetCell.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/28.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
NS_ASSUME_NONNULL_BEGIN

@interface NormalSetCell : UITableViewCell
@property(strong, nonatomic) UILabel *rightLabel;
@property(strong, nonatomic, readonly) UIImageView *arrowImageView;

-(void)addArrow;

@end

NS_ASSUME_NONNULL_END
