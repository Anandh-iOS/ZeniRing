//
//  LTPHud.m
//   
//
//  Created by lanzhongping on 2020/4/17.
//  Copyright © 2020 linktop. All rights reserved.
//

#import "LTPHud.h"
#import "AppDelegate.h"
#import <MBProgressHUD.h>


@interface LTPHud()

@property(strong, nonatomic)MBProgressHUD *mbpHud;
@property(weak, nonatomic) UIView *baseView;
@end

@implementation LTPHud

+ (instancetype)Instance {
    static LTPHud *_hud = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _hud = [[super allocWithZone:NULL] init];
    });
    return _hud;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.baseView = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
        self.mbpHud = [[MBProgressHUD alloc]initWithView:self.baseView];
        self.mbpHud.minShowTime = 1.0f;
        self.mbpHud.removeFromSuperViewOnHide = YES;
        self.mbpHud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        self.mbpHud.label.textColor = [UIColor whiteColor];
        self.mbpHud.userInteractionEnabled = NO;
        [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
//        self.mbpHud.contentColor = [UIColor lightTextColor]; //字体和菊花颜色
        self.mbpHud.bezelView.backgroundColor = ([UIColor colorWithRed:31/255.0f green:32/255.0f blue:36/255.0f alpha:1.0f]);//[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8f]; // 小框颜色
//        self.mbpHud.bezelView.backgroundColor = [UIColor colorWithRed:35/255.0 green:34/255.0 blue:32/255.0 alpha:0.7];
        
    }
    return self;
}

- (void)showHud {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mbpHud hideAnimated:NO];
        self.mbpHud.backgroundView.userInteractionEnabled = YES;
        self.mbpHud.mode = MBProgressHUDModeIndeterminate;
        self.mbpHud.label.text = nil;
        self.mbpHud.offset = CGPointMake(0.f, 0.f);
        [self.baseView addSubview:self.mbpHud];
        [self.mbpHud showAnimated:YES];
    });
    
    
}

- (void)showHudLasting:(CGFloat)time {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mbpHud hideAnimated:NO];
        self.mbpHud.backgroundView.userInteractionEnabled = YES;
        self.mbpHud.mode = MBProgressHUDModeIndeterminate;
        self.mbpHud.label.text = nil;
        [self.baseView addSubview:self.mbpHud];
        self.mbpHud.offset = CGPointMake(0.f, 0.f);
        [self.mbpHud showAnimated:YES];
        [self.mbpHud hideAnimated:YES afterDelay:time];
    });
    
    
}


- (void)showText:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mbpHud hideAnimated:NO];
        self.mbpHud.backgroundView.userInteractionEnabled = NO;
        self.mbpHud.mode = MBProgressHUDModeText;
        self.mbpHud.label.textColor = [UIColor whiteColor];
        self.mbpHud.label.text = text;
        // Move to bottm center.
        self.mbpHud.offset = CGPointMake(0.f, MBProgressMaxOffset / 5);
        [self.baseView addSubview:self.mbpHud];
        [self.mbpHud showAnimated:YES];
        [self.mbpHud hideAnimated:YES afterDelay:3.f];
    });
    
    
}

- (void)showText:(NSString *)text Lasting:(CGFloat)time {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mbpHud hideAnimated:NO];
        self.mbpHud.backgroundView.userInteractionEnabled = NO;
        self.mbpHud.mode = MBProgressHUDModeText;
        self.mbpHud.label.textColor = [UIColor whiteColor];
        self.mbpHud.label.text = text;
        self.mbpHud.offset = CGPointMake(0.f, MBProgressMaxOffset / 5);
        [self.baseView addSubview:self.mbpHud];
        [self.mbpHud showAnimated:YES];
        [self.mbpHud hideAnimated:YES afterDelay:time];
    });
    
}

- (void)showHud:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mbpHud hideAnimated:NO];
        self.mbpHud.backgroundView.userInteractionEnabled = YES;
        self.mbpHud.mode = MBProgressHUDModeIndeterminate;
        self.mbpHud.label.text = text;
        [self.baseView addSubview:self.mbpHud];
        self.mbpHud.offset = CGPointMake(0.f, 0);
        [self.mbpHud showAnimated:YES];
    });
    
}

- (void)showHudLasting:(CGFloat)time Text:(NSString *)text {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mbpHud hideAnimated:NO];
        self.mbpHud.backgroundView.userInteractionEnabled = YES;
        self.mbpHud.mode = MBProgressHUDModeIndeterminate;
        self.mbpHud.label.text = text;
        [self.baseView addSubview:self.mbpHud];
        self.mbpHud.offset = CGPointMake(0.f, 0);
        [self.mbpHud showAnimated:YES];
      
        [self.mbpHud hideAnimated:YES afterDelay:time];
    });
    
    
}


- (void)hideHud {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mbpHud hideAnimated:YES];
//        [self.mbpHud removeFromSuperview];
    });
    
}



@end
