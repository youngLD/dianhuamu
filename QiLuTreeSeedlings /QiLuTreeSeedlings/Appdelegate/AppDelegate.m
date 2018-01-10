   //
//  AppDelegate.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/1/28.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarController.h"

#import "UIDefines.h"
#import "HttpClient.h"
#import "ToastView.h"
//键盘自动管理
#import <IQKeyboardManager/IQKeyboardManager.h>

//友盟
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMMobClick/MobClick.h"
//微信
#import "WXApi.h"
//支付宝
#import <AlipaySDK/AlipaySDK.h>
#import <AudioToolbox/AudioToolbox.h>
//引导页
#import "EAIntroView.h"
//环信
#import "AppDelegate+Parse.h"
#import "AppDelegate+EaseMob.h"
#import "UserProfileManager.h"
#import "HttpDefines.h"
//畅言
#import "ChangyanSDK.h"
#import "MYVendorToll.h"
#import "GetCityDao.h"
//开屏广告相关
#import "YLDSadvertisementModel.h"
#import "XHLaunchAd.h"
#import "YLDSADViewController.h"
#import "ZIKMyShopViewController.h"
//个推参数
//#define kGtAppId           @"dxb5cYhXBW6yYLPsAfvtGA"
//#define kGtAppKey          @"m2iC5d15as6Vub2OGIaxP6"
//#define kGtAppSecret       @"9IHKXKIl7G7ozrvkOMQvx7"
//
//#import <UserNotifications/UserNotifications.h>

//阿里推送配置
#import <UserNotifications/UserNotifications.h>
#import <CloudPushSDK/CloudPushSDK.h>
#define kAiLAppKey          @"24696567"
#define kAiLAppSecret       @"eb9ddf820ef02651b630fc9a0a828ddc"
@interface AppDelegate ()<CLLocationManagerDelegate,WXApiDelegate,EAIntroDelegate,UIAlertViewDelegate,EMCallManagerDelegate,EMChatManagerDelegate,UNUserNotificationCenterDelegate>
@property (nonatomic,strong)EAIntroView *intro;
@property (strong, nonatomic) NSDate *lastPlaySoundDate;
@property (nonatomic,strong)YLDSadvertisementModel *adModel;
@end

@implementation AppDelegate
{
    // iOS 10通知中心
    UNUserNotificationCenter *_notificationCenter;
}
@synthesize intro;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量

    keyboardManager.enable = YES; // 控制整个功能是否启用

    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘

    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义

    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框

    keyboardManager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条

    keyboardManager.shouldShowTextFieldPlaceholder = YES; // 是否显示占位文字

    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17]; // 设置占位文字的字体
    
    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
    
  
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        GetCityDao *citydao=[GetCityDao new];
        [citydao openDataBase];
        self.cityModel = [citydao getcityModelByCityCode:@"1101"];
        [citydao closeDataBase];
        //生成缓存池
        NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
        [NSURLCache setSharedURLCache:URLCache];
        self.IDFVSTR=[MYVendorToll getIDFV];
        //阿里文件服务
        NSString *endpoint = @"http://img.miaoxintong.cn";
        id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:@"LTAIgyOv3oX16N4n" secretKey:@"cjU2iSqjrQT8PYuoMWqn284G6qVWBr"];
        
        _client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];
                //生成地址数据库
        [self initData];
        /*******************友盟分享*******************/
        //[UMSocialData setAppKey:@"569c3c37e0f55a8e3b001658"];
        //[UMSocialData defaultData].appKey = @"56fde8aae0f55a1cd300047c";
        [UMSocialData setAppKey:@"56fde8aae0f55a1cd300047c"];
        [UMSocialData openLog:YES];
        UMConfigInstance.appKey = @"56fde8aae0f55a1cd300047c";
        UMConfigInstance.token  = @"56fde8aae0f55a1cd300047c";
        //UMConfigInstance.secret = @"secretstringaldfkals";
        //    UMConfigInstance.eSType = E_UM_GAME;
        [MobClick startWithConfigure:UMConfigInstance];
        [MobClick setLogEnabled:YES];
        //设置微信AppId、appSecret，分享url
        [UMSocialWechatHandler setWXAppId:@"wx380f0f3dd0059942" appSecret:@"044bc19fadfd1b6b232e87250f4416b5" url:@"http://www.somiao.top"];
        //设置分享到QQ/Qzone的应用Id，和分享url 链接
        [UMSocialQQHandler setQQWithAppId:@"1105469454" appKey:@"APPkey:LdUq6avQVQjxOZoD" url:@"http://www.qlmm.cn"];//16位0x41E4200E
        //向微信注册wx15fce880e520ad30
        [WXApi registerApp:@"wx380f0f3dd0059942" withDescription:@"点花木"];
        /*******************友盟分享*******************/
        
        
        
        /*******************环信*******************/
        _connectionState = EMConnectionConnected;
        // 环信UIdemo中有用到Parse，您的项目中不需要添加，可忽略此处。
