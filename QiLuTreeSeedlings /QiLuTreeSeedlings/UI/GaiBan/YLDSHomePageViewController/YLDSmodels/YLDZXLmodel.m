//
//  YLDZXLmodel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/2/14.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDZXLmodel.h"
#import "ZIKFunction.h"
@implementation YLDZXLmodel
+(YLDZXLmodel *)yldZXLmodelbyDIC:(NSDictionary *)dic
{
    YLDZXLmodel *model=[YLDZXLmodel new];
    model.articleCategoryName = [dic objectForKey:@"articleCategoryName"];
    model.articleCategoryShortName = [dic objectForKey:@"articleCategoryShortName"];
    model.uid = [dic objectForKey:@"uid"];
    if (model.uid.length==0) {
        model.uid = [dic objectForKey:@"articleUid"];
    }
    model.title = [dic objectForKey:@"title"];
    model.pic = [dic objectForKey:@"pic"];
    model.author = [dic objectForKey:@"author"];
    NSString *creatTime=[dic objectForKey:@"publishtimeStr"];

    model.publishtimeStr =[ZIKFunction compareCurrentTime:[ZIKFunction getDateFromString:creatTime]];
    model.contentView = [dic objectForKey:@"contentView"];
    model.articleType = [[dic objectForKey:@"articleType"] integerValue];
    model.istop = [[dic objectForKey:@"istop"] integerValue];
    model.tenderBuy = [[dic objectForKey:@"tenderBuy"] integerValue];
    model.tenderPrice = [[dic objectForKey:@"tenderPrice"] floatValue];
    model.viewTimes = [[dic objectForKey:@"viewTimes"] integerValue];
    model.isbuy=[[dic objectForKey:@"isbuy"] integerValue];
    model.articleCategory=[dic objectForKey:@"articleCategory"];
    if (model.pic.length>0) {
        model.picAry=[model.pic componentsSeparatedByString:@","];
    }
    return model;
}
+(NSArray *)yldZXLmodelbyAry:(NSArray *)ary
{
    NSMutableArray *Ary=[NSMutableArray array];
    for (NSDictionary *dic in ary) {
        YLDZXLmodel *model=[YLDZXLmodel yldZXLmodelbyDIC:dic];
        [Ary addObject:model];
    }
    return Ary;
}
@end
