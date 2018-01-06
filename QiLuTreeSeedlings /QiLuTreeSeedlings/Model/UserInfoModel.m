//
//  UserInfoModel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/10.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel
+(UserInfoModel *)userInfoCreatByDic:(NSDictionary *)dic
{
    UserInfoModel *model=[[UserInfoModel alloc]init];
 
    model.access_token=[dic objectForKey:@"access_token"];


    return model;
}
-(void)reloadInfoByDic:(NSDictionary *)dic
{
//    self.access_token=[dic objectForKey:@"access_token"];
    self.nickname=dic[@"nickname"];
    self.createdByPartyId=dic[@"createdByPartyId"];
    self.createdDate=dic[@"createdDate"];
    self.dataSourceId=dic[@"dataSourceId"];
    self.headPortrait=dic[@"headPortrait"];
    self.lastModifiedByPartyId=dic[@"lastModifiedByPartyId"];
    self.lastModifiedDate=dic[@"lastModifiedDate"];
    self.partyId=dic[@"partyId"];
}

@end
