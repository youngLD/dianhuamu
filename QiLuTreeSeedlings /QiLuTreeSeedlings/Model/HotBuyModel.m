//
//  HotBuyModel.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/2.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "HotBuyModel.h"
#import "ZIKFunction.h"
@implementation HotBuyModel
+(HotBuyModel *)hotBuyModelCreatByDic:(NSDictionary *)dic
{
    HotBuyModel *model=[[HotBuyModel alloc]init];
    if (dic) {
        model.area=[dic objectForKey:@"area"];
        NSString *creatTime=[NSString stringWithFormat:@"%@",[dic objectForKey:@"updateTime"]];
        if ([HotBuyModel isPureNumandCharacters:creatTime]) {
            NSDate* date = [NSDate dateWithTimeIntervalSince1970:[creatTime integerValue]/1000.0];
            model.creatTime =[ZIKFunction getStringFromDate:date];
        }else{
           model.creatTime=[dic objectForKey:@"updateTime"];
        }
        
        if (model.creatTime.length==0) {
            model.creatTime=[dic objectForKey:@"time"];
        }
     
        
        if (model.creatTime) {
            model.creatTime = [model.creatTime substringToIndex:19];
            NSDate *creatTimeDate=[ZIKFunction getDateFromString:model.creatTime];
            model.timeAger=[ZIKFunction compareCurrentTime:creatTimeDate];
                
        }
        
        
        model.effective=[dic objectForKey:@"effective"];
        model.price=[dic objectForKey:@"price"];
        model.New=[[dic objectForKey:@"new"] integerValue];
         model.state=[[dic objectForKey:@"state"] integerValue];
        model.title=[dic objectForKey:@"title"];
        model.count=[[dic objectForKey:@"count"] integerValue];
        if (model.count>9999) {
            NSInteger zz=model.count/1000%10;
            if (zz>0) {
                CGFloat ff=model.count/10000.f;
                model.countS=[NSString stringWithFormat:@"%.1lf万",ff];
            }else{
                CGFloat ff=model.count/10000.f;
                model.countS=[NSString stringWithFormat:@"%.0lf万",ff];
            }
            
        }else{
            model.countS=[NSString stringWithFormat:@"%ld",model.count];
        }
        model.uid=[dic objectForKey:@"uid"];
        model.supplybuyUid=[dic objectForKey:@"supplybuyUid"];
        model.checkReason=[dic objectForKey:@"checkReason"];

        model.goldsupplier=[dic[@"goldsupplier"] integerValue];
        model.searchTime=dic[@"searchTime"];
        model.name=dic[@"productName"];
        model.unit=dic[@"unit"];
        if (!model.unit) {
            model.unit=@"棵";
        }

    }
    return model;
}
+(NSArray *)creathotBuyModelAryByAry:(NSArray *)ary
{
    NSMutableArray *Ary=[[NSMutableArray alloc]init];
    for (int i=0; i<ary.count; i++) {
        NSDictionary *dic=ary[i];
        HotBuyModel *model=[HotBuyModel hotBuyModelCreatByDic:dic];
        [Ary addObject:model];
    }
    return Ary;
}
+(HotBuyModel *)simpleBuyModelCreatByDic:(NSDictionary *)dic
{
    HotBuyModel *model=[[HotBuyModel alloc]init];
    if (dic) {
        NSInteger checkStatus=[[dic objectForKey:@"checkStatus"] integerValue];
        if (checkStatus) {
            model.state=3;
        }else
        {
            model.state=1;
        }
        
        model.title=[dic objectForKey:@"title"];
        model.uid=[dic objectForKey:@"uid"];
        model.checkReason=[dic objectForKey:@"checkReason"];
        model.effectiveTime =[[dic objectForKey:@"effectiveTime"] integerValue];
        model.details=[dic objectForKey:@"details"];
        NSInteger creatTime=[[dic objectForKey:@"updateTime"] integerValue];
        NSDate *date=[NSDate dateWithTimeIntervalSinceNow:creatTime];
        model.creatTime=[ZIKFunction getStringFromDate:date];
    }
    return model;
}
+(NSArray *)creatsimpleBuyModelAryByAry:(NSArray *)ary
{
    NSMutableArray *Ary=[[NSMutableArray alloc]init];
    for (int i=0; i<ary.count; i++) {
        NSDictionary *dic=ary[i];
        HotBuyModel *model=[HotBuyModel simpleBuyModelCreatByDic:dic];
        [Ary addObject:model];
    }
    return Ary;
}
+ (BOOL)isPureNumandCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    } 
    return YES;
}
@end
