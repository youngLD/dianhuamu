//
//  YLDShopListModel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/10/11.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLDShopListModel : NSObject
@property (nonatomic,copy) NSString *areaAddress;
@property (nonatomic,copy) NSString *memberId;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *shopName;
+(YLDShopListModel *)yldShopListModelWithDic:(NSDictionary *)dic;
+(NSMutableArray *)creatShopListByAry:(NSArray *)ary;
@end