//        [self parseApplication:application didFinishLaunchingWithOptions:launchOptions];
//        EMOptions *options = [EMOptions optionsWithAppkey:HXAPPKey];
//        NSString *apnsCertName = nil;
//        
//   
//#if DEBUG
//        apnsCertName = @"miaoxintong_dev";
//#else
//        apnsCertName = @"miaoxintongfabu";
//#endif
//        NSString *hxKeyStr=HXAPPKey;
//        
//        options.apnsCertName = apnsCertName;
//        [[EMClient sharedClient] initializeSDKWithOptions:options];
//        
//        [[EaseSDKHelper shareHelper] hyphenateApplication:application
//                            didFinishLaunchingWithOptions:launchOptions
//                                                   appkey:hxKeyStr                                         apnsCertName:apnsCertName
//                                              otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
//        //注册环信消息回调代理
//        [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
        
        //    EMError *error = [[EMClient sharedClient] registerWithUsername:@"15953523812" password:@"123456"];
        //    if (error==nil) {
        //        NSLog(@"注册成功");
        //    }
        /*******************环信*******************/
#if DEBUG
        
#else

#endif
        
        //#endif
        
       
        
        // 处理远程通知启动APP
        [self receiveNotificationByLaunchingOptions:launchOptions];
//        application.applicationIconBadgeNumber = 0;
        //网络状况监听
        [self AFNReachability];
        
        //畅言
        // 一定要用自己的 不要用demo中的
        [ChangyanSDK registerApp:changyan_id
                          appKey:changyan_key
                     redirectUrl:nil
            anonymousAccessToken:nil];
        
        [ChangyanSDK setAllowSelfLogin:YES];
        
        
        [ChangyanSDK setAllowAnonymous:NO];
        [ChangyanSDK setAllowRate:NO];
        [ChangyanSDK setAllowUpload:YES];
        [ChangyanSDK setAllowWeiboLogin:NO];
        [ChangyanSDK setAllowQQLogin:NO];
        [ChangyanSDK setAllowSohuLogin:NO];

    });

  [XHLaunchAd setWaitDataDuration:3.2];
   [HTTPADCLIENT openViewAdSuccess:^(id responseObject) {
       if ([[responseObject objectForKey:@"success"] integerValue]&&[[responseObject objectForKey:@"count"] integerValue]) {
           NSArray *result=[responseObject objectForKey:@"result"];
           YLDSadvertisementModel *model=[YLDSadvertisementModel yldSadvertisementModelByDic:[result firstObject]];
           self.adModel=model;
           if (model.adsType==0||model.adsType==2||model.adsType==4) {
               XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration new];
               //广告停留时间
               imageAdconfiguration.duration = 3.0;
               //广告frame
               imageAdconfiguration.frame = CGRectMake(0, 0, kWidth, kHeight);
               //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
               
               imageAdconfiguration.imageNameOrURLString = model.attachment;
               //缓存机制(仅对网络图片有效)
               //为告展示效果更好,可设置为XHLaunchAdImageCacheInBackground,先缓存,下次显示
               imageAdconfiguration.imageOption = XHLaunchAdImageDefault;
               //图片填充模式
               imageAdconfiguration.contentMode = UIViewContentModeScaleToFill;
               //广告点击打开链接
               if (model.adType==0) {
                  imageAdconfiguration.openURLString = model.content;
               }else if (model.adType==1){
                   imageAdconfiguration.openURLString = model.link;
               }else{
                   imageAdconfiguration.openURLString=model.shop;
               }
               
               //广告显示完成动画
               imageAdconfiguration.showFinishAnimate =ShowFinishAnimateFadein;
               //广告显示完成动画时间
               imageAdconfiguration.showFinishAnimateTime = 0.1;
               //跳过按钮类型
               imageAdconfiguration.skipButtonType = SkipTypeTimeText;
               //后台返回时,是否显示广告
               imageAdconfiguration.showEnterForeground = NO;
               

               //显示开屏广告
               [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
           }
       }
   } failure:^(NSError *error) {
       
   }];

   
    [HTTPCLIENT getVersionSuccess:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]==1) {
             NSInteger version=[[[responseObject objectForKey:@"result"] objectForKey:@"version"] integerValue];
            //版本更新比较
            if (version>25) {
                NSInteger updateState=[[[responseObject objectForKey:@"result"] objectForKey:@"updateState"] integerValue];
                if (updateState==1) {
                    ShowSpecialActionV();
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"更新提示" message:[[responseObject objectForKey:@"result"] objectForKey:@"updateContent"] preferredStyle:UIAlertControllerStyleAlert];
                   
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull      action) {
                        
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/miao-xin-tong/id1104131374?mt=8"]];
                        
                    }];
                    [alertController addAction:okAction];
                    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
                }else{
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"更新提示" message:[[responseObject objectForKey:@"result"] objectForKey:@"updateContent"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull      action) {
                        
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/miao-xin-tong/id1104131374?mt=8"]];
                        
                    }];
                    [alertController addAction:cancelAction];
                    [alertController addAction:okAction];
                    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
                }
                
   
                
            }
        }
        RemoveActionV();
    } failure:^(NSError *error) {
        RemoveActionV();
    }];

    //自动登录功能
    [self selfloginAction];
   
    //是否是第一次启动
   [self requestInitInfo];


    self.userModel = [[UserInfoModel alloc]init];
    NSUserDefaults *userDefau = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken=[userDefau objectForKey:@"deviceToken"];
    if (deviceToken.length==0) {
        [userDefau setObject:@"用户未授权" forKey:@"deviceToken"];
        [userDefau synchronize];
    }
 

    /*******************阿里推送*******************/
    // APNs注册，获取deviceToken并上报
    [self registerAPNS:application];
    // 初始化SDK
    [self initCloudPush];
    // 监听推送通道打开动作
    [self listenerOnChannelOpened];
    // 监听推送消息到达
    [self registerMessageReceive];
    // 点击通知将App从关闭状态启动时，将通知打开回执上报
    // [CloudPushSDK handleLaunching:launchOptions];(Deprecated from v1.8.1)
    [CloudPushSDK sendNotificationAck:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    BaseTabBarController *mainController = [[BaseTabBarController alloc] init];
    self.window.rootViewController = mainController;
    [self.window makeKeyAndVisible];
    
    return YES;
}
#pragma mark-开屏广告点击
- (void)xhLaunchAd:(XHLaunchAd *)launchAd clickAndOpenURLString:(NSString *)openURLString;
{
    NSString *ttt;
    if ([self isNeedLogin]) {
        ttt=@"0";
    }else{
        ttt=@"1";
    }
    [HTTPADCLIENT adClickAcitionWithADuid:self.adModel.uid WithMemberUid:self.userModel.access_id WithBrowsePage:nil WithBrowseUserType:ttt withiosClientId:APPDELEGATE.IDFVSTR Success:^(id responseObject) {
        //                        [ToastView showTopToast:responseObject obgect]
    } failure:^(NSError *error) {
        
    }];
    if (self.adModel.adType==0||self.adModel.adType==1) {
        YLDSADViewController *VC = [[YLDSADViewController alloc] init];
        VC.urlString = openURLString;
        VC.hidesBottomBarWhenPushed=YES;
        //此处不要直接取keyWindow
        BaseTabBarController* rootVC = (BaseTabBarController *)self.window.rootViewController;
        UINavigationController* nav = [rootVC.viewControllers objectAtIndex:0];
        
        UIViewController *pushVC = [nav.viewControllers objectAtIndex:0];
        [pushVC.navigationController pushViewController:VC animated:YES];
    }else if (self.adModel.adType==2)
    {
        ZIKMyShopViewController *VC = [[ZIKMyShopViewController alloc] init];
        VC.memberUid = openURLString;
        VC.type=1;
        VC.hidesBottomBarWhenPushed=YES;
        //此处不要直接取keyWindow
        BaseTabBarController* rootVC = (BaseTabBarController *)self.window.rootViewController;
        UINavigationController* nav = [rootVC.viewControllers objectAtIndex:0];
        
        UIViewController *pushVC = [nav.viewControllers objectAtIndex:0];
        [pushVC.navigationController pushViewController:VC animated:YES];
    }
    
}
-(void)selfloginAction
{
    //自动登录
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *token=[userDefaults objectForKey:kACCESS_TOKEN];

    
    if (token) {
        self.userModel.access_token = token;
        ShowActionV();
        
        [self reloadUserInfoSuccess:^(id responseObject) {
            //获取企业信息
            
            RemoveActionV();
            
        } failure:^(NSError *error) {
            RemoveActionV();
        }];
        
    }

}
#pragma mark-监听网络
-(void)AFNReachability
{
    //1.创建网络监听管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    

    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status!=0) {
            if (![APPDELEGATE isNeedLogin]) {
                [self selfloginAction];
            }
            NSUserDefaults *userDefau = [NSUserDefaults standardUserDefaults];
            NSArray *aryImage=[NSArray arrayWithArray:[userDefau objectForKey:@"RZImageAry"]];
            if (aryImage.count>0) {
                __weak typeof(self)weakself=self;
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    for (NSDictionary *dic in aryImage) {
                        [weakself upUnImageWithImagePath:dic];
                    }
                });
            }
        }

    }];
    
    //3.开始监听
    [manager startMonitoring];
}
- (void)requestInitInfo {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"diyici"]) {
        
        //[self judgeLogin];//判断是否需要登录
    }else{
      
        [self showIntroWithCrossDissolve];
    }
    
    //注册本地通知
    UIApplication *application = [UIApplication sharedApplication];
