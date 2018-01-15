//
//  YLDJJRDeitalViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/9.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDJJRDeitalViewController.h"
#import "YLDJJRD1TableViewCell.h"
#import "YLDJJrModel.h"

#import "ChangyanSDK.h"

#import "UINavController.h"
#import "YLDLoginViewController.h"
#import "KMJRefresh.h"
#import "BuyDetialInfoViewController.h"
#import "SellDetialViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

#import "ZIKMyShopViewController.h"
#import "YLDSadvertisementModel.h"
#import "YLDSBigImageVadCell.h"
#import "YLDStextAdCell.h"
#import "YLDSADViewController.h"
#import "YLDTADThreePicCell.h"
#import "YLDTLeftTextAdCell.h"
#import "YLDTMoreBigImageADCell.h"
//友盟
#import "UMSocialControllerService.h"
#import "UMSocial.h"

#import "YLDFSupplyModel.h"
#import "YLDFBuyModel.h"
#import "YLDFMyBuyTableViewCell.h"
#import "YLFMySupplyTableViewCell.h"
@interface YLDJJRDeitalViewController ()<UITableViewDelegate,UITableViewDataSource,UMSocialUIDelegate,MFMessageComposeViewControllerDelegate>
@property (nonatomic,assign)NSInteger type;
@property (nonatomic,strong)NSMutableArray *dataAry;

@property (nonatomic,strong)YLDJJrModel *jjreModel;
@property (nonatomic,strong)NSString *topic_id;
@property (nonatomic,strong)UIView *gqV;
@property (nonatomic,strong)UIView *moveView;
@property (nonatomic,strong)UIButton *nowBtn;
@property (nonatomic,assign)NSInteger buyPage;
@property (nonatomic,assign)NSInteger sellPage;
@property (nonatomic,copy)NSString *shareText;
@property (nonatomic,copy)NSString *shareTitle;
@property (nonatomic,copy)NSString *shareUrl;
@property (nonatomic,strong)UIImage *shareImage;
@property (nonatomic,copy)NSString *lastTime;
@end

@implementation YLDJJRDeitalViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    RemoveActionV();
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataAry=[NSMutableArray array];

    [self rightbtnimage:[UIImage imageNamed:@"shareBlackB"] frame:CGRectMake(Width-50, 26, 35, 35)];
    __weak typeof(self) weakSelf = self;
    self.rightBarBtnBlock = ^{
        [weakSelf requestShareData];
    };
    self.vcTitle=@"苗木经纪人";
    self.buyPage=1;
    self.sellPage=1;
    [self topActionView];
    [self sdsdsdasd];
  
    [HTTPCLIENT jjrDetialWithpartyId:self.uid   WithlastTime:_lastTime Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSDictionary *data=[responseObject objectForKey:@"data"];
            NSDictionary *broker=[data objectForKey:@"broker"];
            YLDJJrModel *model=[YLDJJrModel yldJJrdetialModelByDic:broker];
            self.jjreModel=model;
            
            NSArray *supplysAry=data[@"supplys"];
            NSArray *modelAry=[YLDFSupplyModel YLDFSupplyModelAryWithAry:supplysAry];
            YLDFSupplyModel *smodel=[modelAry lastObject];
            _lastTime=smodel.lastTime;
            [self.dataAry addObjectsFromArray:modelAry];
            
            [self.tableView reloadData];
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
    [self.tableView addFooterWithCallback:^{
        if (weakSelf.type==1) {
            weakSelf.buyPage+=1;
            [weakSelf getdataWithPage:nil];
        }else{
            weakSelf.sellPage+=1;
            [weakSelf getdataWithPage:nil];
        }
    }];

    // Do any additional setup after loading the view from its nib.
}
-(void)getdataWithPage:(NSString *)page
{
   
    ShowActionV();
    if (self.type==1) {
        [HTTPCLIENT jjrbuysWithpartyId:self.uid WithlastTime:_lastTime Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                if (!_lastTime) {
                    [self.dataAry removeAllObjects];
                }
                NSArray *buysAry=[responseObject objectForKey:@"data"];
                if (buysAry.count>0) {
                    NSArray *modelAry=[YLDFBuyModel YLDFBuyModelAryWithAry:buysAry];
                    YLDFBuyModel *model=[modelAry lastObject];
                    _lastTime=model.lastTime;
                    [self.dataAry addObjectsFromArray:modelAry];
                }else{
                    [ToastView showTopToast:@"暂无更多数据"];
                }
                
                [self.tableView reloadData];
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
            [self.tableView footerEndRefreshing];
        } failure:^(NSError *error) {
            [self.tableView footerEndRefreshing];
        }];
    }else{
        
        [HTTPCLIENT jjrDetialWithpartyId:self.uid   WithlastTime:_lastTime Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                NSDictionary *data=[responseObject objectForKey:@"data"];
                if (!_lastTime) {
                    [self.dataAry removeAllObjects];
                }
                NSArray *supplysAry=data[@"supplys"];
                if (supplysAry.count>0) {
                    NSArray *modelAry=[YLDFSupplyModel YLDFSupplyModelAryWithAry:supplysAry];
                    [self.dataAry addObjectsFromArray:modelAry];
                    YLDFSupplyModel *model=[modelAry lastObject];
                    _lastTime=model.lastTime;
                }else{
                    [ToastView showTopToast:@"暂无更多数据"];
                }
                
                [self.tableView reloadData];
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
            [self.tableView footerEndRefreshing];
        } failure:^(NSError *error) {
            [self.tableView footerEndRefreshing];
        }];
    }
