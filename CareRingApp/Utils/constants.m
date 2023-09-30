//
//  constants.m
//  CareRingApp
//
//  Created by Anandh Selvam on 22/09/23.
//

#import "constants.h"


@implementation constants

+ (UIColor *) mainBlue { return MAIN_BLUE; }
+ (UIColor *) mainWhite { return MAIN_WHITE; }
+ (UIColor *) navTitleGray { return MAIN_NAV_TITLE_GRAY; }
+ (UIColor *) seplineColor: (float) alpha{return SEPLINE_COLOR(alpha);};
+ (UIColor *) healthColorBest{return HEALTH_COLOR_BEST;};
+ (UIColor *) healthColorWell{return HEALTH_COLOR_WELL;};
+ (UIColor *) healthColorAttection{return HEALTH_COLOR_ATTECTION;};
+ (UIColor *) itemBgColor{return ITEM_BG_COLOR;};
+ (UIColor *) drawBorderColor{return DRAW_BORDER_COLOR;};
+ (UIColor *) sleepReadyTailBGColor{return SLEEP_READY_XLABEL_HEAD_TAIL_BG_COLOR;};
+ (UIColor *) loginSepColor{return LOGIN_TF_SEP_COLOR;};
+ (NSString *) fontArialbold{return FONT_ARIAL_BOLD;};
+ (NSString *) fontArialregular{return FONT_ARIAL_REGULAR;};
+ (NSString *) fontPopinsregular{return FONT_POPIN_REGULAR;};
+ (NSString *) fontPopinssemiBold{return FONT_POPIN_SEMIBOLD;};
+ (NSString *) fontPopinsBold{return FONT_POPIN_BOLD;};

+ (CGFloat) fontNavTitleSize{return  FONT_NAV_TITLE_SIZE;};
+ (CGFloat) fontNavSubTitleSize{return  FONT_NAV_SUB_TITLE_SIZE;};
+ (CGFloat) fontNavHealthCell{return  FONT_NAV_HEALTHCELL;};
+ (CGFloat) fontNavHealthCellSub{return  FONT_NAV_HEALTHCELL_SUB;};
+ (CGFloat) fontHealthCellScore{return  FONT_HEALTHCELL_SCORE;};




// Protocol Constants
+ (NSString *)privacyProtocol { return L_PROTOCAL_PRIVACY;}

+ (NSString *)welcomeProtocol { return L_PROTOCAL_WELCOME;}

+ (NSString *)protocolFormat { return L_PROTOCAL_FORMAT;}

+ (NSString *)disclaimerProtocol { return L_PROTOCAL_DISC;}

+ (NSString *)startBackground { return L_BGSTART;}

+ (NSString *)notAgreePrivacyTips { return L_NOT_AGREE_PRIVY_TIPS;}

+ (NSString *)tabReady { return L_TAB_READY;}

+ (NSString *)tabSleep { return L_TAB_SLEEP;}

+ (NSString *)tabActivity { return L_TAB_ACTIVITY;}

+ (NSString *)tabSetting { return L_TAB_SETTING;}

// Other Constants
+ (NSString *)tips { return L_TIPS;}

+ (NSString *)comma { return L_COMMA;}

+ (NSString *)noMoreRecords { return L_NO_MORE_RECORDS;}

+ (NSString *)tipOpenBLE { return L_TIP_OPEN_BLE;}

+ (NSString *)btnGoSetting { return L_BTN_GO_SETTING;}

+ (NSString *)tipNeedBLEAuth { return L_TIP_NEED_BLE_AUTH;}

// Login and Registration Constants
+ (NSString *)btnAgree { return L_BTN_AGREE;}

+ (NSString *)login { return L_LOGIN;}

+ (NSString *)register { return L_REGISTER;}

+ (NSString *)forgetPassword { return L_FORGET_PWD;}

+ (NSString *)textInputEmail { return L_TXT_INPUT_EMAIL;}

+ (NSString *)textInputPassword { return L_TXT_INPUT_PWD;}

+ (NSString *)textInputAuthCode { return L_TXT_INPUT_AUTHCODE;}

+ (NSString *)btnRegister { return L_BTN_REGISTER;}

