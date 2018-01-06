//
//  MYVendorToll.m
//  QiLuTreeSeedlings
//
//  Cr、eated by 杨乐栋 on 2017/7/22.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "MYVendorToll.h"
#import "MYKeyChainTool.h"
@implementation MYVendorToll
+ (NSString *)getIDFV
{
    NSString *IDFV = (NSString *)[MYKeyChainTool load:@"IDFV"];
    
    if ([IDFV isEqualToString:@""] || !IDFV) {
        
        IDFV = [UIDevice currentDevice].identifierForVendor.UUIDString;
        [MYKeyChainTool save:@"IDFV" data:IDFV];
    }
    
    return IDFV;
}
@end
