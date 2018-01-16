//
//  YLDDataCacheHelp.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/16.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLDDataCacheHelp : NSObject
@property (nonatomic,strong) NSMutableArray *cacheAry;
-(id)initWithC:(NSInteger)c;
-(BOOL)replaceDataWithDataAry:(NSArray *)dataAry WithIndex:(NSInteger)index;
-(NSArray *)getDataAryWithIndex:(NSInteger)index withPage:(NSInteger)page WithPageSize:(NSInteger)pagesize;
@end
