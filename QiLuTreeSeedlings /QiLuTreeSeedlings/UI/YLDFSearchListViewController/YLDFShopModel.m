//
//  YLDFShopModel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/20.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFShopModel.h"
#import "ZIKFunction.h"
#import "UIDefines.h"
@implementation YLDFShopModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"descriptions" : @"description"};
}
//黑名单
+ (NSArray *)modelPropertyBlacklist {
    return @[@"JJTextH",@"isOpen"];
}
+(NSArray *)creatAryByAry:(NSArray *)ary
{
    NSMutableArray *Ary=[NSMutableArray array];
    for ( NSDictionary *dic in ary) {
        YLDFShopModel  *model=[YLDFShopModel yy_modelWithJSON:dic];
        NSString *jjStr=[NSString stringWithFormat:@"店铺简介：%@",model.descriptions];
        CGRect re=[ZIKFunction getCGRectWithContent:jjStr width:kWidth-30 font:14];
         CGFloat hhh=re.size.height;
        if (hhh>=18) {
            model.JJTextH=hhh;
        }else
        {
            model.JJTextH=18;
        }
        [Ary addObject:model];
    }
    return Ary;
}
@end
