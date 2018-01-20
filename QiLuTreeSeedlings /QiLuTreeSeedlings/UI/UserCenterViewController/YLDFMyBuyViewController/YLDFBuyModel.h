//
//  YLDFBuyModel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/2.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLDFBuyModel : NSObject
@property (nonatomic,copy) NSString *demand;
@property (nonatomic,copy) NSString *lastTime;
@property (nonatomic,copy) NSString *partyId;
@property (nonatomic,copy) NSString *productName;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *staticUrl;
@property (nonatomic,copy) NSString *buyId;
@property (nonatomic,copy) NSString *createdDate;
@property (nonatomic,copy) NSString *quoteTypeId;
@property (nonatomic,assign) NSInteger views;
@property (nonatomic,copy) NSString *quantity;
@property (nonatomic,assign)BOOL isSelect;
@property (nonatomic,copy) NSString *lastModifiedByPartyId;
@property (nonatomic,copy) NSString *lastModifiedDate;
@property (nonatomic,copy) NSString *productId;
@property (nonatomic,copy) NSString *addressId;
@property (nonatomic,copy) NSString *createdByPartyId;
@property (nonatomic,copy) NSString *dataSourceId;
@property (nonatomic,copy) NSString *updateDate;
@property (nonatomic,copy) NSString *area;
@property (nonatomic,copy) NSString *htmlUrl;
@property (nonatomic,copy) NSString *baseUrl;
@property (nonatomic,strong)NSArray *roles;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *linkman;
@property (nonatomic,copy) NSArray *attacs;
+(YLDFBuyModel *)YLDFBuyModelWithDic:(NSDictionary *)dic;
+(NSArray *)YLDFBuyModelAryWithAry:(NSArray *)ary;
@end
