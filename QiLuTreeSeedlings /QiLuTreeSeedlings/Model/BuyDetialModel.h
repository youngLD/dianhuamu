//
//  BuyDetialModel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/29.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface spec : NSObject
@property (nonatomic) NSInteger main;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *unit;
@property (nonatomic,strong) NSArray *value;
+(spec *)creatspecModelByDic:(NSDictionary*)dic;
@end
@interface BuyDetialModel : NSObject
@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *address;
@property (nonatomic) NSInteger collect;
@property (nonatomic,strong) NSString *collectUid;
@property (nonatomic,strong) NSString *count;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *descriptions;
@property (nonatomic,strong) NSString *endTime;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSMutableArray *spec;
@property (nonatomic,strong) NSString *supplybuyName;
@property (nonatomic,strong) NSString *supplybuyUid;
@property (nonatomic,strong) NSString *title;
@property (nonatomic) NSInteger views;
@property (nonatomic,strong) NSString *searchTime;
@property (nonatomic,strong) NSString *productName;
@property (nonatomic,assign) NSInteger isBuyTime;
@property (nonatomic,strong) NSArray *imagessmallAry;
@property (nonatomic,strong) NSArray *imagesAry;
//1金，2银，3铜

@property (nonatomic) NSInteger goldsupplier;
//--0/1/2/3/4   已关闭，只能删除/过期,可编辑删除/未审核,可编辑删除/审核不通过,可编辑删除/审核通过，只能关闭/已删除
@property (nonatomic) NSInteger state;
@property (nonatomic) NSInteger buy;
@property (nonatomic) NSInteger push;
@property (nonatomic,strong) NSString *publishUid;
@property (nonatomic) float buyPrice;

@property (nonatomic, copy) NSString *companyName;
+(BuyDetialModel *)creatBuyDetialModelByDic:(NSDictionary*)dic withResult:(NSDictionary *)result;
@end
