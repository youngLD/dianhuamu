//
//  YLDFMyOrderItemsModel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/10.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFMyOrderItemsModel.h"

@implementation YLDFMyOrderItemsModel
+(YLDFMyOrderItemsModel *)creatModelByDic:(NSDictionary *)dic
{
    YLDFMyOrderItemsModel *model=[YLDFMyOrderItemsModel new];
    model.demand=dic[@"demand"];
    model.closed=[dic[@"closed"] integerValue];
    model.engineeringProcurementItemId=dic[@"engineeringProcurementItemId"];
    model.itemName=dic[@"itemName"];
    model.quantity=dic[@"quantity"];
    model.quoteCount=[dic[@"quoteCount"] integerValue];
    model.status=dic[@"status"];
    model.engineeringProcurementItemId=dic[@"engineeringProcurementItemId"];
    return model;
}
+(NSArray *)creatModelByAry:(NSArray *)ary
{
    NSMutableArray *Ary=[NSMutableArray array];
    for (NSDictionary *dic in ary) {
        YLDFMyOrderItemsModel *model=[YLDFMyOrderItemsModel creatModelByDic:dic];
        [Ary addObject:model];
    }
    return Ary;
}
@end
