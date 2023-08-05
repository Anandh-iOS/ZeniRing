//
//  LNCTabbarController.h
//   
//
//  Created by lanzhongping on 2020/11/4.
//  Copyright © 2020 linktop. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMTabbarController : UITabBarController


-(void)createTabs;

/// 添加VC
/// @param vc 控制器
/// @param title tabbaritem标题
/// @param imgNm tabbaritem普通图片
/// @param selecImgNm tabbaritem选中图片
- (void)addSubControllers:(UIViewController *)vc
                    Title:(NSString * __nullable)title
                ImageName:(NSString *)imgNm
           SelectImagName:(NSString *)selecImgNm;

@property(copy, nonatomic) void (^viewdidAppearBLK)(void);


@end

NS_ASSUME_NONNULL_END
