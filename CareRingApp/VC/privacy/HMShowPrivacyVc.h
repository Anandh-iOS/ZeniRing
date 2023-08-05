//
//  LNCShowPrivacyVc.h
//   
//
//  Created by lanzhongping on 2020/11/9.
//  Copyright © 2020 linktop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NAVTemplateViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface HMShowPrivacyVc : NAVTemplateViewController

@property(assign, nonatomic)BOOL isPresentToShow; //标记是否是模态推出
@property(assign, nonatomic)BOOL isPrivacy; //是否隐私政策

@end

NS_ASSUME_NONNULL_END
