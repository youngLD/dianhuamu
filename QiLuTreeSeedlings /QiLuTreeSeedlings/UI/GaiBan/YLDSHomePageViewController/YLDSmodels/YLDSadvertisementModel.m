//
//  YLDSadvertisementModel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/2/17.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDSadvertisementModel.h"
#import "ZIKFunction.h"
@implementation YLDSadvertisementModel
+(YLDSadvertisementModel *)yldSadvertisementModelByDic:(NSDictionary *)dic
{
    YLDSadvertisementModel *model=[YLDSadvertisementModel new];
    model.adsType =[dic[@"adsType"] integerValue];
    model.adType=[[dic objectForKey:@"adType"] integerValue];
    model.state=[[dic objectForKey:@"state"] integerValue];
    model.brief=[dic objectForKey:@"brief"];
    model.clickcount=[dic objectForKey:@"clickcount"];
    model.endTime=[dic objectForKey:@"endTime"];
    model.name=[dic objectForKey:@"name"];
    model.startTime=[dic objectForKey:@"startTime"];
    model.uid=[dic objectForKey:@"uid"];
    model.attachment=[dic objectForKey:@"attachment"];
    model.imageAry=[model.attachment componentsSeparatedByString:@","];
    model.content = dic[@"content"];
    model.link = dic[@"link"];
    model.shop = dic[@"shop"];
    return model;
}
+(NSArray *)aryWithAry:(NSArray *)ary
{
    NSMutableArray *arys=[NSMutableArray array];
    for (NSDictionary *dic in ary) {
        YLDSadvertisementModel *model=[YLDSadvertisementModel yldSadvertisementModelByDic:dic];
        [arys addObject:model];
    }
    return arys;
}
+(YLDSadvertisementModel *)lzlSadvertisementModelByDic:(NSDictionary *)dic
{
    YLDSadvertisementModel *model=[YLDSadvertisementModel new];
    model.adType=[[dic objectForKey:@"ad_type"] integerValue];
    model.state=[[dic objectForKey:@"state"] integerValue];
    model.brief=[dic objectForKey:@"brief"];
    model.clickcount=[dic objectForKey:@"clickcount"];
    model.endTime=[dic objectForKey:@"end_time"];
    model.name=[dic objectForKey:@"name"];
    model.startTime=[dic objectForKey:@"time_handel"];
    model.uid=[dic objectForKey:@"uid"];
    model.attachment=[dic objectForKey:@"attachment"];
    model.adsType =[dic[@"ads_type"] integerValue];
    model.content = dic[@"content"];
    model.link = dic[@"link"];
    model.shop = dic[@"shop"];
    model.imageAry=[model.attachment componentsSeparatedByString:@","];
    NSDate *creatTimeDate=[ZIKFunction getDateFromString:model.startTime];
    model.timeStr=[ZIKFunction compareCurrentTime:creatTimeDate];

    return model;
}
+(NSArray *)lzlAryWithAry:(NSArray *)ary
{
    NSMutableArray *arys=[NSMutableArray array];
    for (NSDictionary *dic in ary) {
        YLDSadvertisementModel *model=[YLDSadvertisementModel lzlSadvertisementModelByDic:dic];
        [arys addObject:model];
    }
    return arys;
    
}
@end
