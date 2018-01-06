//
//  ZIKFunction.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/29.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKFunction.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UIAlertView+Blocks.h"
#import "WXApi.h"
#import "HttpDefines.h"
#import "UIDefines.h"
//获取ip相关

#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
//#define IOS_VPN       @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"
/*********支付宝相关*********/
#define kwshZhiFuBaoZhangHao @"2088621928906045"
#define kzhifubaoSeller @"2789870571@qq.com"
#define kzhifubaoMiYao @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAN94ZUR1Ra+4zFwe2AL99XDg990VmyVhKN4bbmEB9B8BD87q/Eg2g8awP607AftaN1x4TXCWWMOEsMKm8hLky1XD2SUvOCsU/MBkfY0Xls++iDXYhRB/P6SKB8Qgz2CsQZla16ReMLVz9yJewQlMiW95RpDErgsWHAj0mITjpubdAgMBAAECgYAFxdlv3Euxj2eQFafk4+ScRuOATZeVbp4cpr7COMeyqVdcNAvSXb4nutPaSMTzVlBJzj3J48hlPJ9IWAG25TwvbaGphqpwJ92+McCJ7A4+tkfu+XsjPKvnleRtEvKmdReFqAFGGoyplKVRT+PbPtARsTa5QNdWrTGpAgcW2MwxgQJBAPrGHfSQUbnke6FjyEv5lpYeWvqDxLu7WSdYwerxeHkeQ7J7Ml1xzYvLgdNZKoqe21bpFwaztUJwUTj2Expf/T0CQQDkIJ0HjUNPA2RxCJR4HtibFb45xemoIE4jUxPYddALhh0GbMJ5S9CS5yKN82rUKlAyog3+m0vq6AUzOkd23GohAkAm/s3DrPl4baYn54tK/SnEeD3vfLQH+U8Yxj2JWjlApEskovGnBD5RQbkTc2chHSjAcAiLm0BRb4PB1soLrOeFAkEA2Tmo7Vj5P9LGIM//uEX/EeXpZk/rx3lDjmV8X0EH4wFIwCZuJFwp9sh64dpo3jCQfzZKxyePadaXpQkYpbkKoQJAc8cteEe/kpjODxWtB8vYOPLYuHvpJudhsUkgkkHu8YX5Hhkb2Z0hi3RTqklcNrrcXIQk1c9FNwK/5EHwA4YGwQ=="
/*********end支付宝相关end*********/
//#define APPDELEGATE     ((AppDelegate *)[UIApplication sharedApplication].delegate)

@implementation ZIKFunction


