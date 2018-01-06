//
//  YLDSPingLunModel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/2/24.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDSPingLunModel.h"
#import "ZIKFunction.h"
@implementation YLDSPingLunModel
+(YLDSPingLunModel *)modelWithDic:(NSDictionary *)dic
{
    YLDSPingLunModel *model=[YLDSPingLunModel new];
    model.appreciateCount=[dic[@"appreciateCount"] integerValue];
    model.isAppreciate=[dic[@"isAppreciate"] integerValue];
    model.comment=dic[@"comment"];
    model.memberUid=dic[@"memberUid"];
    model.supplybuyUid=dic[@"supplybuyUid"];
    model.headUrl=dic[@"headUrl"];
    model.createTime=dic[@"createTime"];
    model.memberName=dic[@"memberName"];
    model.uid=dic[@"uid"];
  
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[model.createTime doubleValue]/ 1000.0];
    model.timec = [ZIKFunction compareCurrentTime:date];
   
    return model;
}
+(NSArray *)aryWithAry:(NSArray *)ary
{
    NSMutableArray *Ary=[NSMutableArray array];
    for (NSDictionary *dic in ary) {
        YLDSPingLunModel *model=[YLDSPingLunModel modelWithDic:dic];
        [Ary addObject:model];
    }
    
    return Ary;
}
+(YLDSPingLunModel *)modelWithChangYanDic:(NSDictionary *)dic
{
    YLDSPingLunModel *model=[YLDSPingLunModel new];
    model.appreciateCount=[dic[@"appreciateCount"] integerValue];
    model.isAppreciate=[dic[@"isAppreciate"] integerValue];
    model.comment=dic[@"content"];
    model.memberUid=[[dic[@"passport"] objectForKey:@"user_id"] integerValue];
    model.supplybuyUid=dic[@"supplybuyUid"];
    model.headUrl=[dic[@"passport"] objectForKey:@"img_url"];
    model.createTime=dic[@"create_time"];
    model.memberName=[dic[@"passport"] objectForKey:@"nickname"];
    model.uid=dic[@"comment_id"];
    model.appreciateCount=[dic[@"support_count"] integerValue];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[model.createTime doubleValue]/ 1000.0];
    model.timec = [ZIKFunction compareCurrentTime:date];
    model.reply_count=[dic[@"reply_count"] integerValue];
    model.reply_id=[dic[@"reply_id"] integerValue];
    return model;
}
+(NSArray *)aryWithChangYanAry:(NSArray *)ary
{
    NSMutableArray *Ary=[NSMutableArray array];
    for (NSDictionary *dic in ary) {
        YLDSPingLunModel *model=[YLDSPingLunModel modelWithChangYanDic:dic];
        [Ary addObject:model];
    }
    
    return Ary;
}
@end
