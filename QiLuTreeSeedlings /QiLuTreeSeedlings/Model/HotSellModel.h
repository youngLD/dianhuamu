//
//  HotSellModel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/2.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotSellModel : NSObject
@property (nonatomic,strong) NSString *area;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *updateTime;
@property (nonatomic) NSInteger edit;
@property (nonatomic,strong) NSString *count;
@property (nonatomic,strong) NSString *iamge;
@property (nonatomic,strong) NSString *iamge2;
@property (nonatomic,strong) NSString *iamge3;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *supplybuyUid;
@property (nonatomic,strong) NSString *supplybuyNurseryUid;
@property (nonatomic,strong) NSString *searchtime;
@property (nonatomic)        BOOL isRead;
//1金，2银，3铜

@property (nonatomic) NSInteger goldsupplier;
@property (nonatomic,strong) NSString *timeAger;
+(HotSellModel *)hotSellCreatByDic:(NSDictionary *)dic;
+(NSArray *)hotSellAryByAry:(NSArray *)ary;
@end
