//
//  TrendHeader.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/10/13.
//

#ifndef TrendHeader_h
#define TrendHeader_h

typedef NS_ENUM(NSUInteger, TREDNVC_TYPE) {
    TREDNVC_NONE = 0,
    TREDNVC_IMMERSE = 1,        // 沉浸
    TREDNVC_HRV,
    TREDNVC_SLEEP_DURATION ,    // 睡眠时长
    TREDNVC_QUALITY_SLEEP,      //优质睡眠
    TREDNVC_DEEP_SLEEP ,        //深度睡眠
    TREDNVC_OXYGEN ,            // 血氧
    TREDNVC_BREATH_RATE ,       // 呼吸率
};


// 时间类型
typedef NS_ENUM(NSUInteger, TrendDrawTIME_TYPE) {
    TrendDrawTIME_TYPE_DAY_PREPAGE = 1, // 每页一天
    TrendDrawTIME_TYPE_EVERY_WEEK_PREPAGE, // 每周为一页
    TrendDrawTIME_TYPE_SEVERIAL_WEEK_PREPAGE, // 几周一页
    TrendDrawTIME_TYPE_12_MONTH_PERPAGE, // 一页 12个月
};
#endif /* TrendHeader_h */
