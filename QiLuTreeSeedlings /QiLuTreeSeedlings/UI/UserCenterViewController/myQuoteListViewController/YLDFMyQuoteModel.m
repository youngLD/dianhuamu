//
//  YLDFMyQuoteModel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/15.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFMyQuoteModel.h"
#import "YYModel.h"
@implementation YLDFMyQuoteModel
+(NSArray *)creatByAry:(NSArray *)ary
{
    NSMutableArray *Ary=[NSMutableArray array];
    for (NSDictionary *dic in ary) {
        YLDFMyQuoteModel *model=[YLDFMyQuoteModel yy_modelWithJSON:dic];
        [Ary addObject:model];
    }
    return Ary;
}
@end
