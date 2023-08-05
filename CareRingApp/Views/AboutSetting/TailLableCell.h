//
//  TailLableCell.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/7/27.
//  尾部有uilabel的cell

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@interface TailLableCell : UITableViewCell
@property(strong, nonatomic, readonly)UILabel *tailLbl;
@end

NS_ASSUME_NONNULL_END
