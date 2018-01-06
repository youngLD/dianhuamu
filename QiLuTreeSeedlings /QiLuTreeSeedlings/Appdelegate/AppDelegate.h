//
//  AppDelegate.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/1/28.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "UserInfoModel.h"
#import "BusinessMesageModel.h"
#import "YLDGCGSModel.h"
//环信
#import "MainViewController.h"
#import "ApplyViewController.h"
#import "ChatDemoHelper.h"



#import <AliyunOSSiOS/OSSService.h>
#import "CityModel.h"
#import "YLDFAddressModel.h"
#import "YLDFQYInfoModel.h"
#import "YYModel.h"
//#import "EMSDK.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate, EMChatManagerDelegate>
{
    EMConnectionState _connectionState;
}


@property (strong, nonatomic) UIWindow *window;
/////
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) ChatDemoHelper *ChatHelper;
@property (nonatomic, strong) UserInfoModel *userModel;
@property (nonatomic, strong) BusinessMesageModel *companyModel;
@property (nonatomic, strong) YLDGCGSModel *GCGSModel;
@property (nonatomic, strong) OSSClient* client;
@property (nonatomic, strong) CityModel* cityModel;
@property (nonatomic)BOOL isCanPublishBuy;
@property (nonatomic,copy)NSString *IDFVSTR;
@property (nonatomic,strong) YLDFAddressModel *addressModel;
@property (nonatomic,copy) NSArray *addressAry;
@property (nonatomic,strong) YLDFQYInfoModel *qyModel;
/**
 *  是否来自单条购买界面（用来判断单条购买界面余额不足，进行充值）
 */
@property (nonatomic, assign) BOOL isFromSingleVoucherCenter;
@property (strong, nonatomic) MainViewController *mainController;

-(BOOL)isNeedLogin;
-(BOOL)isNeedCompany;
-(void)reloadUserInfoSuccess:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;
-(void)logoutAction;
-(void)reloadCompanyInfo;
- (void)saveContext;
- (void)requestBuyRestrict;
- (NSURL *)applicationDocumentsDirectory;
-(void)getGchenggongsiInfo;
// 统计未读消息数
-(NSInteger)setupUnreadMessageCount;
-(void)unReadShowOrHiddenRedPiont;
-(void)getdefaultAddress;
-(void)huoquqiyxinxi;
@end

