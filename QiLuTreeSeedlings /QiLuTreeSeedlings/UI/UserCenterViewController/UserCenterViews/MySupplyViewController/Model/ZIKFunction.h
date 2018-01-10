//
//  ZIKFunction.h
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/29.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YLDFAddressModel.h"
@interface ZIKFunction : NSObject
/**
 *  设置TableView空行分割线隐藏
 *
 *  @param tableView tableView description
 */
+ (void)setExtraCellLineHidden: (UITableView *)tableView;
/**
 *  字符串判空
 *
 *  @param parmStr 字符串
 *
 *  @return BOOL(YES:空 NO:非空)
 */
+(Boolean)xfunc_check_strEmpty:(NSString *) parmStr;   //字符串判空
/**
 *  与当前时间做比较
 *
 *  @param compareDate compareDate description
 *
 *  @return 时间差【多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)】
 */
+(NSString *) compareCurrentTime:(NSDate*) compareDate;
/**
 *  字符串转时间
 *
 *  @param date date description
 *
 *  @return 时间字符串
 */
+(NSString*)getStringFromDate:(NSDate*)date;
/**
 *  时间转字符串
 *
 *  @param dateString dateString description
 *
 *  @return 时间NSDate格式
 */
+(NSDate *)getDateFromString:(NSString *)dateString;

+ (NSString *)weixinPayWithOrderID:(NSString *)orderID;
+ (void)zhiFuBao:(UIViewController *)controller name:(NSString*)name titile:(NSString*)title price:(NSString*)price outTradeNo:(NSString *)outTradeNo notify_url:(NSString *)notify_url roleApplyAuditId:(NSString *)roleApplyAuditId;
+ (void)zhiFuBao:(UIViewController *)controller name: (NSString*)name titile:(NSString*)title price:(NSString*)price orderId:(NSString*)orderId supplyBuyUid:(NSString *)supplyBuyUid type:(NSString *)type
;
+ (void)ADzhiFuBao:(UIViewController *)controller name: (NSString*)name titile:(NSString*)title price:(NSString*)price orderId:(NSString*)orderId supplyBuyUid:(NSString *)supplyBuyUid type:(NSString *)type
;
+ (NSString *)generateTradeNO;
+(NSData *)imageData:(UIImage *)myimage;
/**
 *  正则判断密码
 *
 *  @param password app端 忘记密码，设置新密码时，密码长度没有做限制，会员端限制在6-20的字母、数字、下划线
 *
 *  @return return value description
 */
+ (BOOL)xfunc_isPassword:(NSString*)password;
+ (BOOL)xfunc_isAmount:(NSString*)amount;

/**
 *  根据内容和宽度以及字号获取字符串CGRect
 *
 *  @param content 字符串内容
 *  @param width   宽度
 *  @param font    字符串字体大小
 *
 *  @return 字符串CGRect
 */
+(CGRect)getCGRectWithContent:(NSString *)content width:(CGFloat)width font:(CGFloat)font;
/**
 *  根据内容和宽度以及字号获取字符串CGRect
 *
 *  @param content 字符串内容
 *  @param height   高度
 *  @param font    字符串字体大小
 *
 *  @return 字符串CGRect
 */
+(CGRect)getCGRectWithContent:(NSString *)content height:(CGFloat)height font:(CGFloat)font;
//创造虚线
+(UIImage*)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth;
//合并数组
+(NSMutableArray *)aryWithMessageAry:(NSArray *)ary1 withADAry:(NSArray *)ary2;
+(NSMutableArray *)aryWithMessageAry:(NSArray *)ary1 withADAry:(NSArray *)ary2 andIndex:(NSInteger)index;
//oss文件路径
+(NSString *)creatFilePathWithHeardStr:(NSString *)heardStr WithTypeStr:(NSString *)typeStr;
//获取字符串的高度
+(CGFloat)getHeightWithContent:(NSString *)content width:(CGFloat)width font:(CGFloat)font;
//　字符串转换成字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
//字典转换成字符串
+(NSString *)convertToJsonData:(NSDictionary *)dict;
//　获取设备ip
- (NSString *)getIPAddress:(BOOL)preferIPv4;
//读取csv文件
+(NSArray *)readCSVDataWithfieldName:(NSString *)fieldName;
//根据addressid获取地址信息
+(YLDFAddressModel *)GetAddressModelWithAddressId:(NSString *)addressid;
@end
