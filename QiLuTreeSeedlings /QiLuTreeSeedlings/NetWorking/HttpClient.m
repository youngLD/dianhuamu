 //
//  HttpClient.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/2/25.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "HttpClient.h"

#import "UIDefines.h"

@implementation HttpClient
+ (instancetype)sharedClient {
    static HttpClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[HttpClient alloc] initWithBaseURL:[NSURL URLWithString:AFBaseURLString]];
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"leo" ofType:@"cer"];
        NSData * certData =[NSData dataWithContentsOfFile:cerPath];
        NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        // 是否允许,NO-- 不允许无效的证书
        [securityPolicy setAllowInvalidCertificates:YES];
        // 设置证书
        [securityPolicy setPinnedCertificates:certSet];
        securityPolicy.validatesDomainName = NO;
        
        
        
        _sharedClient.securityPolicy = securityPolicy;
         
        [_sharedClient.requestSerializer willChangeValueForKey:@"timeoutInterval"];
         _sharedClient.requestSerializer.timeoutInterval = 30.f;
        [_sharedClient.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        [_sharedClient.requestSerializer setValue:kclient_id forHTTPHeaderField:@"client_id"];
        [_sharedClient.requestSerializer setValue:kclient_secret forHTTPHeaderField:@"client_secret"];
        
        
    });
    return _sharedClient;
}
+ (instancetype)sharedADClient
{
    static HttpClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[HttpClient alloc] initWithBaseURL:[NSURL URLWithString:ADBaseURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [_sharedClient.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _sharedClient.requestSerializer.timeoutInterval = 30.f;
        [_sharedClient.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        [_sharedClient.requestSerializer setValue:@"v2" forHTTPHeaderField:@"api-version"];
    });
    return _sharedClient;
}
#pragma mark -网络异常判断
+(void)HTTPERRORMESSAGE:(NSError *)errorz
{ 
    NSString *messageStr=[errorz.userInfo objectForKey:@"NSLocalizedDescription"];
    [ToastView showTopToast:messageStr];
    RemoveActionV();
}

#pragma mark -版本检测
-(void)getVersionSuccess:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"iosVersion";
    [self GET:postURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark -修改个人信息
-(void)changeUserInfoWithToken:(NSString *)token
                  WithAccessID:(NSString *)accessID
                  WithClientID:(NSString *)clientID
              WithClientSecret:(NSString *)clientSecret
                  WithDeviceID:(NSString *)deviceID
                      withName:(NSString *)name
                Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure
{

    NSString *postURL = @"party/persons";
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
//    parmers[@"access_token"] = APPDELEGATE.userModel.access_token;
//    parmers[@"access_id"] = APPDELEGATE.userModel.access_id;
//    parmers[@"client_id"] = kclient_id;
//    parmers[@"client_secret"] = kclient_secret;
//    parmers[@"device_id"] = str;
    parmers[@"headPortrait"] = deviceID;
    parmers[@"nickname"] = name;
    parmers[@"_method"]   = @"PUT";
    
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark-修改密码
-(void)changeUserPwdWithToken:(NSString *)token
                  WithAccessID:(NSString *)accessID
                  WithClientID:(NSString *)clientID
              WithClientSecret:(NSString *)clientSecret
                  WithDeviceID:(NSString *)deviceID
               WithOldPassWord:(NSString *)oldPwd
               WithNewPassWord:(NSString *)newPwd
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];

    if (!str) {
        str=@"用户未授权";
    }
    NSString *postURL = @"api/modifypassword";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
     parmers[@"terminal"]        = @"2";
    parmers[@"oldPassword"]      = oldPwd;
    parmers[@"plainPassword"]    = newPwd;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark-取消苗圃
-(void)cancelMiaoPuWithToken:(NSString *)token
                WithAccessID:(NSString *)accessID
                WithClientID:(NSString *)clientID
            WithClientSecret:(NSString *)clientSecret
                WithDeviceID:(NSString *)deviceID
                     WithIds:(NSString *)ids
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"api/nursery/delete";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                              token,@"access_token",
                              accessID,@"access_id",
                              clientSecret,@"client_secret",
                              deviceID,@"device_id",
                              ids,@"ids",
                              nil];
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark-上传个人头像
-(void)upDataUserImageWithToken:(NSString *)token
                  WithAccessID:(NSString *)accessID
                  WithClientID:(NSString *)clientID
              WithClientSecret:(NSString *)clientSecret
                  WithDeviceID:(NSString *)deviceID
                     WithUserIamge:(UIImage *)image
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"fileUpload/uploadphotoios";
//    NSString *postURL = @"fileupload/uploadphotoios";

    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];

    NSData* imageData;
    //判断图片是不是png格式的文件
    if (UIImagePNGRepresentation(image)) {
        //返回为png图像。
        imageData = UIImagePNGRepresentation(image);
    }else {
        //返回为JPEG图像。
        imageData = UIImageJPEGRepresentation(image, 0.0001);
    }
    if (imageData.length>=1024*1024) {
        CGSize newSize = {150,150};
        imageData =  [self imageWithImageSimple:image scaledToSize:newSize];
    }
    NSString *myStringImageFile = [imageData base64EncodedStringWithOptions:(NSDataBase64Encoding64CharacterLineLength)];
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"terminal"]         = @"2";
    parmers[@"file"]             = myStringImageFile;
    parmers[@"fileName"]         = @"personHeadImage.png";
    //NSLog(@"%@",parameters);
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
-(NSData*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();

    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.

    return UIImagePNGRepresentation(newImage);
}

#pragma mark-上传图片
-(void)upDataIamge:(UIImage *)image
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"apiupload";

    NSData *iconData=UIImageJPEGRepresentation(image, 0.1);
    [self POST:postURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:iconData name:@"file" fileName:@"testImage" mimeType:@"image/png/file"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}

#pragma mark-站长信息列表
-(void)getWrokStationListWithToken:(NSString *)token
                      WithAccessID:(NSString *)accessID
                      WithClientID:(NSString *)clientID
                  WithClientSecret:(NSString *)clientSecret
                      WithDeviceID:(NSString *)deviceID
                WithWorkstationUId:(NSString *)workstationUId
                      WithAreaCode:(NSString *)areaCode
                          WithPage:(NSString *)page
                      WithPageSize:(NSString *)pageSize
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/wrokStationListoutme";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
     parmers[@"terminal"] = @"2";
    parmers[@"workstationUId"]   = APPDELEGATE.userModel.workstationUId;
    parmers[@"areaCode"]         = areaCode;
    parmers[@"page"]             = page;
    parmers[@"pageSize"]         = pageSize;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark-求购信息收藏列表
-(void)collectBuyListWithToken:(NSString *)token
                  WithAccessID:(NSString *)accessID
                  WithClientID:(NSString *)clientID
              WithClientSecret:(NSString *)clientSecret
                  WithDeviceID:(NSString *)deviceID
                      WithPage:(NSString *)page
                  WithPageSize:(NSString *)pageSize
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    
    if (!str) {
        str=@"用户未授权";
    }
    NSString *postURL = @"api/collect/buy";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                              APPDELEGATE.userModel.access_token,@"access_token",
                              APPDELEGATE.userModel.access_id,@"access_id",
                              kclient_id,@"client_id",
                              kclient_secret,@"client_secret",
                              str,@"device_id",
                              page,@"page",
                              pageSize,@"pageSize",
                              nil];
    ShowActionV();
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark-供应信息收藏列表
-(void)collectSellListWithPage:(NSString *)page
                  WithPageSize:(NSString *)pageSize
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    
    if (!str) {
        str=@"用户未授权";
    }
    NSString *postURL = @"api/collect/supply";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                              APPDELEGATE.userModel.access_token,@"access_token",
                              APPDELEGATE.userModel.access_id,@"access_id",
                              kclient_id,@"client_id",
                              kclient_secret,@"client_secret",
                              str,@"device_id",
                              page,@"page",
                              pageSize,@"pageSize",
                              nil];
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark-供应信息列表
-(void)SellListWithWithPageSize:(NSString *)pageSize
                       WithPage:(NSString *)page
               Withgoldsupplier:(NSString *)goldsupplier
                 WithSerachTime:(NSString *)searchTime
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"apisupply";
    NSMutableDictionary *parameters=[NSMutableDictionary new];
    parameters[@"fristTime"]=page;
    parameters[@"pageSize"]=pageSize;
    parameters[@"lastTime"]=searchTime;
    
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark-求购信息列表
-(void)BuyListWithWithPageSize:(NSString *)pageSize
                    WithStatus:(NSString *)status
               WithStartNumber:(NSString *)startNumber
                withSearchTime:(NSString *)searchTime
              WithSearchStatus:(NSString *)searchStatus
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"apibuy";
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    parameters[@"searchStatus"]=searchStatus;
    [parameters setObject:@"2" forKey:@"type"];
    [parameters setObject:startNumber forKey:@"page"];
    [parameters setObject:pageSize forKey:@"pageSize"];
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark-求购检索
-(void)buySearchWithPage:(NSString *)page
            WithPageSize:(NSString *)pageSize
        Withgoldsupplier:(NSString *)goldsupplier
          WithproductUid:(NSString *)productUid
         WithproductName:(NSString *)productName
            WithProvince:(NSString *)province
                WithCity:(NSString *)city
              WithCounty:(NSString *)county
          WithsearchTime:(NSString *)searchTime
        WithSearchStatus:(NSString *)searchStatus
                 WithAry:(NSArray *)ary
                 Success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"buys";
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:@"2" forKey:@"type"];
    [parameters setObject:page forKey:@"page"];
    [parameters setObject:pageSize forKey:@"pageSize"];
    if (productName) {
         [parameters setObject:productName forKey:@"productName"];
    }
    if (goldsupplier) {
        [parameters setObject:goldsupplier forKey:@"goldsupplier"];
    }
    if (productUid) {
        [parameters setObject:productUid forKey:@"productUid"];

    }
    if (province) {
        [parameters setObject:province forKey:@"province"];
    }
    if (city) {
       [parameters setObject:city forKey:@"city"];
    }
    if (county) {
        [parameters setObject:county forKey:@"county"];
    }
    parameters[@"searchStatus"]=searchStatus;
    parameters[@"searchTime"]=searchTime;
    for (int i=0; i<ary.count; i++) {
        NSDictionary *dic=ary[i];
        [parameters setObject:[dic objectForKey:@"value"] forKey:[dic objectForKey:@"field"]];
    }
    [self GET:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"%@",responseObject);
        if (![[responseObject objectForKey:@"success"] integerValue]) {
//            NSLog(@"%@",[responseObject   objectForKey:@"msg"]);
        }
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark-求购详情
-(void)buyDetailWithUid:(NSString *)uid
           WithAccessID:(NSString *)access_id
               WithType:(NSString *)type
    WithmemberCustomUid:(NSString *)memberCustomUid
                Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"apibuy/detail";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                            uid,@"uid",
                            access_id,@"access_id",
                            type,@"type",
                            memberCustomUid,@"memberCustomUid",
                              nil];
    ShowActionV();
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark-我的求购编辑
-(void)myBuyEditingWithUid:(NSString *)uid
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    if (!str) {
        str=@"用户未授权";
    }
    //NSLog(@"%@",str);
    NSString *postURL = @"api/apibuy/update";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                              APPDELEGATE.userModel.access_token,@"access_token",
                              APPDELEGATE.userModel.access_id,@"access_id",
                              str,@"device_id",
                              kclient_id,@"client_id",
                              kclient_secret,@"client_secret",
                              uid,@"uid",
                              nil];
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark-供应详情
-(void)sellDetailWithUid:(NSString *)uid
            WithAccessID:(NSString *)access_id
                 Success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"apisupply/detail";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                              uid,@"uid",
                              access_id,@"access_id",
                              nil];
    ShowActionV();
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark-热门搜索
-(void)hotkeywordWithkeywordCount:(NSString *)keyWordCount
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"apihotkeyword";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                              @"10",@"keywordCount",
                             	  nil];
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark-供应检索
-(void)sellSearchWithPage:(NSString*)page
             WithPageSize:(NSString *)pageSize
         Withgoldsupplier:(NSString *)goldsupplier
           WithProductUid:(NSString *)productUid
          WithProductName:(NSString *)productName
             WithProvince:(NSString *)province
                 WithCity:(NSString *)city
               WithCounty:(NSString *)county
           WithSearchTime:(NSString *)searchTime
                  WithAry:(NSArray *)ary
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"apisupply";
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters setObject:@"2" forKey:@"type"];
    parameters[@"type"]=@"2";
    parameters[@"pageSize"]=pageSize;
    parameters[@"productName"]=productName;
    parameters[@"goldsupplier"]=goldsupplier;
    parameters[@"productUid"]=productUid;
    parameters[@"province"]=province;
    parameters[@"city"]=city;
    parameters[@"county"]=county;
    parameters[@"lastTime"]=searchTime;
    parameters[@"fristTime"]=page;
    for (int i=0; i<ary.count; i++) {
        NSDictionary *dic=ary[i];
        [parameters setObject:[dic objectForKey:@"value"] forKey:[dic objectForKey:@"field"]];
    }
    
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       // NSLog(@"%@",responseObject);
        if([[responseObject objectForKey:@"success"] integerValue])
        {
          success(responseObject);
        }else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            RemoveActionV();
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark-根据苗木名称获取规格属性
-(void)getMmAttributeWith:(NSString *)name
                 WithType:(NSString *)type
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"apisupplybuy/getProductSpec";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                             name,@"name",
                             type,@"type",
                              nil];
    ShowActionV();
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"%@",[responseObject objectForKey:@"msg"]);
        RemoveActionV();
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark-登录
-(void)loginInWithPhone:(NSString *)phone
            andPassWord:(NSString *)passWord
                Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *device_id = [userDefaults objectForKey:@"deviceToken"];
    if (!device_id) {
        device_id=@"用户未授权";
    }
   // NSLog(@"%@",device_id);
    ShowActionV();
    NSString *postURL = @"authorize";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                              @"password",@"grant_type",
                              phone,@"username",
                              passWord,@"password",
                              kclient_id,@"client_id",
                              kclient_secret,@"client_secret",
                              device_id,@"device_id",
                              @"token",@"response_type",
                              nil];
   // NSLog(@"%@",parameters);
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        if ([[responseObject objectForKey:@"success"] integerValue]) {

        }else{
            RemoveActionV();
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
         RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
-(void)updataClient_id
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *device_id = [userDefaults objectForKey:@"deviceToken"];
    if (!device_id) {
        return;
    }
    NSString *postURL = @"api/client";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                              APPDELEGATE.userModel.access_token,@"access_token",
                              APPDELEGATE.userModel.access_id,@"access_id",
                              device_id,@"device_id",
                              kclient_id,@"client_id",
                              kclient_secret,@"client_secret",
                              device_id,@"cid",
                              @"2",@"type",
                              nil];


    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       RemoveActionV();
    }];

}
#pragma mark-帐号注册
-(void)registeredUserWithPhone:(NSString *)phone
                  withPassWord:(NSString *)password
                withRepassWord:(NSString *)repassword
                      withCode:(NSString *)code
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{

    NSString *postURL = @"register";
    
    
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                              phone,@"loginName",
                              password,@"password",
                              code,@"verificationCode",
                              nil];
    [self.requestSerializer setValue:kclient_id forHTTPHeaderField:@"client_id"];
    [self.requestSerializer setValue:kclient_secret forHTTPHeaderField:@"client_secret"];
    ShowActionV();
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark-检查用户名是否已存在
-(void)checkUserNameByloginName:(NSString *)loginName
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    
    if (!str) {
        str=@"用户未授权";
    }
    //NSLog(@"%@",str);
    NSString *postURL = @"checkLoginName";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"loginName"]     = loginName;
    ShowActionV();
    [self GET:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark-个人信息
-(void)getUserInfoByToken:(NSString *)token
               byAccessId:(NSString *)accessId
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
     NSString *str = [userdefaults objectForKey:kdeviceToken];
    
    if (!str) {
        str=@"用户未授权";
    }
    NSString *postURL = @"party/persons";
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
   
    [self GET:postURL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark -供应信息收藏
-(void)collectSupplyWithSupplyNuresyid:(NSString *)nuresyid
                               Success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    
    if (!str) {
        str=@"用户未授权";
    }
    NSString *postURL = @"api/collect/supply/save";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                              APPDELEGATE.userModel.access_token,@"access_token",
                              APPDELEGATE.userModel.access_id,@"access_id",
                              str,@"device_id",
                              kclient_id,@"client_id",
                              kclient_secret,@"client_secret",
                              nuresyid,@"supplynuresyid",
                              nil];
    ShowActionV();
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
         RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark -求购信息收藏
-(void)collectBuyWithSupplyID:(NSString *)supply_id
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    
    if (!str) {
        str=@"用户未授权";
    }
    NSString *postURL = @"api/collect/buy/save";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                              APPDELEGATE.userModel.access_token,@"access_token",
                              APPDELEGATE.userModel.access_id,@"access_id",
                              str,@"device_id",
                              kclient_id,@"client_id",
                              kclient_secret,@"client_secret",
                              supply_id,@"supply_id",
                              nil];
    ShowActionV();
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark -取消收藏
-(void)deletesenderCollectWithIds:(NSString *)ids
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    
    if (!str) {
        str=@"用户未授权";
    }
    NSString *postURL = @"api/collect/delete";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                              APPDELEGATE.userModel.access_token,@"access_token",
                              APPDELEGATE.userModel.access_id,@"access_id",
                              str,@"device_id",
                              kclient_id,@"client_id",
                              kclient_secret,@"client_secret",
                              ids,@"ids",
                              
                              nil];
    //NSLog(@"%@",ids);
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark -我的求购列表
-(void)myBuyInfoListWtihPage:(NSString *)page
                   WithState:(NSString *)state
              WithsearchTime:(NSString *)searchTime
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    
    if (!str) {
        str=@"用户未授权";
    }
    NSString *postURL = @"api/buy/my";
    NSMutableDictionary *parameters=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                              APPDELEGATE.userModel.access_token,@"access_token",
                              APPDELEGATE.userModel.access_id,@"access_id",
                              str,@"device_id",
                              kclient_id,@"client_id",
                              kclient_secret,@"client_secret",
                              //ids,@"ids",
                              page,@"page",
                              @"15",@"pageSize",
                              state,@"state",
                              nil];
    parameters[@"searchTime"]=searchTime;
    ShowActionV();
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark -我的求购信息保存
-(void)fabuBuyMessageWithUid:(NSString *)uid
                   Withtitle:(NSString *)title
                    WithName:(NSString *)name
              WithProductUid:(NSString *)productUid
                   WithCount:(NSString *)count
                   WithPrice:(NSString *)price
           WithEffectiveTime:(NSString *)effectiveTime
                  WithRemark:(NSString *)remark
                WithusedArea:(NSString *)usedArea
                     WithAry:(NSArray  *)ary
                    WithRuid:(NSString *)ruid
                withurlSring:(NSString *)urlSring
           withcompressSring:(NSString *)compressSring
         withimageDetailUrls:(NSString *)imageDetailUrls
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    
    if (!str) {
        str=@"用户未授权";
    }
    NSString *postURL ;
    if (uid) {
     postURL =[NSString stringWithFormat:@"api/buy/%@",uid];
    }else{
     postURL =@"api/buy";
    }
    NSDictionary *parameter=[NSDictionary dictionaryWithObjectsAndKeys:
                              APPDELEGATE.userModel.access_token,@"access_token",
                              APPDELEGATE.userModel.access_id,@"access_id",
                              str,@"device_id",
                              kclient_id,@"client_id",
                              kclient_secret,@"client_secret",
                              @"2",@"terminal",
                              nil];
    NSMutableDictionary *parameters=[NSMutableDictionary dictionaryWithDictionary:parameter];
    if (uid) {
        [parameters setObject:uid forKey:@"uid"];
        [parameters setObject:@"put" forKey:@"_method"];
    }
    if (title) {
        [parameters setObject:title forKey:@"title"];
    }
    if (name) {
        [parameters setObject:name forKey:@"name"];
    }
    if (productUid) {
        [parameters setObject:productUid forKey:@"productUid"];
    }
    
    if (count) {
        [parameters setObject:count forKey:@"count"];
    }
    if (price) {
        [parameters setObject:price forKey:@"price"];
    }
    if (effectiveTime) {
        [parameters setObject:effectiveTime forKey:@"effectiveTime"];
    }
    if (remark) {
        [parameters setObject:remark forKey:@"remark"];
    }
    if (usedArea) {
        [parameters setObject:usedArea forKey:@"usedArea"];
    }
    if (ruid) {
        [parameters setObject:ruid forKey:@"ruid"];
    }
    for (int i=0; i<ary.count; i++) {
        NSDictionary *dic=ary[i];
        [parameters setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"value"]] forKey:[dic objectForKey:@"field"]];
    }
    parameters[@"imageUrls"]         = urlSring;
    parameters[@"imageCompressUrls"] = compressSring;
    parameters[@"imageDetailUrls"]   = imageDetailUrls;
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark -获取企业信息
-(void)getCompanyInfoSuccess:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    
    if (!str) {
        str=@"用户未授权";
    }
    NSString *postURL = @"api/company/info";
    NSDictionary *parameter=[NSDictionary dictionaryWithObjectsAndKeys:
                             APPDELEGATE.userModel.access_token,@"access_token",
                             APPDELEGATE.userModel.access_id,@"access_id",
                             str,@"device_id",
                             kclient_id,@"client_id",
                             kclient_secret,@"client_secret",
                             nil];
    [self POST:postURL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark -保存企业信息
-(void)saveCompanyInfoWithUid:(NSString *)uid
              WithCompanyName:(NSString *)name
           WithCompanyAddress:(NSString *)companyAddress
      WithcompanyAreaProvince:(NSString *)companyAreaProvince
          WithcompanyAreaCity:(NSString *)companyAreaCity
        WithcompanyAreaCounty:(NSString *)companyAreaCounty
          WithcompanyAreaTown:(NSString *)companyAreaTown
              WithlegalPerson:(NSString *)legalPerson
                    Withphone:(NSString *)phone
                  Withzipcode:(NSString *)zipcode
                    Withbrief:(NSString *)brief
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    
    if (!str) {
      str=@"USERLOCK";
   }
    NSString *postURL = @"api/company/save";
    NSDictionary *parameter=[NSDictionary dictionaryWithObjectsAndKeys:
                             APPDELEGATE.userModel.access_token,@"access_token",
                             APPDELEGATE.userModel.access_id,@"access_id",
                             str,@"device_id",
                             kclient_id,@"client_id",
                             kclient_secret,@"client_secret",@"2",@"terminal",
                             nil];
    //NSLog(@"%@",parameter);
    NSMutableDictionary *parameters=[NSMutableDictionary dictionaryWithDictionary:parameter];
    if (uid) {
        [parameters setObject:uid forKey:@"uid"];
    }
    if (name) {
        [parameters setObject:name forKey:@"companyName"];
    }
    if (companyAddress) {
        [parameters setObject:companyAddress forKey:@"companyAddress"];
    }
    if (companyAreaProvince) {
        [parameters setObject:companyAreaProvince forKey:@"companyAreaProvince"];
    }
    if (companyAreaCounty) {
        [parameters setObject:companyAreaCounty forKey:@"companyAreaCounty"];
    }else
    {
//        [parameters setObject:@"" forKey:@"companyAreaCounty"];
    }
    
    if (companyAreaCity) {
        [parameters setObject:companyAreaCity forKey:@"companyAreaCity"];
    }else
    {
//        [parameters setObject:@"" forKey:@"companyAreaCity"];
    }
    if (companyAreaTown) {
        [parameters setObject:companyAreaTown forKey:@"companyAreaTown"];
    }else
    {
//        [parameters setObject:@"" forKey:@"companyAreaTown"];
    }
    if (legalPerson) {
        [parameters setObject:legalPerson forKey:@"legalPerson"];
    }
    
    if (phone) {
        [parameters setObject:phone forKey:@"phone"];
    }
    if (zipcode) {
        [parameters setObject:zipcode forKey:@"zipcode"];
    }
    if (brief) {
        [parameters setObject:brief forKey:@"brief"];
    }
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark -苗圃列表信息
-(void)getNurseryListWithPage:(NSString *)page
                 WithPageSize:(NSString *)pageSize
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    
    if (!str) {
        str=@"用户未授权";
    }
    NSString *postURL = @"api/nursery/list";
    NSDictionary *parameter=[NSDictionary dictionaryWithObjectsAndKeys:
                             APPDELEGATE.userModel.access_token,@"access_token",
                             APPDELEGATE.userModel.access_id,@"access_id",
                             str,@"device_id",
                             kclient_id,@"client_id",
                             kclient_secret,@"client_secret",
                             page,@"page",
                             pageSize,@"pageSize",
                             nil];
    [self POST:postURL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark -苗圃详情
-(void)nurseryDetialWithUid:(NSString *)uid
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    
    if (!str) {
        str=@"用户未授权";
    }
    NSString *postURL = @"api/nursery/info";
    NSDictionary *parameter=[NSDictionary dictionaryWithObjectsAndKeys:
                             APPDELEGATE.userModel.access_token,@"access_token",
                             APPDELEGATE.userModel.access_id,@"access_id",
                             str,@"device_id",
                             kclient_id,@"client_id",
                             kclient_secret,@"client_secret",
                             uid,@"nrseryId",
                             nil];
    [self POST:postURL parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark -添加/修改苗圃信息
-(void)saveNuresryWithUid:(NSString *)uid
          WithNurseryName:(NSString *)nurseryName
  WithnurseryAreaProvince:(NSString *)nurseryAreaProvince
      WithnurseryAreaCity:(NSString *)nurseryAreaCity
    WithnurseryAreaCounty:(NSString *)nurseryAreaCounty
      WithnurseryAreaTown:(NSString *)nurseryAreaTown
       WithnurseryAddress:(NSString *)nurseryAddress
        WithchargelPerson:(NSString *)chargelPerson
                WithPhone:(NSString *)phone
                Withbrief:(NSString *)brief
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    
    if (!str) {
        str=@"用户未授权";
    }
    NSString *postURL = @"api/nursery/save";
    NSDictionary *parameter=[NSDictionary dictionaryWithObjectsAndKeys:
                             APPDELEGATE.userModel.access_token,@"access_token",
                             APPDELEGATE.userModel.access_id,@"access_id",
                             str,@"device_id",
                             kclient_id,@"client_id",
                             kclient_secret,@"client_secret",@"2",@"terminal",
                             nil];
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithDictionary:parameter];
    parameters[@"uid"]=uid;
    parameters[@"nurseryName"]=nurseryName;
    parameters[@"nurseryAreaProvince"]=nurseryAreaProvince;
    parameters[@"nurseryAreaCity"]=nurseryAreaCity;
    parameters[@"nurseryAreaCounty"]=nurseryAreaCounty;
    parameters[@"nurseryAreaTown"]=nurseryAreaTown;
    parameters[@"nurseryAddress"]=nurseryAddress;
    parameters[@"chargelPerson"]=chargelPerson;
    parameters[@"phone"]=phone;
    parameters[@"brief"]=brief;
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark ---------- 供求发布限制 -----------
-(void)getSupplyRestrictWithToken:(NSString *)token withId:(NSString *)accessID withClientId:(NSString *)clientID withClientSecret:(NSString *)clientSecret withDeviceId:(NSString *)deviceID withType:(NSString *)typeInt success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL = @"api/supplybuy/checknursery";
    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
                              token,@"access_token",
                              accessID,@"access_id",
                              kclient_id,@"client_id",
                              kclient_secret,@"client_secret",
                              str,@"device_id",
                              typeInt,@"type",
                              nil];
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}