//    application.applicationIconBadgeNumber = 0;
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
}
//获取默认地址
-(void)getdefaultAddress
{
    [HTTPCLIENT getDefaultAddressSuccess:^(id responseObject) {
        if([[responseObject objectForKey:@"success"] integerValue])
        {
            NSDictionary *dic=[responseObject objectForKey:@"data"];
            self.addressModel=[YLDFAddressModel creatModelWithDic:dic];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)huoquqiyxinxi
{
    [HTTPCLIENT enterpriseInfoSuccess:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            self.qyModel=[YLDFQYInfoModel yy_modelWithJSON:[responseObject objectForKey:@"data"]];
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {

    }];
}
-(void)getAddressAryDate
{
    [HTTPCLIENT addressListSuccess:^(id responseObject) {
        if([[responseObject objectForKey:@"success"] integerValue])
        {
            
            NSArray *ary=[responseObject objectForKey:@"data"];
             self.addressAry=ary;
            
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)getGchenggongsiInfo
{
    [HTTPCLIENT gongchengZhongXinInfoSuccess:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            self.GCGSModel=[YLDGCGSModel yldGCGSModelWithDic:[[responseObject objectForKey:@"result"] objectForKey:@"companyInfo"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)showIntroWithCrossDissolve {
    int height=(int)kHeight;
    EAIntroPage *page0 = [EAIntroPage page];
    page0.title        = @"";
    page0.desc         = @"";
    page0.bgImage      = [UIImage imageNamed:[NSString stringWithFormat:@"0miaomu%d",height*2]];
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title        = @"";
    page1.desc         = @"";
    page1.bgImage      = [UIImage imageNamed:[NSString stringWithFormat:@"1miaomu%d",height*2]];
    //page1.titleImage   = [UIImage imageNamed:@"original"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title        = @"";
    page2.desc         = @"";
    page2.bgImage      = [UIImage imageNamed:[NSString stringWithFormat:@"2miaomu%d",height*2]];
    //page2.titleImage   = [UIImage imageNamed:@"supportcat"];
    
    
    intro = [[EAIntroView alloc] initWithFrame:self.window.bounds andPages:@[page0,page1,page2]];
    
    [intro setDelegate:self];
    [intro showInView:self.window animateDuration:0.0];
}

- (void)introDidFinish {
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"diyici"];
    [intro hideWithFadeOutDuration:0.0f];
    intro = nil;

}
-(void)reloadCompanyInfo
{
    if ([self isNeedLogin]==NO) {
        RemoveActionV();
        return;
    }
   
    [HTTPCLIENT getCompanyInfoSuccess:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSDictionary *dic=[responseObject objectForKey:@"result"];
            if (![[dic objectForKey:@"ishave"] isEqualToString:@"nocompany"]) {
                self.companyModel=[BusinessMesageModel creatBusinessMessageModelByDic:dic];
            }
            else{
                
            }
        }
        RemoveActionV();
    } failure:^(NSError *error) {
        RemoveActionV();
    }];
}
- (BOOL)isNeedLogin
{
    return (self.userModel.partyId) ? YES : NO;
}
-(BOOL)isNeedCompany
{
    return (self.companyModel.uid) ? YES : NO;
}
- (void)requestBuyRestrict {
    HttpClient *httpClient=[HttpClient sharedClient];
    //供求发布限制
    ShowActionV();
    [httpClient getSupplyRestrictWithToken:APPDELEGATE.userModel.access_token  withId:APPDELEGATE.userModel.access_id withClientId:nil withClientSecret:nil withDeviceId:nil withType:@"1" success:^(id responseObject) {
        RemoveActionV();
        NSDictionary *dic=[responseObject objectForKey:@"result"];
        if ( [dic[@"count"] integerValue] == 0) {// “count”: 1	--当数量大于0时，表示可发布；等于0时，不可发布
            self.isCanPublishBuy = NO;
            //NSLog(@"不可发布");
        }
        else {
            //NSLog(@"可发布");
            self.isCanPublishBuy = YES;
        }
        RemoveActionV();
    } failure:^(NSError *error) {
        RemoveActionV();
    }];
}
-(void) reloadUserInfoSuccess:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure
{
    RemoveActionV();
    if (!self.userModel.access_token) {
        return;
    }
    
    
    [HTTPCLIENT getUserInfoByToken:self.userModel.access_token byAccessId:nil Success:^(id responseObject) {
        RemoveActionV();
        if (![[responseObject objectForKey:@"success"] integerValue]) {
            //NSLog(@"%@",responseObject);
            NSString *msg=[responseObject objectForKey:@"msg"];
            
            if ([msg isEqualToString:@"Token验证失败"]) {
                [self logoutAction];
//                [self unReadShowOrHiddenRedPiont];
                [ToastView showTopToast:@"您的登录已失效，请重新登录"];
            }else{
                [ToastView showTopToast:msg];
            }
        }else
        {
           
            NSDictionary *personDic=[[responseObject objectForKey:@"data"] objectForKey:@"person"];
            [self.userModel reloadInfoByDic:personDic];
            self.userModel.roles=[[responseObject objectForKey:@"data"] objectForKey:@"roles"];
             [self getdefaultAddress];
            [self  getAddressAryDate];
            [self huoquqiyxinxi];
            success(responseObject);
//            [self unReadShowOrHiddenRedPiont];

            
           
            [ChangyanSDK loginSSO:self.userModel.partyId userName:self.userModel.nickname profileUrl:nil imgUrl:self.userModel.headUrl completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
                if (statusCode == CYSuccess)
                {
                }
            }];
        }
        RemoveActionV();
    } failure:^(NSError *error) {
        RemoveActionV();
    }];
}
-(void)logoutAction
{
    [ToastView showTopToast:@"您已退出登录"];
    NSUserDefaults *defatluts = [NSUserDefaults standardUserDefaults];
    
    [defatluts removeObjectForKey:@"jjrRenZheng"];
    [defatluts synchronize];
        
    
    EMError *error = [[EMClient sharedClient] logout:YES];
    if (!error) {
       
    }
    [ChangyanSDK logout];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenReadPoint" object:nil];
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kACCESS_ID];
    [userDefaults removeObjectForKey:kACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] setObject:@""   forKey:@"myphone"];
    [userDefaults synchronize];
    self.userModel=nil;
    self.companyModel=nil;
    self.addressModel=nil;
    self.addressAry =nil;
    self.qyModel=nil;
    self.isCanPublishBuy=NO;
    [HTTPCLIENT logoutSuccess:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - 用户通知(推送) _自定义方法
#pragma mark SDK Init
- (void)initCloudPush {
    // 正式上线建议关闭
    [CloudPushSDK turnOnDebug];
    // SDK初始化
    [CloudPushSDK asyncInit:kAiLAppKey appSecret:kAiLAppSecret callback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Push SDK init success, deviceId");
        } else {
            NSLog(@"Push SDK init failed, error: %@", res.error);
        }
    }];
}
#pragma mark Channel Opened
/**
 *    注册推送通道打开监听
 */
- (void)listenerOnChannelOpened {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onChannelOpened:)
                                                 name:@"CCPDidChannelConnectedSuccess"
                                               object:nil];
}

/**
 *    推送通道打开回调
 *
 *    @param     notification
 */
- (void)onChannelOpened:(NSNotification *)notification {
//    [MsgToolBox showAlert:@"温馨提示" content:@"消息通道建立成功"];
}
/** 注册用户通知 */
- (void)registerAPNS:(UIApplication *)application {
    float systemVersionNum = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersionNum >= 10.0) {
        // iOS 10 notifications
        _notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
        // 创建category，并注册到通知中心
        [self createCustomNotificationCategory];
        _notificationCenter.delegate = self;
        // 请求推送权限
        [_notificationCenter requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                // granted
                NSLog(@"User authored notification.");
                // 向APNs注册，获取deviceToken
                dispatch_async(dispatch_get_main_queue(), ^{
                    [application registerForRemoteNotifications];
                });
            } else {
                // not granted
                NSLog(@"User denied notification.");
            }
        }];
    } else if (systemVersionNum >= 8.0) {
        // iOS 8 Notifications
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        [application registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:
          (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                           categories:nil]];
        [application registerForRemoteNotifications];
#pragma clang diagnostic pop
    } else {
        // iOS < 8 Notifications
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
#pragma clang diagnostic pop
    }
}