+ (NSString *)btnSendAuthCode { return L_BTN_SNED_AUTHCODE;}

+ (NSString *)btnSendResendAuthCode { return L_BTN_SNED_RESEND_AUTHCODE;}

+ (NSString *)btnResetPassword { return L_BTN_RESET_PWD;}

+ (NSString *)tipEmailIllegal { return L_TIP_EMAIL_ILLEGAL;}

+ (NSString *)tipEmailNotRegistered { return L_TIP_EMAIL_NOT_REGIST;}

+ (NSString *)tipAuthCodeSended { return L_TIP_AUTHCODE_SENDED;}

+ (NSString *)tipAccountExist { return L_TIP_ACCOUNT_EXIST;}

+ (NSString *)tipRegisterSuccess { return L_TIP_REGISTER_SUCCESS;}

+ (NSString *)tipAuthCodeIllegal { return L_TIP_AUTHCODE_ILLEGAL;}

+ (NSString *)tipPasswordResetSuccess { return L_TIP_PWD_RESET_SUCC;}

+ (NSString *)tipPasswordResetFail { return L_TIP_PWD_RESET_FAIL;}

+ (NSString *)tipLoginSuccess { return L_TIP_LOGIN_SUCC;}

+ (NSString *)tipLoginFail { return L_TIP_LOGIN_FAIL;}

+ (NSString *)tipLoginAccountOrPasswordError { return L_TIP_LOGIN_ACCOUNT_OR_PWD_ERROR;}

+ (NSString *)tipInternetError { return L_TIP_INTERNET_ERROR;}

+ (NSString *)titleAccount { return L_TITLE_ACCOUNT;}

+ (NSString *)tipLogout { return L_TIP_LOGOUT;}

+ (NSString *)titleRegistAgree { return L_TITLE_REGIST_AGREE;}

+ (NSString *)titleUserAgreement { return L_TITLE_USER_AGREEMENT;}

+ (NSString *)tipPasswordContainIllegal { return L_TIP_PWD_CONTAIN_ELIGAL;}

+ (NSString *)tipPasswordMustBeMoreThan { return L_TIP_PWD_MST_MORE_THAN;}

+ (NSString *)tipPasswordMustBeLessThan { return L_TIP_PWD_MST_LESS_THAN;}

+ (NSString *)titleLogin { return L_TITLE_LOGIN;}

+ (NSString *)titleForgetPassword { return L_TITLE_FORGET_PWD;}

+ (NSString *)titleRegister { return L_TITLE_REGIST;}

// Home Constants
+ (NSString *)quarTitlHR { return L_QUAR_TITL_HR;}

+ (NSString *)quarTitlHRV { return L_QUAR_TITL_HRV;}

+ (NSString *)quarTitlTemp { return L_QUAR_TITL_TEMP;}

+ (NSString *)quarTitlStep { return L_QUAR_TITL_STEP;}

+ (NSString *)quarTitlCalorie { return L_QUAR_TITL_CALORIE;}

+ (NSString *)barDrawTitleHR { return L_BAR_DRAW_TITLE_HR;}

+ (NSString *)barDrawTitleHRV { return L_BAR_DRAW_TITLE_HRV;}

+ (NSString *)barDrawTitleTemp { return L_BAR_DRAW_TITLE_TEMP;}

+ (NSString *)barDrawJustNow { return L_BAR_DRAW_JUST_NOW;}

+ (NSString *)barDrawMinAgo { return L_BAR_DRAW_MIN_AGO;}

+ (NSString *)barDrawHourAgo { return L_BAR_DRAW_HOUR_AGO;}

+ (NSString *)barDrawFormatHourMin { return L_BAR_DRAW_FORMAT_HOUR_MIN;}

+ (NSString *)titleDateYesterday { return L_TITLE_DATE_YESTERDAY;}

+ (NSString *)titleDateInThisYear { return L_TITLE_DATE_IN_THIS_YEAR;}

+ (NSString *)titleDateBeforeThisYear { return L_TITLE_DATE_BEFORE_THIS_YEAR;}