+ (void)zhiFuBao:(UIViewController *)controller name: (NSString*)name titile:(NSString*)title price:(NSString*)price orderId:(NSString*)orderId supplyBuyUid:(NSString *)supplyBuyUid type:(NSString *)type
{


    NSString *partner    = kwshZhiFuBaoZhangHao;
    NSString *seller     = kzhifubaoSeller;
    NSString *privateKey = kzhifubaoMiYao;

    //partner和seller获取失败,提示
    if ([partner length] == 0 || [seller length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }

    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.productName = name; //商品标题
    order.productDescription = title; //商品描述
    order.amount = price; //商品价格

    // NSMutableDictionary *infor = [[XtomManager sharedManager] myinitInfor];
    //NSString * updateURL = [infor objectForKey:@"mall_server_ip"];
//#warning 注释
    NSString * updateURL = AFBaseURLString;
    // NSString * updateURL = RequestURL;
    updateURL = [updateURL stringByAppendingString:@"apimember/pay/alipay/notify"];

    if ([type isEqualToString:@"0"]) {
    order.notifyURL =  [NSString stringWithFormat:@"%@?access_id=%@&type=%@",updateURL,orderId,type]; //回调URL
    } else if ([type isEqualToString:@"2"]) {
    order.notifyURL =  [NSString stringWithFormat:@"%@?access_id=%@&supplyBuyUid=%@&type=%@",updateURL,orderId,supplyBuyUid,type]; //回调URL
    } else if ([type isEqualToString:@"1"]){
   order.notifyURL =  [NSString stringWithFormat:@"%@?access_id=%@&supplyBuyUid=%@&type=%@",updateURL,orderId,supplyBuyUid,type]; //回调URL
    }else if ([type isEqualToString:@"3"]){
        order.notifyURL =  [NSString stringWithFormat:@"%@?access_id=%@&type=%@",updateURL,orderId,type]; //回调URL
    }else if ([type isEqualToString:@"4"]){
        order.notifyURL =  [NSString stringWithFormat:@"%@?access_id=%@&supplyBuyUid=%@&type=%@",updateURL,orderId,supplyBuyUid,type]; //回调URL
    }else if ([type isEqualToString:@"5"]){
        order.notifyURL =  [NSString stringWithFormat:@"%@?access_id=%@&supplyBuyUid=%@&type=%@",updateURL,orderId,supplyBuyUid,type]; //回调URL
    }
    else if ([type isEqualToString:@"6"]){
        order.notifyURL =  [NSString stringWithFormat:@"%@?access_id=%@&supplyBuyUid=%@&type=%@",updateURL,orderId,supplyBuyUid,type]; //回调URL
    }
//    order.notifyURL =  [NSString stringWithFormat:@"%@?access_id=%@&supplyBuyUid=\"%@\"&type=\"%@\"",updateURL,orderId,supplyBuyUid,type]; //回调URL


    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";

    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"miaoxintong";

    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    //NSLog(@"orderSpec = %@",orderSpec);

    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    //NSLog(@"%@",privateKey);
    //orderSpec = [orderSpec stringByAppendingString:[NSString stringWithFormat:@"?access_id=\"%@\"",orderId]];
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];

    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
       // NSLog(@"str=%@",orderString);
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {

            if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
                //                [kApp telSevicePaySuccess:self.oderID];
                //                UIAlertView *seccuss = [[UIAlertView alloc]initWithTitle:@"提示" message:@"支付成功！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                //                seccuss.tag = 166;
                //                [seccuss show];
//                if (APPDELEGATE.isFromSingleVoucherCenter) {
//                        
//                } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PaySuccessNotification" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CaiGouSinglePaySuccessNotification" object:nil];

                if (!APPDELEGATE.isFromSingleVoucherCenter) {
                   [[NSNotificationCenter defaultCenter] postNotificationName:@"SinglePaySuccessNotification" object:nil];
                }

                //}

                [[[UIAlertView alloc] initWithTitle:@"提示"
                                            message:@"支付成功!"
                                   cancelButtonItem:[RIButtonItem itemWithLabel:@"确定" action:^{
                    if (controller) {
//                          [controller.navigationController popViewControllerAnimated:YES];
                    }

                    //[controller.navigationController popToRootViewControllerAnimated:YES];


                }] otherButtonItems:nil, nil] show];


            }
            else if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"4000"]) {
                //NSLog(@"订单交易失败");
               // NSLog(@"%@",resultDic[@"memo"]);
                [[[UIAlertView alloc] initWithTitle:@"提示"
                                            message:@"支付失败!"
                                   cancelButtonItem:[RIButtonItem itemWithLabel:@"确定" action:^{

                    //[controller.navigationController popToRootViewControllerAnimated:YES];

                }] otherButtonItems:nil, nil] show];
            } else {
                NSLog(@"%@",resultDic);
                NSLog(@"%@",resultDic[@"memo"]);
                [[[UIAlertView alloc] initWithTitle:@"提示"
                                            message:@"支付失败!"
                                   cancelButtonItem:[RIButtonItem itemWithLabel:@"确定" action:^{

                    //[controller.navigationController popToRootViewControllerAnimated:YES];

                }] otherButtonItems:nil, nil] show];

            }
        }];


    }

}
+ (void)ADzhiFuBao:(UIViewController *)controller name: (NSString*)name titile:(NSString*)title price:(NSString*)price orderId:(NSString*)orderId supplyBuyUid:(NSString *)supplyBuyUid type:(NSString *)type
{
    
    
    NSString *partner    = kwshZhiFuBaoZhangHao;
    NSString *seller     = kzhifubaoSeller;
    NSString *privateKey = kzhifubaoMiYao;
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 || [seller length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.productName = name; //商品标题
    order.productDescription = title; //商品描述
    order.amount = price; //商品价格
    
    // NSMutableDictionary *infor = [[XtomManager sharedManager] myinitInfor];
    //NSString * updateURL = [infor objectForKey:@"mall_server_ip"];
    //#warning 注释
    NSString * updateURL = ADBaseURLString;
    // NSString * updateURL = RequestURL; 
    updateURL = [updateURL stringByAppendingString:@"/handler/aliPayReturn.ashx"];
    
    order.notifyURL =  [NSString stringWithFormat:@"%@?member_uid=%@",updateURL,orderId]; //回调URL
    
    //    order.notifyURL =  [NSString stringWithFormat:@"%@?access_id=%@&supplyBuyUid=\"%@\"&type=\"%@\"",updateURL,orderId,supplyBuyUid,type]; //回调URL
    
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"miaoxintong";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    //NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    //NSLog(@"%@",privateKey);
    //orderSpec = [orderSpec stringByAppendingString:[NSString stringWithFormat:@"?access_id=\"%@\"",orderId]];
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        // NSLog(@"str=%@",orderString);
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
            if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
                //                [kApp telSevicePaySuccess:self.oderID];
                //                UIAlertView *seccuss = [[UIAlertView alloc]initWithTitle:@"提示" message:@"支付成功！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                //                seccuss.tag = 166;
                //                [seccuss show];
                //                if (APPDELEGATE.isFromSingleVoucherCenter) {
                //
                //                } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PaySuccessNotification" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CaiGouSinglePaySuccessNotification" object:nil];
                
                if (!APPDELEGATE.isFromSingleVoucherCenter) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"SinglePaySuccessNotification" object:nil];
                }
                
                //}
                
                [[[UIAlertView alloc] initWithTitle:@"提示"
                                            message:@"支付成功!"
                                   cancelButtonItem:[RIButtonItem itemWithLabel:@"确定" action:^{
                    if (controller) {
                        //                          [controller.navigationController popViewControllerAnimated:YES];
                    }
                    
                    //[controller.navigationController popToRootViewControllerAnimated:YES];
                    
                    
                }] otherButtonItems:nil, nil] show];
                
                
            }
            else if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"4000"]) {
                //NSLog(@"订单交易失败");
                // NSLog(@"%@",resultDic[@"memo"]);
                [[[UIAlertView alloc] initWithTitle:@"提示"
                                            message:@"支付失败!"
                                   cancelButtonItem:[RIButtonItem itemWithLabel:@"确定" action:^{
                    
                    //[controller.navigationController popToRootViewControllerAnimated:YES];
                    
                }] otherButtonItems:nil, nil] show];
            } else {
                NSLog(@"%@",resultDic);
                NSLog(@"%@",resultDic[@"memo"]);
                [[[UIAlertView alloc] initWithTitle:@"提示"
                                            message:@"支付失败!"
                                   cancelButtonItem:[RIButtonItem itemWithLabel:@"确定" action:^{
                    
                    //[controller.navigationController popToRootViewControllerAnimated:YES];
                    
                }] otherButtonItems:nil, nil] show];
                
            }
        }];
        
        
    }
    
}

