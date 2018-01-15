//
//  YLDFMyQuoteModel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/15.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLDFMyQuoteModel : NSObject
@property (nonatomic,copy)NSString *area;
@property (nonatomic,copy)NSString *demand;
@property (nonatomic,copy)NSString *lastTime;
@property (nonatomic,copy)NSString *productDate;
@property (nonatomic,copy)NSString *productDateStr;
@property (nonatomic,copy)NSString *quote;
@property (nonatomic,copy)NSString *quoteType;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,assign)NSInteger views;
+(NSArray *)creatByAry:(NSArray *)ary;
@end
