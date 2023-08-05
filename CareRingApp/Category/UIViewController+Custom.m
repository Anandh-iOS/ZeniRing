//
//  UIViewController+ForceOrientation.m
//   
//
//  Created by lanzhongping on 2020/4/26.
//  Copyright © 2020 linktop. All rights reserved.
//

#import "UIViewController+Custom.h"
NSString * const OTAS_DIR = @"otas";


@implementation UIViewController (Custom)
//- (void)forceOrientationToLand:(UIInterfaceOrientation)orientation {
//
//        if ([[UIDevice currentDevice] respondsToSelector: @selector(setOrientation:)]) {
//            SEL selector = NSSelectorFromString(@"setOrientation:");
//            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
//            [invocation setSelector:selector];
//            [invocation setTarget:[UIDevice currentDevice]];
//            UIInterfaceOrientation val = orientation;//= UIInterfaceOrientationLandscapeLeft;//横屏
//
//
//            [invocation setArgument:&val atIndex:2];
//            [invocation invoke];
//
//        }
//}

- (void)showAlertWarningWithTitle:(NSString *)title Msg:(NSString *)msg btnCancel:(NSString *)btnTitle Compelete:(void (^ __nullable)(void))completion {

    dispatch_async(dispatch_get_main_queue(), ^{
         UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
           UIAlertAction *sure = [UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleCancel handler:nil];
           [alert addAction:sure];
           [self presentViewController:alert animated:YES completion:completion];
    });
   
}

- (void)showAlertWarningWithTitle:(NSString *)title
                              Msg:(NSString *)msg
                            btnOk:(nullable NSString  *)btnTitle
                            OkBLk:(void (^ __nullable)(void))okBlk
                        CancelBtn:(nullable NSString *)cancelTitle
                        CancelBlk:(void (^ __nullable)(void))cancelBlk
                        Compelete:(void (^ __nullable)(void))completion {

    dispatch_async(dispatch_get_main_queue(), ^{
         UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
        if (cancelTitle) {
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                if (cancelBlk) {
                    cancelBlk();
                }
            }];
            [alert addAction:cancel];
        }
        if (btnTitle) {
            UIAlertAction *ok = [UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (okBlk) {
                    okBlk();
                }
            }];
            [alert addAction:ok];
        }
          
           [self presentViewController:alert animated:YES completion:completion];
    });
   
}

-(void)mainStyle {
    self.view.backgroundColor = UIColor.blackColor;
}

- (void)copyFileFromResourceTOSandbox:(NSArray<NSURL *> *)fileUrls
{
    
    [fileUrls.firstObject startAccessingSecurityScopedResource];
    
    
    NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
    NSError *error;
    
    [fileCoordinator coordinateReadingItemAtURL:fileUrls.firstObject options:0 error:&error byAccessor:^(NSURL *newURL) {
        //
        NSString *fileName = [newURL lastPathComponent];
        NSError *error = nil;
        NSData *fileData = [NSData dataWithContentsOfURL:newURL options:NSDataReadingMappedIfSafe error:&error];
        
        if (error) {
            // 读取出错
        } else {
            // 上传
            DebugNSLog(@"fileName : %@", fileName);
            NSString * appDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *directryPath = [appDir stringByAppendingPathComponent:OTAS_DIR];
            NSError *fileError;
            BOOL isCreate = [[NSFileManager defaultManager] createDirectoryAtPath:directryPath withIntermediateDirectories:YES attributes:nil error:&fileError];
            if (fileError) {
                DebugNSLog(@"%@", fileError);
            }
            
            
            NSString *path = [directryPath stringByAppendingPathComponent:fileName];
            [[NSFileManager defaultManager] copyItemAtURL:fileUrls.firstObject toURL:[NSURL fileURLWithPath:path] error:&fileError];
            if (fileError) {
                DebugNSLog(@"copy %@", fileError);
            }
            
        }
    }];
    [fileUrls.firstObject stopAccessingSecurityScopedResource];
    
    
}

@end
