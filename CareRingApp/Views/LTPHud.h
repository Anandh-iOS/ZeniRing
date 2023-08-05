//
//  LTPHud.h
//   
//
//  Created by lanzhongping on 2020/4/17.
//  Copyright © 2020 linktop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define HUD_TEXT_SHORT (1.5f)
#define HUD_TEXT_LONG  (3.0f)

NS_ASSUME_NONNULL_BEGIN

@interface LTPHud : NSObject
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (id)copy NS_UNAVAILABLE;
- (id)mutableCopy NS_UNAVAILABLE;

/* public */
+ (instancetype)Instance;
- (void)hideHud;
// toast
- (void)showText:(NSString *)text;
// toast
- (void)showText:(NSString *)text Lasting:(CGFloat)time;

- (void)showHud ;
- (void)showHudLasting:(CGFloat)time;

- (void)showHud:(NSString *)text;
- (void)showHudLasting:(CGFloat)time Text:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
