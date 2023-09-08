//
//  SleepStageHeader.h
//  sr01sdkProject
//
//  Created by 兰仲平 on 2022/10/19.
//

#ifndef SleepStageHeader_h
#define SleepStageHeader_h

typedef NS_ENUM(NSUInteger, SleepStagingType) {
    NONE,  // no sleep
    WAKE,  // wake up
    NREM1, // NREM1
    NREM2, // NREM2
    NREM3, // NREM3
    REM,   // REM
    NAP,   // NAP

}; // sleep type staging

#endif /* SleepStageHeader_h */
