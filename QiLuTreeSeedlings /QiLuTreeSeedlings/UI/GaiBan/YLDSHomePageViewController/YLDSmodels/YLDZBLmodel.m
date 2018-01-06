//
//  YLDZBLmodel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/2/13.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDZBLmodel.h"

@implementation YLDZBLmodel
+(YLDZBLmodel *)creatBYdic:(NSDictionary *)dic
{
    YLDZBLmodel *model=[YLDZBLmodel new];
    model.area=[dic objectForKey:@"area"];
    model.articleCategoryName=[dic objectForKey:@"articleCategoryName"];
    model.articleCategoryShortName=[dic objectForKey:@"articleCategoryShortName"];
    model.articleType=[[dic objectForKey:@"articleType"] integerValue];
    model.biddingUnit=[dic objectForKey:@"articleType"];
    model.contentView=[dic objectForKey:@"contentView"];
    model.endTime=[dic objectForKey:@"endTime"];
    model.infoNumber=[dic objectForKey:@"infoNumber"];
    model.publishTime=[dic objectForKey:@"publishTime"];
    model.publishtimeStr=[dic objectForKey:@"publishtimeStr"];
    model.startTime=[dic objectForKey:@"startTime"];
    model.title=[dic objectForKey:@"title"];
    model.uid=[dic objectForKey:@"uid"];
    model.articleCategory=[dic objectForKey:@"articleCategory"];
    model.tenderBuy=[[dic objectForKey:@"tenderBuy"] integerValue];
    model.tenderPrice=[[dic objectForKey:@"tenderPrice"] floatValue];
    return model;
    
}
+(NSArray *)creatByAry:(NSArray *)ary
{
    NSMutableArray *Ary=[NSMutableArray array];
    for (NSDictionary *dic in ary) {
        YLDZBLmodel *model=[YLDZBLmodel creatBYdic:dic];
        
        [Ary addObject:model];
    }
    
    return Ary;
}
@end