/**
 *  创建并注册通知category(iOS 10+)
 */
- (void)createCustomNotificationCategory {
    // 自定义`action1`和`action2`
    UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:@"action1" title:@"test1" options: UNNotificationActionOptionNone];
    UNNotificationAction *action2 = [UNNotificationAction actionWithIdentifier:@"action2" title:@"test2" options: UNNotificationActionOptionNone];
    // 创建id为`test_category`的category，并注册两个action到category
    // UNNotificationCategoryOptionCustomDismissAction表明可以触发通知的dismiss回调
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"test_category" actions:@[action1, action2] intentIdentifiers:@[] options:
                                        UNNotificationCategoryOptionCustomDismissAction];
    // 注册category到通知中心
    [_notificationCenter setNotificationCategories:[NSSet setWithObjects:category, nil]];
}

/**
 *  处理iOS 10通知(iOS 10+)
 */
- (void)handleiOS10Notification:(UNNotification *)notification {
    UNNotificationRequest *request = notification.request;
    UNNotificationContent *content = request.content;
    NSDictionary *userInfo = content.userInfo;
    // 通知时间
    NSDate *noticeDate = notification.date;
    // 标题
    NSString *title = content.title;
    // 副标题
    NSString *subtitle = content.subtitle;
    // 内容
    NSString *body = content.body;
    // 角标
    int badge = [content.badge intValue];
    // 取得通知自定义字段内容，例：获取key为"Extras"的内容
    NSString *extras = [userInfo valueForKey:@"Extras"];
    // 通知角标数清0
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // 同步角标数到服务端
    // [self syncBadgeNum:0];
    // 通知打开回执上报
    [CloudPushSDK sendNotificationAck:userInfo];
    NSLog(@"Notification, date: %@, title: %@, subtitle: %@, body: %@, badge: %d, extras: %@.", noticeDate, title, subtitle, body, badge, extras);
}

