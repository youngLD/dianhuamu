//
//  YLDZXLmodel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/2/14.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLDZXLmodel : NSObject
@property (nonatomic,strong) NSString *articleCategoryName;
@property (nonatomic,strong) NSString *articleCategoryShortName;
@property (nonatomic,strong) NSString *contentView;
@property (nonatomic,assign) NSInteger articleType;
@property (nonatomic,assign) NSInteger istop;
@property (nonatomic,assign) NSInteger tenderBuy;
@property (nonatomic,assign) CGFloat tenderPrice;
@property (nonatomic,assign) NSInteger viewTimes;
@property (nonatomic,assign) NSInteger isbuy;
@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *author;
@property (nonatomic,strong) NSString *pic;
@property (nonatomic,strong) NSArray *picAry;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *publishtimeStr;
@property(nonatomic,strong) NSString *articleCategory;
@property(nonatomic,assign) BOOL readed;
+(YLDZXLmodel *)yldZXLmodelbyDIC:(NSDictionary *)dic;
+(NSArray *)yldZXLmodelbyAry:(NSArray *)ary;
@end
