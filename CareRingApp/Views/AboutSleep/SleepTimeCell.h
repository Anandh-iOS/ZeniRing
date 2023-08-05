//
//  SleepTimeCell.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/24.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "SleepTimeDrawView.h"
//#import "SleepTimeDrawObj.h"
#import "SleepStageHeader.h"
#import "TextInfoView.h"
#import "StagingDataV2.h"


NS_ASSUME_NONNULL_BEGIN

@interface SleepTimeCell : UITableViewCell
//@property(strong, nonatomic)UILabel *mainLabel, *subTitlA, *subTitlB;

@property(strong, nonatomic)TextInfoView *infoView;
//@property(strong, nonatomic)UIImageView *arrowImage;
//@property(weak, nonatomic)UIView *drawArea;
@property(strong, nonatomic)SleepTimeDrawView *drawView;
@property(strong, nonatomic, nullable)StagingDataV2 *sleepData;
//@property(strong, nonatomic)SleepTimeDrawObj *drawObj;

-(void)startDraw;
-(void)drawNone;

@end

NS_ASSUME_NONNULL_END