//微信支付
+ (NSString *)weixinPayWithOrderID:(NSString *)orderID{
    //XtomManager *manager = [XtomManager sharedManager];
    //NSString *urlString = [NSString stringWithFormat:@"%@%@%@",AFBaseURLString,@"apimember/pay/wx/notify/",orderID];
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@",AFBaseURLString,@"apimember/pay/wx/notify/",orderID];

//
    // 1.根据网址初始化OC字符串对象
    NSString *urlStr = [NSString stringWithFormat:@"%@", urlString];
    // 2.创建NSURL对象
    NSURL *url = [NSURL URLWithString:urlStr];
    // 3.创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 4.创建参数字符串对象
    NSString *parmStr = orderID;
    // 5.将字符串转为NSData对象
    NSData *pramData = [parmStr dataUsingEncoding:NSUTF8StringEncoding];
    // 6.设置请求体
    [request setHTTPBody:pramData];
    // 7.设置请求方式
    [request setHTTPMethod:@"POST"];

    // 创建同步链接
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//
    //解析服务端返回json数据
    NSError *error;
    //加载一个NSURL对象
    //NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //将请求的url数据放到NSData对象中
    //NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ( response != nil) {
        NSMutableDictionary *dict = NULL;
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        dict = [dict objectForKey:@"info"];
        if(dict != nil){
            //            NSMutableString *retcode = [dict objectForKey:@"status"];
            //            if (retcode.intValue == 1){
            NSMutableString *stamp  = [dict objectForKey:@"timestamp"];

            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.partnerId           = [dict objectForKey:@"partnerid"];//商户号
            req.prepayId            = [dict objectForKey:@"prepayid"];//预支付交易ID
            req.nonceStr            = [dict objectForKey:@"noncestr"];//随机字符串
            req.timeStamp           = stamp.intValue;//时间戳
            req.package             = [dict objectForKey:@"package"];
            req.sign                = [dict objectForKey:@"sign"];

            [WXApi sendReq:req];
            //日志输出
            return @"";
            //            }else{
            //                return [dict objectForKey:@"retmsg"];
            //            }
        }else{
            return @"服务器返回错误，未获取到json对象";
        }
    }else{
        return @"服务器返回错误";
    }

    
}

