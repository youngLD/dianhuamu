//
//  YLDFAddressModel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/12/13.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDFAddressModel.h"

@implementation YLDFAddressModel
+(YLDFAddressModel *)creatModelWithDic:(NSDictionary *)dic
{
    YLDFAddressModel *model=[YLDFAddressModel new];
    model.addressId=dic[@"addressId"];
    model.city=dic[@"city"];
    model.county=dic[@"county"];
    model.createdByPartyId=dic[@"createdByPartyId"];
    model.createdDate=dic[@"createdDate"];
    model.dataSourceId=dic[@"dataSourceId"];
    model.defaultAddress=[dic[@"defaultAddress"] integerValue];
    model.lastModifiedByPartyId=dic[@"lastModifiedByPartyId"];
    model.lastModifiedDate=dic[@"lastModifiedDate"];
    model.lat=dic[@"lat"];
    model.linkman=dic[@"linkman"];
    model.lng=dic[@"lng"];
    model.partyId=dic[@"partyId"];
    model.phone=dic[@"phone"];
    model.province=dic[@"province"];
    return model;
}
+(NSArray *)creatAryWithary:(NSArray *)ary
{
    NSMutableArray *Ary=[NSMutableArray array];
    for (int i=0; i<ary.count; i++) {
        NSDictionary *dic=ary[i];
        YLDFAddressModel *model = [YLDFAddressModel creatModelWithDic:dic];
        [Ary addObject:model];
    }
//
    return Ary;
}
@end
