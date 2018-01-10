//
//  YLDFMyOrderItemsModel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/10.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLDFMyOrderItemsModel : NSObject
@property (nonatomic,copy)NSString *demand;
@property (nonatomic,assign)NSInteger closed;
@property (nonatomic,copy)NSString *engineeringProcurementItemId;
@property (nonatomic,copy)NSString *itemName;
@property (nonatomic,copy)NSString *quantity;
@property (nonatomic,assign)NSInteger quoteCount;
@property (nonatomic,copy)NSString *status;
+(YLDFMyOrderItemsModel *)creatModelByDic:(NSDictionary *)dic;
+(NSArray *)creatModelByAry:(NSArray *)ary;
@end