#pragma mark ---------- 我的供应列表 -----------
- (void)getMysupplyListWithToken:(NSString *)token withAccessId:(NSString *)accessID withClientId:(NSString *)clientID withClientSecret:(NSString *)clientSecret withDeviewId:(NSString *)deviceId withState:(NSString *)state withPage:(NSString *)page withPageSize:(NSString *)pageSize               WithsearchTime:(NSString *)searchTime success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL = @"api/supply/my";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                APPDELEGATE.userModel.access_token,@"access_token",
                                APPDELEGATE.userModel.access_id,@"access_id",
                                kclient_id,@"client_id",
                                kclient_secret,@"client_secret",
                                str,@"device_id",
                                state,@"state",
                                page,@"page",
                                pageSize,@"pageSize",
                                nil];
    parameters[@"searchTime"] = searchTime;
    ShowActionV()
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
         RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
         RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}

-(void)upDataImageIOS:(NSString *)imageString
       workstationUid:(NSString *)workstationUid
           companyUid:(NSString *)companyUid
                 type:(NSString *)type
             saveTyep:(NSString *)saveType
              Success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure {
    NSString *postURL = @"apiuploadios";
//    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
//                                imageString,@"file",
//                                @"gongyingtupian.png",@"fileName",
//                                nil];
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"file"]             = imageString;
    parmers[@"fileName"]         = @"tupian.png";
    parmers[@"workstationUid"]   = workstationUid;
    parmers[@"companyUid"]       = companyUid;
    parmers[@"type"]             = type;
    parmers[@"saveType"]         = saveType;
    if ([saveType isEqualToString:@"5"]||[saveType isEqualToString:@"4"]) {
        parmers[@"access_id"]    = APPDELEGATE.userModel.access_id;
    }
    //NSLog(@"%@",parameters);
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}


#pragma mark-上传图片
-(void)upDataImage:(UIImage *)image
           Success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure;
{
    NSString *postURL = @"apiuploadios";
    
    NSData *iconData = UIImageJPEGRepresentation(image, 0.1);
    //    self.responseSerializer =  [AFHTTPResponseSerializer serializer];//3840
    //    self.requestSerializer  = [AFHTTPRequestSerializer serializer];
    //    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    params[@"file"] = @"imagefile";
    //    params[@"fileName"] = @"imagefileName.png";
    //[GTMBase64 stringByEncodingData:iconData];
    [self POST:postURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:iconData name:@"file" fileName:@"kong" mimeType:@"image/png/file"];
        //[formData appendPartWithFileURL:[NSURL fileURLWithPath:[self documentFolderPath]] name:@"testImage" error:nil];
        //[formData appendPartWithFileURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@kong",[self documentFolderPath]]] name:@"testImage" error:nil];
        //[formData appendPartWithFileData:iconData name:@"imagefile" fileName:@"imagefileName" mimeType:@"image/png/file"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}

- (void)getTypeInfoSuccess:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure {
    NSString *postURL = @"apiproducttype";
//    NSDictionary *parameters=[NSDictionary dictionaryWithObjectsAndKeys:
//                              @"10",@"keywordCount",
//                              @"10",@"recommendCount",
//                              @"5",@"supplyCount", nil];
    ShowActionV();
    [self GET:postURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
         RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}

- (void)getProductWithTypeUid:(NSString *)typeUid
                         type:(NSString *)type
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure {
    NSString *postURL = @"apiproduct";
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                  typeUid,@"typeUid",
                                     type,@"type",nil];
    [self GET:postURL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 我的供应信息保存 -----------
- (void)saveSupplyInfoWithruid:(NSString *)ruid
                             accessId:(NSString *)accessId
                             clientId:(NSString *)clientId
                         clientSecret:(NSString *)clientSecret
                             deviceId:(NSString *)deviceId
                                  uid:(NSString *)uid
                                title:(NSString *)title
                                 name:(NSString *)name
                           productUid:(NSString *)productUid
                                count:(NSString *)count
                                price:(NSString *)price
                        effectiveTime:(NSString *)time
                               remark:(NSString *)remark
                           nurseryUid:(NSString *)nurseryUid
                            imageUrls:(NSString *)imageUrls
                    imageCompressUrls:(NSString *)imageCompressUrls
          withSpecificationAttributes:(NSArray *)etcAttributes
                      imageDetailUrls:(NSString *)imageDetailUrls
                              Success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure {

    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL ;
    if (uid) {
        postURL=[NSString stringWithFormat:@"api/supply/%@",uid];
    }else{
        postURL=@"api/supply";
    }
    NSMutableDictionary *parmers  = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]      = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]         = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]         = kclient_id;
    parmers[@"client_secret"]     = kclient_secret;
    parmers[@"device_id"]         = str;
    parmers[@"terminal"]          = @"2";
    parmers[@"terminal"]          = @"2";
//    parmers[@"uid"]               = uid;
    parmers[@"ruid"]              = ruid;
    parmers[@"title"]             = title;
    parmers[@"name"]              = name;
    parmers[@"productUid"]        = productUid;
    parmers[@"count"]             = count;
    parmers[@"price"]             = price;
    parmers[@"effectiveTime"]     = time;
    parmers[@"remark"]            = remark;
    parmers[@"nurseryUid"]        = nurseryUid;
    parmers[@"imageUrls"]         = imageUrls;
    parmers[@"imageCompressUrls"] = imageCompressUrls;
    parmers[@"imageDetailUrls"]   = imageDetailUrls;
    if (uid) {
       parmers[@"_method"]   = @"PUT";
    }
    NSArray *array = etcAttributes[0];
    for (int i=0; i<array.count; i++) {
        NSDictionary *dic=array[i];
        [parmers setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"value"]] forKey:[dic objectForKey:@"field"]];
    }

    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 我的供应信息详情 -----------
- (void)getMySupplyDetailInfoWithAccessToken:(NSString *)accesToken
                                    accessId:(NSString *)accessId
                                    clientId:(NSString *)clientId
                                clientSecret:(NSString *)clientSecret
                                    deviceId:(NSString *)deviceId
                                         uid:(NSString *)uid
                                     Success:(void (^)(id responseObject))success
                                     failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL = @"api/supply/my/detail";
    NSMutableDictionary *parmers  = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]      = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]         = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]         = kclient_id;
    parmers[@"client_secret"]     = kclient_secret;
    parmers[@"device_id"]         = str;
    parmers[@"uid"]               = uid;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 收到的我的订制信息 -----------
- (void)getMyCustomizedListInfoWithPageNumber:(NSString *)pageNumber
                                     pageSize:(NSString *)pageSize
                                      Success:(void (^)(id responseObject))success
                                      failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/member/push/record";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"pageNumber"]       = pageNumber;
    parmers[@"pageSize"]         = pageSize;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}

#pragma mark ---------- 我的定制信息列表 -----------
- (void)getCustomSetListInfo:(NSString *)pageNumber
                    pageSize:(NSString *)pageSize
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/member/push/customset";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"pageNumber"]       = pageNumber;
    parmers[@"pageSize"]         = pageSize;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];


}

