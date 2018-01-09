//
//  YLDFEOrderModel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/9.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLDFEOrderModel : NSObject
@property (nonatomic,copy)NSString *area;
@property (nonatomic,copy)NSString *Description;
@property (nonatomic,copy)NSString *engineeringProcurementId;
@property (nonatomic,copy)NSString *engineeringProcurementName;
@property (nonatomic,copy)NSString *enterpriseName;
@property (nonatomic,copy)NSString *itemName;
@property (nonatomic,copy)NSString *lastTime;
@property (nonatomic,copy)NSString *quoteType;
@property (nonatomic,copy)NSString *quoteTypeId;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *thruDate;
+(YLDFEOrderModel *)creatModeByDic:(NSDictionary *)dic;
+(NSMutableArray *)creatModeByAry:(NSArray *)ary;
@end
