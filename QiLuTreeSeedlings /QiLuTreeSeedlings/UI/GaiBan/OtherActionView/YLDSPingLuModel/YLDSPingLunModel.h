//
//  YLDSPingLunModel.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/2/24.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLDSPingLunModel : NSObject
@property (nonatomic,assign) NSInteger appreciateCount;
@property (nonatomic,assign) NSInteger isAppreciate;
@property (nonatomic,strong) NSString *comment;
@property (nonatomic,assign) NSInteger memberUid;
@property (nonatomic,strong) NSString *supplybuyUid;
@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *headUrl;
@property (nonatomic,strong) NSString *memberName;
@property (nonatomic,strong) NSString *timec;
@property (nonatomic,assign) NSInteger reply_count;
@property (nonatomic,strong) NSString *reply_str;
@property (nonatomic,assign) NSInteger reply_id;
+(YLDSPingLunModel *)modelWithDic:(NSDictionary *)dic;
+(NSArray *)aryWithAry:(NSArray *)ary;
+(YLDSPingLunModel *)modelWithChangYanDic:(NSDictionary *)dic;
+(NSArray *)aryWithChangYanAry:(NSArray *)ary;
@end
