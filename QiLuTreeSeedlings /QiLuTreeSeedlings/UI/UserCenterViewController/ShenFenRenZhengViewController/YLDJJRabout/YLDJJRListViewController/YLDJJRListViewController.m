//
//  YLDJJRListViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/8.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDJJRListViewController.h"
#import "YLDJJrModel.h"
#import "YLDJJRListCell.h"
#import "KMJRefresh.h"

#import "yldjjlSelctView.h"
#import "AdvertView.h"

#import "YLDSadvertisementModel.h"
#import "ZIKMyShopViewController.h"
#import "YLDSADViewController.h"
#import "YLDJJRDeitalViewController.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
#import "JJRScreenView.h"
#import "YLDLoginViewController.h"
#import "JJRGGViewController.h"
#import "YLDJJRMyViewController.h"
#import "UINavController.h"
#import "YLDJJRenShenQing1ViewController.h"
#import "YLDJJRSHZViewController.h"
#import "YLDJJRNotPassViewController.h"
#import "YLDJJRHSQView.h"
//友盟
#import "UMSocialControllerService.h"
#import "UMSocial.h"

#import "YLDFRZzhongViewController.h"
#import "YLDFRealNameViewController.h"
#import "ZIKVoucherCenterViewController.h"
@interface YLDJJRListViewController ()<UMSocialUIDelegate,UITableViewDelegate,UITableViewDataSource,AdvertDelegate,JJRScreenViewDelegate,YLDJJRenShenQing1ViewControllerDelegate,YLDJJRNotPassViewControllerDelegate>
@property (nonatomic,strong)NSMutableArray *dataAry;
@property (nonatomic,strong)NSMutableArray *productTypeDataMArray;
@property (nonatomic,copy)NSString *areaCode;
@property (nonatomic,copy)NSString *productUid;
@property (nonatomic,copy)NSString *lastTime;
@property (nonatomic,assign)NSInteger pageNum;
@property (nonatomic,strong)JJRScreenView *jjrScreenView;
@property (nonatomic)NSArray *lunboAry;
@property (nonatomic,copy)NSString *shareText;
@property (nonatomic,copy)NSString *shareTitle;
@property (nonatomic,copy)NSString *shareUrl;
@property (nonatomic,strong)UIImage *shareImage;
@end
@implementation YLDJJRListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle = @"找对人，买好苗，好卖苗！";

    [self.titleLab setFont:[UIFont systemFontOfSize:16]];
    self.dataAry = [NSMutableArray array];
    self.productTypeDataMArray=[NSMutableArray array];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    __weak typeof(self) weakself=self;
    
    
    [self.tableView addHeaderWithCallback:^{
        weakself.pageNum=1;
        [weakself getDateListPageWithPageNum:[NSString stringWithFormat:@"%ld",weakself.pageNum]];
    }];
    [self.tableView addFooterWithCallback:^{
        weakself.pageNum+=1;
        [weakself getDateListPageWithPageNum:[NSString stringWithFormat:@"%ld",weakself.pageNum]];
    }];
    [self.tableView headerBeginRefreshing];
    UIButton *shareBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-85,23, 35, 35)];
    [shareBtn setEnlargeEdgeWithTop:10 right:0 bottom:10 left:10];
    [shareBtn setImage:[UIImage imageNamed:@"shareBlack"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(requestShareData) forControlEvents:UIControlEventTouchUpInside];
    [self.navBackView addSubview:shareBtn];
    UIButton *screenBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-46,16.5, 40, 45)];
    [screenBtn setEnlargeEdgeWithTop:10 right:30 bottom:10 left:10];
    [screenBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [screenBtn setTitleColor:titleLabColor forState:UIControlStateNormal];
    [screenBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    screenBtn.titleEdgeInsets = UIEdgeInsetsMake(28,-28,0,0);
    screenBtn.imageEdgeInsets = UIEdgeInsetsMake(-5,6,0,0);
    
    [screenBtn setImage:[UIImage imageNamed:@"icon_screen_small"] forState:UIControlStateNormal];
    [screenBtn addTarget:self action:@selector(screenBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navBackView addSubview:screenBtn];
   self.jjrScreenView=[JJRScreenView jjrScreenView];
    self.jjrScreenView.delegate=self;
}
-(void)screenBtnAction
{
    [self.view addSubview:self.jjrScreenView];
    [self.jjrScreenView showView];
}
-(void)screenActionWithAreaCode:(NSString *)areaCode WithName:(NSString *)name
{
    _areaCode=areaCode;
    _productUid=name;
    [self.tableView headerBeginRefreshing];
}
-(void)getDateListPageWithPageNum:(NSString *)page
{
    [HTTPCLIENT jjrListWithareaCode:_areaCode lastTime:nil  WithproductUid:_productUid Success:^(id responseObject) {
    if([[responseObject objectForKey:@"success"] integerValue])
    {
       
        if (self.lastTime==nil) {
            [self.dataAry removeAllObjects];
//            NSString *advertisementsStr=[dic objectForKey:@"advertisements"];
//            NSDictionary *advertisementsDic=[ZIKFunction dictionaryWithJsonString:advertisementsStr];
//            self.lunboAry=[YLDSadvertisementModel aryWithAry:[advertisementsDic objectForKey:@"result"]];
            
        }
        NSArray *data=[responseObject objectForKey:@"data"];
        if (data.count>0) {
            NSArray *dataAry=[YLDJJrModel yldJJrModelByAry:data];
            [self.dataAry addObjectsFromArray:dataAry];
        }else{
            [ToastView showTopToast:@"暂无更多数据"];
        }
        
        
    }else{
        [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
    }
    if ([self.tableView isHeaderRefreshing]) {
        [self.tableView headerEndRefreshing];
        [self.tableView reloadData];
    }
    if ([self.tableView isFooterRefreshing]) {
        [self.tableView footerEndRefreshing];
        [self.tableView reloadData];
    }
} failure:^(NSError *error) {
    if ([self.tableView isHeaderRefreshing]) {
        [self.tableView headerEndRefreshing];

    }
    if ([self.tableView isFooterRefreshing]) {
        [self.tableView footerEndRefreshing];

    }
}];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else{
      return self.dataAry.count;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return  0.368*kWidth;
    }
    return 94;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 60;
    }
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
   
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view=[UIView new];
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==0) {
        YLDJJRHSQView *view=[YLDJJRHSQView yldJJRHSQView];
        CGRect frame=view.frame;
        frame.size.width=kWidth;
        view.frame=frame;
        [view.shenqingBtn addTarget:self action:@selector(jjrtjAction) forControlEvents:UIControlEventTouchUpInside];
        [view.youshiBtn addTarget:self action:@selector(shojjreYSAction) forControlEvents:UIControlEventTouchUpInside];
        return view;
    }
    UIView *view=[UIView new];
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        AdvertView *adView=[[AdvertView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 0.368*kWidth)];
        adView.delegate=self;
        adView.selectionStyle = UITableViewCellSelectionStyleNone;
        [adView setAdInfoWithAry:self.lunboAry];
        [adView adStart];
        return adView;
    }else{
        
    }
    YLDJJRListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDJJRListCell"];
    if (!cell) {
        cell=[YLDJJRListCell yldJJRListCell];
    }
    YLDJJrModel *model=self.dataAry[indexPath.row];
    cell.model=model;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1) {
        YLDJJRDeitalViewController *vc=[YLDJJRDeitalViewController new];
        YLDJJrModel *model=self.dataAry[indexPath.row];
        vc.uid=model.userUid;
        vc.vzuid=model.uid;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)advertPush:(NSInteger)index
{if (index<self.lunboAry.count) {
    YLDSadvertisementModel *model=self.lunboAry[index];
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



}
-(void)shojjreYSAction
{
    JJRGGViewController *vc=[JJRGGViewController new];
    
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)jjrtjAction
{
    if (![APPDELEGATE isNeedLogin]) {
        YLDLoginViewController *loginViewController=[[YLDLoginViewController alloc]init];
        [ToastView showTopToast:@"请先登录"];
        UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
        
        [self presentViewController:navVC animated:YES completion:^{
            
        }];
        return;
    }
    [self jjrBtnAction:nil];
    
}

#pragma mark - 经纪人分享
- (void)requestShareData {
    ShowActionV();
    //CLog(@"hotuid:%@,  hotsupplyuid:%@  ,selfmodelsupplyuid:%@",self.hotModel.uid,self.hotModel.supplybuyUid,self.model.supplybuyUid)
    [HTTPCLIENT jjrGetListShareSuccess:^(id responseObject) {
        if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]] withOriginY:kWidth/2 withSuperView:self.view];
            return ;
        }
        NSDictionary *shareDic = responseObject[@"result"];
        self.shareText   = shareDic[@"text"];
        self.shareTitle  = shareDic[@"title"];
        NSString *urlStr = shareDic[@"img"];
        NSData * data    = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlStr]];
        self.shareImage  = [[UIImage alloc] initWithData:data];
        self.shareUrl    = shareDic[@"url"];
        RemoveActionV();
        [self umengShare];
        
    } failure:^(NSError *error) {
        RemoveActionV();
    }];
}