+ (NSString *)dateFormatMeasureList { return L_DATEFORMAT_MEASURE_LIST;}

// Ready State Constants
+ (NSString *)readyState { return L_READY_STATE;}

+ (NSString *)titelReadyStateContribue { return L_TITEL_READYSTATE_CONTRIBUE;}

+ (NSString *)titelReadyDetail { return L_TITEL_READY_DETAIL;}

+ (NSString *)titelHRImmersion { return L_TITEL_HR_IMMERSION;}

+ (NSString *)titelAvgHRInSleep { return L_TITEL_AVG_HR_INSLEEP;}

+ (NSString *)titelSleepDuration { return L_TITEL_SLEEP_DURATION;}

+ (NSString *)titelMinHR { return L_TITEL_MIN_HR;}

+ (NSString *)titelAvgHRV { return L_TITEL_AVG_HRV;}

+ (NSString *)tiemDetailTargetHRImmerse { return L_TIEM_DETAIL_TARGET_HRIMMERSE;}

+ (NSString *)tiemDetailTargetHRV { return L_TIEM_DETAIL_TARGET_HRV;}

+ (NSString *)tiemDetailTargetSleepDuration { return L_TIEM_DETAIL_TARGET_SLEEP_DURATION;}

+ (NSString *)tiemDetailTargetThermometer { return L_TIEM_DETAIL_TARGET_THERMOEMTER;}

// Real-time Data Format Constants
+ (NSString *)tiemDataStrSleepDuration { return L_TIEM_DATA_STR_SLEEP_DURATION;}

+ (NSString *)tiemDataStrSleepDurationReach { return L_TIEM_DATA_STR_SLEEP_DURATION_REACH;}

+ (NSString *)tiemDataStrQualitySleepFinish { return L_TIEM_DATA_STR_QUALITY_SLEEP_FIN;}

+ (NSString *)tiemDataStrQualitySleepNotFinish { return L_TIEM_DATA_STR_QUALITY_SLEEP_NOT_FIN;}

+ (NSString *)tiemDataStrImmerse { return L_TIEM_DATA_STR_IMMERSE;}

+ (NSString *)tiemDataStrDeepSleep { return L_TIEM_DATA_STR_DEEP_SLEEP;}

+ (NSString *)tiemDataStrDeepSleepFin { return L_TIEM_DATA_STR_DEEP_SLEEP_FIN;}

+ (NSString *)tiemDataStrHRVHigher { return L_TIEM_DATA_STR_HRV_HIGHER;}

+ (NSString *)tiemDataStrHRVLower { return L_TIEM_DATA_STR_HRV_LOWER;}

+ (NSString *)tiemDataStrThermometerNormal { return L_TIEM_DATA_STR_THERMOMOTER_NORMAL;}

+ (NSString *)tiemDataStrThermometerAbnormal { return L_TIEM_DATA_STR_THERMOMOTER_AB_NORMAL;}

+ (NSString *)formatSleepAvgHeart { return L_FORMAT_SLEEP_AVG_HEART;}

+ (NSString *)formatSleepMaxHRV { return L_FORMAT_SLEEP_MAX_HRV;}

// Settings Constants
+ (NSString *)setMainTitle { return L_SET_MAIN_TITLE;}

+ (NSString *)setItemTitleMyInfo { return L_SET_ITEM_TITLE_MYINFO;}

+ (NSString *)setItemTitleMyDevice { return L_SET_ITEM_TITLE_MYDEVICE;}

+ (NSString *)setItemTitleTarget { return L_SET_ITEM_TITLE_TARGET;}

+ (NSString *)setItemTitleMySet { return L_SET_ITEM_TITLE_MYSET;}

+ (NSString *)setItemTitleContact { return L_SET_ITEM_TITLE_CONTACT;}

+ (NSString *)setItemTitleUpdateDev { return L_SET_ITEM_TITLE_UPDATE_DEV;}

// Device Constants
+ (NSString *)devModelAndSize { return L_DEV_MODEL_AND_SIZE;}

+ (NSString *)devFirmwareVersion { return L_DEV_FIRMWARE_VER;}

+ (NSString *)devSN { return L_DEV_SN;}