#pragma mark ---------- 消费记录 -----------
- (void)getConsumeRecordInfoWithPageNumber:(NSString *)pageNumber
                                  pageSize:(NSString *)pageSize
                                   Success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/member/consume/record";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"page"]             = pageNumber;
    parmers[@"pageSize"]         = pageSize;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}

- (void)weixinPayOrder:(NSString *)price
          supplyBuyUid:(NSString *)supplyBuyUid
             recordUid:(NSString *)recordUid
                  type:(NSString *)type
               Success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure {

    NSString *postURL            = @"wxpay/broker";

    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"total_fee"]        = price;
    parmers[@"memberUid"]        = APPDELEGATE.userModel.access_id;
    ZIKFunction *zikfun=[ZIKFunction new];
    parmers[@"spbill_create_ip"]=[zikfun getIPAddress:YES];
//    parmers[@"spbill_create_ip"] = kclient_id;
    if (supplyBuyUid.length>0) {
        parmers[@"productUid"]     = supplyBuyUid;
    }else if (recordUid.length>0)
    {
        parmers[@"productUid"]        = recordUid;
    }
    parmers[@"type"]             = type;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 银联获取tn交易号方法 -----------
- (void)getUnioPay:(NSString *)price
           Success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure {
    NSString *postURL            = @"apimember/pay/unionpay/order";

    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"txnAmt"]        = price;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];


}
- (void)getUnioPayTnString:(NSString *)price
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure {
    NSString *postURL            = @"apimember/pay/unionpay/order";

    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"txnAmt"]        = price;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark-个人积分
-(void)getMyIntegralListWithPageNumber:(NSString *)pageNumber
                               Success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/integral/record";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"pageNumber"]       = pageNumber;
    parmers[@"pageSize"]         = @"15";
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 我的供应信息修改 -----------
-(void)mySupplyUpdataWithUid:(NSString *)uid
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/apisupply/update";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}

#pragma mark ---------- 我的订制设置保存 -----------
- (void)saveMyCustomizedInfo:(NSString *)uid
                  productUid:(NSString *)productUid
                usedProvince:(NSString *)usedProvince
                    usedCity:(NSString *)usedCity
 withSpecificationAttributes:(NSArray *)etcAttributes
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL = @"api/member/push/customset/create";
    NSMutableDictionary *parmers  = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]      = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]         = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]         = kclient_id;
    parmers[@"client_secret"]     = kclient_secret;
    parmers[@"device_id"]         = str;
    parmers[@"uid"]               = uid;
    parmers[@"productUid"]        = productUid;
    parmers[@"usedProvince"]      = usedProvince;
    parmers[@"usedCity"]          = usedCity;
    NSArray *array = etcAttributes[0];
    for (int i=0; i<array.count; i++) {
        NSDictionary *dic=array[i];
        [parmers setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"value"]] forKey:[dic objectForKey:@"field"]];
    }
    
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

    
}

#pragma mark ---------- 我的订制设置修改信息 -----------
- (void)getMyCustomsetEditingWithUid:(NSString *)uid
                             Success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/member/push/customset/update";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"customsetUid"]     = uid;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}

#pragma mark ---------- 我的供应信息批量删除 -----------
- (void)deleteMySupplyInfo:(NSString *)uids
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure {    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/apisupply/delete";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uids"]             = uids;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark 我的求购信息批量删除
- (void)deleteMyBuyInfo:(NSString *)uids
                Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/apibuy/delete";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uids"]             = uids;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 我的定制信息批量删除 -----------
- (void)deleteCustomSetInfo:(NSString *)uids
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/member/push/customset/deleteBatch";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uids"]             = uids;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark 我的苗圃信息批量删除
- (void)deleteMyNuseryInfo:(NSString *)uids
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/nursery/delete";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"ids"]             = uids;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}

#pragma mark ---------- 获得当前用户余额 -----------
- (void)getAmountInfo:(NSString *)nilString
              Success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/member/getamount";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
     [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 是否首次充值 -----------
- (void)isFirstRecharge:(NSString *)nilString
                Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/member/consume/isfirstcz";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark 我的收藏猜你喜欢供应列表
-(void)myCollectionYouLikeSupplyWithPage:(NSString *)pageNum
                            WithPageSize:(NSString *)pageSize
                                 Success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/collect/supplylike";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"page"]             = pageNum;
    parmers[@"pageSize"]         = pageSize;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark 求购联系方式购买
-(void)payForBuyMessageWithBuyUid:(NSString *)uid
                             type:(NSString *)type
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"apibuy/buy";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    parmers[@"type"]             = type;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark 我的求购信息关闭
-(void)closeMyBuyMessageWithUids:(NSString *)uids
                         Success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/apibuy/close";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uids"]              = uids;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark 我的求购信息打开
-(void)openMyBuyMessageWithUids:(NSString *)uids
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/apibuy/open";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uids"]              = uids;
    
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark 我的求购退回原因
-(void)MyBuyMessageReturnReasonWihtUid:(NSString *)Uid
                               Success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/apibuy/reason";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = Uid;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 购买记录 -----------
- (void)purchaseHistoryWithPage:(NSString *)page Withtype:(NSString *)type
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/member/purchaseHistory";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"page"]             = page;
    parmers[@"pageSize"]         = @"15";
    parmers[@"type"]             = type;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}

#pragma mark ---------- 购买记录删除 -----------
- (void)purchaseHistoryDeleteWithUid:(NSString *)uid
                             Success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/member/purchaseHistory/delete";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark ---------- 手动刷新供应 -----------
- (void)sdsupplybuyrRefreshWithUid:(NSString *)uid
                         Success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/sdsupplybuy/refresh";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"ids"]              = uid;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark ---------- 分享等单条非手动刷新供应 -----------
- (void)supplybuyrRefreshWithUid:(NSString *)uid
                         Success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/supplybuy/refresh";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 消息列表 -----------
-(void)messageListWithPage:(NSString *)page
              WithPageSize:(NSString *)pageSize
                 WithReads:(NSString *)reads
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/member/messageRecord";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"page"]             = page;
    parmers[@"pageSize"]         = pageSize;
    parmers[@"reads"]            = reads;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark ---------- 单条消息设置已读 -----------
-(void)myMessageReadingWithUid:(NSString *)uid
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/member/messageRecord/read";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]             = uid;

    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark ---------- 批量消息删除 -----------
-(void)myMessageDeleteWithUid:(NSString *)uids
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/member/messageRecord/delete";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"ids"]             = uids;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark ---------- 验证手机号是否存在 -----------
-(void)checkPhoneNum:(NSString *)phone
             Success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/member/checkPhone";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"phone"]             = phone;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark ---------- 忘记密码，验证手机验证码是否正确 -----------
-(void)checkChongzhiPassWorldWihtPhone:(NSString *)phone
                              WithCode:(NSString *)code
                               Success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure{
    NSString *postURL            = @"api/member/checkVerificationCode";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"phone"]             = phone;
    parmers[@"code"]             = code;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark ---------- 设置新密码 -----------
-(void)setNewPassWordWithPhone:(NSString *)phone
                  WithPassWord:(NSString *)password
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure{
    NSString *postURL            = @"api/member/resetPwd";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"phone"]             = phone;
    parmers[@"password"]          = password;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}


#pragma mark ---------- 我的供应详情-分享供应 -----------
-(void)supplyShareWithUid:(NSString *)uid
               nurseryUid:(NSString *)nurseryUid
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/supply/share";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    parmers[@"nurseryUid"]       = nurseryUid;

    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark ---------- 我的订制信息 -----------
-(void)customizationUnReadWithPageSize:(NSString *)pageSize
                            PageNumber:(NSString *)pageNumber
                              infoType:(NSInteger)infoType
                               Success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
//    NSString *postURL            = @"api/member/push/record";
    NSString *postURL            = nil;
    if (infoType == 0) {
        postURL = @"api/member/push/record";
    } else if (infoType == 1) {
        postURL = @"api/workstation/purchase/push/record";
    }

    //经纪人推送信息接口:api/member/push/broker
    //参数：  int pageNumber,
    //int pageSize,
    //String type, （3：供应，4：求购）
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    if (infoType == 3) {
        postURL = @"api/member/push/broker";
        parmers[@"type"]        = @"3";
    } else if (infoType == 4) {
        postURL = @"api/member/push/broker";
        parmers[@"type"]        = @"4";
    }else if (infoType == 5) {
        postURL = @"api/member/push/broker";
        parmers[@"type"]        = @"5";
    }
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"pageNumber"]       = pageNumber;
    parmers[@"pageSize"]         = pageSize;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}

#pragma mark ---------- 按产品ID查询订制信息 -----------
- (void)recordByProductWithProductUid:(NSString *)productUid
                             infoType:(NSInteger)infoType
                             pageSize:(NSString *)pageSize
                              Success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
//    NSString *postURL            = @"api/member/push/recordByProduct";
    NSString *postURL            = nil;
    if (infoType == 0||infoType == 3||infoType == 4||infoType == 5) {
         postURL = @"api/member/push/recordByProduct";
    } else if (infoType == 1) {
        postURL = @"api/workstation/purchase/push/recordByProduct";
    }
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    if (infoType == 3||infoType == 4 ||infoType == 5) {
        parmers[@"type"]        = [NSString stringWithFormat:@"%ld",infoType];
    }
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
//#warning pageNumber pageSize
    parmers[@"pageNumber"]       = pageSize;
    parmers[@"pageSize"]         = @"15";
    parmers[@"productUid"]       = productUid;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 批量删除订制信息（按条） -----------
- (void)deleterecordWithIds:(NSString *)ids
                   infoType:(NSInteger)infoType
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
//    NSString *postURL            = @"api/member/push/deleterecord";
    NSString *postURL            = nil;
    if (infoType == 0||infoType == 3||infoType == 4) {
        postURL = @"api/member/push/deleterecord";
    } else if (infoType == 1) {
        postURL = @"api/workstation/purchase/push/delete";
    }
    else if (infoType == 5) {
        postURL = @"api/member/push/deletepurchaseinfo";
    }
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    if (infoType == 3||infoType == 4) {
        parmers[@"type"]     = [NSString stringWithFormat:@"%ld",infoType];
    }
    
    if (infoType ==5) {
        parmers[@"mesUids"]       = ids;
    }else{
       parmers[@"ids"]       = ids;
    }
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]       = str;
    
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark ---------- 批量删除订制信息（按树种） -----------
- (void)deleteprorecordWithIds:(NSString *)ids
                      infoType:(NSInteger)infoType
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
//    NSString *postURL            = @"api/member/push/deleteprorecord";
    NSString *postURL            = nil;
    if (infoType == 0||infoType==3||infoType==4) {
        postURL = @"api/member/push/deleteprorecord";
    } else if (infoType == 1) {
        postURL = @"api/workstation/purchase/push/deletebyproduct";
    }else if (infoType == 5) {
        postURL = @"api/member/push/deletepurchaseinfobyproduct";
    }
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    if (infoType==3||infoType==4) {
       parmers[@"type"]        = [NSString stringWithFormat:@"%ld",infoType];
    }
    if (infoType==5) {
        parmers[@"productUids"]              = ids;
    }else{
      parmers[@"ids"]              = ids;
    }
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}



#pragma mark ---------- 求购分享 -----------
- (void)buyShareWithUid:(NSString *)uid
                  state:(NSString *)state
                Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure {

    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = [NSString stringWithFormat:@"api/buys/%@/share",uid];
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"state"]            = state;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {


    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}


#pragma mark ---------- 按树名获取苗木规格属性 -----------
-(void)huoqumiaomuGuiGeWithTreeName:(NSString *)name
                            andType:(NSString *)type andMain:(NSString *)main
                            Success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure{
  
    NSString *postURL            = @"apisupplybuy/getProductSpec";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"name"]        = name;
    parmers[@"type"]        = type;
    parmers[@"main"]        = main;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 根据关联规格ID获取下一级 -----------
-(void)huoquxiayijiguigeWtithrelation:(NSString *)relation
                              Success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"apinextspec";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"relation"]     = relation;

    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 积分兑换规则 -----------
- (void)integraRuleSuccess:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure {
           NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
           NSString *str                = [userdefaults objectForKey:kdeviceToken];
           NSString *postURL            = @"api/integral/exchange/rule";
           NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
           parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
           parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
           parmers[@"client_id"]        = kclient_id;
           parmers[@"client_secret"]    = kclient_secret;
           parmers[@"device_id"]        = str;
           ShowActionV();
           [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
               
               
           
           } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               success(responseObject);
               RemoveActionV();
           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               failure(error);
               RemoveActionV();
               [HttpClient HTTPERRORMESSAGE:error];
           }];
}

#pragma mark ---------- 积分兑换 -----------
- (void)integralrecordexchangeWithIntegral:(NSString *)integral
                                 withMoney:(NSString *)money
                                   Success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/integral/record/exchange";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"integral"]         = integral;
    parmers[@"money"]            = money;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {


    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark ---------- 使用帮助 -----------
-(void)userHelpSuccess:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"memhelp/lists";
    ShowActionV();
    [self POST:postURL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}


#pragma mark ---------- 工程助手API -----------
/*******************工程助手API*******************/

#pragma mark ---------- 我的订单列表 -----------
/**
 *  我的订单列表
 *
 *  @param status     订单状态 1：报价中；0：已结束
 *  @param keywords   检索词
 *  @param pageNumber 当前页码， 默认1
 *  @param pageSize   每页显示数，默认15
 *  @param success    success description
 *  @param failure    failure description
 */
- (void)projectGetMyOrderListWithStatus:(NSString *)status
                         keywords:(NSString *)keywords
                       pageNumber:(NSString *)pageNumber
                         pageSize:(NSString *)pageSize
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure {
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/order/my/list";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"pageNumber"]       = pageNumber;
    parmers[@"pageSize"]         = pageSize;
    if (keywords) {
        parmers[@"keywords"]         = keywords;
    }
    if (status) {
        parmers[@"status"]           = status;

    }
//    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
//        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
//        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 获取订单类型 -----------
- (void)stationGetOrderTypeSuccess:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/ordertype";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark ---------- 获取质量要求、报价要求、订单类型 -----------
-(void)huiquZhiliangYaoQiuBaoDingSuccess:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure

{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/zidian";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark ---------- 发布工程订单 -----------
-(void)fabuGongChengDingDanWithUid:(NSString *)uid WithprojectName:(NSString *)projectName
                     WithorderName:(NSString *)orderName
                  WithorderTypeUid:(NSString *)orderTypeUid
                  WithusedProvince:(NSString *)usedProvince
                      WithusedCity:(NSString *)usedCity
                       WithendDate:(NSString *)endDate
                  WithchargePerson:(NSString *)chargePerson
                         Withphone:(NSString *)phone
            WithqualityRequirement:(NSString *)qualityRequirement
             WithquotationRequires:(NSString *)quotationRequires
                           Withdbh:(NSString *)dbh
                WithgroundDiameter:(NSString *)groundDiameter
                   Withdescription:(NSString *)description
                              With:(NSString *)itemjson
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/order/create";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"terminal"]        = @"2";
    parmers[@"uid"]              =uid;
    parmers[@"projectName"]      =projectName;
    parmers[@"orderName"]        =orderName;
    parmers[@"orderTypeUid"]     =orderTypeUid;
    parmers[@"usedProvince"]     =usedProvince;
    parmers[@"usedProvinceName"] =usedCity;
    parmers[@"endDate"]          =endDate;
    parmers[@"chargePerson"]     =chargePerson;
    parmers[@"phone"]            =phone;
    parmers[@"qualityRequirement"]=qualityRequirement;
    parmers[@"quotationRequires"]=quotationRequires;
    parmers[@"dbh"]              =dbh;
    parmers[@"groundDiameter"]   =groundDiameter;
    parmers[@"description"]      =description;
    parmers[@"itemjson"]         =itemjson;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}

#pragma mark ---------- 工程中心分享 -----------
- (void)GCZXShareSuccess:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/company/share";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark ---------- 我的订单详情 -----------
-(void)myDingDanDetialWithUid:(NSString *)uid
                 WithPageSize:(NSString *)pageSize
                  WithPageNum:(NSString *)pageNumber
                  Withkeyword:(NSString *)keyword
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/order/my/detail";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    if (keyword) {
        parmers[@"keyword"]      = keyword;
    }
    parmers[@"pageNumber"]       = pageNumber;
    parmers[@"pageSize"]         = pageSize;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        //        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        //        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 报价管理-----------
-(void)baojiaGuanLiWithStatus:(NSString *)status
                  Withkeyword:(NSString *)keyword
               WithpageNumber:(NSString *)pageNumber
                 WithpageSize:(NSString *)pageSize
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/company/quote/list";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    if (status) {
        parmers[@"status"]           = status;
    }
    if (keyword) {
        parmers[@"keyword"]          = keyword;
    }
    parmers[@"pageNumber"]       = pageNumber;
    parmers[@"pageSize"]         = pageSize;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 报价详情-苗木信息-----------
-(void)baojiaDetialMiaoMuWtihUid:(NSString *)uid
                         Success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/company/quote/detail/item";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark ---------- 报价详情-报价信息-----------
