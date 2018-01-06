//
//  MYKeyChainTool.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/7/22.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYKeyChainTool : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)deleteKeyData:(NSString *)service;


@end
