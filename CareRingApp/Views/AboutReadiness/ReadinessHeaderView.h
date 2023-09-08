//
//  ReadinessHeaderView.h
//  CareRingApp
//
//  Created by Anandh Selvam on 21/08/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReadinessHeaderView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *infoLabel;

- (instancetype)initWithFrame:(CGRect)frame;
-(void)setScoreTitle:(NSString *)title :(NSString *)score;

@end

NS_ASSUME_NONNULL_END