-(void)baojiaDetialMessageWithUid:(NSString *)uid
                      WithkeyWord:(NSString *)keyword
                   WithpageNumber:(NSString *)pageNumber
                     WithpageSize:(NSString *)pageSize
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/company/quote/detail";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    if (keyword) {
        parmers[@"keyword"]      = keyword;
    }
    parmers[@"pageNumber"]       = pageNumber;
    parmers[@"pageSize"]         = pageSize;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark ---------- 金牌供应 -----------
- (void)GoldSupplrWithPageSize:(NSString *)pageSize WithPage:(NSString *)page
              Withgoldsupplier:(NSString *)goldsupplier
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"apisupplyGold";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"page"]            = page;
    parmers[@"pageSize"]        = pageSize;
    parmers[@"goldsupplier"]    = goldsupplier;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}


#pragma mark ---------- 建立合作 -----
-(void)jianliHezuoWithBaoJiaID:(NSString *)uid   Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/company/quote/cooperate";
    
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    
    parmers[@"uid"]              =uid;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 工作站详情 -----------
-(void)workstationdetialWithuid:(NSString *)uid
                 WithpageNumber:(NSString *)pageNumber
                   WithpageSize:(NSString *)pageSize
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/company/workstationList/detail";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    parmers[@"pageNumber"]       = pageNumber;
    parmers[@"pageSize"]         = pageSize;
    
    
    // parmers[@"address"]         = address;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark ---------- 进入资质审核信息填写页面，获取之前的审核数据-----------
-(void)gongchenggongsiShengheTuiHuiBianJiSuccess:(void (^)(id responseObject))success
                                         failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/apply/company/info";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark ---------- 工程助手－我的订单基本信息编辑-----------
-(void)wodedingdanbianjiWithUid:(NSString *)uid Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/order/my/update";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 工程助手－订单苗木编辑信息-----------
-(void)dingdanMMbianjiWithUid:(NSString *)uid Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/order/updateItem";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 工程助手－订单苗木更新-----------
-(void)dingdanMMgengxinWithUid:(NSString *)uid
                      WithName:(NSString *)name
                  Withquantity:(NSString *)quantity
                      Withunit:(NSString *)unit
                Withdecription:(NSString *)decription Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/order/doUpdateItem";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    parmers[@"name"]             = name;
    parmers[@"quantity"]         = quantity;
    parmers[@"decription"]       = decription;
    parmers[@"unit"]             = unit;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 工程助手－站长供应信息列表-----------
-(void)zhanzhanggongyingListWithPageNum:(NSString *)pageNumber WithPageSize:(NSString *)pageSize WithsearchTime:(NSString *)searchTime
                                Success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/company/supplylist";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"pageNumber"]              = pageNumber;
    parmers[@"pageSize"]         = pageSize;
    parmers[@"searchTime"]       = searchTime;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 工程助手－站长供应信息检索-----------
-(void)ZhanZhanggongyingListWithPage:(NSString*)page
                        WithPageSize:(NSString *)pageSize
                    Withgoldsupplier:(NSString *)goldsupplier
                      WithProductUid:(NSString *)productUid
                     WithProductName:(NSString *)productName
                        WithProvince:(NSString *)province
                            WithCity:(NSString *)city
                          WithCounty:(NSString *)county
                             WithAry:(NSArray *)ary
                      WithSearchTime:(NSString *)searchTime
                             Success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"api/project/supply/search";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    parameters[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parameters[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parameters[@"client_id"]        = kclient_id;
    parameters[@"client_secret"]    = kclient_secret;
    parameters[@"device_id"]        = str;
    
    parameters[@"pageNumber"]=page;
    parameters[@"pageSize"]=pageSize;
    parameters[@"productName"]=productName;
    
    parameters[@"goldsupplier"]=goldsupplier;
    parameters[@"productUid"]=productUid;
    parameters[@"province"]=province;
    parameters[@"city"]=city;
    parameters[@"county"]=county;
    parameters[@"searchTime"]=searchTime;
    for (int i=0; i<ary.count; i++) {
        NSDictionary *dic=ary[i];
        [parameters setObject:[dic objectForKey:@"value"] forKey:[dic objectForKey:@"field"]];
    }
    
    [self POST:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}

#pragma mark ---------- 工程助手－工程中心----------
-(void)gongchengZhongXinInfoSuccess:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/company";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    
    
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 工程助手－工程信息编辑----------
-(void)gongchengZhongXinInfoEditWithUid:(NSString *)uid WithcompanyName:(NSString *)companyName WithlegalPerson:(NSString *)legalPerson Withphone:(NSString *)phone Withbrief:(NSString *)brief Withprovince:(NSString *)province WithCity:(NSString *)city Withcounty:(NSString *)county
                            WithAddress:(NSString *)address
                                Success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/company/update";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    parmers[@"companyName"]      = companyName;
    parmers[@"legalPerson"]      = legalPerson;
    parmers[@"phone"]            = phone;
    parmers[@"brief"]            = brief;
    parmers[@"brief"]            = brief;
    parmers[@"province"]         = province;
    if (city) {
        parmers[@"city"]         = city;
    }
    if (county) {
        parmers[@"county"]        = county;
    }
    parmers[@"address"]         = address;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark ---------- 工程助手－我的资质----------
-(void)GCZXwodezizhiWithuid:(NSString *)uid
             WithpageNumber:(NSString *)pageNumber
               WithpageSize:(NSString *)pageSize
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/qualification/list";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]      = uid;
    parmers[@"pageNumber"]      = pageNumber;
    parmers[@"pageSize"]            = pageSize;
    
    // parmers[@"address"]         = address;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 工程助手－工程助手首页--------
-(void)GCGSshouyeWithPageSize:(NSString *)pageSize WithsupplyCount:(NSString *)supplyCount
             WithsupplyNumber:(NSString *)supplyNumber                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/company/index";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"supplyCount"]      = supplyCount;
    parmers[@"pageSize"]         = pageSize;
    parmers[@"supplyNumber"]         = supplyNumber;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
    
}
#pragma mark ---------- 工程助手－我的资质保存--------
-(void)GCGSRongYuTijiaoWithuid:(NSString *)uid
      WtihcompanyQualification:(NSString *)companyQualification
           WithacquisitionTime:(NSString *)acquisitionTime
                          With:(NSString *)level
                WithcompanyUid:(NSString *)companyUid
          WithissuingAuthority:(NSString *)issuingAuthority
                      WithType:(NSString *)Type 
                Withattachment:(NSString *)attachment   Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/qualification/create";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    if (uid) {
        parmers[@"uid"]      = uid;
    }
    
    parmers[@"companyQualification"]= companyQualification;
    parmers[@"acquisitionTime"]         = acquisitionTime;
    parmers[@"level"]         = level;
    parmers[@"companyUid"]         = companyUid;
    parmers[@"issuingAuthority"]         = issuingAuthority;
    parmers[@"attachment"]         = attachment;
     parmers[@"type"]         = Type;
    
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 工程助手－我的资质删除-------
-(void)GCZXDeleteRongYuWithuid:(NSString *)uid
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/qualification/delete";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    
    
    // parmers[@"address"]         = address;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 合作详情 -----
-(void)hezuoDetialWithorderUid:(NSString *)orderUid withitemUid:(NSString *)itemUid
                   WithPageNum:(NSString *)pageNumber
                  WithPageSize:(NSString *)pageSize
                   WithKeyWord:(NSString *)keyword
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/company/quote/cooperate/detail";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"pageNumber"]       = pageNumber;
    parmers[@"pageSize"]         = pageSize;
    if (keyword) {
        parmers[@"keyword"]      = keyword;
    }
    
    if (orderUid) {
        parmers[@"orderUid"]         = orderUid;
    }
    if (itemUid) {
        parmers[@"itemUid"]      = itemUid;
    }
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark ---------- 站长助手－审核工程订单 -----------
- (void)shenhedingdanWithUid:(NSString *)uid WithauditStatus:(BOOL)auditStatus Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/order/audit";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    if (auditStatus) {
        parmers[@"auditStatus"]      = @"1";
    }else{
        parmers[@"auditStatus"]      = @"0";
    }
    
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
/******************* end 工程助手API  end*******************/
-(void)jiaoyanfanhuideshuju:(NSString *)postStr Parmers:(NSDictionary *)parmers
{
    // 1.根据网址初始化OC字符串对象
    NSString *urlStr = [NSString stringWithFormat:@"%@",AFBaseURLString];
    // 2.创建NSURL对象
    NSURL *url = [NSURL URLWithString:urlStr];
    // 3.创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 4.创建参数字符串对象
    NSMutableString *parmStr;
    NSArray *keyArrays = [parmers allKeys];
    for (int i=0; i<keyArrays.count; i++) {
        NSString *keyStr=keyArrays[i];
        NSString *valueStr=parmers[keyStr];
        NSString *tempStr=[NSString stringWithFormat:@"%@=%@",keyStr,valueStr];
        [parmStr appendString:tempStr];
    }
    
    // 5.将字符串转为NSData对象
    NSData *pramData = [parmStr dataUsingEncoding:NSUTF8StringEncoding];
    // 6.设置请求体
    [request setHTTPBody:pramData];
    // 7.设置请求方式
    [request setHTTPMethod:@"POST"];
    
    // 创建同步链接
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *str1 = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",str1);
}

#pragma mark ---------- 站长助手API -----------
/*******************站长助手API*******************/
#pragma mark ---------- 检索工程订单 -----------
/**
 *  检索工程订单
 *
 *  @param orderBy      排序，发布时间：orderDate,截止日期：endDate,默认orderDate
 *  @param orderSort    排序，升序：asc,降序：desc,默认desc
 *  @param status       0:已结束，1：报价中，2：已报价
 *  @param orderTypeUid 订单类型ID
 *  @param area         用苗地，Json格式， [{"provinceCode":"11", "cityCode":"110101"},{"provinceCode":"11", "cityCode":"110102"}]
 *  @param pageNumber   当前页码， 默认1
 *  @param pageSize     每页显示数，默认15
 *  @param success      success description
 *  @param failure      failure description
 */
- (void)stationGetOrderSearchWithOrderBy:(NSString *)orderBy
                               orderSort:(NSString *)orderSort
                                  status:(NSString *)status
                            orderTypeUid:(NSString *)orderTypeUid
                                    area:(NSString *)area
                              pageNumber:(NSString *)pageNumber
                                pageSize:(NSString *)pageSize
                                 Success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/workstation/order/search";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"orderBy"]          = orderBy;
    parmers[@"orderSort"]        = orderSort;
    parmers[@"status"]           = status;
    parmers[@"orderTypeUid"]     = orderTypeUid;
    parmers[@"area"]             = area;
    parmers[@"pageNumber"]       = pageNumber;
    parmers[@"pageSize"]         = pageSize;
    
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 我的分享 -----------
-(void)getMyShareSuccess:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/integral/invitation";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
//    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 站长助手-我的报价 -----------
/**
 *  我的报价
 *
 *  @param status     状态1：已报价；2：已合作；3:已过期；默认所有
 *  @param keyword    检索词
 *  @param pageNumber 页码，默认1
 *  @param pageSize   每页显示数，默认15
 *  @param success    success description
 *  @param failure    failure description
 */
- (void)stationMyQuoteListWithStatus:(NSString *)status
                         Withkeyword:(NSString *)keyword
                      WithpageNumber:(NSString *)pageNumber
                        WithpageSize:(NSString *)pageSize
                             Success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/quote/my/list";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    if (status) {
        parmers[@"status"]       = status;
    }
    if (keyword) {
        parmers[@"keyword"]      = keyword;
    }
    parmers[@"pageNumber"]       = pageNumber;
    parmers[@"pageSize"]         = pageSize;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 站长助手-检索订单详情 -----------
/**
 *  检索订单详情
 *
 *  @param orderUid 订单ID
 *  @param keyword  检索关键词
 *  @param success  success description
 *  @param failure  failure description
 */
- (void)stationGetOrderDetailWithOrderUid:(NSString *)orderUid
                                  keyword:(NSString *)keyword
                                  Success:(void (^)(id responseObject))success
                                  failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/workstation/order/search/detail";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"orderUid"]         = orderUid;
    parmers[@"keyword"]          = keyword;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}


#pragma mark ---------- 站长助手-报价 -----------
/**
 *  报价
 *
 *  @param uid          订单苗木ID
 *  @param orderUid     订单ID
 *  @param price        报价价格
 *  @param quantity     报价数量
 *  @param province     苗圃 省
 *  @param city         苗圃 市
 *  @param county       苗圃 县
 *  @param town         苗圃 镇
 *  @param description  描述
 *  @param imags        大图‘,’分割
 *  @param compressImgs 缩略图‘,’分割
 *  @param success      success description
 *  @param failure      failure description
 */
- (void)stationQuoteCreateWithUid:(NSString *)uid
                         orderUid:(NSString *)orderUid
                            price:(NSString *)price
                         quantity:(NSString *)quantity
                         province:(NSString *)province
                             city:(NSString *)city
                           county:(NSString *)county
                             town:(NSString *)town
                      description:(NSString *)description
                             imgs:(NSString *)imags
                     compressImgs:(NSString *)compressImgs
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/quote/create";

    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;

    parmers[@"uid"]              = orderUid;
    parmers[@"orderUid"]         = uid;
    parmers[@"price"]            = price;
    parmers[@"quantity"]         = quantity;
    parmers[@"province"]         = province;
    parmers[@"city"]             = city;
    parmers[@"county"]           = county;
    parmers[@"town"]             = town;
    parmers[@"description"]      = description;
    parmers[@"imgs"]             = imags;
    parmers[@"compressImgs"]     = compressImgs;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}


     //#pragma mark ---------- APP设置首次充值最低额度 -----------
     //- (void)getLimitChargeSuccess:(void (^)(id responseObject))success
     //                      failure:(void (^)(NSError *error))failure {
     //    NSString *postURL            = @"getLimitCharge";
     //
     //    [self POST:postURL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
     //
     //    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     //        success(responseObject);
     //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     //        failure(error);
     //        [HttpClient HTTPERRORMESSAGE:error];
     //    }];
     //
     //}
#pragma mark ---------- 站长中心 -----------
- (void)stationMasterSuccess:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/workstation/master";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}


#pragma mark ---------- 站长中心编辑 -----------
/**
 *  站长中心编辑
 *
 *  @param chargePerson 负责人
 *  @param phone        电话
 *  @param brief        简介，说明
 *  @param success      success description
 *  @param failure      failure description
 */
- (void)stationMasterUpdateWithChargePerson:(NSString *)chargePerson
                                      phone:(NSString *)phone
                                      brief:(NSString *)brief
                                    Success:(void (^)(id responseObject))success
                                    failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/workstation/master/update";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"chargelPerson"]     = chargePerson;
    parmers[@"phone"]            = phone;
    parmers[@"brief"]            = brief;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}


#pragma mark ---------- 我的荣誉列表 -----------
/**
 *  我的荣誉列表
 *
 *  @param workstationUid 工作站ID
 *  @param pageNumber     页码，默认1
 *  @param pageSize       每页显示数。默认10
 *  @param success        success description
 *  @param failure        failure description
 */
- (void)stationHonorListWithWorkstationUid:(NSString *)workstationUid
                                pageNumber:(NSString *)pageNumber
                                  pageSize:(NSString *)pageSize
                                   Success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/workstation/honor/list";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"workstationUid"]   = workstationUid;
    parmers[@"pageNumber"]       = pageNumber;
    parmers[@"pageSize"]         = pageSize;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}

#pragma mark ---------- 荣誉详情与编辑页信息共用接口 -----------
/**
 *  荣誉详情与编辑页信息共用接口
 *
 *  @param uid     荣誉ID
 *  @param success success description
 *  @param failure failure description
 */
- (void)stationHonorDetailWithUid:(NSString *)uid
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/workstation/honor/detail";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 荣誉添加 -----------
/**
 *  荣誉添加
 *
 *  @param uid             新增是为空，更新是必传
 *  @param workstationUid  工作站ID
 *  @param name            荣誉名称
 *  @param acquisitionTime 获取时间，格式：yyyy-MM-dd
 *  @param image           荣誉
 
 *  @param success         success description
 *  @param failure         failure description
 */
- (void)stationHonorCreateWithUid:(NSString *)uid
                   workstationUid:(NSString *)workstationUid
                             name:(NSString *)name
                  acquisitionTime:(NSString *)acquisitionTime
                            image:(NSString *)image
                             Type:(NSString *)type
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/workstation/honor/create";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    parmers[@"type"]             = type;
    parmers[@"workstationUid"]   = workstationUid;
    parmers[@"name"]             = name;
    parmers[@"acquisitionTime"]  = acquisitionTime;
    parmers[@"image"]            = image;

    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}

#pragma mark ---------- 荣誉删除 -----------
/**
 *  荣誉删除
 *
 *  @param uid     荣誉ID
 *  @param success success description
 *  @param failure failure description
 */
- (void)stationHonorDeleteWithUid:(NSString *)uid
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/workstation/honor/delete";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 我的团队 -----------
/**
 *  我的团队
 *
 *  @param uid        工作站ID
 *  @param pageNumber 页码，默认1
 *  @param pageSize   每页显示数。默认10
 *  @param success    success description
 *  @param failure    failure description
 */