/**
 *  App处于前台时收到通知(iOS 10+)
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSLog(@"Receive a notification in foregound.");
    // 处理iOS 10通知，并上报通知打开回执
    [self handleiOS10Notification:notification];
    // 通知不弹出
    completionHandler(UNNotificationPresentationOptionNone);
    
    // 通知弹出，且带有声音、内容和角标
    //completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge);
}

/**
 *  触发通知动作时回调，比如点击、删除通知和点击自定义action(iOS 10+)
 */

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSString *userAction = response.actionIdentifier;
    // 点击通知打开
    if ([userAction isEqualToString:UNNotificationDefaultActionIdentifier]) {
        NSLog(@"User opened the notification.");
        // 处理iOS 10通知，并上报通知打开回执
        [self handleiOS10Notification:response.notification];
    }
    // 通知dismiss，category创建时传入UNNotificationCategoryOptionCustomDismissAction才可以触发
    if ([userAction isEqualToString:UNNotificationDismissActionIdentifier]) {
        NSLog(@"User dismissed the notification.");
    }
    NSString *customAction1 = @"action1";
    NSString *customAction2 = @"action2";
    // 点击用户自定义Action1
    if ([userAction isEqualToString:customAction1]) {
        NSLog(@"User custom action1.");
    }
    
    // 点击用户自定义Action2
    if ([userAction isEqualToString:customAction2]) {
        NSLog(@"User custom action2.");
    }
    completionHandler();
}

