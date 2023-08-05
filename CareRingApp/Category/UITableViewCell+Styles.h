//
//  UITableViewCell+Styles.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/7/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (Styles)

-(void)addTopBottomCornerRadius:(UIColor *)bgColor IndexPath:(NSIndexPath *)indexPath TableView:(UITableView *)tableView CornerRadius:(CGFloat)cornerRadius;

@end

NS_ASSUME_NONNULL_END
