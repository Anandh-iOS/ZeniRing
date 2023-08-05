//
//  SleepTimeCell.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/24.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "NapSleepTimeDrawView.h"
//#import "SleepTimeDrawObj.h"
#import "SleepStageHeader.h"
#import "TextInfoView.h"


@class DBSleepData;

NS_ASSUME_NONNULL_BEGIN

@interface NapSleepTimeCell : UITableViewCell

@property(strong, nonatomic)TextInfoView *infoView;

@property(strong, nonatomic)NapSleepTimeDrawView *napDrawView;
@property(strong, nonatomic, nullable)NSMutableArray<DBSleepData *> *sleepDataArray;

-(void)startDraw;
-(void)drawNone;

@end

NS_ASSUME_NONNULL_END
