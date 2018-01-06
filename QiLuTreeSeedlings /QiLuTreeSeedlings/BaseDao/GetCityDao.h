//
//  GetCityDao.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/5.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "BaseDao.h"
#import "CityModel.h"
@interface GetCityDao : BaseDao
-(NSMutableArray *)getCityByLeve:(NSString *)str;
-(NSMutableArray *)getCityByLeve:(NSString *)str andParent_code:(NSString *)parent_code;
-(NSString *)getCityNameByCityUid:(NSString *)uid;
- (NSString *)getCityParentCode:(NSString *)uid;
-(CityModel *)getcityModelByCityCode:(NSString *)uid;
-(NSDictionary *)getcityDicByCityCode:(NSString *)uid;
-(CityModel *)getCityCodeByColumn1:(NSString *)Column1;
-(BOOL)deleteAction;
-(BOOL)updataActionWithAry:(NSArray *)ary;
@end