// Device Constants
+ (NSString *)deviceMacAddress {return L_DEV_MAC_ADDRESS;}

+ (NSString *)deviceReboot {return L_DEV_REBOOT;}

+ (NSString *)deviceReset {return L_DEV_RESET;}

+ (NSString *)deviceBindNew {return L_DEV_BINDNEW;}

+ (NSString *)deviceMeasureDuration {return L_DEV_MEASURE_DURA;}

+ (NSString *)deviceMaintain {return L_DEV_MAINTAIN;}

+ (NSString *)deviceCharging {return L_DEV_CHARGING;}

+ (NSString *)deviceIllustrate {return L_DEV_ILLSUSTRATE;}

+ (NSString *)deviceColorSilver {return L_DEV_COLOR_SILVER;}

+ (NSString *)deviceColorBlack {return L_DEV_COLOR_BLACK;}

+ (NSString *)deviceColorGold {return L_DEV_COLOR_GOLD;}

+ (NSString *)deviceColorRoseGold {return L_DEV_COLOR_ROSE_GOLD;}

+ (NSString *)deviceSizeUS {return L_DEV_SIZE_US;}

+ (NSString *)deviceTitleWear {return L_DEV_TITLE_WEAR;}

+ (NSString *)deviceTitleTools {return L_DEV_TITLE_TOOLS;}

+ (NSString *)deviceTitleAirMode {return L_DEV_TITLE_AIR_MODE;}

+ (NSString *)deviceTitleAlreadyConnectRing {return L_DEV_TITLE_ALREADY_CONNECT_RING;}

+ (NSString *)deviceTitleAlreadyDisconnectRing {return L_DEV_TITLE_ALREADY_DISCONNECT_RING;}

+ (NSString *)deviceTitleDevCharging {return L_DEV_TITLE_DEV_CHARGING;}

+ (NSString *)deviceTitleDevChargFull {return L_DEV_TITLE_DEV_CHARG_FULL;}

+ (NSString *)deviceTitleBatteryPower {return L_DEV_TITLE_BATTERY_POWER;}

+ (NSString *)deviceTipsRebootRing {return L_DEV_TIPS_REBOOT_RING;}

+ (NSString *)deviceTipsFactoryResetRing {return L_DEV_TIPS_FACTORY_RESET_RING;}

+ (NSString *)deviceGeneration {return L_DEV_GENERATION;}

// ... (continue with other constants)

// Settings Constants
+ (NSString *)titleUnit {return L_TITLE_UNIT;}

+ (NSString *)titleNotifications {return L_TITLE_NOTI;}

+ (NSString *)titlePrivacy {return L_TITLE_PRIVACY;}

+ (NSString *)titleUseRule {return L_TITLE_USE_RULE;}

+ (NSString *)titleAppSoftwareVersion {return L_TITLE_APP_SOFT_VER;}

+ (NSString *)titleLogout {return L_TITLE_LOGOUT;}

+ (NSString *)textUnitMetric {return L_TXT_UNIT_METRIC;}

+ (NSString *)textUnitImperial {return L_TXT_UNIT_IMPERIAL;}

+ (NSString *)textOn {return L_TXT_ON;}

+ (NSString *)textOff {return L_TXT_OFF;}

+ (NSString *)tipsNoticeSwitch {return L_TIPS_NOTICE_SWITCH;}

+ (NSString *)sure {return L_SURE;}

+ (NSString *)sectionTitleGeneralSettings {return L_SECTION_TIL_GEN_SET;}

+ (NSString *)sectionTitlePrivacy {return L_SECTION_TIL_PRIVACY;}

+ (NSString *)sectionTitleSoftwareInfo {return L_SECTION_TIL_SOFT_INFO;}

+ (NSString *)recordTitleHR {return L_RECORD_TITLE_HR;}

+ (NSString *)recordTitleHRV {return L_RECORD_TITLE_HRV;}

+ (NSString *)recordTitleThermometer {return L_RECORD_TITLE_THERMEMOTER;}

+ (NSString *)readinessTitleHR {return L_READINESS_TITLE_HR;}

+ (NSString *)readinessTitleHRV {return L_READINESS_TITLE_HRV;}

