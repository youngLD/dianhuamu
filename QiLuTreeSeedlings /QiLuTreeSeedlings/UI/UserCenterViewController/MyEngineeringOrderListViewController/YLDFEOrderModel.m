//
//  YLDFEOrderModel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/9.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFEOrderModel.h"

@implementation YLDFEOrderModel
+(YLDFEOrderModel *)creatModeByDic:(NSDictionary *)dic
{
    YLDFEOrderModel *model=[YLDFEOrderModel new];
    model.area=dic[@"area"];
    model.Description=dic[@"description"];
    model.engineeringProcurementId=dic[@"engineeringProcurementId"];
    model.engineeringProcurementId=dic[@"engineeringProcurementName"];
    model.enterpriseName=dic[@"enterpriseName"];
    model.itemName=dic[@"itemName"];
    model.lastTime=dic[@"lastTime"];
    model.quoteType=dic[@"quoteType"];
    model.quoteTypeId=dic[@"quoteTypeId"];
    model.status=dic[@"status"];
    model.thruDate=dic[@"thruDate"];
    return model;
}
+(NSMutableArray *)creatModeByAry:(NSArray *)ary
{
    NSMutableArray *Ary=[NSMutableArray array];
    for (NSDictionary *dic in ary) {
        YLDFEOrderModel *model=[YLDFEOrderModel creatModeByDic:dic];
        [Ary addObject:model];
    }
    return Ary;
}
@end