#pragma mark - 设置TableView空行分割线隐藏
// 设置TableView空行分割线隐藏
+ (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark - 字符串判空
+(Boolean)xfunc_check_strEmpty:(NSString *) parmStr  //字符串判空
{
    if (!parmStr) {
        return YES;
    }
    if ([parmStr isEqual:nil]) {
        return YES;
    }
    if ([parmStr isEqual:@""]) {
        return YES;
    }
    id tempStr=parmStr;
    if (tempStr==[NSNull null]) {
        return YES;
    }
    return NO;
}

#pragma mark - 计算指定时间与当前的时间差
+(NSString *) compareCurrentTime:(NSDate*) compareDate
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    NSInteger temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",(long)temp];
    }

    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",(long)temp];
    }

    else if((temp = temp/24)){

        if (temp/7 < 1) {
            result = [NSString stringWithFormat:@"%ld天前",(long)temp];
        }
        else {
            result = [NSString stringWithFormat:@"%ld周前",(long)temp/7];
        }
    }

//    else if((temp = temp/30) <12){
//        result = [NSString stringWithFormat:@"%ld月前",(long)temp];
//    }
//    else{
//        temp = temp/12;
//        result = [NSString stringWithFormat:@"%ld年前",(long)temp];
//    }

    return  result;
}

#pragma mark - 时间转字符串
+ (NSString*)getStringFromDate:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}

#pragma  mark -  字符串转时间
+(NSDate *)getDateFromString:(NSString *)dateString {
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    NSDate *date =[dateFormat dateFromString:dateString];
    return date;
}

#pragma mark   ==============产生随机订单号==============
+ (NSString *)generateTradeNO
{
    static int kNumber = 15;

    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

+(NSData *)imageData:(UIImage *)myimage
{
    NSData *data = UIImageJPEGRepresentation(myimage, 1.0);
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data = UIImageJPEGRepresentation(myimage, 0.1);
        }
        else if (data.length>512*1024) {//0.5M-1M
            data = UIImageJPEGRepresentation(myimage, 0.9);
        }
        else if (data.length>200*1024) {//0.25M-0.5M
            data = UIImageJPEGRepresentation(myimage, 0.9);
        }
    }
    return data;
}
+ (BOOL)xfunc_isPassword:(NSString*)password
{
    NSString *regex = @"^[a-zA-Z_0-9]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

    return [pred evaluateWithObject:password];
}
//验证数字和小数点:^[0-9]+([.]{0}|[.]{1}[0-9]+)$
+ (BOOL)xfunc_isAmount:(NSString*)amount
{
    NSString *regex = @"^[0-9]+([.]{0}|[.]{1}[0-9]+)$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

    return [pred evaluateWithObject:amount];
}
#pragma mark - 获取字符串的CGRect
//获取字符串的CGRect
+(CGRect)getCGRectWithContent:(NSString *)content width:(CGFloat)width font:(CGFloat)font{

    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                        context:nil];
    return rect;
}
/**
 *  根据内容和宽度以及字号获取字符串CGRect
 *
 *  @param content 字符串内容
 *  @param height   高度
 *  @param font    字符串字体大小
 *
 *  @return 字符串CGRect
 */
