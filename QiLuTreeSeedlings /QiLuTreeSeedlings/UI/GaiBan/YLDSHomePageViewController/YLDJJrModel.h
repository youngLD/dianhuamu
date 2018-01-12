//
//  YLDJJrModel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/8.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLDJJrModel : NSObject
@property (nonatomic,copy) NSString *areaNames;
@property (nonatomic,copy) NSString *productNames;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *photo;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *userUid;
@property (nonatomic,copy) NSString *explain;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *defaultArea;
@property (nonatomic,copy) NSString *defaultAreaName;
@property (nonatomic,copy) NSString *partyId;
@property (nonatomic,assign) NSInteger comments;
@property (nonatomic,copy) NSArray *area;
@property (nonatomic,assign)BOOL selected;
+(YLDJJrModel *)yldJJrModelByDic:(NSDictionary *)dic;
+(NSArray *)yldJJrModelByAry:(NSArray *)ary;
+(YLDJJrModel *)yldJJrdetialModelByDic:(NSDictionary *)dic;

@end
