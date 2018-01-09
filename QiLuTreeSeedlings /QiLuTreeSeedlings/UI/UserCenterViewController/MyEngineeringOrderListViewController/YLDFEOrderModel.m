//
//  YLDFEOrderModel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/9.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFEOrderModel.h"
#import "ZIKFunction.h"
#import "UIDefines.h"
@implementation YLDFEOrderModel
+(YLDFEOrderModel *)creatModeByDic:(NSDictionary *)dic
{
    YLDFEOrderModel *model=[YLDFEOrderModel new];
    model.area=dic[@"area"];
    model.Description=dic[@"description"];
    model.engineeringProcurementId=dic[@"engineeringProcurementId"];
    model.engineeringProcurementName=dic[@"engineeringProcurementName"];
    model.enterpriseName=dic[@"enterpriseName"];
    model.itemName=dic[@"itemName"];
    model.lastTime=dic[@"lastTime"];
    model.quoteType=dic[@"quoteType"];
    model.quoteTypeId=dic[@"quoteTypeId"];
    model.status=dic[@"status"];
    model.thruDate=dic[@"thruDate"];
    model.itemNameH=[ZIKFunction getCGRectWithContent:model.itemName width:kWidth-110 font:15].size.height;
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
