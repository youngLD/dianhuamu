//
//  YLDFSupplyModel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/12/28.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDFSupplyModel.h"

@implementation YLDFSupplyModel
+(YLDFSupplyModel *)YLDFSupplyModelWithDic:(NSDictionary *)dic
{
    YLDFSupplyModel *model=[YLDFSupplyModel new];
    model.demand=dic[@"demand"];
    model.lastTime=dic[@"lastTime"];
    model.partyId=dic[@"partyId"];
    model.productName=dic[@"productName"];
    model.status=dic[@"status"];
    model.supplyId=dic[@"supplyId"];
    model.updateDate=dic[@"updateDate"];
    model.area=dic[@"area"];
    model.attacs=dic[@"attacs"];
    model.views=[dic[@"views"] integerValue];
    model.htmlUrl=dic[@"url"];
    model.addressId=dic[@"addressId"];
    model.keywords=dic[@"keywords"];
    model.phone=dic[@"phone"];
    return model;
}
+(NSArray *)YLDFSupplyModelAryWithAry:(NSArray *)ary
{
    NSMutableArray *Ary=[NSMutableArray array];
    for (NSDictionary *dic in ary) {
        YLDFSupplyModel *model=[YLDFSupplyModel YLDFSupplyModelWithDic:dic];
        [Ary addObject:model];
    }
    return Ary;
}
@end
