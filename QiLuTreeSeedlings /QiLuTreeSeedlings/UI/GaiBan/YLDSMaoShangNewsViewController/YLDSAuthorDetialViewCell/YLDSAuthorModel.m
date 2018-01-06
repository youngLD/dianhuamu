//
//  YLDSAuthorModel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/4/10.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDSAuthorModel.h"

@implementation YLDSAuthorModel
+(YLDSAuthorModel *)modelWithDic:(NSDictionary *)dic{
    YLDSAuthorModel *model=[YLDSAuthorModel new];
    model.uid=dic[@"uid"];
    model.name=dic[@"name"];
    model.headPortrait=dic[@"headPortrait"];
    model.remark=dic[@"remark"];
    model.follow=[dic[@"follow"] boolValue];
    if (model.remark.length==0) {
        model.remark=@"这个作者很懒，什么都没有留下。";
    }
    return model;
}
+(NSMutableArray *)modelWithAry:(NSArray *)ary
{
    NSMutableArray *arysss=[NSMutableArray array];
    for (NSDictionary *dic in ary) {
        YLDSAuthorModel *model = [YLDSAuthorModel modelWithDic:dic];
        [arysss addObject:model];
    }
    return arysss;
}
@end
