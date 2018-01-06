//
//  YLDTHEDWModel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/9/15.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDTHEDWModel.h"

@implementation YLDTHEDWModel
+(YLDTHEDWModel *)creatByDic:(NSDictionary *)dic
{
    YLDTHEDWModel *model=[YLDTHEDWModel new];
    model.address=dic[@"address"];
    model.details=dic[@"details"];
    model.name=dic[@"name"];
    model.recommendType=dic[@"recommendType"];
    model.uid=dic[@"uid"];
    model.updateTime=[dic[@"updateTime"] integerValue];
    model.entType=[dic[@"entType"] integerValue];
    model.createTime=[dic[@"createTime"] integerValue];
    if (!model.recommendType) {
        model.recommendType=@"xxx";
    }
    return model;
}
+(NSMutableArray *)creatByAry:(NSArray *)ary
{
    NSMutableArray *Ary=[NSMutableArray array];
    for (NSDictionary *dic in ary) {
        YLDTHEDWModel *model=[YLDTHEDWModel creatByDic:dic];
        [Ary addObject:model];
    }
    return Ary;
}
@end