/** 自定义：APP被“推送”启动时处理推送消息处理（APP 未启动--》启动）*/
- (void)receiveNotificationByLaunchingOptions:(NSDictionary *)launchOptions {
    if (!launchOptions)
        return;
    
    /*
     通过“远程推送”启动APP
     UIApplicationLaunchOptionsRemoteNotificationKey 远程推送Key
     */
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (userInfo) {
        [self performSelector:@selector(tongzhihuanxingchuli:) withObject:userInfo/*可传任意类型参数*/ afterDelay:2.0];
        }

}
-(void)tongzhihuanxingchuli:(NSDictionary *)userInfo
{
    
    
    NSString *tuisongType=[[userInfo objectForKey:@"aps"] objectForKey:@"category"];
    if ([tuisongType isEqualToString:@"push_buy"]||[tuisongType isEqualToString:@"buy_match_supply"]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dingzhixinxituisong" object:@"1"];
    }else if ([tuisongType isEqualToString:@"purchase_match_supply"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dingzhixinxituisong" object:@"2"];
    }else if ([tuisongType isEqualToString:@"push_broker_supplybuy"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dingzhixinxituisong" object:@"4"];
    }else if ([tuisongType isEqualToString:@"workstationQuote"]) {
        // workstationQuote
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dingzhixinxituisong" object:@"3"];
    }else
    {

        [[NSNotificationCenter defaultCenter] postNotificationName:@"dingzhixinxituisong" object:@"0"];
    }
 
}

#pragma mark - 用户通知(推送)回调 _IOS 8.0以上使用

/** 已登记用户通知 */
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // 注册远程通知（推送）
    [application registerForRemoteNotifications];
    
    
}

#pragma mark - 远程通知(推送)回调

/** 
 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *myToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    myToken = [myToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
   
    //阿里推送
    [CloudPushSDK registerDevice:deviceToken withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            
            NSLog(@"Register deviceToken success %@.",myToken);
        } else {
//            NSLog(@"Register deviceToken failed, error: %@", res.error);
        }
    }];
    //畅言推送

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient] bindDeviceToken:deviceToken];
    });
    [HTTPCLIENT.requestSerializer setValue:myToken forHTTPHeaderField:@"device_id"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:myToken forKey:kdeviceToken];
    [userDefaults synchronize];
//    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", myToken);
}

/** 远程通知注册失败委托 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
//    [GeTuiSdk registerDeviceToken:@""];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"用户未授权" forKey:@"deviceToken"];
    [userDefaults synchronize];
    //NSLog(@"\n>>>[DeviceToken Error]:%@\n\n", error.description);
}
/**
 *    注册推送消息到来监听
 */
- (void)registerMessageReceive {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onMessageReceived:)
                                                 name:@"CCPDidReceiveMessageNotification"
                                               object:nil];
}
/**
 *    处理到来推送消息
 *
 *    @param     notification
 */
- (void)onMessageReceived:(NSNotification *)notification {
    CCPSysMessage *message = [notification object];
    NSString *title = [[NSString alloc] initWithData:message.title encoding:NSUTF8StringEncoding];
    NSString *body = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
    NSLog(@"Receive message title: %@, content: %@.", title, body);
}
#pragma mark - APP运行中接收到通知(推送)处理

