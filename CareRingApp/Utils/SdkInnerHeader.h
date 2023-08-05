//
//  SdkInnerHeader.h
//  CareRingApp
//
//  Created by 兰仲平 on 2023/3/17.
//

#ifndef SdkInnerHeader_h
#define SdkInnerHeader_h


#define SDK_WEAK_SELF  __weak typeof(self) weakSelf = self;
#define SDK_STRONG_SELF  __strong typeof(weakSelf) strongSelf = weakSelf; \
                     if (!strongSelf) return; \

#define SDK_STRONG_SELF_NOT_CHECK  __strong typeof(weakSelf) strongSelf = weakSelf;

#endif /* SdkInnerHeader_h */
