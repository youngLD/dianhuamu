//
//  YLDFAddressModel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/12/13.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLDFAddressModel : NSObject
@property (copy,nonatomic) NSString *addressId;
@property (copy,nonatomic) NSString *city;
@property (copy,nonatomic) NSString *county;
@property (copy,nonatomic) NSString *createdByPartyId;
@property (copy,nonatomic) NSString *createdDate;
@property (copy,nonatomic) NSString *dataSourceId;
@property (assign,nonatomic) NSInteger defaultAddress;
@property (copy,nonatomic) NSString *lastModifiedByPartyId;
@property (copy,nonatomic) NSString *lastModifiedDate;
@property (copy,nonatomic) NSString *lat;
@property (copy,nonatomic) NSString *lng;
@property (copy,nonatomic) NSString *linkman;
@property (copy,nonatomic) NSString *partyId;
@property (copy,nonatomic) NSString *phone;
@property (copy,nonatomic) NSString *province;
@property (copy,nonatomic) NSString *area;
+(YLDFAddressModel *)creatModelWithDic:(NSDictionary *)dic;
+(NSArray *)creatAryWithary:(NSArray *)ary;
@end
