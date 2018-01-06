//
//  ZIKVoucherCenterViewController.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/4/1.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//
#import "ZIKArrowViewController.h"
typedef NS_ENUM(NSUInteger, PayWay) {
    Pay_Online,     //充值
    Pay_ZhifuBao,   //求购购买
    Pay_WeiXin,     //采购单购买
    Pay_YuE,        //开通苗木帮
};

@interface ZIKVoucherCenterViewController : ZIKArrowViewController
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, assign)NSInteger infoType;
@property (nonatomic, copy) NSString *wareStr;
@end
