//
//  OTAVc.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/8/30.
//

#import "NAVTemplateViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTAVc : NAVTemplateViewController

@property(strong, nonatomic)NSURL * updateImageFileUrl;

@property(copy, nonatomic)void (^ _Nullable otaFinishBLK)(BOOL isSucc);

@end

NS_ASSUME_NONNULL_END