+ (NSString *)readinessTitleThermometer {return L_READINESS_TITLE_THERMEMOTER;}

+ (NSString *)readinessTitleTotalSleep {return L_READINESS_TITLE_TOTALSLEEP;}

+ (NSString *)cancel {return L_CANCEL;}

+ (NSString *)ok {return L_OK;}

+ (NSString *)today {return L_TODAY;}

+ (NSString *)save {return L_SAVE;}

+ (NSString *)txtWaketime { return L_TXT_WAKETIME;}

+ (NSString *)txtLightsleep { return L_TXT_LIGHTSLEEP;}

+ (NSString *)txtDeepsleep { return L_TXT_DEEPSLEEP;}

+ (NSString *)txtRemsleep { return L_TXT_REMSLEEP;}

+ (NSString *)titleSleepEvo { return L_TITLE_SLEEP_EVO;}

+ (NSString *)titleSleepCon { return L_TITLE_SLEEP_CON;}

+ (NSString *)titleSleepDetail { return L_TITLE_SLEEP_DETAIL;}

+ (NSString *)titleHealth { return L_TITLE_HEALTH;}

+ (NSString *)titleQualitySleep { return L_TITLE_QUALITY_SLEEP;}

+ (NSString *)titleDeepSleep { return L_TITLE_DEEP_SLEEP;}

+ (NSString *)titleOxygenInsleep { return L_TITLE_OXYGEN_INSLEEP;}

+ (NSString *)titleBreathRate { return L_TITLE_BREATH_RATE;}

+ (NSString *)titleBreathSubB { return L_TITLE_BREATH_SUB_B;}

+ (NSString *)titleSpo2SubB { return L_TITLE_SPO2_SUB_B;}

+ (NSString *)fmtBreathNormal { return L_FMT_BREATH_NORMAL;}

+ (NSString *)fmtBreathLow { return L_FMT_BREATH_LOW;}

+ (NSString *)fmtBreathHigh { return L_FMT_BREATH_HIGH;}

+ (NSString *)fmtOxygenNormal { return L_FMT_OXYGEN_NORMAL;}

+ (NSString *)fmtOxygenLow { return L_FMT_OXYGEN_LOW;}

+ (NSString *)titleSleepAnalyze { return L_TITLE_SLEEP_ANALYZE;}

+ (NSString *)sleepCellSubBFmt { return L_SLEEP_CELL_SUBB_FMT;}

+ (NSString *)napSleepCellSubBFmt { return L_NAP_SLEEP_CELL_SUBB_FMT;}

+ (NSString *)titleContribLevelBest { return L_TITLE_CONTRIB_LEVEL_BEST;}

+ (NSString *)titleContribLevelGood { return L_TITLE_CONTRIB_LEVEL_GOOD;}

+ (NSString *)titleContribLevelAttention { return L_TITLE_CONTRIB_LEVEL_ATTENTION;}

+ (NSString *)timeDetailTargetQualitySleep { return L_TIEM_DETAIL_TARGET_QUALITY_SLEEP;}

+ (NSString *)timeDetailTargetDeepSleep { return L_TIEM_DETAIL_TARGET_DEEP_SLEEP;}

+ (NSString *)otaVCTitle { return L_OTA_VC_TITLE;}

+ (NSString *)otaNewFirmTitle { return L_OTA_NEW_FIRM_TITLE;}

+ (NSString *)otaUpdateNow { return L_OTA_UPDATE_NOW;}

+ (NSString *)otaChargeTips { return L_OTA_CHARG_TIPS;}

+ (NSString *)otaUpdatingTips { return L_OTA_UPDATING_TIPS;}

+ (NSString *)otaSucc { return L_OTA_SUCC;}

+ (NSString *)otaFail { return L_OTA_FAIL;}

+ (NSString *)otaAlertMsgNew { return L_OTA_ALERT_MSG_NEW;}

+ (NSString *)otaAlreadyNew { return L_OTA_ALREDY_NEW;}

+ (NSString *)otaDwnFail { return L_OTA_DWN_FAIL;}

+ (NSString *)otaWaitRing { return L_OTA_WAIT_RING;}