//    ShowActionV();
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    if (section==1) {
      return  [self.dataAry count];
        
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        self.tableView.estimatedRowHeight = 215;
        self.tableView.rowHeight = UITableViewAutomaticDimension;//设置cell的高度为自动计算，只有才xib或者storyboard上自定义的cell才会生效，而且需要设置好约束
 
        return tableView.rowHeight;
    }

    if (indexPath.section==1) {
        id model=self.dataAry[indexPath.row];
        if ([model isKindOfClass:[YLDFSupplyModel class]]) {
            return 182;
        }
        if ([model isKindOfClass:[YLDFBuyModel class]]) {
            return 141;
        }
    }
    return 1;
 
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        YLDJJRD1TableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDJJRD1TableViewCell"];
        if (!cell) {
            cell =[YLDJJRD1TableViewCell yldJJRD1TableViewCell];
            [cell.moreBtn addTarget:self action:@selector(moreJSAction) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.model=self.jjreModel;
        return cell;
    }

    if (indexPath.section==1) {
        id model=self.dataAry[indexPath.row];
        if ([model isKindOfClass:[YLDFSupplyModel class]]) {
            YLFMySupplyTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLFMySupplyTableViewCell"];
            if (!cell) {
                cell=[YLFMySupplyTableViewCell yldFListSupplyTableViewCell];
                
            }
            cell.model=self.dataAry[indexPath.row];
            return cell;
        }
        if ([model  isKindOfClass:[YLDFBuyModel class]]) {
            YLDFMyBuyTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"YLDFMyBuyTableViewCell"];
            if (!cell) {
                cell=[YLDFMyBuyTableViewCell yldFListBuyTableViewCell];
            }
            cell.model=self.dataAry[indexPath.row];
            return cell;
        }
    }
    UITableViewCell *cell=[UITableViewCell new];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==1) {
        return 5;
    }else{
        return 0.01;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

        UIView *view=[UIView new];
        return view;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return 50;
    }else{
        return 0.1;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[UIView new];
    if (section==1) {
        return self.gqV;
    }

    return view;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
}
- (void)topActionView {
    NSArray *ary=@[@"供应",@"求购"];
  
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 64, kWidth, 50)];
    [view setBackgroundColor:[UIColor whiteColor]];
    view.layer.shadowColor   = [UIColor blackColor].CGColor;///shadowColor阴影颜色
    view.layer.shadowOpacity = 0.2;////阴影透明度，默认0
    view.layer.shadowOffset  = CGSizeMake(0, 2);//shadowOffset阴影偏移,x向右偏移0，y向下偏移1，默认(0, -3),这个跟shadowRadius配合使用
    
    view.layer.shadowRadius  = 1;//阴影半径，默认3
    CGFloat btnWith=kWidth/ary.count;
    UIView *moveView=[[UIView alloc]initWithFrame:CGRectMake(0, 47, btnWith, 3)];
    [moveView setBackgroundColor:NavColor];
    self.moveView=moveView;
    [view addSubview:moveView];
    for (int i=0; i<ary.count; i++) {
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(btnWith*i, 0, btnWith, 47)];
        [btn setTitle:ary[i] forState:UIControlStateNormal];
        [btn setTitle:ary[i] forState:UIControlStateSelected];
        [btn setTitleColor:titleLabColor forState:UIControlStateNormal];
        [btn setTitleColor:NavColor forState:UIControlStateSelected];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        btn.tag=i;
        if (i==0) {
            btn.selected=YES;
            _nowBtn=btn;
        }
        [btn addTarget:self action:@selector(topBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        UIView *iamgeV1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 0.5)];
        [iamgeV1 setBackgroundColor:kLineColor];
        [view addSubview:iamgeV1];
        UIView *iamgeV2=[[UIImageView alloc]initWithFrame:CGRectMake(0, 49.5, kWidth, 0.5)];
        [iamgeV2 setBackgroundColor:kLineColor];
        [view addSubview:iamgeV2];
        
    }
    self.gqV=view;
}
-(void)topBtnAction:(UIButton *)sender
{
    if (sender==_nowBtn) {
        return;
    }
    
    sender.selected=YES;
    _nowBtn.selected=NO;
    _nowBtn=sender;
   
       
    self.type=sender.tag;
    self.lastTime=nil;
    [self getdataWithPage:nil];
    CGRect frame=_moveView.frame;
    frame.origin.x=kWidth/2*(sender.tag);
    [UIView animateWithDuration:0.3 animations:^{
        _moveView.frame=frame;
    }];
}

