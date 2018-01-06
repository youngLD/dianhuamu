//
//  YLDTHEDWModel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/9/15.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLDTHEDWModel : NSObject
@property (nonatomic,copy)NSString *address;
@property (nonatomic,copy)NSString *details;
@property (nonatomic,assign)NSInteger createTime;
@property (nonatomic,assign)NSInteger updateTime;
@property (nonatomic,assign)NSInteger entType;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *recommendType;
@property (nonatomic,copy)NSString *uid;
+(YLDTHEDWModel *)creatByDic:(NSDictionary *)dic;
+(NSMutableArray *)creatByAry:(NSArray *)ary;
@end
