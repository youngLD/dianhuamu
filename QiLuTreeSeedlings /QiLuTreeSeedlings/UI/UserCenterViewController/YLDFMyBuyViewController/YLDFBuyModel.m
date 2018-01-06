//
//  YLDFBuyModel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/2.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFBuyModel.h"

@implementation YLDFBuyModel
+(YLDFBuyModel *)YLDFBuyModelWithDic:(NSDictionary *)dic
{
    YLDFBuyModel *model=[YLDFBuyModel new];
    model.addressId=dic[@"addressId"];
    model.buyId=dic[@"buyId"];
    model.createdByPartyId=dic[@"createdByPartyId"];
    model.createdDate=dic[@"createdDate"];
    model.dataSourceId=dic[@"dataSourceId"];
    
    model.demand=dic[@"demand"];
    model.lastModifiedByPartyId=dic[@"lastModifiedByPartyId"];
    model.lastModifiedDate=dic[@"lastModifiedDate"];
    model.partyId=dic[@"partyId"];
    model.productName=dic[@"productName"];
    model.quantity=dic[@"quantity"];
    model.quoteTypeId=dic[@"quoteTypeId"];
    model.staticUrl=dic[@"staticUrl"];
    model.status=dic[@"status"];
    model.area=dic[@"area"];
    model.updateDate=dic[@"updateDate"];
    model.views=[dic[@"views"] integerValue];
    model.htmlUrl=dic[@"htmlUrl"];
    return model;
}
+(NSArray *)YLDFBuyModelAryWithAry:(NSArray *)ary
{
    NSMutableArray *Ary=[NSMutableArray array];
    for (NSDictionary *dic in ary) {
        YLDFBuyModel *model=[YLDFBuyModel YLDFBuyModelWithDic:dic];
        
        [Ary addObject:model];
    }
    return Ary;
}
@end
