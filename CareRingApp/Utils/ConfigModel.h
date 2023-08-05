//
//  ConfigModel.h
//  CareRingApp
//
//  Created by 兰仲平 on 2022/6/1.
//

#import <Foundation/Foundation.h>
#import "LocalizeTool.h"
#import "LocalizeKeys.h"
#import "HMUserdefaultUtil.h"
#import "Colors.h"
#import "LTPHud.h"
#import "NSObject+Tool.h"

NS_ASSUME_NONNULL_BEGIN

// 贡献的分数等级
typedef NS_ENUM(NSUInteger, CONTRIBUTE_LEVEL) {
    CONTRIBUTE_LEVEL_BEST,
    CONTRIBUTE_LEVEL_GOOD,
    CONTRIBUTE_LEVEL_ATTENTION,
};

//#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
//#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)






// 主vc的横边距
#define VC_ITEM_MARGIN_HOR   (10.0f)

#define ITEM_CORNOR_RADIUS   (13.0f)  // 圆角


#define WEAK_SELF  __weak typeof(self) weakSelf = self;
#define STRONG_SELF  __strong typeof(weakSelf) strongSelf = weakSelf; \
                     if (!strongSelf) return; \

#define STRONG_SELF_NOT_CHECK  __strong typeof(weakSelf) strongSelf = weakSelf;

#define _L(x) [LocalizeTool localizeFromTables:x Tables:@[@"Localizable", @"LocalizableTwo"]]


extern  NSString * const NONE_VALUE;

extern NSUInteger PWD_LENGTH_LOW; // 密码长度下限
extern NSUInteger PWD_LENGTH_HIGH; // 密码长度上限


// colors




#define UD_LOGINACCOUNT @"lastloginname"
#define UD_LOGINSECRET  @"lastloginpswd"
#define UD_COUNTRYCODE @"lastCountryCode"
#define UD_ISDOCTOR @"isDoctor"//是否是医生

#define BT_PID @"pid"
#define BT_AKEY @"akey"
#define BT_DEVINFO @"devinfo"

#define ACCOUNTNAME_PREFIX @""  //@"life_"   //lifestone


#define NO_NEED_VERIFICATION_CODE //注册不需要验证码
#define NewLoginStoryboard @"NewLogin"



#define ISGETHOSTNEW
#ifdef  ISGETHOSTNEW
#define IS_NEW @"1"
#else
#define IS_NEW @"0"
#endif


//#define APPtype @"dev"
#define APPtype @"store"
//#define APPtype @"inhouse"

#define HOSTNAME @"lt-us.cloudapp.net"

#define APPKEY   @"902feebe2bd04ba69a8bb1b87fdf95cc"    //life
#define SECRET   @"972caa9127c74f8b825a23e1201f3e9c"


#define INNEST
#ifdef INNEST
#define PWD_LOST @"pwd_lost_2"
#else
#define PWD_LOST @"pwd_lost"
#endif

extern const CGFloat LOGIN_TITLE_SIZE;


@interface ConfigModel : NSObject

+(NSString *)appVersion;
+(NSString *)appName;


@end

NS_ASSUME_NONNULL_END
