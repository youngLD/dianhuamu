//
//  YLDDataCacheHelp.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/16.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDDataCacheHelp.h"

@implementation YLDDataCacheHelp
-(id)initWithC:(NSInteger)c
{
    self=[super init];
    if (self) {
        self.cacheAry = [NSMutableArray array];
        for (int i=0; i<c; i++) {
            NSArray *itemsAry=[NSArray array];
            [self.cacheAry addObject:itemsAry];
        }
    }
    return self;
}
-(BOOL)replaceDataWithDataAry:(NSArray *)dataAry WithIndex:(NSInteger)index
{
    
    if (index>[self.cacheAry count]) {
        return NO;
    }else{
        [self.cacheAry replaceObjectAtIndex:index withObject:dataAry];
        return YES;
    }
    return NO;
}
-(NSArray *)getDataAryWithIndex:(NSInteger)index withPage:(NSInteger)page WithPageSize:(NSInteger)pagesize
{
//    NSArray *dataAry;
    if (index>[self.cacheAry count]) {
        return @[];
    }else{
        NSMutableArray *indexAry=[NSMutableArray arrayWithArray:self.cacheAry[index]];
        if (indexAry.count>(page-1)*pagesize) {
            NSInteger beginIndex;
//            if (page<=1) {
//                beginIndex=0;
//            }else{
                beginIndex=(page-1)*pagesize;
//            }
            if (indexAry.count>=page*pagesize) {
                NSArray *dataAry=[indexAry subarrayWithRange:NSMakeRange(beginIndex, pagesize)];
                return dataAry;
            }else{
                NSArray *dataAry=[indexAry subarrayWithRange:NSMakeRange(beginIndex, [indexAry count]-(page-1)*pagesize)];
                return dataAry;
            }
            return @[];
        }else{
            return @[];
        }
//        [self.cacheAry replaceObjectAtIndex:index withObject:dataAry];
//        return YES;
    }
//    return dataAry;
}
@end
