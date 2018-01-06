//
//  YLDSadvertisementModel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/2/17.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLDSadvertisementModel : NSObject
@property (nonatomic,assign)NSInteger adType;
@property (nonatomic,strong)NSString *brief;
@property (nonatomic,strong)NSString *clickcount;
@property (nonatomic,strong)NSString *endTime;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *startTime;
@property (nonatomic,assign)NSInteger state;
@property (nonatomic,strong)NSString *uid;
@property (nonatomic,strong)NSString *attachment;
@property (nonatomic,assign)NSInteger adsType;
@property (nonatomic,strong)NSString *content;
@property (nonatomic,strong)NSString *link;
@property (nonatomic,strong)NSString *shop;
@property (nonatomic,strong)NSString *timeStr;
@property (nonatomic,strong)NSArray *imageAry;
@property (nonatomic)       BOOL isRead;
+(YLDSadvertisementModel *)yldSadvertisementModelByDic:(NSDictionary *)dic;
+(NSArray *)aryWithAry:(NSArray *)ary;
+(YLDSadvertisementModel *)lzlSadvertisementModelByDic:(NSDictionary *)dic;
+(NSArray *)lzlAryWithAry:(NSArray *)ary;
@end
