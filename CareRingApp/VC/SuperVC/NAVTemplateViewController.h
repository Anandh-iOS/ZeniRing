//
//  NAVTemplateViewController.h
//   
//
//  Created by 兰仲平 on 2021/4/15.
//  Copyright © 2021 linktop. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NAVTemplateViewController : UIViewController <UIGestureRecognizerDelegate>
@property(strong, nonatomic)NSNumber *didLoad;

-(void)customNavStyleNormal:(NSString * _Nullable)centerTitle BackBlk:( void(^ __nullable)(void))backBlk;
- (void)customNavBarView:(NSString *)leftBtnTitle;
- (void)viewDidLoad;

-(void)arrowback:(void(^ __nullable)(void))backBlk;
-(void)cleanLeftBarButon;

@end

NS_ASSUME_NONNULL_END