- (void)stationTeamWithUid:(NSString *)uid
                pageNumber:(NSString *)pageNumber
                  pageSize:(NSString *)pageSize
                   keyword:(NSString *)keyword
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/workstation/team";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    parmers[@"pageNumber"]       = pageNumber;
    parmers[@"pageSize"]         = pageSize;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}



#pragma mark ---------- 站长中心分享 -----------
- (void)stationShareSuccess:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/workstation/share";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 店铺分享 -----------
- (void)shopShareWithMemberUid:(NSString *)memberUid
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"shop/share";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"memberUid"]        = memberUid;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 站长助手－报价获取苗木信息 -----------
- (void)getstationBaoJiaMessageWithUid:(NSString *)uid Success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/quote/createinfo";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 工作站列表 -----------
/**
 *  工作站列表
 *
 *  @param province   省
 *  @param city       市
 *  @param county     县
 *  @param keyword    检索词
 *  @param pageNumber 页码，默认1
 *  @param pageSize   每页显示数，默认15
 */
- (void)stationListWithProvince:(NSString *)province
                           city:(NSString *)city
                         county:(NSString *)county
                        keyword:(NSString *)keyword
                     pageNumber:(NSString *)pageNumber
                       pageSize:(NSString *)pageSize
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure {
    
    NSString *postURL            = @"api/company/workstationList";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"province"]         = province;
    parmers[@"city"]             = city;
    parmers[@"county"]           = county;
    parmers[@"keyword"]          = keyword;
    parmers[@"pageNumber"]       = pageNumber;
    parmers[@"pageSize"]         = pageSize;
    
    
    // parmers[@"address"]         = address;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
/******************* end 站长助手API  end*******************/
/******************* begin 店铺API  end*******************/
#pragma mark ---------- 店铺首页 -----------
-(void)getMyShopHomePageMessageSuccess:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/apishopIndex";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;

//    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
//        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
//        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 店铺基本信息 -----------
-(void)getMyShopBaseMessageSuccess:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/apishopInfo";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 店铺基本信息修改-----------
-(void)getMyShopBaseMessageUpDataWithType:(NSString *)type value:(NSString *)value Success:(void (^)(id responseObject))success
                                  failure:(void (^)(NSError *error))failure{
    NSString *postURL            = @"api/apishopUpdate";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"type"]             = type;
    parmers[@"value"]            = value;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 店铺地址信息修改-----------
-(void)UpDataMyShopAddressWithshopProvince:(NSString *)shopProvince
                              WithshopCity:(NSString *)shopCity
                            WithshopCounty:(NSString *)shopCounty
                           WithshopAddress:(NSString *)shopAddress
                                   Success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/apishopUpdateArea";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"shopProvince"]     = shopProvince;
    parmers[@"shopCity"]         = shopCity;
    parmers[@"shopCounty"]         = shopCounty;
    parmers[@"shopAddress"]         = shopAddress;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 后台店铺上传图片-----------
-(void)updataShopImageWithType:(NSString *)type WithImageStr:(NSString *)imageStr
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"fileUpload/uploadshophead";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uploadFile"]       = imageStr;
    parmers[@"type"]             = type;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 添加店铺分享记录-----------
-(void)shareShopMessageViewNumWithmemberUid:(NSString *)memberUid
                                    Success:(void (^)(id responseObject))success
                                    failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"shopAddShare";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"memberUid"]             = memberUid;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 店铺装修-----------
-(void)getShopInoterMessageSuccess:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/apishopRenovation";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark ---------- 未通过审核订单删除-----------
-(void)deleteOrderByUids:(NSString *)uids Success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/order/deleteOrder";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uids"]             = uids;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark ---------- 未通过审核订单苗木删除-----------
-(void)deleteOrderMMByUid:(NSString *)uid Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/order/deleteItem";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uidlist"]             = uid;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- APP店铺全部求购 -----------
- (void)shopBuyList:(NSString *)memberUid
               page:(NSString *)page
           pageSize:(NSString *)pageSize
      selfrecommend:(NSString *)selfrecommend
            Success:(void (^)(id responseObject))success
            failure:(void (^)(NSError *error))failure {
    NSString *postURL            = @"shopbuy";

    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"memberUid"]        = memberUid;
    parmers[@"page"]             = page;
    parmers[@"pageSize"]         = pageSize;
    parmers[@"selfrecommend"]    = selfrecommend;
     ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark ---------- APP店铺全部供应 -----------
- (void)shopSupplyList:(NSString *)memberUid
                  page:(NSString *)page
              pageSize:(NSString *)pageSize
         selfrecommend:(NSString *)selfrecommend
               Success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure {
    NSString *postURL            = @"shopsupply";

    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"memberUid"]        = memberUid;
    parmers[@"page"]             = page;
    parmers[@"pageSize"]         = pageSize;
    parmers[@"selfrecommend"]    = selfrecommend;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- APP后台店铺供应信息推荐 -----------
- (void)shopAddSupply:(NSString *)supplyUid
              Success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure {
    NSString *postURL            = @"api/apishopAddSupply";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];

    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"supplyUid"]        = supplyUid;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- APP后台店铺求购信息推荐 -----------
- (void)shopAddBuy:(NSString *)supplyUid
           Success:(void (^)(id responseObject))success
           failure:(void (^)(NSError *error))failure {
    NSString *postURL            = @"api/apishopAddbuy";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];

    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"supplyUid"]        = supplyUid;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}

/******************* end 店铺API  end*******************/
#pragma mark ---------- 分组分享 -----------
- (void)groupShareWithProductUid:(NSString *)porductUid
                     productName:(NSString *)productName
                        province:(NSString *)province
                            city:(NSString *)city
                          county:(NSString *)county
                       startTime:(NSString *)startTime
                    searchStatus:(NSString *)searchStatus
                     spec_XXXXXX:(NSArray *)ary
                         Success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure {
    NSString *postURL            = @"api/group/share";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];

    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"porductUid"]       = porductUid;
    parmers[@"productName"]      = productName;
    parmers[@"province"]         = province;
    parmers[@"city"]             = city;
    parmers[@"county"]           = county;
    parmers[@"startTime"]        = startTime;
    parmers[@"searchStatus"]     = searchStatus;
//    parmers[@"spec"]             = spec;
    for (int i = 0; i < ary.count; i++) {
        NSDictionary *dic = ary[i];
        [parmers setObject:[dic objectForKey:@"value"] forKey:[dic objectForKey:@"field"]];
    }

    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}

#pragma mark ---------- 采购详情 -----------
/**
 *  站长中心定制信息的采购详情
 *
 *  @param uid     求购UID
 *  @param success success description
 *  @param failure failure description
 */
- (void)workstationPushPurchaseInfo:(NSString *)uid type:(NSString *)type
                            Success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure {
    NSString *postURL            = @"api/workstation/purchase/push/purchaseinfo";
   
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];

    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    if ([type isEqualToString:@"5"]) {
        postURL            = @"api/member/push/brokerpurchaseinfo";
        parmers[@"mesUid"]              = uid;
    }else{
        parmers[@"uid"]              = uid;
    }
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 推送信息求购联系方式购买 -----------
/**
 *  推送信息求购联系方式购买
 *
 *  @param recordUid 推送信息UID
 *  @param success   success description
 *  @param failure   failure description
 */
- (void)wrokstationPurchasePushBuy:(NSString *)recordUid
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure {
    NSString *postURL            = @"api/workstation/purchase/push/buyPurchasePushRecord";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];

    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"recordUid"]        = recordUid;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 站长求购 -----------
/**
 *  站长求购
 *
 *  @param pageSize   每页显示条数，（默认15条）
 *  @param page       当前页：默认为1
 *  @param searchTime 检索时间，当前页的最后一条数据的searchTime，不传时，默认是第一页
 *  @param success    success description
 *  @param failure    failure description
 */
- (void)workstationBuyWithPageSize:(NSString *)pageSize
                              page:(NSString *)page
                        searchTime:(NSString *)searchTime
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure {
    NSString *postURL            = @"api/workstation/buy";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];

    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"page"]             = page;
    parmers[@"pageSize"]         = pageSize;
    parmers[@"searchTime"]       = searchTime;
    ShowActionV();
     [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 站长晒单-我的晒单列表 -----------
- (void)workstationMyShaiDanWithPageNumber:(NSString *)pageNumber
                                pageSize:(NSString *)pageSize
                                 Success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure {
    NSString *postURL            = @"api/workstation/shaidan/mylist";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];

    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"pageNumber"]       = pageNumber;
    parmers[@"pageSize"]         = pageSize;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 站长晒单-全部晒单列表 -----------
- (void)workstationAllShaiDanWithThpe:(NSInteger )type
                        PageNumber:(NSString *)pageNumber
                          pageSize:(NSString *)pageSize
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure {
    NSString *postURL            = nil;
    if (type == 0) {//全部
        postURL  = @"api/workstation/shaidan/list";
    } else if (type == 1) {
        postURL = @"api/workstation/shaidan/mylist";
    }
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];

    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"pageNumber"]       = pageNumber;
    parmers[@"pageSize"]         = pageSize;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 站长晒单-评论删除 -----------
- (void)workStationShaiDanPingLunDeleteWithPingLunUid:(NSString *)pingLunUid//评论ID
                                              Success:(void (^)(id responseObject))success
                                              failure:(void (^)(NSError *error))failure {
    NSString *postURL            = @"api/workstation/shaidan/pinglun/delete";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];

    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"pingLunUid"]       = pingLunUid;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 站长晒单-评论 -----------
- (void)workstationShaiDanPIngLunWithShaiDanUid:(NSString *)shaiDanUid
                                        content:(NSString *)content
                                        Success:(void (^)(id responseObject))success
                                        failure:(void (^)(NSError *error))failure {
    NSString *postURL            = @"api/workstation/shaidan/pinglun";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];

    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"shaiDanUid"]       = shaiDanUid;
    parmers[@"content"]          = content;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 站长晒单-晒单详情 -----------
- (void)workstationShaiDanDetailWithUid:(NSString *)uid
                             pageNumber:(NSString *)pageNumber
                               pageSize:(NSString *)pageSize
                                Success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure {
    NSString *postURL            = @"api/workstation/shaidan/detail";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];

    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    parmers[@"pageNumber"]       = pageNumber;
    parmers[@"pageSize"]         = pageSize;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 站长晒单-点赞取消点赞 -----------
- (void)workStationShaiDaDianzanWithShaiDanUid:(NSString *)shaiDanUid
                                    dianZanUid:(NSString *)dianZanUid
                                       Success:(void (^)(id responseObject))success
                                       failure:(void (^)(NSError *error))failure {
    NSString *postURL            = @"api/workstation/shaidan/dianzan";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];

    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"shaiDanUid"]       = shaiDanUid;
    parmers[@"dianZanUid"]       = dianZanUid;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 站长晒单编辑信息 -----------
- (void)workstationShaiDanUpdateWithUid:(NSString *)uid
                                Success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure {
    NSString *postURL            = @"api/workstation/shaidan/update";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];

    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 站长晒单删除 -----------
- (void)workstationShaiDanDeleteWithUids:(NSString *)uids
                                 Success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure {
    NSString *postURL            = @"api/workstation/shaidan/delete";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];

    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uids"]              = uids;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 站长晒单 -----------
- (void)workstationShaiDanSaveWithUid:(NSString *)uid
                                title:(NSString *)title
                              content:(NSString *)content
                               images:(NSString *)images
                              Success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure {
    NSString *postURL            = @"api/workstation/shaidan/save";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];

    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    parmers[@"title"]            = title;
    parmers[@"content"]          = content;
    parmers[@"images"]           = images;
     ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}




    

#pragma mark ---------- 合作苗企-合作苗企首页 -----------
- (void)cooperationCompanyIndexSuccess:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure {
    NSString *postURL            = @"api/cooperationcompany/index";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];


    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;

   

    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {


    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}



#pragma mark ---------- 合作苗企-苗企供应信息列表 -----------
- (void)cooperationCompanySupplyWithPage:(NSString *)page
                                pageSize:(NSString *)pageSize
                              searchTime:(NSString *)searchTime
                                 Success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure {
    NSString *postURL            = @"api/cooperationcompany/supply";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];

    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;

    parmers[@"page"]             = page;
    parmers[@"pageSize"]         = pageSize;
    parmers[@"searchTime"]       = searchTime;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 合作苗企-苗企求购 -----------
- (void)cooperationCompanyBuyWithPageSize:(NSString *)pageSize
                                     page:(NSString *)page
                               searchTime:(NSString *)searchTime
                             goldsupplier:(NSString *)goldsupplier
                                  Success:(void (^)(id responseObject))success
                                  failure:(void (^)(NSError *error))failure {
    NSString *postURL            = @"api/cooperationcompany/buy";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];

    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
  
    parmers[@"page"]             = page;
    parmers[@"pageSize"]         = pageSize;
    parmers[@"searchTime"]       = searchTime;
    parmers[@"goldsupplier"]       = goldsupplier;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 合作苗企-苗企详情 -----------
- (void)cooperationCompanyDetailWithUid:uid
                                 Success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure {
    NSString *postURL            = [NSString stringWithFormat:@"api/cooperationcompany/detail/%@",uid];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];

    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;

    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 合作苗企-苗企中心 -----------
- (void)cooperationCompanuCenterWithSuccess:(void (^)(id responseObject))success
                                    failure:(void (^)(NSError *error))failure {

    NSString *postURL            = @"api/cooperationcompany/center";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];

    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;

    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 合作苗企-合作苗企列表 -----------
- (void)cooperationCompanyListWithSearchTime:(NSString *)searchTime
                                   starLevel:(NSString *)starLevel
                                    province:(NSString *)province
                                        city:(NSString *)city
                                      county:(NSString *)county
                                        page:(NSString *)page
                                    pageSize:(NSString *)pageSize
                                     Success:(void (^)(id responseObject))success
                                     failure:(void (^)(NSError *error))failure {
    NSString *postURL            = @"api/cooperationcompany/list";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];

    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;

    parmers[@"keyword"]       = searchTime;
    parmers[@"starLevel"]        = starLevel;
    parmers[@"province"]         = province;
    parmers[@"city"]             = city;
    parmers[@"county"]           = county;
    parmers[@"page"]             = page;
    parmers[@"pageSize"]         = pageSize;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 合作苗企-合作苗企荣誉列表 -----------
- (void)cooperationCompanyHonorsWithMemberUid:(NSString *)memberUid
                                         type:(NSString *)type
                                         page:(NSString *)page
                                     pageSize:(NSString *)pageSize
                                      Success:(void (^)(id responseObject))success
                                      failure:(void (^)(NSError *error))failure {
    NSString *postURL            = @"api/cooperationcompany/honors";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];

    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;

    parmers[@"memberUid"]        = memberUid;
    parmers[@"pageNumber"]       = page;
    parmers[@"pageSize"]         = pageSize;

    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 合作苗企-荣誉详情 -----------
- (void)cooperationCompanyHonorWithUid:(NSString *)uid
                               Success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure {
    NSString *postURL            = [NSString stringWithFormat:@"api/cooperationcompany/honor/%@",uid];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];

    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;

    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}

#pragma mark ---------- 合作苗企-新增荣誉 -----------
- (void)cooperationCompanyHonorsCreateWithUid:(NSString *)uid
                                         type:(NSString *)type
                                         name:(NSString *)name
                              acquisitionTime:(NSString *)acquisitionTime
                                        image:(NSString *)image
                                      Success:(void (^)(id responseObject))success
                                      failure:(void (^)(NSError *error))failure {
    NSString *postURL            = @"api/cooperationcompany/honors/create";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];

    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    parmers[@"name"]             = name;
    parmers[@"acquisitionTime"]  = acquisitionTime;
    parmers[@"image"]            = image;
     ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}

#pragma mark ---------- 合作苗企-荣誉删除 -----------
- (void)cooperationCompanyHonorDeleteWithUid:(NSString *)uid
                                     Success:(void (^)(id responseObject))success
                                     failure:(void (^)(NSError *error))failure {

    NSString *postURL            = [NSString stringWithFormat:@"api/cooperationcompany/honor/delete/%@",uid];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];

    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;

    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}

#pragma mark ---------- 金牌供应商-金牌供应商列表-----------
-(void)goldSupplyListWithprovince:(NSString *)province withcity:(NSString *)city withcounty:(NSString *)county WithKeyWord:(NSString *)keyword withPage:(NSString *)page withPageSize:(NSString *)pageSize  Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/goldsupplier/lists";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"city"]             = city;
    parmers[@"province"]         = province;
    parmers[@"county"]           = county;
    parmers[@"keyword"]          = keyword;
    parmers[@"page"]             = page;
    parmers[@"pageSize"]         = pageSize;
    
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 金牌供应商-金牌中心-----------
-(void)goldSupplierInfoSuccess:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/goldsupplier/info";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"memberUid"]        = APPDELEGATE.userModel.access_id;

    
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 金牌供应商-金牌详情-----------
-(void)goldSupplyDetialWithUid:(NSString *)memberUid Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/goldsupplier/detial";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"memberUid"]        = memberUid;
    
    
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 金牌供应商-金牌供应商荣誉列表----------
-(void)goldSupplierHonorListWithMemberUid:(NSString *)memberUid withPage:(NSString *)page withPageSize:(NSString *)pageSize Success:(void (^)(id responseObject))success
                                  failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/goldsupplier/honor/list";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"memberUid"]        = memberUid;
    parmers[@"pageNumber"]       = page;
    parmers[@"pageSize"]         = pageSize;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 金牌供应商-金牌供应商荣誉详情----------
