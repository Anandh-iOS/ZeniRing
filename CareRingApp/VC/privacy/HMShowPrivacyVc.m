//
//  LNCShowPrivacyVc.m
//   
//
//  Created by lanzhongping on 2020/11/9.
//  Copyright © 2020 linktop. All rights reserved.
//

#import "HMShowPrivacyVc.h"
#import "ConfigModel.h"
#import <Masonry/Masonry.h>
//#import <WebKit/WebKit.h>
#import <WebKit/WKWebView.h>

@interface HMShowPrivacyVc ()
@property(weak, nonatomic)WKWebView *webView;
@end

@implementation HMShowPrivacyVc

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *title = self.isPrivacy ? _L(L_PROTOCAL_PRIVACY) : _L(L_TITLE_USER_AGREEMENT) ;
    
    //    self.navigationItem.title = title;
    //    self.navigationItem.backButtonTitle = @"<";
    self.navigationItem.title = title;
    WEAK_SELF
    [self arrowback:^{
        STRONG_SELF
        if (strongSelf.isPresentToShow) {
            
            //            NSLog(@"strongSelf.navigationController = %@", strongSelf.navigationController);
            [strongSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }
    }];;
    
    
    //    WEAK_SELF
    //    [self customNavStyleNormal:title BackBlk:^{
    //        STRONG_SELF
    //        if (strongSelf.isPresentToShow) {
    //
    ////            NSLog(@"strongSelf.navigationController = %@", strongSelf.navigationController);
    //            [strongSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
    //        } else {
    //            [strongSelf.navigationController popViewControllerAnimated:YES];
    //        }
    //    }];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showRules];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isPresentToShow == NO) {
        self.navigationController.navigationBar.translucent = NO;
        [self.navigationController.navigationBar setShadowImage:nil];
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    if (self.isPresentToShow == NO) {
        self.navigationController.navigationBar.translucent = YES;
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)showRules {
    WKWebView *webView = [WKWebView new];
    [self.view addSubview:webView];
    self.webView = webView;
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        
    }];
    
    //    NSString *fileName = nil;
    
    // hc03
    NSURL *url = nil;
    if (self.isPrivacy) {
        url = [NSURL URLWithString:@"https://www.nexkoo.com/nexring-privacy-policy"]; // 隐私
    } else {
        url = [NSURL URLWithString:@"https://www.nexkoo.com/terms-of-use"];// 用户协议
    }
    
    //    NSURL *url = [NSURL URLWithString:@"https://www.nexkoo.com/nexring-privacy-policy"];
    if (url) {
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
    
    //    if (fileName != nil) {
    //        NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"pdf"];
    //        if (filePath) {
    //            NSURL *url = [NSURL fileURLWithPath:filePath];
    //            NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //            [self.webView loadRequest:request];
    //        }
    //
    //    }
    
    
    
}
-(void)dealloc
{
    
}



@end
