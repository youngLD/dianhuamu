//
//  YLDFShopModel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/20.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"
@interface YLDFShopModel : NSObject
@property (nonatomic,copy) NSString *lastTime;
@property (nonatomic,copy) NSString *descriptions;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,assign)CGFloat JJTextH;
@property (nonatomic,assign)BOOL isOpen;
+(NSArray *)creatAryByAry:(NSArray *)ary;
@end