+(CGRect)getCGRectWithContent:(NSString *)content height:(CGFloat)height font:(CGFloat)font
{
    
    CGRect rect = [content boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                        context:nil];
    return rect;
}
//创造虚线
+(UIImage*)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [[UIColor clearColor] set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGFloat lengths[] = {1.5, 0.4};
    CGContextSetLineDash(context, 0, lengths, 1);
    CGContextMoveToPoint(context, 0.0, 0.0);
    CGContextAddLineToPoint(context, size.width, 0.0);
    CGContextAddLineToPoint(context, size.width, size.height);
    CGContextAddLineToPoint(context, 0, size.height);
    CGContextAddLineToPoint(context, 0.0, 0.0);
    CGContextStrokePath(context);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(NSMutableArray *)aryWithMessageAry:(NSArray *)ary1 withADAry:(NSArray *)ary2
{
    
    NSMutableArray *arys=[NSMutableArray array];
    if (ary1.count==0) {
        return arys;
    }
    for (int i=0; i<ary1.count; i++) {
        [arys addObject:ary1[i]];
        if ((i+1)%2==0) {
            NSInteger j=(i+1)/2;
            if (j<ary2.count+1) {
                [arys addObject:ary2[j-1]];
            }
        }
    }
    
    return arys;
}
+(NSMutableArray *)aryWithMessageAry:(NSArray *)ary1 withADAry:(NSArray *)ary2 andIndex:(NSInteger)index
{
    
    NSMutableArray *arys=[NSMutableArray array];
    if (ary1.count==0) {
        return arys;
    }
    NSMutableArray *adAry=[NSMutableArray arrayWithArray:ary2];
    if(index==0)
    {
        if (adAry.count>0) {
            [arys addObject:[adAry firstObject]];
            [adAry removeObjectAtIndex:0];
        }
        
    }
    if(index<2)
    {
        index=2;
    }
    for (int i=0; i<ary1.count; i++) {
        [arys addObject:ary1[i]];
        if ((i+1)%index==0) {
            if (adAry.count>0) {
                [arys addObject:adAry[0]];
                [adAry removeObjectAtIndex:0];
            }
        }
    }
    if (adAry.count>0) {
        [arys addObjectsFromArray:adAry];
    }
    return arys;
}
//oss文件路径
+(NSString *)creatFilePathWithHeardStr:(NSString *)heardStr WithTypeStr:(NSString *)typeStr
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f",a];
     NSArray * changeArray = [[NSArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9", nil];//存放十个数，以备随机取
    NSMutableString * getStr = [[NSMutableString alloc] initWithCapacity:5];
    NSMutableString * changeString = [[NSMutableString alloc] initWithCapacity:6];//申请内存空间，一定要写，要不没有效果，我自己总是吃这个亏
    for (int i = 0; i<6; i++) {
        NSInteger index = arc4random()%([changeArray count]-1);//循环六次，得到一个随机数，作为下标值取数组里面的数放到一个可变字符串里，在存放到自身定义的可变字符串
        getStr = changeArray[index];
        changeString = (NSMutableString *)[changeString stringByAppendingString:getStr];
        
    }
    NSString *dateStr;
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];

    [inputFormatter setDateFormat:@"yyyy/MM/dd"];
     dateStr = [inputFormatter stringFromDate:dat];
    NSString *PathStr=[NSString stringWithFormat:@"%@/%@/%@/%@%@",heardStr,typeStr,dateStr,timeString,changeString];
    return PathStr;
}
//获取字符串的高度
+(CGFloat)getHeightWithContent:(NSString *)content width:(CGFloat)width font:(CGFloat)font{
    
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, 999)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                        context:nil];
    return rect.size.height;
}
//　字符串转换成字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
//字典转换成字符串
+(NSString *)convertToJsonData:(NSDictionary *)dict
{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}

//获取设备当前网络IP地址
- (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ /*IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6,*/ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ /*IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4,*/ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
//    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

//获取所有相关IP信息
- (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}
+(NSArray *)readCSVDataWithfieldName:(NSString *)fieldName{
    NSString *path = [[NSBundle mainBundle] pathForResource:fieldName ofType:@"csv"];
    NSError *error = nil;
    NSString *fileContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    //取出每一行的数据
    NSArray *_allLinedStrings = [fileContents componentsSeparatedByString:@"\r\n"];
    NSLog(@"%@",_allLinedStrings);
    return _allLinedStrings;
}
//根据addressid获取地址信息
+(YLDFAddressModel *)GetAddressModelWithAddressId:(NSString *)addressid
{
   NSPredicate  *predicate = [NSPredicate predicateWithFormat:@"addressId=%@",addressid];
    NSArray *modelAry = [APPDELEGATE.addressAry filteredArrayUsingPredicate:predicate];
    NSDictionary *dic=[modelAry firstObject];
    YLDFAddressModel *model=[YLDFAddressModel creatModelWithDic:dic];
    return model;
}
@end
