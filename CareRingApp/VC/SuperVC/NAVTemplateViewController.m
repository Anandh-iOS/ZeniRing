//
//  NAVTemplateViewController.m
//   
//
//  Created by 兰仲平 on 2021/4/15.
//  Copyright © 2021 linktop. All rights reserved.
//

#import "NAVTemplateViewController.h"
#import "ConfigModel.h"
#import "UILabel+LNCTitleStyle.h"
#import <QMUIKit/QMUIKit.h>

@interface NAVTemplateViewController ()

@property(copy, nonatomic)void(^backBlk)(void);

@end

@implementation NAVTemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    
    
}

#pragma mark -- navbar style

-(void)arrowback:(void(^ __nullable)(void))backBlk
{
    
    UIImage *image = [UIImage imageNamed:@"back_white"];
    QMUIButton *backBtn = [[QMUIButton alloc]init];
    [backBtn setImage:image forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 0, 50, 44);
    [backBtn setTitle:@"       " forState:UIControlStateNormal];
    backBtn.imagePosition = QMUIButtonImagePositionLeft;
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    self.backBlk = backBlk;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];;

    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)cleanLeftBarButon
{
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)] ];;

    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)customNavStyleNormal:(NSString *)centerTitle BackBlk:( void(^ __nullable)(void))backBlk
{
    //navbar 背景

    UINavigationBar *navBar = self.navigationController.navigationBar;
    if (!navBar) {
        return;
    }
    navBar.tintColor = [UIColor whiteColor];
//    self.title = centerTitle;
//    [self gradientBackGround]; //渐变色背景
    //title
    UILabel  *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 44)];
    titleLabel.font = [UIFont fontWithName:@"ArialMT" size:19.0f];
    [titleLabel setTextColor:[UIColor whiteColor]];
    titleLabel.text = centerTitle;
    titleLabel.textAlignment = NSTextAlignmentCenter;

    
    self.navigationItem.titleView = titleLabel;
    
    //左按钮
    CGFloat bt_w = 50.0f;
    UIButton  * leftCustomBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 60, bt_w, 44)];
    [leftCustomBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftCustomBtn];
    if (backBlk != nil) {
        UIImage *btnArrowImg = [UIImage imageNamed:@"back_white"];
        [leftCustomBtn setImage:btnArrowImg forState:UIControlStateNormal];
        CGFloat imageV_w = btnArrowImg.size.width;
        leftCustomBtn.imageEdgeInsets = UIEdgeInsetsMake(0, imageV_w - bt_w, 0, 0);
    }

    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.backBlk = backBlk;
    
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)customNavBarView:(NSString *)leftBtnTitle
{
    
    //navbar 背景
    UINavigationBar *navBar = self.navigationController.navigationBar;
    if (!navBar) {
        return;
    }
//    navBar.tintColor = [UIColor whiteColor];
    
//    [self gradientBackGround]; //渐变色背景
    
    //左按钮
    /*
     UIButton  * leftCustomBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 60, 100, 44)];
     [leftCustomBtn useNavTitleFont];
     [leftCustomBtn setTitle:leftBtnTitle forState:UIControlStateNormal];
     leftCustomBtn.enabled = NO;
     UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftCustomBtn];

     self.navigationItem.leftBarButtonItem = leftItem;
     */

    UILabel  * leftCustomLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 100, 44)];
    leftCustomLbl.text = leftBtnTitle;
    leftCustomLbl.textAlignment = NSTextAlignmentLeft;
    [leftCustomLbl userNavTitleFont:nil];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftCustomLbl];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    
}

#pragma mark --navbar按键响应
- (void)backBtn:(id)sender {
    if (self.backBlk) {
        self.backBlk();
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


//- (void)gradientBackGround {
//    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBar.barTintColor = MAIN_BG_COLOR;
//
//    if (@available(iOS 15.0, *)) {
//        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
//        [appearance configureWithOpaqueBackground];
//        appearance.backgroundColor = MAIN_BG_COLOR;
//        self.navigationController.navigationBar.standardAppearance = appearance;
//        self.navigationController.navigationBar.scrollEdgeAppearance = self.navigationController.navigationBar.standardAppearance;
//    }
//
//
////    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
//}


@end
