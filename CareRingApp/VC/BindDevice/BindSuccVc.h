//
//  BindSuccVc.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/14.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import <QMUIKit/QMUIKit.h>
#import "ConfigModel.h"
#import "NAVTemplateViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BindSuccVc : NAVTemplateViewController
@property(assign, nonatomic)BOOL isBindeNew; //已存在绑定,替换绑定

@end

NS_ASSUME_NONNULL_END
