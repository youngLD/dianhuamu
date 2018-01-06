//
//  YLDZBLmodel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/2/13.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLDZBLmodel : NSObject
@property(nonatomic,strong) NSString *area;
@property(nonatomic,strong) NSString *articleCategoryName;
@property(nonatomic,strong) NSString *articleCategoryShortName;
@property(nonatomic,assign) NSInteger articleType;
@property(nonatomic,strong) NSString *biddingUnit;
@property(nonatomic,strong) NSString *contentView;
@property(nonatomic,strong) NSString *endTime;
@property(nonatomic,strong) NSString *infoNumber;
@property(nonatomic,assign) NSInteger istop;
@property(nonatomic,strong) NSString *publishTime;
@property(nonatomic,strong) NSString *publishtimeStr;
@property(nonatomic,strong) NSString *startTime;
@property(nonatomic,assign) NSInteger tenderBuy;
@property(nonatomic,assign) CGFloat tenderPrice;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *uid;
@property(nonatomic,strong) NSString *articleCategory;
@property(nonatomic,assign) BOOL readed;
+(YLDZBLmodel *)creatBYdic:(NSDictionary *)dic;
+(NSArray *)creatByAry:(NSArray *)ary;
@end
