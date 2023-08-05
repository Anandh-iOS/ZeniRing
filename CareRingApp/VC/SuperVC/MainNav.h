//
//  MainNav.h
//   
//
//  Created by 兰仲平 on 2021/4/20.
//  Copyright © 2021 linktop. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainNav : UINavigationController
-(instancetype)initWithRootViewController:(UIViewController *)rootViewController ShowNavBar:(BOOL)show;

@end

NS_ASSUME_NONNULL_END
