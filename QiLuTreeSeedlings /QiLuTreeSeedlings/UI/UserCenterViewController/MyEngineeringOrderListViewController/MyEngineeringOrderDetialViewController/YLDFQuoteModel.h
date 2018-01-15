//
//  YLDFQuoteModel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/15.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLDFQuoteModel : NSObject
@property (nonatomic,copy) NSString *demand;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *partyId;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *quote;
@property (nonatomic,copy) NSString *quoteId;
@property (nonatomic,copy) NSString *headPortrait;
@property (nonatomic,copy)NSArray *attacs;
+(NSArray *)creatByAry:(NSArray *)ary;
@end