/** APP已经接收到“远程”通知(推送) - (App运行在后台/App运行在前台) */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
   [CloudPushSDK sendNotificationAck:userInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showReadPoint" object:nil];
    // 处理APN
    if ([application applicationState]==UIApplicationStateActive) {
        SystemSoundID sound=1000;
        AudioServicesPlaySystemSound(sound);
        sound=kSystemSoundID_Vibrate;
        AudioServicesPlaySystemSound(sound);
    }
    if ([application applicationState]==UIApplicationStateInactive) {
        NSString *tuisongType=[[userInfo objectForKey:@"aps"] objectForKey:@"category"];
        if ([tuisongType isEqualToString:@"push_buy"]||[tuisongType isEqualToString:@"buy_match_supply"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dingzhixinxituisong" object:@"1"];
        }else if ([tuisongType isEqualToString:@"purchase_match_supply"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dingzhixinxituisong" object:@"2"];
        }else if ([tuisongType isEqualToString:@"workstationQuote"]) {
            // workstationQuote
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dingzhixinxituisong" object:@"3"];
        }else if ([tuisongType isEqualToString:@"push_broker_supplybuy"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dingzhixinxituisong" object:@"4"];
        }else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dingzhixinxituisong" object:@"0"];
        }
    }
    
    if ([application applicationState]==UIApplicationStateBackground) {
        
    }
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if (_mainController) {
        [_mainController didReceiveLocalNotification:notification];
    }
}


/** APP已经接收到“远程”通知(推送) - 透传推送消息  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showReadPoint" object:nil];
    // 处理APN
    if ([application applicationState]==UIApplicationStateActive) {
        SystemSoundID sound=1000;
        AudioServicesPlaySystemSound(sound);
        sound=kSystemSoundID_Vibrate;
        AudioServicesPlaySystemSound(sound);
    }
    if ([application applicationState]==UIApplicationStateInactive) {
        NSString *tuisongType=[[userInfo objectForKey:@"aps"] objectForKey:@"category"];
        if ([tuisongType isEqualToString:@"push_buy"]||[tuisongType isEqualToString:@"buy_match_supply"]) {
           [[NSNotificationCenter defaultCenter] postNotificationName:@"dingzhixinxituisong" object:@"1"];
        }else if ([tuisongType isEqualToString:@"purchase_match_supply"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dingzhixinxituisong" object:@"2"];
        }else if ([tuisongType isEqualToString:@"workstationQuote"]) {
            // workstationQuote
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dingzhixinxituisong" object:@"3"];
        }else if ([tuisongType isEqualToString:@"push_broker_supplybuy"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dingzhixinxituisong" object:@"4"];
        }else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dingzhixinxituisong" object:@"0"];
        }
    }
    
    if ([application applicationState]==UIApplicationStateBackground) {
        
    }
    completionHandler(UIBackgroundFetchResultNewData);
}
- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    /// Background Fetch 恢复SDK 运行
//    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}
#pragma mark - GeTuiSdkDelegate






- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}
- (void)initData
{
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *documentsDirectory = [paths objectAtIndex:0];
    //    NSString *gpsPath = [documentsDirectory stringByAppendingString: @"/config.xml"];
    //    [[NSFileManager defaultManager] createFileAtPath: gpsPath contents:nil attributes:nil];
    self.isFromSingleVoucherCenter  = NO;
    BOOL copySucceeded = NO;
    
    NSString *fileName = @"areadbs1";
    
    // Get our document path.
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [searchPaths objectAtIndex:0];
    
    // Get the full path to our file.
    NSString *filePath = [documentPath stringByAppendingPathComponent:fileName];
    // Get a file manager
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // Does the database already exist? (If not, copy it from our bundle)
    if(![fileManager fileExistsAtPath: filePath])
    {
        //CLog(@"copyFromBundle - checking for presence of \"%@\"...", fileName);
        // Get the bundle location
        NSString *bundleDBPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"sqlite"];
        
        // Copy the DB to our document directory.
        copySucceeded = [fileManager copyItemAtPath:bundleDBPath
                                             toPath:filePath
                                              error:nil];
        
        if(!copySucceeded) {
           // NSLog(@"copyFromBundle - Unable to copy \"%@\" to document directory.", fileName);
        }
        else {
           // NSLog(@"copyFromBundle - Succesfully copied \"%@\" to document directory.", fileName);
        }
    }
    else
    {
        
    }
    
//    BaseDao *dao = [[BaseDao alloc] init];
//    [dao openDataBase];
//    [dao executeUpdate:sql];
//    [dao closeDataBase];
}
- (void)applicationWillResignActive:(UIApplication *)application {
   
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //环信
    [[EMClient sharedClient] applicationDidEnterBackground:application];

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //环信
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //NSLog(@"- (void)applicationDidBecomeActive:(UIApplication *)application {");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "-5953523812-163.com.QiLuTreeSeedlings" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"QiLuTreeSeedlings" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"QiLuTreeSeedlings.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
       // NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark - 微信支付
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    return  [WXApi handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
  BOOL wxSure =  [WXApi handleOpenURL:url delegate:self];
    if (wxSure == TRUE) {
        return wxSure;
    }
    BOOL result = [UMSocialSnsService handleOpenURL:url wxApiDelegate:self];
     if (result == TRUE) {
        return result;
    }
    BOOL appJump;

    if ([url.host isEqualToString:@"response_from_qq"] || [url.host isEqualToString:@"platformId=wechat"]) {

        return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:self];
    }

    //跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK   
    if ([url.host isEqualToString:@"safepay"]) {
        appJump = YES;
        [[AlipaySDK defaultService]
         processOrderWithPaymentResult:url
         standbyCallback:^(NSDictionary *resultDic) {

             NSString *aliRetValue = nil;

             if([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"])
             {
                 aliRetValue = @"付款成功";
//                 [[NSNotificationCenter defaultCenter] postNotificationName:@"PaySuccessNotification" object:nil userInfo:nil];
//                 [[NSNotificationCenter defaultCenter] postNotificationName:@"SinglePaySuccessNotification" object:nil];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"PaySuccessNotification" object:nil];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"CaiGouSinglePaySuccessNotification" object:nil];

                 if (!self.isFromSingleVoucherCenter) {
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"SinglePaySuccessNotification" object:nil];
                 }


             }else
             {
                 aliRetValue = @"付款失败";
             }

             UIAlertView *aliPayAlert = [[UIAlertView alloc]initWithTitle:@"支付" message:aliRetValue delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
             aliPayAlert.delegate = self;
             //aliPayAlert.tag = PAY_ALERT_TAG;
             [aliPayAlert show];


         }];
    }else{   //跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK

        if ([url.host isEqualToString:@"pay"]) {

            appJump = [WXApi handleOpenURL:url delegate:self];

        }else
        {
            appJump = [UMSocialSnsService handleOpenURL:url];
        }
    }
  
    
    NSString *urlStr = [url absoluteString];
    NSRange range = [urlStr rangeOfString:@"miaoxintong://"];
    if (range.location != NSNotFound) {
        BaseTabBarController *mainViewC =(BaseTabBarController*)self.window.rootViewController;
        mainViewC.selectedIndex=0;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"saosaokanxinwen" object:urlStr];
    }
    return  appJump;
}

#pragma mark -------WXPAY------------------------

-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;

        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;

        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n\n", msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = @"这是从微信启动的消息";

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}



-(void) onResp:(BaseResp*)resp
{

    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;

    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){

        //支付返回结果，实际支付结果需要去微信服务器端查询

        strTitle           = [NSString stringWithFormat:@"支付结果"];

        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                //                [[NSNotificationCenter defaultCenter] postNotificationName:@"PaySuccessNotification" object:nil userInfo:nil];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"PaySuccessNotification" object:nil];//SinglePaySuccessNotification
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"SinglePaySuccessNotification" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PaySuccessNotification" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CaiGouSinglePaySuccessNotification" object:nil];
                if (!self.isFromSingleVoucherCenter) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"SinglePaySuccessNotification" object:nil];
                }

                break;

            default:

                strMsg = [NSString stringWithFormat:@"支付结果：失败！"];
                break;
        }

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
}


- (void)didReceiveMessages:(NSArray *)aMessages
{
    UIApplication *application = [UIApplication sharedApplication];
    
    application.applicationIconBadgeNumber += 1;
    for(EMMessage *message in aMessages){
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        switch (state) {
            case UIApplicationStateBackground:
                [self showNotificationWithMessage:message];
                break;
            default:
                break;
        }
    }
}
- (void)showNotificationWithMessage:(EMMessage *)message
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showReadPoint" object:nil];
    EMMessageBodyType type = message.body.type;
    
    NSString *messageStr = nil;
    
    switch (type) {
            
        case EMMessageBodyTypeText:
            
        {
            
            messageStr = @"您有一条新消息";
            
        }
            
            break;
            
        case EMMessageBodyTypeImage:
            
        {
            
            messageStr = @"[图片]";
            
        }
            
            break;
            
        case EMMessageBodyTypeLocation:
            
        {
            
            messageStr = @"[位置]";
            
        }
            
            break;
            
        case EMMessageBodyTypeVoice:
            
        {
            
            messageStr = @"[音频]";
            
        }
            
            break;
            
        case EMMessageBodyTypeVideo:{
            
            messageStr = @"[视频]";
            
        }
            
            break;
            
        default:
            
            break;
            
    }
    
    
    
    //发送本地推送
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    notification.fireDate = [NSDate date]; //触发通知的时间
    
    
    
    NSString *title = message.from;
    if (message.chatType == EMChatTypeGroupChat) {
        title=@"群消息";
    }
    

    
    
    
    notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    
    notification.alertAction = @"打开";
    
    notification.timeZone = [NSTimeZone defaultTimeZone];
    
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    
    //发送通知
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
   
    

}
// 统计未读消息数
-(NSInteger)setupUnreadMessageCount
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    return unreadCount;
}
-(void)unReadShowOrHiddenRedPiont
{
    if ([self isNeedLogin]) {
        NSInteger miaoshangquanNum=[self setupUnreadMessageCount];
        if (miaoshangquanNum>0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showReadPoint" object:nil];
            return;
        }
        [HTTPCLIENT getunReadSuccess:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                NSDictionary *dic=[responseObject objectForKey:@"result"];
               NSInteger unread=[dic[@"SystemMessageCount"] integerValue]+[dic[@"CustomCount"] integerValue];
                if (unread>0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"showReadPoint" object:nil];
                }else{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenReadPoint" object:nil];
                }
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenReadPoint" object:nil];
            }
        } failure:^(NSError *error) {
            
        }];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenReadPoint" object:nil];
    }
   
}
-(void)upUnImageWithImagePath:(NSDictionary *)imageDic
{
    

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    //设置一个图片的存储路径
    NSString *imagePath = [path stringByAppendingString:[NSString stringWithFormat:@"%@",[imageDic objectForKey:@"path"]]];
    UIImage *croppedImage = [UIImage imageWithContentsOfFile:imagePath];
    NSData *imageData;
    
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    // 必填字段
    put.bucketName = @"miaoxintong";
    put.contentType=[imageDic objectForKey:@"type"];
    put.objectKey=[imageDic objectForKey:@"name"];
    if (UIImagePNGRepresentation(croppedImage)) {
        //返回为png图像。
        imageData = UIImagePNGRepresentation(croppedImage);
       
        
    }else {
        //返回为JPEG图像。
        
        imageData = UIImageJPEGRepresentation(croppedImage, 0.5);
        
        
    }
    
    put.uploadingData = imageData; // 直接上传NSData
    // 可选字段，可不设置 
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        // 当前上传段长度、当前已经上传总长度、一共需要上传的总长度
    };
    
    OSSTask * putTask = [self.client putObject:put];
    
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                //Update UI in UI thread here
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSMutableArray *ary=[NSMutableArray arrayWithArray:[userDefaults objectForKey:@"RZImageAry"]];
                [ary removeObject:imageDic];
                [userDefaults setObject:ary forKey:@"RZImageAry"];
                [userDefaults synchronize];
                
            });
            
        } else {
        
            
        }
        return nil;
    }];
}


@end
