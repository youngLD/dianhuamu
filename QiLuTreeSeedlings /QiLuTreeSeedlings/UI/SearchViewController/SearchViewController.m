//
//  SearchViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/2/26.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "SearchViewController.h"
#import "UIDefines.h"

#import "SearchSuccessView.h"
#import "ScreeningView.h"
#import "BuyDetialInfoViewController.h"
#import "SellDetialViewController.h"
#import "HttpClient.h"
#import "ZIKMyShopViewController.h"
//友盟分享
#import "UMSocialControllerService.h"
#import "UMSocial.h"
//end 友盟分享

#import "YLDLoginViewController.h"
#import "UINavController.h"
#import "YLDSadvertisementModel.h"
#import "ZIKMyShopViewController.h"
#import "YLDSADViewController.h"
#import "YLDSearchActionViewController.h"
@interface SearchViewController ()<UITextFieldDelegate,SearchSuccessViewDelegatel,ScreeningViewDelegate,UMSocialUIDelegate,YLDSearchActionVCDelegate>
@property (nonatomic,weak) UIButton *chooseSBBtn;
@property (nonatomic,copy) NSString *searchStr;
@property (nonatomic,strong) SearchSuccessView *searchSuccessView;

@property (nonatomic,strong)UITextField *searchMessageField;
@property (nonatomic) NSInteger searchType;
@property (nonatomic,weak) ScreeningView *screeningView;

@property (nonatomic, strong) NSString       *shareText; //分享文字
@property (nonatomic, strong) NSString       *shareTitle;//分享标题
@property (nonatomic, strong) UIImage        *shareImage;//分享图片
@property (nonatomic, strong) NSString       *shareUrl;  //分享url
@property (nonatomic,strong) UIButton *shaixuanBtn;
@property (nonatomic,strong) UIButton *zmBtn;
@property (nonatomic,strong) UIView *backSearchV;
@property (nonatomic,strong) UIView *searchView;
@end

