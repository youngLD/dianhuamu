//
//  YLDSAuthorModel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/4/10.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLDSAuthorModel : NSObject
@property (nonatomic)BOOL follow;
@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *headPortrait;
@property (nonatomic,assign)NSInteger followCount;
@property (nonatomic,copy)NSString *remark;
+(YLDSAuthorModel *)modelWithDic:(NSDictionary *)dic;
+(NSMutableArray *)modelWithAry:(NSArray *)ary;
@end
