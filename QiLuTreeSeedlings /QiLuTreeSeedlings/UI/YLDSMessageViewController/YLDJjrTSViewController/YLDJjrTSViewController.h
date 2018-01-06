//
//  YLDJjrTSViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/7/29.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "ZIKArrowViewController.h"
typedef NS_ENUM(NSInteger, InfoTypes) {
    InfoTypeMys = 0,        //我的定制信息
    InfoTypeStations = 1,//站长推送定制信息
    InfoTypeMMBs = 2,
    InfoTypeJJS = 3,//经纪人供应
    InfoTypeJJB = 4//经纪人求购
};
@interface YLDJjrTSViewController : ZIKArrowViewController
@property (nonatomic, assign) NSInteger infoType;
@end