@implementation SearchViewController
-(void)dealloc
{
     
}
-(id)initWithSearchType:(NSInteger)type
{
    self=[super init];
    if (self) {
        self.searchType=type;

    }
    return self;
}
-(id)initWithSearchType:(NSInteger)type andSaerChStr:(NSString *)searchStr
{
    self=[super init];
    if (self) {
        self.searchType=type;
        
        self.searchStr=searchStr;
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchSuccessView=[[SearchSuccessView alloc]initWithFrame:CGRectMake(0, 64+44, kWidth, kHeight-64-44)];
    self.searchSuccessView.delegate=self;
    
    UIView *searchView=[self makeSearchNavView];
    [self.view addSubview:searchView];
   
    
    [self.view addSubview:self.searchSuccessView];
    
    [self.view addSubview:self.searchSuccessView];
    

}
#pragma mark-点击进入详情页面
-(void)SearchSuccessViewPushBuyDetial:(NSString *)uid
{
    BuyDetialInfoViewController *viewC=[[BuyDetialInfoViewController alloc]initWithSaercherInfo:uid];
    [self.navigationController pushViewController:viewC animated:YES];
}

-(void)SearchSuccessViewPushSellDetial:(HotSellModel *)uid
{
    SellDetialViewController *viewC=[[SellDetialViewController alloc]initWithUid:uid];
    [self.navigationController pushViewController:viewC animated:YES];
}
-(void)SearchSuccessViewPushshopDetial:(NSString *)uid
{
    ZIKMyShopViewController *shopVC = [[ZIKMyShopViewController alloc] init];
    shopVC.memberUid = uid;
    shopVC.type = 1;
    [self.navigationController pushViewController:shopVC animated:YES];
}
-(void)searchWithAdViewPushadDetial:(YLDSadvertisementModel *)model
{
    if (model.adType==0) {
        YLDSADViewController *advc=[[YLDSADViewController alloc]init];
        advc.urlString=model.content;
        [self.navigationController pushViewController:advc animated:YES];
    }else if (model.adType==1)
    {
        YLDSADViewController *advc=[[YLDSADViewController alloc]init];
        advc.urlString=model.link;
        [self.navigationController pushViewController:advc animated:YES];
    }else if (model.adType==2)
    {
        ZIKMyShopViewController *shopVC = [[ZIKMyShopViewController alloc] init];
        shopVC.memberUid = model.shop;
        shopVC.type = 1;
        [self.navigationController pushViewController:shopVC animated:YES];
    }
}
-(void)reloadBtnWithSearchStatus:(NSString *)status{
    if ([status isEqualToString:@"free"]) {
        if ([self.chooseSBBtn.titleLabel.text isEqualToString:@"精品求购"]) {
            self.chooseSBBtn.selected=NO;
            UIButton *btn =  [self.searchView viewWithTag:3];
            btn.selected=YES;
            self.chooseSBBtn=btn;
        }
    }
}
#pragma mark-生成搜索栏
-(UIView *)makeSearchNavView
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,kWidth, 104)];
    [view setBackgroundColor:BGColor];
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(12, 27, 30, 30)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"backBtnBlack"] forState:UIControlStateNormal];
    [backBtn setEnlargeEdgeWithTop:15 right:60 bottom:10 left:10];
    [view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    //[view setBackgroundColor:[UIColor greenColor]];
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(60, 25, kWidth-120, 44-10)];
    [backView setBackgroundColor:[UIColor whiteColor]];
    backView.layer.masksToBounds=YES;
    backView.layer.cornerRadius=3;
    self.backSearchV=backView;
    [view addSubview:backView];

    UITextField * searchMessageField=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, backView.frame.size.width-50, 34)];
    [searchMessageField setEnabled:NO];
    self.searchMessageField=searchMessageField;
    searchMessageField.placeholder=@"请输入搜索关键词";
    if (self.searchStr.length>0) {
        searchMessageField.text=self.searchStr;
        
    }
    [searchMessageField setTextColor:titleLabColor];

    
    searchMessageField.tag=1001;
    [searchMessageField setFont:[UIFont systemFontOfSize:14]];
    [backView addSubview:searchMessageField];
    UIButton *searchBtn=[[UIButton alloc]initWithFrame:CGRectMake(backView.frame.size.width-45, 0, 40,34)];
    [searchBtn setTitleColor:NavColor forState:UIControlStateNormal];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];

    [backView addSubview:searchBtn];
    
    UIButton *showSearchVBtn=[[UIButton alloc]initWithFrame:backView.bounds];
    [backView addSubview:showSearchVBtn];
    [showSearchVBtn addTarget:self action:@selector(showSearchViewBtnAction) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *screenBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-50,16.5, 40, 45)];
    
    
    [screenBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [screenBtn setTitleColor:[UIColor colorWithRed:102/225.f green:120/225.f blue:102/225.f alpha:1] forState:UIControlStateNormal];
    [screenBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    screenBtn.titleEdgeInsets = UIEdgeInsetsMake(28,-28,0,0);
    screenBtn.imageEdgeInsets = UIEdgeInsetsMake(-3,0,0,0);
    [screenBtn setEnlargeEdgeWithTop:15 right:5 bottom:5 left:5];
    [screenBtn setImage:[UIImage imageNamed:@"icon_screen_small"] forState:UIControlStateNormal];
    self.shaixuanBtn=screenBtn;
    [screenBtn addTarget:self action:@selector(screeingBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:screenBtn];
    
    UIView *qgsView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, kWidth, 44)];
    [qgsView setBackgroundColor:[UIColor whiteColor]];
    self.searchView=qgsView;
    [view addSubview:qgsView];
    
    UIButton *gongyingSBtn=[[UIButton alloc] initWithFrame:CGRectMake(kWidth/3*2, 0, kWidth/3, 44)];
    gongyingSBtn.tag=1;
    [gongyingSBtn setTitleColor:MoreDarkTitleColor forState:UIControlStateNormal];
    [gongyingSBtn setTitleColor:NgreenColor forState:UIControlStateSelected];
    [gongyingSBtn setTitle:@"供应" forState:UIControlStateNormal];
    [gongyingSBtn setTitle:@"供应" forState:UIControlStateSelected];
    [gongyingSBtn addTarget:self action:@selector(chooseSBBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [qgsView addSubview:gongyingSBtn];
    UIButton *qiugouSBtn=[[UIButton alloc] initWithFrame:CGRectMake(kWidth/3, 0, kWidth/3, 44)];
    qiugouSBtn.tag=2;
    [qiugouSBtn setTitleColor:MoreDarkTitleColor forState:UIControlStateNormal];
    [qiugouSBtn setTitleColor:NgreenColor forState:UIControlStateSelected];
    [qiugouSBtn setTitle:@"精品求购" forState:UIControlStateNormal];
    [qiugouSBtn setTitle:@"精品求购" forState:UIControlStateSelected];
    [qiugouSBtn addTarget:self action:@selector(chooseSBBtnAction:) forControlEvents:UIControlEventTouchUpInside];

    [qgsView addSubview:qiugouSBtn];
    UIButton *spSBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, kWidth/3, 44)];
    spSBtn.tag=3;
    [spSBtn setTitleColor:MoreDarkTitleColor forState:UIControlStateNormal];
    [spSBtn setTitleColor:NgreenColor forState:UIControlStateSelected];
    [spSBtn setTitle:@"免费求购" forState:UIControlStateNormal];
    [spSBtn setTitle:@"免费求购" forState:UIControlStateSelected];
    [spSBtn addTarget:self action:@selector(chooseSBBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [qgsView addSubview:spSBtn];
    if (self.searchType==1) {
        [self chooseSBBtnAction:gongyingSBtn];
        self.chooseSBBtn=gongyingSBtn;
    }
    if (self.searchType==2) {
        [self chooseSBBtnAction:qiugouSBtn];
        self.chooseSBBtn=qiugouSBtn;
    }
    if (self.searchType==3) {
        [self chooseSBBtnAction:spSBtn];
        self.chooseSBBtn=spSBtn;
    }
    return view;
}
-(void)showSearchViewBtnAction
{
    YLDSearchActionViewController *searchVC=[[YLDSearchActionViewController alloc]init];
    searchVC.delegate=self;
    searchVC.searchType=self.searchType;
    if (self.searchType==2&&[self.searchSuccessView.searchStatus isEqualToString:@"free"]) {
        searchVC.searchType=3;
    }
    searchVC.searchStr=self.searchMessageField.text;
    [self presentViewController:searchVC animated:NO completion:^{
        
    }];
    
}
-(void)searchActionWithType:(NSInteger)searchType searchString:(NSString *)searchStr{

    
    self.searchStr=searchStr;
    self.searchMessageField.text=searchStr;
    self.chooseSBBtn.selected=NO;
    UIButton *btn=[self.searchView viewWithTag:searchType];
    
    [self chooseSBBtnAction:btn];
    
}

-(void)screeingBtnAction
{
    [self.searchMessageField resignFirstResponder];
    if (self.screeningView) {
        [self.screeningView setSearchStr:self.searchMessageField.text];
        if (self.screeningView.superview==nil) {
                [self.view addSubview:self.screeningView];
        }
        
    }else{
      ScreeningView *screeningV=[[ScreeningView alloc]initWithFrame:CGRectMake(kWidth, 0, kWidth, kHeight) andSearch:self.searchMessageField.text andSerachType:self.searchType];
        self.screeningView=screeningV;
        screeningV.delegate=self;
        [self.view addSubview:self.screeningView];
    }
    [self.screeningView showViewAction];
}
-(void)ScreeningbackBtnAction
{
    self.screeningView=nil;
}


-(void)chooseSBBtnAction:(UIButton *)sender
{
    [self.searchMessageField resignFirstResponder];
    if (sender.selected==YES) {
        return;
   }
    self.chooseSBBtn.selected=NO;
   self.chooseSBBtn=sender;
    if (sender.tag==1) {
        sender.selected=YES;

        if (self.searchType!=1) {
           self.searchType=1;
 
        }
        
    }
    if (sender.tag==2) {
        sender.selected=YES;

            self.searchType=2;
 
            self.searchSuccessView.searchStatus=@"new";
        
    }
    if (sender.tag==3) {
        sender.selected=YES;

            self.searchType=2;
        
            self.searchSuccessView.searchStatus=@"free";
        
    }
    self.searchSuccessView.province=nil;
    
    self.searchSuccessView.county=nil;
    self.searchSuccessView.City=nil;
    self.searchSuccessView.goldsupplier=nil;
    self.searchSuccessView.productUid=nil;
    self.searchSuccessView.shaixuanAry=nil;
    [self.screeningView removeFromSuperview];
    self.screeningView=nil;
   [self SearchActionWithString:self.searchMessageField.text];
//   [self reloadSearchViewStatus:sender.tag];
 
}

-(void)reloadSearchViewStatus:(NSInteger)status
{
    if (status==1) {
        CGRect r =self.backSearchV.frame;
        r.size.width=kWidth-160;
        self.backSearchV.frame=r;
        self.shaixuanBtn.hidden=NO;
        r=self.shaixuanBtn.frame;
        r.origin.x=kWidth-90;
        self.shaixuanBtn.frame=r;
        self.zmBtn.hidden=NO;
        r=self.zmBtn.frame;
        r.origin.x=kWidth-50;
        self.zmBtn.frame=r;
    }
    if (status==2||status==3) {
        CGRect r =self.backSearchV.frame;
        r.size.width=kWidth-120;
        self.backSearchV.frame=r;
        self.shaixuanBtn.hidden=NO;
        r=self.shaixuanBtn.frame;
        r.origin.x=kWidth-50;
        self.shaixuanBtn.frame=r;
        self.zmBtn.hidden=YES;
        r=self.zmBtn.frame;
        r.origin.x=kWidth+50;
        self.zmBtn.frame=r;
    }
}

- (void)SearchActionWithString:(NSString *)searchStr
{
    if (!self.searchSuccessView) {
        self.searchSuccessView=[[SearchSuccessView alloc]initWithFrame:CGRectMake(0, 64+44, kWidth, kHeight-64-44)];
        self.searchSuccessView.delegate=self;
        [self.view addSubview:self.searchSuccessView];
    }
    self.searchSuccessView.province=nil;
 
    self.searchSuccessView.county=nil;
    self.searchSuccessView.City=nil;
    self.searchSuccessView.goldsupplier=nil;
    self.searchSuccessView.productUid=nil;
    self.searchSuccessView.shaixuanAry=nil;
    [self.searchSuccessView searchViewActionWith:searchStr AndSearchType:self.searchType];
    
}
-(void)creeingActionWithAry:(NSArray *)ary WithProvince:(NSString *)province WihtCity:(NSString *)city WithCounty:(NSString *)county WithGoldsupplier:(NSString *)goldsupplier WithProductUid:(NSString *)productUid withProductName:(NSString *)productName
{

    if (!self.searchSuccessView) {
        self.searchSuccessView=[[SearchSuccessView alloc]initWithFrame:CGRectMake(0, 64+44, kWidth, kHeight-64-44)];
        self.searchSuccessView.delegate=self;
        [self.view addSubview:self.searchSuccessView];
    }
    self.searchMessageField.text=productName;
    self.searchSuccessView.province=province;
    self.searchSuccessView.searchStr=productName;
    self.searchSuccessView.county=county;
    self.searchSuccessView.City=city;
    self.searchSuccessView.goldsupplier=goldsupplier;
    self.searchSuccessView.productUid=productUid;
    self.searchSuccessView.shaixuanAry=ary;

    [self.searchSuccessView searchViewActionWith:productName AndSearchType:self.searchType];
}

-(void)backBtnAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)canUmshare {
                YLDLoginViewController *loginViewController=[[YLDLoginViewController alloc] init];
                [ToastView showTopToast:@"请先登录"];
                UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
    
                [self presentViewController:navVC animated:YES completion:^{
    
                }];
                return;

}
- (void)umshare:(NSString *)shareText title:(NSString *)shareTitle image:(UIImage *)shareImage url:(NSString *)shareUrl {

    self.shareText  = shareText;
    self.shareTitle = shareTitle;
    self.shareImage = shareImage;
    self.shareUrl   = shareUrl;
    [self umengShare];
}

- (void)umengShare {
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"56fde8aae0f55a1cd300047c"
                                      shareText:self.shareText
                                     shareImage:self.shareImage
                                shareToSnsNames:@[UMShareToWechatTimeline,UMShareToQzone,UMShareToWechatSession,UMShareToQQ]
                                       delegate:self];
    NSString *urlString = self.shareUrl;


    [UMSocialData defaultData].extConfig.wechatSessionData.url = urlString;

    //如果是朋友圈，则替换平台参数名即可

    [UMSocialData defaultData].extConfig.wechatTimelineData.url = urlString;

    [UMSocialData defaultData].extConfig.qqData.url    = urlString;
    [UMSocialData defaultData].extConfig.qzoneData.url = urlString;
    //设置微信好友title方法为
    //    NSString *titleString = @"苗信通-苗木买卖神器";
    NSString *titleString = self.shareTitle;

    [UMSocialData defaultData].extConfig.wechatSessionData.title = titleString;

    //设置微信朋友圈title方法替换平台参数名即可

    [UMSocialData defaultData].extConfig.wechatTimelineData.title = titleString;

    //QQ设置title方法为

    [UMSocialData defaultData].extConfig.qqData.title = titleString;

    //Qzone设置title方法将平台参数名替换即可

    [UMSocialData defaultData].extConfig.qzoneData.title = titleString;

}

-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    //NSLog(@"didClose is %d",fromViewControllerType);
}

//下面得到分享完成的回调
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //NSLog(@"didFinishGetUMSocialDataInViewController with response is %@",response);
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        //NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

-(void)didFinishShareInShakeView:(UMSocialResponseEntity *)response
{
    //NSLog(@"finish share with response is %@",response);
}

@end
