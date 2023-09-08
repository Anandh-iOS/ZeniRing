//
//  ReadinessHeaderView.m
//  CareRingApp
//
//  Created by Anandh Selvam on 21/08/23.
//

#import "ReadinessHeaderView.h"
#import "Colors.h"
#import "MASConstraintMaker.h"
#import <Masonry/Masonry.h>


@implementation ReadinessHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Create a circular subview
        
        
        UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
        circleView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.15];
        circleView.layer.cornerRadius = circleView.frame.size.width / 2;
        circleView.clipsToBounds = YES;
        circleView.center = self.center;
        
        // Create and customize the title label
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, circleView.frame.size.width-50, 80)];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.font = [UIFont fontWithName:FONT_ARIAL_REGULAR size:15];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor whiteColor];
//
        // Create an attributed string for the info label
        
        
        // Create and configure the info label with the attributed text
        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, circleView.frame.size.width-50, 80)];
//        // Add labels to the circular subview
        [circleView addSubview:self.titleLabel];
        [circleView addSubview:self.infoLabel];
//
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(circleView.mas_centerX);
            make.top.equalTo(circleView.mas_top).offset(30);
            make.width.equalTo(@100);
            
        }];
        
        [self.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(circleView.mas_centerX);
            make.top.equalTo(circleView.mas_top).offset(70);
            make.width.equalTo(@100);
            
        }];
        
        
        
        [self addSubview:circleView];
    }
    return self;
}

-(void)setScoreTitle:(NSString *)title :(NSString *)score
{
    self.titleLabel.text = title;
    
    NSString *infoText = [NSString stringWithFormat:@"%@ Good",score];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:infoText];
    
    // Customize the appearance of "75" (big and bold)
    [attributedText addAttributes:@{ NSFontAttributeName: [UIFont fontWithName:FONT_ARIAL_BOLD size:40], NSForegroundColorAttributeName: [UIColor blackColor] } range:NSMakeRange(0, 2)];
    
    // Customize the appearance of "Good" (half the size)
    [attributedText addAttributes:@{ NSFontAttributeName: [UIFont fontWithName:FONT_ARIAL_BOLD size:15], NSForegroundColorAttributeName: [UIColor blackColor] } range:NSMakeRange(3, infoText.length - 3)];
    
    [attributedText addAttribute:NSForegroundColorAttributeName value:HEALTH_COLOR_WELL range:NSMakeRange(0, [attributedText length])];
    
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    self.infoLabel.attributedText = attributedText;
}


@end
