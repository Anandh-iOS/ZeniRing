//
//  UIViewController+ForceOrientation.h
//   
//
//  Created by lanzhongping on 2020/4/26.
//  Copyright © 2020 linktop. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
extern NSString * const OTAS_DIR;

@interface UIViewController (Custom)
//- (void)forceOrientationToLand:(UIInterfaceOrientation)orientation;

- (void)showAlertWarningWithTitle:(NSString *)title Msg:(NSString *)msg btnCancel:(NSString *)btnTitle Compelete:(void (^ __nullable)(void))completion;
- (void)showAlertWarningWithTitle:(NSString *)title
                              Msg:(NSString *)msg
                            btnOk:(nullable NSString  *)btnTitle
                            OkBLk:(void (^ __nullable)(void))okBlk
                        CancelBtn:(nullable NSString *)cancelTitle
                        CancelBlk:(void (^ __nullable)(void))cancelBlk
                        Compelete:(void (^ __nullable)(void))completion;

-(void)mainStyle;
- (void)copyFileFromResourceTOSandbox:(NSArray<NSURL *> *)fileUrls;


@end

NS_ASSUME_NONNULL_END