+ (NSString *)contactTip { return L_CONTACT_TIP;}

+ (NSString *)contactEmail { return L_CONTACT_EMAIL;}

+ (NSString *)contactWeb { return L_CONTACT_WEB;}

+ (NSString *)pdfNo { return L_PDF_NO;}

+ (NSString *)pdfDatetime { return L_PDF_DATETIME;}

+ (NSString *)pdfTemperature { return L_PDF_TEMPERAUURE;}

+ (NSString *)pdfSysP { return L_PDF_SYS_P;}

+ (NSString *)pdfDiaP { return L_PDF_DIA_P;}

+ (NSString *)pdfOxygen { return L_PDF_OXYGEN;}

+ (NSString *)pdfRecordTime { return L_PDF_RECORD_TIME;}

+ (NSString *)pdfEcgTimeFormat { return L_PDF_ECG_TIME_FORMAT;}

+ (NSString *)pdfTimeFormat { return L_PDF_TIME_FORMAT;}

+ (NSString *)pdfUnitBp { return L_PDF_UNIT_BP;}

+ (NSString *)pdfUnitHr { return L_PDF_UNIT_HR;}

+ (NSString *)lead { return L_LEAD;}

+ (NSString *)unitHz { return L_UNIT_HZ;}

+ (NSString *)pdfEcgHrFormat { return L_PDF_ECG_HR_FORMAT;}

+ (NSString *)pdfBirthFormat { return L_PDF_BITRH_FORMAT;}

+ (NSString *)pdfTimeBirth { return L_PDF_TIME_BITRH;}

+ (NSString *)pdfTipNothing { return L_PDF_TIP_NOTHING;}

+ (NSString *)medicTxtRhr { return L_MEDIC_TXT_RHR;}

+ (NSString *)medicTxtTemp { return L_MEDIC_TXT_TEMP;}

+ (NSString *)medicTxtStep { return L_MEDIC_TXT_STEP;}

+ (NSString *)medicTxtHrv { return L_MEDIC_TXT_HRV;}

+ (NSString *)medicTxtReadiness { return L_MEDIC_TXT_READINESS;}

+ (NSString *)medicTxtSleepScore { return L_MEDIC_TXT_SLEEP_SCORE;}

+ (NSString *)trendTitleGoal { return L_TREND_TITLE_GOAL;}

+ (NSString *)trendKnow { return L_TREND_KNOW;}

+ (NSString *)trendEdit { return L_TREND_EDIT;}

+ (NSString *)trendSegDay { return L_TREND_SEG_DAY;}

+ (NSString *)trendSegWeek { return L_TREND_SEG_WEEK;}

+ (NSString *)trendSegMonth { return L_TREND_SEG_MONTH;}

+ (NSString *)trendAboutImmerse { return L_TREND_ABT_IMMERSE;}

+ (NSString *)trendAboutHrv { return L_TREND_ABT_HRV;}

+ (NSString *)trendAboutSleeptime { return L_TREND_ABT_SLEEPTIME;}

+ (NSString *)trendAboutDeepsleep { return L_TREND_ABT_DEEPSLEEP;}

+ (NSString *)trendAboutQualitysleep { return L_TREND_ABT_QUALITYSLEEP;}

+ (NSString *)trendAboutOxygen { return L_TREND_ABT_OXYGEN;}

+ (NSString *)trendAboutBreathrate { return L_TREND_ABT_BREATH_RATE;}

+ (NSString *)trendGoalImmerse { return L_TREND_GOAL_IMMERSE;}

+ (NSString *)trendGoalCommonFmt { return L_TREND_GOAL_COMMON_FMT;}

+ (NSString *)trendGoalSleeptime { return L_TREND_GOAL_SLEEPTIME;}

+ (NSString *)trendGoalQualitySleep { return L_TREND_GOAL_QUALITY_SLEEP;}

+ (NSString *)trendGoalDeepSleep { return L_TREND_GOAL_DEEP_SLEEP;}

+ (NSString *)segSleep { return L_SEG_SLEEP;}

+ (NSString *)segNap { return L_SEG_NAP;}



@end
