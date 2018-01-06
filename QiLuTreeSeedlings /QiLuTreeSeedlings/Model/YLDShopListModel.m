//
//  YLDShopListModel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/10/11.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDShopListModel.h"

@implementation YLDShopListModel
+(YLDShopListModel *)yldShopListModelWithDic:(NSDictionary *)dic
{
    YLDShopListModel *model=[YLDShopListModel new];
    model.areaAddress=dic[@"areaAddress"];
    model.memberId=dic[@"memberId"];
    model.phone=dic[@"phone"];
    model.shopName=dic[@"shopName"];
    return model;

}
+(NSMutableArray *)creatShopListByAry:(NSArray *)ary
{
    NSMutableArray *Ary=[NSMutableArray array];
    for (NSDictionary *dic in ary) {
        YLDShopListModel *model=[self yldShopListModelWithDic:dic];
        [Ary addObject:model];
    }

    return Ary;
}
@end
