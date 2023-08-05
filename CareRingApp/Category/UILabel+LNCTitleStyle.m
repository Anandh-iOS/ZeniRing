//
//  UILabel+HrvTitleStyle.m
//   
//
//  Created by lanzhongping on 2020/11/9.
//  Copyright © 2020 linktop. All rights reserved.
//

#import "UILabel+LNCTitleStyle.h"

@implementation UILabel (LNCTitleStyle)

- (void)hrvTitleStyle {
    self.textAlignment = NSTextAlignmentRight; //右对齐
    self.font = [UIFont systemFontOfSize:17.0f];
    self.textColor = [UIColor darkTextColor];
    
    
}

- (void)hrvValueStyle {
    self.textAlignment = NSTextAlignmentLeft; //左对齐
    self.font = [UIFont systemFontOfSize:16.0f];
    self.textColor = [UIColor lightGrayColor];
    
    
}

- (void)hrvHisStyle {
    self.textAlignment = NSTextAlignmentLeft; //左对齐
    self.font = [UIFont systemFontOfSize:16.0f];
    self.textColor = [UIColor whiteColor];
    
    
}

-(void)userNavTitleFont:(NSNumber * _Nullable)fontSize
{
    CGFloat size = 19.0f;
    if (fontSize != nil) {
        size = fontSize.floatValue;
    }
    self.font = [UIFont fontWithName:NAVTITLEFONT_NAME size:size];
    [self setTextColor:[UIColor colorWithRed:254.0f/255.0f green:254.0f/255.0f blue:254.0f/255.0f alpha:1.0f]];
}

-(void)measureValueStyle {
    
    self.textColor = [UIColor darkGrayColor];
    self.font = [UIFont fontWithName:MAINBTNFONT_NAME size:19.0f];
}

- (void)figureTitleStyle
{
    self.textAlignment = NSTextAlignmentLeft;
//    [self sizeToFit];
    self.textColor = [UIColor lightGrayColor];
    self.font = [UIFont systemFontOfSize:14.0f];
    
}


@end
