//
//  GetCityDao.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/5.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "GetCityDao.h"

@implementation GetCityDao
-(NSMutableArray *)getCityByLeve:(NSString *)str
{
    NSMutableArray *ary=[NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"select * from area where level = %@",str];
    
    FMResultSet *frs = [self executeQuery:sql];
    while(frs.next)
    {
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
//        [dic setObject:[frs stringForColumn:@"id"] forKey:@"id"];
        [dic setObject:[frs stringForColumn:@"code"] forKey:@"code"];
        [dic setObject:[frs stringForColumn:@"parent_code"] forKey:@"parent_code"];
        [dic setObject:[frs stringForColumn:@"name"] forKey:@"name"];
        [dic setObject:[frs stringForColumn:@"level"] forKey:@"level"];
        [ary addObject:dic];
    }
    
    return ary;
}
-(NSMutableArray *)getCityByLeve:(NSString *)str andParent_code:(NSString *)parent_code
{
    NSMutableArray *ary=[NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"select * from area where parent_code = %@",parent_code];
    
    FMResultSet *frs = [self executeQuery:sql];
    while(frs.next)
    {
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
//        [dic setObject:[frs stringForColumn:@"id"] forKey:@"id"];
         [dic setObject:[frs stringForColumn:@"code"] forKey:@"code"];
        [dic setObject:[frs stringForColumn:@"parent_code"] forKey:@"parent_code"];
         [dic setObject:[frs stringForColumn:@"name"] forKey:@"name"];
        [dic setObject:[frs stringForColumn:@"level"] forKey:@"level"];
        [ary addObject:dic];
        
    }
    
    return ary;
}
-(NSString *)getCityNameByCityUid:(NSString *)uid
{
    NSString *str;
    
    NSString *sql = [NSString stringWithFormat:@"select name from area where code = %@",uid];
    
    FMResultSet *frs = [self executeQuery:sql];
    while(frs.next)
    {
       str = [frs stringForColumn:@"name"];
    }
    return str;
}
- (NSString *)getCityParentCode:(NSString *)uid {

    NSString *str;

    NSString *sql = [NSString stringWithFormat:@"select * from area where code = %@",uid];

    FMResultSet *frs = [self executeQuery:sql];
    while(frs.next)
    {
        str = [frs stringForColumn:@"parent_code"];
        NSLog(@"%@",[frs stringForColumn:@"name"]);
        //NSLog(@"%@",frs);
        NSLog(@"%@",[frs stringForColumn:@"parent_code"]);
    }
    return str;
}
-(CityModel *)getcityModelByCityCode:(NSString *)uid
{
    
    
    NSString *sql = [NSString stringWithFormat:@"select * from area where code = %@",uid];
    
    FMResultSet *frs = [self executeQuery:sql];
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    while(frs.next)
    {
        
//        [dic setObject:[frs stringForColumn:@"id"] forKey:@"id"];
        [dic setObject:[frs stringForColumn:@"code"] forKey:@"code"];
        [dic setObject:[frs stringForColumn:@"parent_code"] forKey:@"parent_code"];
        [dic setObject:[frs stringForColumn:@"name"] forKey:@"name"];
        [dic setObject:[frs stringForColumn:@"level"] forKey:@"level"];
       
    }
    CityModel *model =[CityModel creatCtiyModelByDic:dic];
    model.select=YES;
    return model;
}
-(NSDictionary *)getcityDicByCityCode:(NSString *)uid
{
    
    
    NSString *sql = [NSString stringWithFormat:@"select * from area where code = %@",uid];
    
    FMResultSet *frs = [self executeQuery:sql];
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    while(frs.next)
    {
        
//        [dic setObject:[frs stringForColumn:@"id"] forKey:@"id"];
        [dic setObject:[frs stringForColumn:@"code"] forKey:@"code"];
        [dic setObject:[frs stringForColumn:@"parent_code"] forKey:@"parent_code"];
        [dic setObject:[frs stringForColumn:@"name"] forKey:@"name"];
        [dic setObject:[frs stringForColumn:@"level"] forKey:@"level"];
        
    }

    return dic;
}
- (CityModel *)getCityCodeByColumn1:(NSString *)Column1
{
    
    
    NSString *sql = [NSString stringWithFormat:@"select * from area where column1 = '%@'",Column1];
    FMResultSet *frs = [self executeQuery:sql];
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    while(frs.next)
    {
        
//        [dic setObject:[frs stringForColumn:@"id"] forKey:@"id"];
        [dic setObject:[frs stringForColumn:@"code"] forKey:@"code"];
        [dic setObject:[frs stringForColumn:@"parent_code"] forKey:@"parent_code"];
        [dic setObject:[frs stringForColumn:@"name"] forKey:@"name"];
        [dic setObject:[frs stringForColumn:@"level"] forKey:@"level"];
        
    }
    CityModel *model =[CityModel creatCtiyModelByDic:dic];
    //    model.select=YES;
    return model;
    
}
-(BOOL)deleteAction
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM area"];
    BOOL zz = [self executeUpdate:sql];
    return zz;
}
-(BOOL)updataActionWithAry:(NSArray *)ary
{
//
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO area(code, name,level,parent_code,column1) VALUES(%@,'%@',%@,%@,'%@')",ary[0],ary[1],ary[2],ary[3],ary[4]];
    BOOL zz = [self executeUpdate:sql];
    return zz;
}
@end
