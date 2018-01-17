//
//  YLDFSupplyModel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/12/28.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLDFSupplyModel : NSObject
@property (nonatomic,copy) NSString *demand;
@property (nonatomic,copy) NSString *lastTime;
@property (nonatomic,copy) NSString *partyId;
@property (nonatomic,copy) NSString *productName;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *supplyId;
@property (nonatomic,copy) NSString *updateDate;
@property (nonatomic,copy) NSString *area;
@property (nonatomic,assign) NSInteger views;
@property (nonatomic,copy) NSString *htmlUrl;
@property (nonatomic,copy) NSString *addressId;
@property (nonatomic,copy) NSString *keywords;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,assign)BOOL isSelect;
@property (nonatomic,copy) NSArray *attacs;
@property (nonatomic,copy) NSArray *roles;
+(YLDFSupplyModel *)YLDFSupplyModelWithDic:(NSDictionary *)dic;
+(NSArray *)YLDFSupplyModelAryWithAry:(NSArray *)ary;
@end
