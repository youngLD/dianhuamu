//
//  HotBuyModel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/2.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    BuyStateUnAudit=1,//1、未审核
    BuyStatePastAudit=2,//2、已审核通过
    BuyStateUnPassAudit=3,//3、审核未通过；
    BuyStateColose=4,//4、已关闭；
    BuyStateOverdue=5//5、已过期
    
} BuyModelState;

@interface HotBuyModel : NSObject
@property (nonatomic,strong) NSString *area;
@property (nonatomic,copy)   NSString *creatTime;
@property (nonatomic,strong) NSString *effective;
@property (nonatomic,strong) NSString *price;
@property (nonatomic)        NSInteger count;
@property (nonatomic,strong) NSString *countS;

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *supplybuyUid;
@property (nonatomic)NSInteger New;
@property (nonatomic)NSInteger state;
@property (nonatomic)NSInteger effectiveTime;
@property (nonatomic,strong) NSString *timeAger;
@property (nonatomic,strong) NSString *checkReason;
@property (nonatomic,strong) NSString *searchTime;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *unit;
@property (nonatomic,strong) NSString *details;
@property (nonatomic)        BOOL isRead;
//1金，2银，3铜
@property (nonatomic) NSInteger goldsupplier;
@property (nonatomic,assign) BOOL isSelect;
+(HotBuyModel *)hotBuyModelCreatByDic:(NSDictionary *)dic;
+(NSArray *)creathotBuyModelAryByAry:(NSArray *)ary;
+(HotBuyModel *)simpleBuyModelCreatByDic:(NSDictionary *)dic;
+(NSArray *)creatsimpleBuyModelAryByAry:(NSArray *)ary;
@end