-(void)goldSupplierHonordetialUid:(NSString *)uid Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/goldsupplier/honor/detail";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;

    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 金牌供应商-金牌供应商新增荣誉----------
-(void)updatagoldSupplierHonordetialUid:(NSString *)Uid withName:(NSString *)name withacquisitionTime:(NSString *)acquisitionTime withimage:(NSString *)image withType:(NSString *)type Success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/goldsupplier/honor/create";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = Uid;
    parmers[@"name"]             = name;
    parmers[@"acquisitionTime"]  = acquisitionTime;
    parmers[@"image"]            = image;
    parmers[@"type"]            = type;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 金牌供应商-荣誉删除----------
-(void)deletegoldSupplierHonordetialUid:(NSString *)Uid Success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/goldsupplier/honor/delete";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = Uid;
   
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 金牌供应商-自我介绍修改----------
-(void)goldSupplierUpdatebrief:(NSString *)brief Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/updatebrief";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"brief"]            = brief;
    
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 金牌供应商-金牌中心分享----------
-(void)goldsupplierShareSuccess:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/goldsupplier/share";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
 
    
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark ---------- 工程公司-订单开启与关闭----------
-(void)GCGSOrderOpenWithUid:(NSString *)uid Withstatus:(NSString *)status Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/order/open";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    parmers[@"status"]           = status;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 工程公司-订单开启与关闭----------
-(void)GCGSOrderitemReleaseWithUid:(NSString *)uid Withstatus:(NSString *)status Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/order/item/release";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    parmers[@"status"]           = status;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 工程公司-订单明细开启与关闭----------
-(void)GCGSOrderItemOpenWithUid:(NSString *)uid andOrdeUid:(NSString *)orderUid Withstatus:(NSString *)status Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/order/item/open";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    parmers[@"orderUid"]              = orderUid;
    parmers[@"status"]           = status;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark ---------- 搜索店铺----------
-(void)shopSearchWithPage:(NSString *)page WithpageSize:(NSString *)pageSize Withkeyword:(NSString *)keyword Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure
{
    NSString *postURL             = @"searchshoplist";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"page"]              = page;
    parmers[@"pageSize"]          = pageSize;
    parmers[@"keyword"]           = keyword;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}


#pragma mark ---------- 机器人客服模糊查询 -----------
- (void)robotReplysWithKeyword:(NSString *)keyword
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure {
    NSString *postURL            = @"api/robotreplys";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];

    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"keyword"]          = keyword;

    ShowActionV();
    [self GET:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}

#pragma mark ---------- 机器人客服详情 -----------
- (void)robotReplysDetailWithUid:(NSString *)uid
                                 Success:(void (^)(id responseObject))success
                                 failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = [NSString stringWithFormat:@"api/robotreplys/%@",uid];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];

    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;

    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {


    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark ---------- 获取群成员 -----------
- (void)getGroupmembersWithGroupUid:(NSString *)uid
                            Success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/chartgroupmember";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"groupid"]          = uid;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}



#pragma mark -供求评论发布
- (void)gongqiucommentsFabuWithsupplybuyUid:(NSString *)supplybuyUid withcomment:(NSString *)comment
                                    Success:(void (^)(id responseObject))success
                                    failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"api/comments";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"supplybuyUid"]     = supplybuyUid;
    parmers[@"comment"]          = comment;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark -供求评论点赞
- (void)gongqiucommentsZanWithUid:(NSString *)commentUid
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = [NSString stringWithFormat:@"api/comments/%@/appreciates",commentUid];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
   
    
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark -供求评论列表
-(void)gouqiucommentsListWithsupplybuyUid:(NSString *)supplybuyUid
                           WithpageNumber:(NSString *)pageNumber
                             WithpageSize:(NSString *)pageSize
                                  Success:(void (^)(id responseObject))success
                                  failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =@"comments";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"supplybuyUid"]     = supplybuyUid;
    parmers[@"pageNumber"]       = pageNumber;
    parmers[@"pageSize"]         = pageSize;
    ShowActionV();
    [self GET:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark -新闻列表
-(void)getNewsListWitharticleCategory:(NSString *)articleCategory pageNumber:(NSString *)pageNumber pageSize:(NSString *)pageSize keywords:(NSString *)keywords
                              Success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =@"articles";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"articleCategory"]  = articleCategory;
    parmers[@"lastTime"]         = keywords;
    parmers[@"firstTime"]       = pageNumber;
    parmers[@"pageSize"]         = pageSize;
    ShowActionV();
    [self GET:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark -新闻评论
-(void)newsCommentWithUid:(NSString *)uid
                  comment:(NSString *)comment
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =[NSString stringWithFormat:@"api/articles/%@/comments",uid];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"comment"]          = comment;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark -新闻收藏
-(void)newsCollectActionArticle_uid:(NSString *)article_uid
                            Success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =[NSString stringWithFormat:@"api/collect/article/save"];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"article_uid"]      = article_uid;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark -新闻取消收藏
-(void)newsUnCollectActionArticle_uid:(NSString *)article_uid
                              Success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =[NSString stringWithFormat:@"api/collect/article/remove"];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"article_uid"]      = article_uid;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark -新闻收藏查看
-(void)newsCollectcheckArticle_uid:(NSString *)article_uid
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =[NSString stringWithFormat:@"api/collect/article/check"];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"article_uid"]      = article_uid;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark -新闻收藏列表
-(void)newsCollectListWithPageSize:(NSString *)pageSize
                          WithPage:(NSString *)page
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =[NSString stringWithFormat:@"api/collect/article"];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"pageSize"]         = pageSize;
    parmers[@"page"]             = page;
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark -供求评论删除
-(void)commentDeleteWithCommentUid:(NSString *)commentUid
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =[NSString stringWithFormat:@"comments"];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"commentUid"]       = commentUid;
    parmers[@"_method"]          = @"DELETE";
    ShowActionV();
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark -未读消息数量获取
-(void)getunReadSuccess:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =@"api/member/messageRecord/messageCount";
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    [self GET:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark -新闻点击数统计
-(void)adReadNumWithAdUid:(NSString *)uid
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =[NSString stringWithFormat:@"advertisements/view/%@",uid];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark -新闻部分信息
-(void)newsDetialWithAritleUid:(NSString *)adid
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =[NSString stringWithFormat:@"/Home/ShareAritle"];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];

    parmers[@"adid"]        = adid;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark -求购简易发布
-(void)simplebuyWithUid:(NSString *)Uid
              Wtihtitle:(NSString *)title
      WitheffectiveTime:(NSString *)effectiveTime
            Withdetails:(NSString *)details
                Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure
{

    NSString *postURL            =nil;
    NSMutableDictionary *parmers     = [[NSMutableDictionary alloc] init];
    if (Uid) {
        postURL            =[NSString stringWithFormat:@"api/simplebuy/%@",Uid];
        parmers[@"_method"]   = @"PUT";
    }else{
        postURL            =[NSString stringWithFormat:@"api/simplebuy"];
        
    }
    NSUserDefaults *userdefaults     = [NSUserDefaults standardUserDefaults];
    NSString *str                    = [userdefaults objectForKey:kdeviceToken];
    parmers[@"access_token"]         = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]            = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]            = kclient_id;
    parmers[@"client_secret"]        = kclient_secret;
    parmers[@"device_id"]            = str;
    parmers[@"title"]                = title;
    parmers[@"effectiveTime"]        = effectiveTime;
    parmers[@"details"]              = details;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark -简易求购详情
-(void)simplebuyWithUid:(NSString *)uid
                Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =[NSString stringWithFormat:@"api/simplebuy/%@",uid];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    NSUserDefaults *userdefaults     = [NSUserDefaults standardUserDefaults];
    NSString *str                    = [userdefaults objectForKey:kdeviceToken];
    parmers[@"access_token"]         = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]            = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]            = kclient_id;
    parmers[@"client_secret"]        = kclient_secret;
    parmers[@"device_id"]            = str;
    
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark -作者详情
-(void)AuthorDetialWithUid:(NSString *)adid
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =[NSString stringWithFormat:@"author/%@",adid];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];

    parmers[@"access_token"]         = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]            = APPDELEGATE.userModel.access_id;

    
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark -作者关注or取消关注
-(void)followAuthorActionWithUid:(NSString *)uid type:(NSInteger)type
                         Success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =[NSString stringWithFormat:@"api/author/%@/follow",uid];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    NSUserDefaults *userdefaults     = [NSUserDefaults standardUserDefaults];
    NSString *str                    = [userdefaults objectForKey:kdeviceToken];
    parmers[@"access_token"]         = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]            = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]            = kclient_id;
    parmers[@"client_secret"]        = kclient_secret;
    parmers[@"device_id"]            = str;
    if (type==1) {
        [parmers setObject:@"delete" forKey:@"_method"];
    }
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark -作者文章分页
-(void)articleListWithAuthorUid:(NSString *)uid
                    withKeyWord:(NSString *)keyWord
                   WithSortType:(NSString *)sortType
                       WithPage:(NSString *)page WithPageSize:(NSString *)pageSize
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =[NSString stringWithFormat:@"author/%@/article",uid];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
  
    parmers[@"access_token"]         = APPDELEGATE.userModel.access_token;
 
    parmers[@"page"]                 = page;
    parmers[@"pageSize"]             = pageSize;
    parmers[@"keyword"]              = keyWord;
    parmers[@"sortType"]             = sortType;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark -我的关注
-(void)myFollowListWithPage:(NSString *)page
               WithPageSize:(NSString *)pageSize
                WithKeyWord:(NSString *)keyword
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =@"api/author/follow";
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    NSUserDefaults *userdefaults     = [NSUserDefaults standardUserDefaults];
    NSString *str                    = [userdefaults objectForKey:kdeviceToken];
    parmers[@"access_token"]         = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]            = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]            = kclient_id;
    parmers[@"client_secret"]        = kclient_secret;
    parmers[@"device_id"]            = str;
    parmers[@"page"]                 = page;
    parmers[@"pageSize"]             = pageSize;
    parmers[@"keyword"]              = keyword;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark -订单分享
-(void)orderShareWithuid:(NSString *)uid
                 Success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure

{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/order/share";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"uid"]              = uid;
    
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark -苗商圈发布
-(void)MiaoshangquanFabuWithContent:(NSString *)content
                           WithPics:(NSString *)pics
                            Success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = @"api/circles";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"content"]          = content;
    parmers[@"pic"]             = pics;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark -苗商圈删除
-(void)MiaoshangquanShanChuWithUid:(NSString *)uid
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str                = [userdefaults objectForKey:kdeviceToken];
    NSString *postURL            = [NSString stringWithFormat:@"api/circles/%@",uid];
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_token"]     = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]        = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]        = kclient_id;
    parmers[@"client_secret"]    = kclient_secret;
    parmers[@"device_id"]        = str;
    parmers[@"_method"]          = @"DELETE";
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark -苗商圈列表
-(void)MiaoshanglistWithPage:(NSString*)page
                WithPageSize:(NSString *)pagesize
                 WithKeyWord:(NSString *)keyword
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =@"circles";
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    NSUserDefaults *userdefaults     = [NSUserDefaults standardUserDefaults];
    NSString *str                    = [userdefaults objectForKey:kdeviceToken];
    parmers[@"access_token"]         = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]            = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]            = kclient_id;
    parmers[@"client_secret"]        = kclient_secret;
    parmers[@"device_id"]            = str;
    parmers[@"page"]                 = page;
    parmers[@"pageSize"]             = pagesize;
    parmers[@"keyword"]              = keyword;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    

    
}

-(void)jjrshenheGetMoneyNumSuccess:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =@"config";
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
   
    parmers[@"attribute"]         =@"brokerCost";

    [self GET:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
 
}

#pragma mark -经纪人详情分享
-(void)jjrGetDetialShareWithBrokerUid:(NSString *)uid Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =[NSString stringWithFormat:@"brokers/%@/share",uid];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_id"]            = APPDELEGATE.userModel.access_id;

    [self GET:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

    
}
#pragma mark -经纪人列表分享
-(void)jjrGetListShareSuccess:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =@"brokers/share";
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"access_id"]            = APPDELEGATE.userModel.access_id;
    
    [self GET:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
    
}
#pragma mark -经纪人列表
-(void)jjrListWithareaCode:(NSString *)areaCode
                  withPage:(NSString *)page
              withPageSize:(NSString *)pageSize
            WithproductUid:(NSString *)productUid
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =@"brokers";
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"areaCode"]             = areaCode;
    parmers[@"access_id"]            = APPDELEGATE.userModel.access_id;
    parmers[@"page"]                 = page;
    parmers[@"pageSize"]             = pageSize;
    parmers[@"product"]           = productUid;
    parmers[@"sortArea"]           = APPDELEGATE.cityModel.code;
    [self GET:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}


#pragma mark -经纪人供求列表
-(void)jjrgqListWithUid:(NSString *)uid
               WtihType:(NSString *)type
               Withpage:(NSString *)page
           WithpageSize:(NSString *)pageSize
                Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =[NSString stringWithFormat:@"/brokers/%@/%@",uid,type];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
  
    parmers[@"pageSize"]             = pageSize;
    parmers[@"page"]                 = page;
    [self GET:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

    
}
#pragma mark -经纪人获取申请信息
-(void)jjrSHInfoListSuccess:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =@"api/brokers/apply";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    NSUserDefaults *userdefaults     = [NSUserDefaults standardUserDefaults];
    NSString *str                    = [userdefaults objectForKey:kdeviceToken];
    parmers[@"access_token"]         = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]            = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]            = kclient_id;
    parmers[@"client_secret"]        = kclient_secret;
    parmers[@"device_id"]            = str;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

    
}
#pragma mark-经纪人供应推送设置已读接口
-(void)jjrReadUid:(NSString *)uid
          Success:(void (^)(id responseObject))success
          failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =@"api/member/messageRecord/pushread";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    NSUserDefaults *userdefaults     = [NSUserDefaults standardUserDefaults];
    NSString *str                    = [userdefaults objectForKey:kdeviceToken];
    parmers[@"access_token"]         = APPDELEGATE.userModel.access_token;
    parmers[@"access_id"]            = APPDELEGATE.userModel.access_id;
    parmers[@"client_id"]            = kclient_id;
    parmers[@"client_secret"]        = kclient_secret;
    parmers[@"device_id"]            = str;
    parmers[@"pushRecordUid"]        = uid;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark-会员单位
///excellentEnterprise
-(void)huiyuanDanweiWithPageSize:(NSString *)pageSize
                    WithlastTime:(NSString *)lastTime
                     WithentType:(NSString *)entType
                   WithparentUid:(NSString *)parentUid
                         Success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =@"excellentEnterprise";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    
//    parmers[@"page_size"]            = pageSize;
    parmers[@"lastTime"]             = lastTime;
    parmers[@"entType"]              = entType;
    parmers[@"parentUid"]            = parentUid;
    [self GET:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
/*
 广告相关接口
 */
#pragma mark -广告费充值记录
-(void)adChongZhiJiLuWithUid:(NSString *)member_uid
                   WithStart:(NSString *)start
                     WithEnd:(NSString *)end
               WithPage_size:(NSString *)page_size
              WithPage_index:(NSString *)page
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =@"api/AdManagerAPI/GetChargeRecord";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
 
    parmers[@"page_size"]             = page_size;
    parmers[@"member_uid"]            = APPDELEGATE.userModel.access_id;
    parmers[@"page_index"]            = page;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

    
}
#pragma mark -广告扣费记录
-(void)adkoufeiJiLuWithUid:(NSString *)member_uid
                 WithStart:(NSString *)start
                   WithEnd:(NSString *)end
             WithPage_size:(NSString *)page_size
            WithPage_index:(NSString *)page
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure
{

    NSString *postURL            =@"api/AdManagerAPI/GetAllDeductionRecord";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    
    parmers[@"page_size"]             = page_size;
    parmers[@"member_uid"]            = APPDELEGATE.userModel.access_id;
    parmers[@"page_index"]            = page;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark -广告费余额
-(void)adYueEWithUid:(NSString *)member_uid
             Success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =@"api/AdManagerAPI/GetAccount";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];

    parmers[@"member_uid"]            = APPDELEGATE.userModel.access_id;

    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark -我的广告列表
-(void)myADListWithUid:(NSString *)member_uid
             WithStart:(NSString *)start
               WithEnd:(NSString *)end
         WithPage_size:(NSString *)page_size
        WithPage_index:(NSString *)page
               Success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =@"api/AdManagerAPI/GetMemberAdvertisements";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    
    parmers[@"page_size"]             = page_size;
    parmers[@"member_uid"]            = APPDELEGATE.userModel.access_id;
    parmers[@"page_index"]            = page;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark -我的广告点击记录