-(void)sdsdsdasd
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, kHeight-50, kWidth, 50)];
    UIButton *shopBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, kWidth*1/5, 50)];
    [shopBtn setBackgroundColor:kBlueShopColor];
    [shopBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [shopBtn setTitle:@"店铺" forState:UIControlStateNormal];
    [shopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shopBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
    [shopBtn addTarget:self action:@selector(shopBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [shopBtn setImage:[UIImage imageNamed:@"1求购供应详情-店铺图标2"] forState:UIControlStateNormal];
    [view addSubview:shopBtn];

    UIButton *messageBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth*1/5.f, 1, kWidth*2/5.f, 50-1)];
    messageBtn.backgroundColor = [UIColor whiteColor];
    
    [messageBtn setTitle:@"短信留言" forState:UIControlStateNormal];
    [messageBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
    messageBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
    [messageBtn addTarget:self action:@selector(meaageAction) forControlEvents:UIControlEventTouchUpInside];
    [messageBtn setImage:[UIImage imageNamed:@"shotMessageImage"] forState:UIControlStateNormal];
    [messageBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [view addSubview:messageBtn];
    UIButton *phoneBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth*3/5.f,0, kWidth*2/5.f, 50)];
    [phoneBtn setTitle:@"联系商家" forState:UIControlStateNormal];
    [phoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    phoneBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
    [phoneBtn setImage:[UIImage imageNamed:@"phoneImage"] forState:UIControlStateNormal];
    [phoneBtn setBackgroundColor:NavColor];
    [phoneBtn addTarget:self action:@selector(CallAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:phoneBtn];
    [phoneBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.view addSubview:view];
}
-(void)CallAction
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.jjreModel.phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
-(void)meaageAction
{
    [self showMessageView:[NSArray arrayWithObjects:self.jjreModel.phone,nil] title:@"经纪人" body:@""];
}
- (void)shopBtnAction {
    
    
    if ([ZIKFunction xfunc_check_strEmpty:self.jjreModel.userUid]) {
        [ToastView showTopToast:@"无店铺信息"];
        return;
    }
    ZIKMyShopViewController *shopVC = [[ZIKMyShopViewController alloc] init];
    shopVC.memberUid = self.jjreModel.userUid;
    shopVC.type = 1;
    [self.navigationController pushViewController:shopVC animated:YES];
    
}
-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
        picker.messageComposeDelegate = self;
        
        // You can specify one or more preconfigured recipients.  The user has
        // the option to remove or add recipients from the message composer view
        // controller.
        picker.recipients = phones;
        
        // You can specify the initial message text that will appear in the message
        // composer view controller.
        picker.body = body;
        
        [self presentViewController:picker animated:YES completion:NULL];
        [[[[picker viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
        {
            [ToastView showToast:@"消息发送成功" withOriginY:250 withSuperView:self.view];
        }
            
            break;
        case MessageComposeResultFailed:
            //信息传送失败
        {
            [ToastView showToast:@"消息发送失败" withOriginY:250 withSuperView:self.view];
        }
            
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
        {
            [ToastView showToast:@"取消发送" withOriginY:250 withSuperView:self.view];
        }
            
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}
-(void)moreJSAction
{
    self.jjreModel.selected=!self.jjreModel.selected;
    //一个cell刷新
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - 经纪人分享
- (void)requestShareData {
    ShowActionV();
    //CLog(@"hotuid:%@,  hotsupplyuid:%@  ,selfmodelsupplyuid:%@",self.hotModel.uid,self.hotModel.supplybuyUid,self.model.supplybuyUid)
    [HTTPCLIENT jjrGetDetialShareWithBrokerUid:self.jjreModel.uid Success:^(id responseObject) {
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
