//
//  UIDefines.h
//  baba88
//
//  Created by JCAI on 15/7/16.
//  Copyright (c) 2015年 BABA88. All rights reserved.
//

#ifndef UIDefines_h
#define UIDefines_h

#import "AppDelegate.h"
#import "ToastView.h"
#import "UserInfoModel.h"
#import "ActionView.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
#import "ZIKFunction.h"
#define APPDELEGATE     ((AppDelegate *)[UIApplication sharedApplication].delegate)
//#define ShowTopToast(text) {\
//[ToastView showToast:text\
//withOriginY:66.0f\
//withSuperView:APPDELEGATE.window];\
//}
//
//#define ShowToast(text) {\
//[ToastView showToast:text\
//withOriginY:[[UIScreen mainScreen] bounds].size.height-100\
//withSuperView:APPDELEGATE.window];\
//}
#define NavTitleSize  20
#define SCALING         (APPDELEGATE.scaling)

#define kHeight [UIScreen mainScreen].bounds.size.height
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kRGB(R,G,B,P) [UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:P]


#pragma mark - 颜色设置
#define NavColor         kRGB(58, 180, 108, 1)
#define NavSColor        kRGB(250,250,250, 1)
#define NavTitleColor    kRGB(68,68,68,1)
#define BGColor         [UIColor colorWithRed:247/255.0f green:247/255.0f blue:247/255.0f alpha:1.0f]
//#define BGColor         [UIColor whiteColor]
#define kLineColor       [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0]
#define NgreenColor kRGB(58, 170, 100, 1)
#define NblueColor kRGB(80, 164, 241, 1)
#define yellowButtonColor kRGB(255, 145,85,1)
#define NavYellowColor    kRGB(255, 145,85,1)
#define titleLabColor kRGB(102, 102, 102,1)
#define detialLabColor kRGB(153, 153, 153,1)
#define kRedHintColor kRGB(237, 136, 116,1)
#define kChengColor kRGB(254, 167,51,1)
#define RedBtnColor    kRGB(253, 74, 82,1)
#define DarkTitleColor kRGB(34,34,34,1)
#define MoreDarkTitleColor kRGB(34,34,34,1)
#define kBlueShopColor kRGB(53,204,249,1)
#define readColor kRGB(136,136,136,1)
#define litleGreenColor kRGB(245,253,242,1)
#pragma mark- 对屏幕尺寸进行判断
#define iPhone35Inch            (([[UIScreen mainScreen] bounds].size.height == 480) ? YES : NO)
#define iPhone47InchLater       (([[UIScreen mainScreen] bounds].size.height >= 667) ? YES : NO)

#define ksearchHistoryAry @"searchHistoryAry"

#define kACCESS_ID @"access_id"
#define kACCESS_TOKEN @"access_token"
#define kdeviceToken @"deviceToken"

#define ShowActionV() {\
[ActionView removeActionView];\
[ActionView addActionView];\
}
#define ShowSpecialActionV() {\
[ActionView removeActionView];\
[ActionView addSpecialActionView];\
}
#define RemoveActionV() [ActionView removeActionView]

#ifdef DEBUG
#define CLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define CLog(fmt, ...)
#endif

#endif
