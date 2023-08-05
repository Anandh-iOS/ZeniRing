//
//  TrendClcViewCell.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/10/13.
//

#import <Masonry/Masonry.h>
#import "TrendClcViewCell.h"

@implementation TrendClcViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIView *test = [UIView new];
        test.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:test];
        [test mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(@40);
            make.height.equalTo(@40);

        }];
    }
    return self;
}




@end
