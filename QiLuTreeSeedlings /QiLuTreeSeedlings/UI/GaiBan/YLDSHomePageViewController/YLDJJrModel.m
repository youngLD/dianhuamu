//
//  YLDJJrModel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/8.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDJJrModel.h"
#import "GetCityDao.h"
@implementation YLDJJrModel
+(YLDJJrModel *)yldJJrModelByDic:(NSDictionary *)dic
{
    YLDJJrModel *model=[YLDJJrModel new];
    model.name=dic[@"name"];
    model.userUid=dic[@"memberUid"];
    model.phone=dic[@"phone"];
    model.areaNames=dic[@"areaNames"];
    model.productNames=dic[@"product"];
    model.uid=dic[@"uid"];
    model.photo=dic[@"photo"];
    model.comments=[[dic[@"comments"] objectForKey:@"comments"] integerValue];
    model.explain=dic[@"explain"];
    model.defaultArea=dic[@"defaultArea"];
    if (model.defaultArea) {
        GetCityDao *citydao=[GetCityDao new];
        [citydao openDataBase];
        model.defaultAreaName=[citydao getCityNameByCityUid:model.defaultArea];
        [citydao closeDataBase];
    }
    return model;
}
+(NSArray *)yldJJrModelByAry:(NSArray *)ary
{
    NSMutableArray *modelAry=[NSMutableArray array];
    for (NSDictionary *dic in ary) {
        YLDJJrModel *model=[YLDJJrModel yldJJrModelByDic:dic];
        [modelAry addObject:model];
    }
    return modelAry;
}
+(YLDJJrModel *)yldJJrdetialModelByDic:(NSDictionary *)dic
{
    YLDJJrModel *model=[YLDJJrModel new];
    model.name=dic[@"name"];
    model.userUid=dic[@"memberUid"];
    model.phone=dic[@"phone"];
    model.areaNames=dic[@"areaNames"];
    model.productNames=dic[@"product"];
    model.uid=dic[@"uid"];
    model.photo=dic[@"photo"];
//    model.comments=[[dic[@"comments"] objectForKey:@"comments"] integerValue];
    model.explain=dic[@"explain"];
    model.defaultArea=dic[@"defaultArea"];
    if (model.defaultArea) {
        GetCityDao *citydao=[GetCityDao new];
        [citydao openDataBase];
        model.defaultAreaName=[citydao getCityNameByCityUid:model.defaultArea];
        [citydao closeDataBase];
    }
    

    return model;
}
@end