-(void)adClickListWithUid:(NSString *)member_uid
                WithStart:(NSString *)start
                  WithEnd:(NSString *)end
            WithPage_size:(NSString *)page_size
           WithPage_index:(NSString *)page
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =@"api/AdManagerAPI/GetAdvertisementClickList";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    
    parmers[@"page_size"]             = page_size;
    parmers[@"advertisement_uid"]     = member_uid;
    parmers[@"page_index"]            = page;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

    
}
#pragma mark -广告点击扣费
-(void)adClickAcitionWithADuid:(NSString *)advertisement_uid
                 WithMemberUid:(NSString *)member_uid
                WithBrowsePage:(NSString *)browse_page
            WithBrowseUserType:(NSString *)browse_user_type
               withiosClientId:(NSString *)ios_client_id
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =@"api/AdManagerAPI/AdvertismentClick";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    
    parmers[@"advertisement_uid"]        = advertisement_uid;
    parmers[@"member_uid"]               = APPDELEGATE.userModel.access_id;
    parmers[@"browse_user_type"]         = browse_user_type;
    parmers[@"ios_client_id"]            = ios_client_id;
    parmers[@"browse_page"]               = browse_page;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark -开屏广告
// /api/GetAdvertisementAPI/AppHomeStart
-(void)openViewAdSuccess:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =@"api/GetAdvertisementAPI/AppHomeStart";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
   
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark -微信充值

-(void)weixinADwithUid:(NSString *)member_uid
                  pice:(NSString *)pice
               Success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =@"Handler/wxPrepay.ashx";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    
    ZIKFunction *zikfun=[ZIKFunction new];
    parmers[@"spbill_create_ip"]     =[zikfun getIPAddress:YES];
    parmers[@"total_fee"]            = pice;
    parmers[@"memberUid"]            = member_uid;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark -广告费退费
-(void)tuifeiWithUid:(NSString *)memberuid
            WithName:(NSString *)rfrequest
             WithYuE:(NSString *)rfmoney
   Withrfgivingmoney:(NSString *)rfgivingmoney
             Success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =@"/api/RefundAPI/RefundRequest";
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"memberUid"]            = memberuid;
    parmers[@"rfrequest"]            = rfrequest;
    parmers[@"rfmoney"]              = rfmoney;
    parmers[@"rfgivingmoney"]        = rfgivingmoney;
    
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark -添加新地址
-(void)addNewAddressWithStr:(NSString *)addressParty
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =[NSString stringWithFormat:@"%@party/addresses",AFBaseURLString];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    NSData *postData = [addressParty dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:postURL parameters:nil error:nil];
    request.timeoutInterval= 30.f;
    [request setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    [request setValue:kclient_id forHTTPHeaderField:@"client_id"];
    [request setValue:kclient_secret forHTTPHeaderField:@"client_secret"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 设置body
    [request setHTTPBody:postData];
    [[self dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            success(responseObject);
            RemoveActionV();
        } else {
            failure(error);
            RemoveActionV();
            [HttpClient HTTPERRORMESSAGE:error];
           
        }
    }] resume];
}

#pragma mark -地址列表
-(void)addressListSuccess:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"party/addresses";
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    [self GET:postURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark -获取默认地址
-(void)getDefaultAddressSuccess:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"party/addresses/default";
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];