#pragma mark - 友盟分享
- (void)umengShare {
    //    [self requestShareData];
    //    return;
    [UMSocialSnsService presentSnsIconSheetView:self
     //appKey:@"569c3c37e0f55a8e3b001658"
                                         appKey:@"56fde8aae0f55a1cd300047c"
                                      shareText:self.shareText
                                     shareImage:self.shareImage
                                shareToSnsNames:@[UMShareToWechatTimeline,UMShareToQzone,UMShareToWechatSession,UMShareToQQ]
                                       delegate:self];
    
    //当分享消息类型为图文时，点击分享内容会跳转到预设的链接，设置方法如下
    //NSString *urlString = @"https://itunes.apple.com/cn/app/miao-xin-tong/id1104131374?mt=8";
    //NSString *urlString = [NSString stringWithFormat:@"http://www.miaoxintong.cn:8081/qlmm/invitation/create?muid=%@",APPDELEGATE.userModel.access_id];
    
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.shareUrl;
    
    //如果是朋友圈，则替换平台参数名即可
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.shareUrl;
    
    [UMSocialData defaultData].extConfig.qqData.url    = self.shareUrl;
    [UMSocialData defaultData].extConfig.qzoneData.url = self.shareUrl;
    //设置微信好友title方法为
    //NSString *titleString = @"苗信通-苗木买卖神器";
    [UMSocialData defaultData].extConfig.wechatSessionData.title = self.shareTitle;
    
    //设置微信朋友圈title方法替换平台参数名即可
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.shareTitle;
    
    //QQ设置title方法为
    
    [UMSocialData defaultData].extConfig.qqData.title = self.shareTitle;
    
    //Qzone设置title方法将平台参数名替换即可
    
    [UMSocialData defaultData].extConfig.qzoneData.title = self.shareTitle;
    
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
        
    }
    else {
        CLog(@"%@",response);
    }
}
- (void)jjrBtnAction:(UIButton *)sender {
    if ([APPDELEGATE.userModel.roles containsObject:@"users"]) {
        if ([APPDELEGATE.userModel.roles containsObject:@"broker"])
        {
            [ToastView showTopToast:@"您已通过经纪人认证"];
        }else{
            ShowActionV();
            [HTTPCLIENT jjrshenheStatueSuccess:^(id responseObject) {
                if ([[responseObject objectForKey:@"success"] integerValue]) {
                    NSDictionary *data=[responseObject objectForKey:@"data"];
                    NSString *status=data[@"status"];
                    
                    if ([status isEqualToString:@"not_apply"]||[status isEqualToString:@"expired"]) {
                        YLDJJRenShenQing1ViewController *vc=[YLDJJRenShenQing1ViewController new];
                        vc.type=1;
                        vc.deleagte=self;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    if ([status isEqualToString:@"audited"]||[status isEqualToString:@"submission"]) {
                        YLDFRZzhongViewController *vc=[YLDFRZzhongViewController new];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    if ([status isEqualToString:@"normal"]) {
                        [ToastView showTopToast:@"您已通过经纪人认证"];
                    }
                    if ([status isEqualToString:@"fail"]) {
                        
                        YLDJJRNotPassViewController * vc=[YLDJJRNotPassViewController new];
                        vc.wareStr=@"经纪人";
                        vc.delegate=self;
                        vc.dic=[responseObject objectForKey:@"data"];
                        [self.navigationController pushViewController:vc animated:YES];
                        
                        
                    }
                    if ([status isEqualToString:@"unpaid"]) {
                        [ToastView showTopToast:@"您还未支付经纪人审核费"];
                        ZIKVoucherCenterViewController *vc=[ZIKVoucherCenterViewController new];
                        vc.dic=[responseObject objectForKey:@"data"];
                        vc.infoType=6;
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }
                    
                }else{
                    [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
                }
            } failure:^(NSError *error) {
                
            }];
            
        }
    }else{
        __weak typeof(self)weakSelf=self;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"实名认证" message:@"经纪人认证前需要实名认证，是否实名认证？" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"实名认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ShowActionV();
            
            [weakSelf shimingrenzheng];
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
-(void)shimingrenzheng
{
    [HTTPCLIENT getRealNameStateSuccess:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            
            NSDictionary *data=[responseObject objectForKey:@"data"];
            NSString *status=data[@"status"];
            
            if ([status isEqualToString:@"not_apply"]||[status isEqualToString:@"expired"]) {
                YLDFRealNameViewController *vc=[YLDFRealNameViewController new];
                //                vc.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            if ([status isEqualToString:@"audited"]||[status isEqualToString:@"submission"]) {
                YLDFRZzhongViewController *vc=[YLDFRZzhongViewController new];
                
                [self.navigationController pushViewController:vc animated:YES];
            }
            if ([status isEqualToString:@"normal"]) {
                
                [APPDELEGATE reloadUserInfoSuccess:^(id responseObject) {
                    [self jjrBtnAction:nil];
                } failure:^(NSError *error) {
                    
                }];
            }
            if ([status isEqualToString:@"fail"]) {
                YLDJJRNotPassViewController * vc=[YLDJJRNotPassViewController new];

                vc.wareStr=@"实名";
                vc.delegate=self;
                vc.dic=[responseObject objectForKey:@"data"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
            
        }else{
            
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)shenheweitongguoChongxintijiaoDic:(NSDictionary *)dic WithwareStr:(NSString *)wareStr
{
    if ([wareStr isEqualToString:@"经纪人"]) {
        [ToastView showTopToast:@"您的经纪人认证已被退回，请重新编辑"];
        YLDJJRenShenQing1ViewController *vc=[YLDJJRenShenQing1ViewController new];
        vc.dic=dic;
        [self.navigationController pushViewController:vc animated:YES];
    }

    if ([wareStr isEqualToString:@"实名"]) {
        YLDFRealNameViewController* vc=[YLDFRealNameViewController new];
        [ToastView showTopToast:@"您的实名认证已被退回，请重新编辑"];
        
        vc.dic=dic;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
-(void)jjrTiJiaoSuccessWithDic:(NSDictionary *)dic{
    ZIKVoucherCenterViewController *vc=[ZIKVoucherCenterViewController new];
    vc.dic=[dic objectForKey:@"data"];
    vc.infoType=6;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)didFinishShareInShakeView:(UMSocialResponseEntity *)response
{
    NSLog(@"finish share with response is %@",response);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