//    ShowActionV();
    [self GET:postURL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark -删除地址
-(void)deleteAddressWithaddressId:(NSString *)addressId
                          Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure
{
 
    NSString *postURL = [NSString stringWithFormat:@"party/addresses/%@",addressId];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
//    NSMutableDictionary *parmers=[NSMutableDictionary dictionary];
//    parmers[@"_method"]       = @"DELETE";
    ShowActionV();
    [self DELETE:postURL parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark -修改地址
-(void)editAddressWithaddressId:(NSString *)addressId
                    WithBodyStr:(NSString *)newaddress
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =[NSString stringWithFormat:@"%@party/addresses/%@",AFBaseURLString,addressId];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    NSData *postData = [newaddress dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"PUT" URLString:postURL parameters:nil error:nil];
    request.timeoutInterval= 30.f;
    [request setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    [request setValue:kclient_id forHTTPHeaderField:@"client_id"];
    [request setValue:kclient_secret forHTTPHeaderField:@"client_secret"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 设置body
    [request setHTTPBody:postData];
    [[self dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            success(responseObject);
            RemoveActionV();
        } else {
            failure(error);
            RemoveActionV();
            [HttpClient HTTPERRORMESSAGE:error];
            
        }
    }] resume];
    
}
#pragma mark -地址详情
-(void)getAssressDetialWithAddressId:(NSString *)addressId
                             Success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure
{
    NSString *postURL = [NSString stringWithFormat:@"party/addresses/%@",addressId];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];

    ShowActionV();
    [self GET:postURL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark -设置默认地址
-(void)setDefaultAddressWithaddressId:(NSString *)addressId
                              Success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure
{
    NSString *postURL = [NSString stringWithFormat:@"party/addresses/%@/default",addressId];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
//    NSMutableDictionary *parmers=[NSMutableDictionary dictionary];
//    parmers[@"_method"]       = @"PUT";
    ShowActionV();
    [self PUT:postURL parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
//    [self PUT:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
    
}
#pragma mark -注册短信验证码
-(void)getregisterCodeWithPhone:(NSString *)phone
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"verification_code/register";
    [self.requestSerializer setValue:kclient_id forHTTPHeaderField:@"client_id"];
    [self.requestSerializer setValue:kclient_secret forHTTPHeaderField:@"client_secret"];
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    parameters[@"phone"]=phone;
    ShowActionV();
    [self GET:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark -new供应发布
-(void)supplyNewPushWithBody:(NSString *)bodyStr
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =[NSString stringWithFormat:@"%@party/supplys",AFBaseURLString];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    NSData *postData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:postURL parameters:nil error:nil];
    request.timeoutInterval= 30.f;
    [request setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    [request setValue:kclient_id forHTTPHeaderField:@"client_id"];
    [request setValue:kclient_secret forHTTPHeaderField:@"client_secret"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 设置body
    [request setHTTPBody:postData];
    [[self dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            success(responseObject);
            RemoveActionV();
        } else {
            failure(error);
            RemoveActionV();
            [HttpClient HTTPERRORMESSAGE:error];
            
        }
    }] resume];
}
#pragma mark -new供应列表
-(void)SupplynewLsitWithQuery:(NSString *)query
                   WithlastTime:(NSString *)lastTime
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"supplys";
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    parameters[@"query"]=query;
    parameters[@"lastTime"]=lastTime;
    ShowActionV();
    [self GET:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark -new我的供应列表
-(void)mySupplynewLsitWithproductName:(NSString *)productName
                     Withstatus:(NSString *)status
                       WithlastTime:(NSString *)lastTime
                   WithsortType:(NSString *)sortType
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"party/supplys";
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    parameters[@"productName"]=productName;
    parameters[@"status"]=status;
    parameters[@"lastTime"]=lastTime;
    parameters[@"sortType"]=sortType;
    ShowActionV();
    [self GET:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark -new供应删除
-(void)mySupplyDeleteWithSupplyIds:(NSString *)supplyIds
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"party/supplys";
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    NSMutableDictionary *parmers=[NSMutableDictionary dictionary];
    parmers[@"supplyIds"]     =supplyIds;
//    parmers[@"_method"]       = @"DELETE";
    ShowActionV();
    [self DELETE:postURL parameters:parmers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
  
    
}
#pragma mark -new供应刷新
-(void) mySupplyRefreshWithSupplyIds:(NSString *)supplyIds
                            Success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure
{
    NSString *postURL = [NSString stringWithFormat:@"party/supplys/refresh?supplyIds=%@",supplyIds];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    parameters[@"supplyIds"]=supplyIds;
    
    ShowActionV();
    [self PUT:postURL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark -获取我的供应详情
-(void)mySupplyDetialWithSupplyId:(NSString *)supplyId
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure
{
    NSString *postURL = [NSString stringWithFormat:@"party/supplys/%@",supplyId];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    
    NSMutableDictionary *parmers=[NSMutableDictionary dictionary];
//    parmers[@"name"]     =supplyId;
    //    ShowActionV();
    [self GET:postURL parameters:parmers progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark -new供应下架
-(void)mySupplyCloseWithSupplyIds:(NSString *)supplyIds
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure
{
    NSString *postURL = [NSString stringWithFormat:@"party/supplys/close?supplyIds=%@",supplyIds];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    parameters[@"supplyIds"]=supplyIds;
    
    ShowActionV();
    [self PUT:postURL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark -new供应上架
-(void)mySupplyOpenWithSupplyIds:(NSString *)supplyIds
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure
{
    NSString *postURL = [NSString stringWithFormat:@"party/supplys/open?supplyIds=%@",supplyIds];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    parameters[@"supplyIds"]=supplyIds;
    
    ShowActionV();
    [self PUT:postURL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark -求购详情查看
-(void)supplyDetialViewActionWithSupplyId:(NSString *)supplyId
                                  Success:(void (^)(id responseObject))success
                                  failure:(void (^)(NSError *error))failure
{
    
    NSString *postURL = [NSString stringWithFormat:@"supplys/%@/view",supplyId];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    
    ShowActionV();
    [self GET:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark -供应打电话记录
-(void)supplyDetialCallActionWithSupplyId:(NSString *)supplyId
                               Success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure
{
    NSString *postURL = [NSString stringWithFormat:@"supplys/%@/call",supplyId];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    
    ShowActionV();
    [self GET:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark -根据拼音匹配树种名称
-(void)getProductNameWithPY:(NSString *)pinyinStr
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"products";
 
    NSMutableDictionary *parmers=[NSMutableDictionary dictionary];
    parmers[@"name"]     =pinyinStr;
//    ShowActionV();
    [self GET:postURL parameters:parmers progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
  
}
#pragma mark -求购详情查看
-(void)buyDetialViewActionWithBuyId:(NSString *)buyId
                            Success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure
{
    NSString *postURL = [NSString stringWithFormat:@"buys/%@/view",buyId];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    
    ShowActionV();
    [self GET:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark -求购详情记录拨打电话
-(void)buyDetialCallActionWithBuyId:(NSString *)buyId
                            Success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure
{
    NSString *postURL = [NSString stringWithFormat:@"buys/%@/call",buyId];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    
    ShowActionV();
    [self GET:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark -求购列表
-(void)BuysNewLsitWithQuery:(NSString *)query
               WithlastTime:(NSString *)lastTime
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"buys";
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    parameters[@"query"]=query;
    parameters[@"lastTime"]=lastTime;
    ShowActionV();
    [self GET:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark -new我的求购列表
-(void)myBuysnewLsitWithproductName:(NSString *)productName
                         Withstatus:(NSString *)status
                           Withpage:(NSString *)page
                       WithlastTime:(NSString *)lastTime
                            Success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"party/buys";
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    parameters[@"productName"]=productName;
    parameters[@"status"]=status;
//    parameters[@"page"]=page;
    parameters[@"lastTime"]=lastTime;
    ShowActionV();
    [self GET:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark -new求购发布
-(void)buyNewPushWithBody:(NSString *)bodyStr
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure{
    NSString *postURL            =[NSString stringWithFormat:@"%@party/buys",AFBaseURLString];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    NSData *postData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:postURL parameters:nil error:nil];
    request.timeoutInterval= 30.f;
    [request setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    [request setValue:kclient_id forHTTPHeaderField:@"client_id"];
    [request setValue:kclient_secret forHTTPHeaderField:@"client_secret"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 设置body
    [request setHTTPBody:postData];
    [[self dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            success(responseObject);
            RemoveActionV();
        } else {
            failure(error);
            RemoveActionV();
            [HttpClient HTTPERRORMESSAGE:error];
            
        }
    }] resume];
}
#pragma mark -求购单条/批量关闭求购
-(void)buyCloseWithbuyIds:(NSString *)buyIds
                  Success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure
{
    NSString *postURL = [NSString stringWithFormat:@"party/buys/close?buyIds=%@",buyIds];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    parameters[@"buyIds"]=buyIds;
 
    ShowActionV();
    [self PUT:postURL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark -求购刷新
-(void)buyRefreshWithbuyIds:(NSString *)buyIds
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure
{
    NSString *postURL = [NSString stringWithFormat:@"party/buys/refresh?buyIds=%@",buyIds];

    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    parameters[@"buyIds"]=buyIds;
    
    ShowActionV();
    [self PUT:postURL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark -求购开启
-(void)buyOpenWithbuyIds:(NSString *)buyIds
             withPartyId:(NSString *)partyId
                 Success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure
{
    NSString *postURL = [NSString stringWithFormat:@"party/buys/open?buyIds=%@",buyIds];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    parameters[@"buyIds"]=buyIds;
    ShowActionV();
    [self PUT:postURL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark -求购删除
-(void)buyDeleteWithbuyIds:(NSString *)buyIds
               withPartyId:(NSString *)partyId
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure
{
    
    NSString *postURL = [NSString stringWithFormat:@"party/buys?buyIds=%@",buyIds];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    parameters[@"buyIds"]=buyIds;
    
    ShowActionV();
    [self DELETE:postURL parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark -我的求购详情
-(void)myBuyDetialWithbuyIds:(NSString *)buyId
                     Success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure
{
    NSString *postURL = [NSString stringWithFormat:@"party/buys/%@",buyId];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    NSMutableDictionary *parmers=[NSMutableDictionary dictionary];

    
    ShowActionV();
    [self GET:postURL parameters:parmers progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark -我的求购编辑
-(void)buyNewUpDataWithBody:(NSString *)bodyStr
                  WithBuyId:(NSString *)buyId
                    Success:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =[NSString stringWithFormat:@"%@party/buys/%@",AFBaseURLString,buyId];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    NSData *postData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"PUT" URLString:postURL parameters:nil error:nil];
    request.timeoutInterval= 30.f;
    [request setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    [request setValue:kclient_id forHTTPHeaderField:@"client_id"];
    [request setValue:kclient_secret forHTTPHeaderField:@"client_secret"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 设置body
    [request setHTTPBody:postData];
    [[self dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            success(responseObject);
            RemoveActionV();
        } else {
            failure(error);
            RemoveActionV();
            [HttpClient HTTPERRORMESSAGE:error];
            
        }
    }] resume];
    
}
#pragma mark -修改个人信息
-(void)updataUserNormalInfoWithKey:(NSString *)keyWord
                         WithValue:(NSString *)Value
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure
{
    NSString *postURL = [NSString stringWithFormat:@"/party/persons?%@=%@",keyWord,Value];
    postURL = [postURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    NSMutableDictionary *parmers=[NSMutableDictionary dictionary];
    parmers[keyWord]=Value;
    ShowActionV();
    [self PUT:postURL parameters:parmers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark -获取微苗商列表
-(void)weimiaoshangListWithPage:(NSString *)page
                        Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure
{
    NSString *postURL =@"circles";
    [self.requestSerializer setValue:kclient_id forHTTPHeaderField:@"client_id"];
    [self.requestSerializer setValue:kclient_secret forHTTPHeaderField:@"client_secret"];
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    
    if (!str) {
        str=@"用户未授权";
    }
    [self.requestSerializer setValue:str forHTTPHeaderField:@"device_id"];
    NSMutableDictionary *parmers=[NSMutableDictionary dictionary];
    parmers[@"page"]=page;
    
    ShowActionV();
    [self GET:postURL parameters:parmers progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark -发表苗商圈
-(void)weimiaoshangFabuWithBodyStr:(NSString *)bodyStr
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =[NSString stringWithFormat:@"%@circles/release",AFBaseURLString];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    NSData *postData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:postURL parameters:nil error:nil];
    request.timeoutInterval= 30.f;
    [request setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    [request setValue:kclient_id forHTTPHeaderField:@"client_id"];
    [request setValue:kclient_secret forHTTPHeaderField:@"client_secret"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 设置body
    [request setHTTPBody:postData];
    [[self dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            success(responseObject);
            RemoveActionV();
        } else {
            failure(error);
            RemoveActionV();
            [HttpClient HTTPERRORMESSAGE:error];
            
        }
    }] resume];
}
#pragma mark -实名认证
-(void)realNameWithBodyStr:(NSString *)bodyStr
                   Success:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =[NSString stringWithFormat:@"%@party/users/apply",AFBaseURLString];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    NSData *postData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:postURL parameters:nil error:nil];
    request.timeoutInterval= 30.f;
    [request setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    [request setValue:kclient_id forHTTPHeaderField:@"client_id"];
    [request setValue:kclient_secret forHTTPHeaderField:@"client_secret"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 设置body
    [request setHTTPBody:postData];
    [[self dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            success(responseObject);
            RemoveActionV();
        } else {
            failure(error);
            RemoveActionV();
            [HttpClient HTTPERRORMESSAGE:error];
            
        }
    }] resume];
}
#pragma mark -实名认证审核状态
-(void)getRealNameStateSuccess:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSString *postURL =@"party/users/apply/status";
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];

    NSMutableDictionary *parmers=[NSMutableDictionary dictionary];
    
    
    ShowActionV();
    [self GET:postURL parameters:parmers progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark -实名认证退回后编辑
-(void)upDataRealNameWithroleApplyAuditId:(NSString *)roleApplyAuditId
                                  bodyStr:(NSString *)bodyStr
                                  Success:(void (^)(id responseObject))success
                                  failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =[NSString stringWithFormat:@"%@party/users/apply/%@",AFBaseURLString,roleApplyAuditId];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    NSData *postData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"PUT" URLString:postURL parameters:nil error:nil];
    request.timeoutInterval= 30.f;
    [request setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    [request setValue:kclient_id forHTTPHeaderField:@"client_id"];
    [request setValue:kclient_secret forHTTPHeaderField:@"client_secret"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 设置body
    [request setHTTPBody:postData];
    [[self dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            success(responseObject);
            RemoveActionV();
        } else {
            failure(error);
            RemoveActionV();
            [HttpClient HTTPERRORMESSAGE:error];
            
        }
    }] resume];
    
}
#pragma mark-企业认证
-(void)enterpriseShenQingWithBodyStr:(NSString *)bodyStr
                             Success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =[NSString stringWithFormat:@"%@party/enterprise/apply",AFBaseURLString];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    NSData *postData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:postURL parameters:nil error:nil];
    request.timeoutInterval= 30.f;
    [request setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    [request setValue:kclient_id forHTTPHeaderField:@"client_id"];
    [request setValue:kclient_secret forHTTPHeaderField:@"client_secret"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 设置body
    [request setHTTPBody:postData];
    [[self dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            success(responseObject);
            RemoveActionV();
        } else {
            failure(error);
            RemoveActionV();
            [HttpClient HTTPERRORMESSAGE:error];
            
        }
    }] resume];
}
#pragma mark-企业认证信息
-(void)enterpriseInfoSuccess:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure
{
    NSString *postURL =@"party/enterprise";
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    
    NSMutableDictionary *parmers=[NSMutableDictionary dictionary];
    
    
//    ShowActionV();
    [self GET:postURL parameters:parmers progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark-修改企业信息
-(void)upDataEnterpriseInfoWithBodyStr:(NSString *)bodyStr
                               Success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure
{
    
    NSString *postURL            =[NSString stringWithFormat:@"%@party/enterprise",AFBaseURLString];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    NSData *postData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"PUT" URLString:postURL parameters:nil error:nil];
    request.timeoutInterval= 30.f;
    [request setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    [request setValue:kclient_id forHTTPHeaderField:@"client_id"];
    [request setValue:kclient_secret forHTTPHeaderField:@"client_secret"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 设置body
    [request setHTTPBody:postData];
    [[self dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            success(responseObject);
            RemoveActionV();
        } else {
            failure(error);
            RemoveActionV();
            [HttpClient HTTPERRORMESSAGE:error];
            
        }
    }] resume];
}
#pragma mark-企业审核状态
-(void)getEnterpriseStateSuccess:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure
{
    NSString *postURL =@"party/enterprise/apply/status";
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    
    NSMutableDictionary *parmers=[NSMutableDictionary dictionary];
    
    
    ShowActionV();
    [self GET:postURL parameters:parmers progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark-企业认证退回修改
-(void)enterpriseShenQingWithBodyStr:(NSString *)bodyStr
                WithroleApplyAuditId:(NSString *)roleApplyAuditId
                             Success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =[NSString stringWithFormat:@"%@party/enterprise/apply/%@",AFBaseURLString,roleApplyAuditId];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    NSData *postData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"PUT" URLString:postURL parameters:nil error:nil];
    request.timeoutInterval= 30.f;
    [request setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    [request setValue:kclient_id forHTTPHeaderField:@"client_id"];
    [request setValue:kclient_secret forHTTPHeaderField:@"client_secret"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 设置body
    [request setHTTPBody:postData];
    [[self dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            success(responseObject);
            RemoveActionV();
        } else {
            failure(error);
            RemoveActionV();
            [HttpClient HTTPERRORMESSAGE:error];
            
        }
    }] resume];
    
}
#pragma mark-获取重置短信验证码
-(void)getCodeShotMessageWtihPhone:(NSString *)phone
                           andType:(NSString *)type
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    
    if (!str) {
        str=@"userrefuse";
    }
    NSString *postURL = @"verification_code/reset";
    [self.requestSerializer setValue:kclient_id forHTTPHeaderField:@"client_id"];
    [self.requestSerializer setValue:kclient_secret forHTTPHeaderField:@"client_secret"];
    [self.requestSerializer setValue:str forHTTPHeaderField:@"device_id"];
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    parameters[@"phone"]=phone;
    
    ShowActionV();
    [self GET:postURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark-重置密码
-(void)resetPassWordWithPhone:(NSString *)phone
         WithverificationCode:(NSString *)verificationCode
              WithNewPassWord:(NSString *)newPassword
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =[NSString stringWithFormat:@"reset"];
    
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    
    parmers[@"phone"]        = phone;
    parmers[@"verificationCode"]        = verificationCode;
    parmers[@"newPassword"]        = newPassword;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark -首页
- (void)getHomePageInfoSuccess:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"index";
    NSDictionary *parmers=[NSDictionary dictionary];

    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    [self.requestSerializer setValue:kclient_id forHTTPHeaderField:@"client_id"];
    [self.requestSerializer setValue:kclient_secret forHTTPHeaderField:@"client_secret"];
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:kdeviceToken];
    
    if (!str) {
        str=@"userrefuse";
    }
    [self.requestSerializer setValue:str forHTTPHeaderField:@"device_id"];
    [self GET:postURL parameters:parmers progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark -报价
- (void)quoteActionWithBodyStr:(NSString *)bodyStr
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =[NSString stringWithFormat:@"%@quotes",AFBaseURLString];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    NSData *postData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:postURL parameters:nil error:nil];
    request.timeoutInterval= 30.f;
    [request setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    [request setValue:kclient_id forHTTPHeaderField:@"client_id"];
    [request setValue:kclient_secret forHTTPHeaderField:@"client_secret"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 设置body
    [request setHTTPBody:postData];
    [[self dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            success(responseObject);
            RemoveActionV();
        } else {
            failure(error);
            RemoveActionV();
            [HttpClient HTTPERRORMESSAGE:error];
            
        }
    }] resume];
}
#pragma mark -获取我的报价已报价列表
-(void)myQuoteListWithLastTime:(NSString *)lastTime
                         state:(NSString *)state
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    
    NSString *postURL = nil;
    if ([state isEqualToString:@"over"]) {
        postURL=@"quotes/over";
    }else{
        postURL=@"quotes";
    }
    NSMutableDictionary *parmers=[NSMutableDictionary dictionary];
    parmers[@"lastTime"]=lastTime;
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];

    [self GET:postURL parameters:parmers progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}

#pragma mark -经纪人提交审核
-(void)jjrshenheWithDic:(NSString *)bodyStr
                Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =[NSString stringWithFormat:@"%@party/brokers/apply",AFBaseURLString];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    NSData *postData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:postURL parameters:nil error:nil];
    request.timeoutInterval= 30.f;
    [request setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    [request setValue:kclient_id forHTTPHeaderField:@"client_id"];
    [request setValue:kclient_secret forHTTPHeaderField:@"client_secret"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 设置body
    [request setHTTPBody:postData];
    [[self dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            success(responseObject);
            RemoveActionV();
        } else {
            failure(error);
            RemoveActionV();
            [HttpClient HTTPERRORMESSAGE:error];
            
        }
    }] resume];
    
}
#pragma mark -经纪人审核状态
-(void)jjrshenheStatueSuccess:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =@"party/brokers/apply/status";
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
  
    [self GET:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark -经纪人退回重新提交
-(void)jjrShenHetuihuiWithRoleApplyAuditId:(NSString *)applyAuditId
                               WithBodyStr:(NSString *)bodyStr
                                   Success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =[NSString stringWithFormat:@"%@party/brokers/apply/%@",AFBaseURLString,applyAuditId];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    NSData *postData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"PUT" URLString:postURL parameters:nil error:nil];
    request.timeoutInterval= 30.f;
    [request setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    [request setValue:kclient_id forHTTPHeaderField:@"client_id"];
    [request setValue:kclient_secret forHTTPHeaderField:@"client_secret"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 设置body
    [request setHTTPBody:postData];
    [[self dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            success(responseObject);
            RemoveActionV();
        } else {
            failure(error);
            RemoveActionV();
            [HttpClient HTTPERRORMESSAGE:error];
            
        }
    }] resume];
}
#pragma mark -经纪人修改
-(void)jjrdetialChangeWithbodyStr:(NSString *)bodyStr
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =[NSString stringWithFormat:@"%@party/brokers",AFBaseURLString];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    NSData *postData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"PUT" URLString:postURL parameters:nil error:nil];
    request.timeoutInterval= 30.f;
    [request setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    [request setValue:kclient_id forHTTPHeaderField:@"client_id"];
    [request setValue:kclient_secret forHTTPHeaderField:@"client_secret"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 设置body
    [request setHTTPBody:postData];
    [[self dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            success(responseObject);
            RemoveActionV();
        } else {
            failure(error);
            RemoveActionV();
            [HttpClient HTTPERRORMESSAGE:error];
            
        }
    }] resume];
    
}
#pragma mark ---------- 工程公司资质申请状态 -----------
- (void)projectCompanyStatusSuccess:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure
{

    NSString *postURL            = @"party/engineering_company/apply/status";
   
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
//    ShowActionV();
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    [self GET:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 工程公司认证-----------
-(void)shengjiGCGSWithqualJson:(NSString *)qualJson
                          Success:(void (^)(id responseObject))success
                          failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =[NSString stringWithFormat:@"%@party/engineering_company/apply",AFBaseURLString];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    NSData *postData = [qualJson dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:postURL parameters:nil error:nil];
    request.timeoutInterval= 30.f;
    [request setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    [request setValue:kclient_id forHTTPHeaderField:@"client_id"];
    [request setValue:kclient_secret forHTTPHeaderField:@"client_secret"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 设置body
    [request setHTTPBody:postData];
    [[self dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            success(responseObject);
            RemoveActionV();
        } else {
            failure(error);
            RemoveActionV();
            [HttpClient HTTPERRORMESSAGE:error];
            
        }
    }] resume];
    
}
#pragma mark ---------- 工程公司认证退回后重新提交
-(void)shengjiGCGSWithqualJson:(NSString *)qualJson
          WithroleApplyAuditId:(NSString *)roleApplyAuditId
                       Success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =[NSString stringWithFormat:@"%@party/engineering_company/apply/%@",AFBaseURLString,roleApplyAuditId];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    NSData *postData = [qualJson dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"PUT" URLString:postURL parameters:nil error:nil];
    request.timeoutInterval= 30.f;
    [request setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    [request setValue:kclient_id forHTTPHeaderField:@"client_id"];
    [request setValue:kclient_secret forHTTPHeaderField:@"client_secret"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 设置body
    [request setHTTPBody:postData];
    [[self dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            success(responseObject);
            RemoveActionV();
        } else {
            failure(error);
            RemoveActionV();
            [HttpClient HTTPERRORMESSAGE:error];
            
        }
    }] resume];
    
}
#pragma mark ---------- 经纪人认证微信下单
-(void)JJRWeChatPayWithroleApplyAuditId:(NSString *)roleApplyAuditId
                      WithoutTradeNo:(NSString *)outTradeNo
                            Success:(void (^)(id responseObject))success
                            failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"wxpay/broker";
    
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    //    ShowActionV();
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"roleApplyAuditId"]=roleApplyAuditId;
    parmers[@"outTradeNo"]=outTradeNo;
    [self POST:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 帮助中心-----------
-(void)kefuXiTongSuccess:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;
{
    NSString *postURL            = @"help";
    
//    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
        ShowActionV();
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];

    [self GET:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 意见反馈 -----------
- (void)yijianfankuiWithBodyStr:(NSString *)bodystr Success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =[NSString stringWithFormat:@"%@opinion",AFBaseURLString];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    NSData *postData = [bodystr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:postURL parameters:nil error:nil];
    request.timeoutInterval= 30.f;
    [request setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    [request setValue:kclient_id forHTTPHeaderField:@"client_id"];
    [request setValue:kclient_secret forHTTPHeaderField:@"client_secret"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 设置body
    [request setHTTPBody:postData];
    [[self dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            success(responseObject);
            RemoveActionV();
        } else {
            failure(error);
            RemoveActionV();
            [HttpClient HTTPERRORMESSAGE:error];
            
        }
    }] resume];
   
    
}
#pragma mark ---------- 工程订单发布 -----------
-(void)fabuGongChengDingDanWithBodyStr:(NSString *)bodyStr
                               Success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =[NSString stringWithFormat:@"%@party/procurement",AFBaseURLString];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    NSData *postData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:postURL parameters:nil error:nil];
    request.timeoutInterval= 30.f;
    [request setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    [request setValue:kclient_id forHTTPHeaderField:@"client_id"];
    [request setValue:kclient_secret forHTTPHeaderField:@"client_secret"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 设置body
    [request setHTTPBody:postData];
    [[self dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            success(responseObject);
            RemoveActionV();
        } else {
            failure(error);
            RemoveActionV();
            [HttpClient HTTPERRORMESSAGE:error];
            
        }
    }] resume];
    
}
#pragma mark ---------- 我得工程订单列表 -----------
-(void)myGongChengDingDanWithLastTime:(NSString *)lastTime
                              Success:(void (^)(id responseObject))success
                              failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"party/procurement";
    
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    ShowActionV();
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"lastTime"]=lastTime;
    [self GET:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark ---------- 工程订单详情 -----------
-(void)MyGongChengDingDanDetialWithorderId:(NSString *)orderId Success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = [NSString stringWithFormat:@"party/procurement/%@",orderId];

    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    ShowActionV();
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];

    [self GET:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark ---------- 工程订单明细关闭 -----------
-(void)MyGongChengDingDanItemCloseWithitemId:(NSString *)itemId WithorderId:(NSString *)orderId Success:(void (^)(id responseObject))success
                                     failure:(void (^)(NSError *error))failure
{

    NSString *postURL            = [NSString stringWithFormat:@"party/procurement/%@/items/%@",orderId,itemId];

    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    ShowActionV();
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];

    [self GET:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 工程订单列表
-(void)getEOrderListWithLastTime:(NSString *)lastTime
                         Success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"procurements";
    
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    ShowActionV();
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"lastTime"]=lastTime;
    [self GET:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark ---------- 工程订单明细报价列表 -----------
-(void)MyGongChengDingDanItemQuotesListWithitemId:(NSString *)itemId WithorderId:(NSString *)orderId Success:(void (^)(id responseObject))success
                                          failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = [NSString stringWithFormat:@"party/procurement/%@/items/%@/quotes",orderId,itemId];

    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    ShowActionV();
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];

    [self GET:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 工程订单明细分页
-(void)MyGongChengDingDanItemsListWithengineeringProcurementId:(NSString *)engineeringProcurementId

                                                      lastTime:(NSString *)lastTime                    Success:(void (^)(id responseObject))success
                                                       failure:(void (^)(NSError *error))failure
{

    NSString *postURL            = [NSString stringWithFormat:@"procurement/%@/items",engineeringProcurementId];

    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    ShowActionV();
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"lastTime"]=lastTime;
    [self GET:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 工程订单列表
-(void)EOrderListWithLastTime:(NSString *)lastTime
                      Success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure
{

    NSString *postURL            = @"procurement";

    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    ShowActionV();
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    parmers[@"lastTime"]=lastTime;
    [self GET:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark ---------- 获取工程订单详情，用于工程订单信息修改
-(void)EOrderDetialWithengineeringProcurementId:(NSString *)engineeringProcurementId
                                        Success:(void (^)(id responseObject))success
                                        failure:(void (^)(NSError *error))failure
{

    NSString *postURL            = [NSString stringWithFormat:@"procurement/%@",engineeringProcurementId];

    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    ShowActionV();
    NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
    [self GET:postURL parameters:parmers progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark -获取消息列表
-(void)systemMessageListWithType:(NSString *)noticeType
                    WithLastTime:(NSString *)lastTime
                         Success:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"party/messages";

    NSMutableDictionary *parmers=[NSMutableDictionary dictionary];
    parmers[@"lastTime"]=lastTime;
    parmers[@"noticeType"]=noticeType;
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];

    [self GET:postURL parameters:parmers progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark -设置消息已读
-(void)readedMessageWithmessageIds:(NSString *)messageIds
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure
{
    NSString *postURL = @"party/messages";

    NSMutableDictionary *parmers=[NSMutableDictionary dictionary];

    parmers[@"messageIds"]=messageIds;
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    ShowActionV();
    [self PUT:postURL parameters:parmers success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        RemoveActionV();
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];

}
#pragma mark -获取消息未读数量
-(void)messageUnReadNumWithpartyId:(NSString *)partyId
                           Success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure
{

    NSString *postURL = @"party/messages";

    NSMutableDictionary *parmers=[NSMutableDictionary dictionary];
    
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];

    [self GET:postURL parameters:parmers progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark -经纪人详情
-(void)jjrDetialWithUid:(NSString *)uid
                Success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure
{
    NSString *postURL            =@"party/brokers";
        [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",APPDELEGATE.userModel.access_token] forHTTPHeaderField:@"Authorization"];
    [self GET:postURL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
#pragma mark -退出登录
-(void)logoutSuccess:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure
{

    NSString *postURL = @"logout";
   
    [self GET:postURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        RemoveActionV();
        [HttpClient HTTPERRORMESSAGE:error];
    }];
    
}
#pragma mark ---------- 获取新闻分类列表 -----------
- (void)getNewsClassSuccess:(void (^)(id responseObject))success
                    failure:(void (^)(NSError *error))failure
{
    NSString *postURL            = @"news/type";
    
    ShowActionV();
    [self GET:postURL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        RemoveActionV();
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        RemoveActionV();
        //        [HttpClient HTTPERRORMESSAGE:error];
    }];
}
@end
