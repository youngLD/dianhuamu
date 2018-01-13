//
//  YLDJJRDeitalViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/9.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDJJRDeitalViewController.h"
#import "YLDJJRD1TableViewCell.h"
#import "YLDSPingLunCell.h"
#import "YLDSPingLunModel.h"
#import "YLDJJrModel.h"
#import "YLDTBuyListCell.h"
#import "HotBuyModel.h"
#import "YLDSsupplyBaseCell.h"
#import "HotSellModel.h"
#import "ChangyanSDK.h"
#import "YLDJJRDPLView.h"
#import "YLDSPingLunSrView.h"//评论框
#import "UINavController.h"
#import "YLDLoginViewController.h"
#import "KMJRefresh.h"
#import "BuyDetialInfoViewController.h"
#import "SellDetialViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "YLDJJRPLListViewController.h"
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
@interface YLDJJRDeitalViewController ()<UITableViewDelegate,UITableViewDataSource,fabiaoDelgate,UMSocialUIDelegate,MFMessageComposeViewControllerDelegate>
@property (nonatomic,strong)NSMutableArray *pinglunAry;
@property (nonatomic,assign)NSInteger type;
@property (nonatomic,strong)NSMutableArray *buyAry;
@property (nonatomic,strong)NSMutableArray *sellAry;
@property (nonatomic,strong)YLDJJrModel *jjreModel;
@property (nonatomic,strong)NSString *topic_id;
@property (nonatomic,strong)YLDJJRDPLView *ppV;
@property (nonatomic,strong)UIView *plV;
@property (nonatomic,strong)UIView *gqV;
@property (nonatomic,strong)UIView *moveView;
@property (nonatomic,strong)UIButton *nowBtn;
@property (nonatomic,strong)YLDSPingLunSrView *fabiaoV;
@property (nonatomic,assign)NSInteger buyPage;
@property (nonatomic,assign)NSInteger sellPage;
@property (nonatomic,copy)NSString *shareText;
@property (nonatomic,copy)NSString *shareTitle;
@property (nonatomic,copy)NSString *shareUrl;
@property (nonatomic,strong)UIImage *shareImage;
@property (nonatomic,copy)NSString *lastTime;
@end

@implementation YLDJJRDeitalViewController
@synthesize buyAry,sellAry;
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    RemoveActionV();
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.pinglunAry=[NSMutableArray array];
    self.buyAry=[NSMutableArray array];
    self.sellAry=[NSMutableArray array];
    [self rightbtnimage:[UIImage imageNamed:@"shareBlackB"] frame:CGRectMake(Width-50, 26, 35, 35)];
    __weak typeof(self) weakSelf = self;
    self.rightBarBtnBlock = ^{
        [weakSelf requestShareData];
    };
    self.vcTitle=@"苗木经纪人";
    self.ppV=[YLDJJRDPLView yldJJRDPLView];
    self.plV=[self pinglunView];
    self.buyPage=1;
    self.sellPage=1;
    [self topActionView];
    [self sdsdsdasd];
  
    [HTTPCLIENT jjrDetialWithpartyId:self.uid   WithlastTime:_lastTime Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSDictionary *data=[responseObject objectForKey:@"data"];
            NSDictionary *broker=[responseObject objectForKey:@"broker"];
            YLDJJrModel *model=[YLDJJrModel yldJJrdetialModelByDic:broker];
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
    [self.tableView addFooterWithCallback:^{
        if (weakSelf.type==1) {
            weakSelf.buyPage+=1;
            [weakSelf getdataWithPage:[NSString stringWithFormat:@"%ld",weakSelf.buyPage]];
        }else{
            weakSelf.sellPage+=1;
            [weakSelf getdataWithPage:[NSString stringWithFormat:@"%ld",weakSelf.sellPage]];
        }
    }];

    // Do any additional setup after loading the view from its nib.
}
-(void)getdataWithPage:(NSString *)page
{
    NSString *type=nil;
    if (self.type==1) {
        type=@"buys";
    }else{
        type=@"supplys";
    }
    ShowActionV();
    [HTTPCLIENT jjrgqListWithUid:self.uid WtihType:type Withpage:page WithpageSize:@"10" Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            if (self.type==0) {
                if ([page isEqualToString:@"1"]) {
                    [self.sellAry removeAllObjects];
                }
                NSArray *ary=[[responseObject objectForKey:@"result"] objectForKey:@"supplys"];
                if (ary.count==0) {
                    [ToastView showTopToast:@"暂无数据"];
                }else{
                    NSArray *aa = [HotSellModel hotSellAryByAry:ary];
                    [self.sellAry addObjectsFromArray:aa];
                }
            }else{
                if ([page isEqualToString:@"1"]) {
                    [self.buyAry removeAllObjects];
                }
                NSArray *ary=[[responseObject objectForKey:@"result"] objectForKey:@"buys"];
                if (ary.count==0) {
                    [ToastView showTopToast:@"暂无数据"];
                }else{
                    NSArray *aa = [HotBuyModel creathotBuyModelAryByAry:ary];
                    [self.buyAry addObjectsFromArray:aa];
                }

            }
        }
        [self.tableView reloadData];
        if ([self.tableView isFooterRefreshing]) {
            [self.tableView footerEndRefreshing];
        }
    } failure:^(NSError *error) {
        if ([self.tableView isFooterRefreshing]) {
            [self.tableView footerEndRefreshing];
        }
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
//    if (section==1) {
//       return  self.pinglunAry.count;
//    }
    if (section==1) {
        if (_type==0) {
            return self.sellAry.count;
        }else{
           
            return self.buyAry.count;
        }
        
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        self.tableView.estimatedRowHeight = 215;
        self.tableView.rowHeight = UITableViewAutomaticDimension;//设置cell的高度为自动计算，只有才xib或者storyboard上自定义的cell才会生效，而且需要设置好约束
 
        return tableView.rowHeight;
    }
//    if (indexPath.section==1) {
//        self.tableView.rowHeight = UITableViewAutomaticDimension;//设置cell的高度为自动计算，只有才xib或者storyboard上自定义的cell才会生效，而且需要设置好约束
//        self.tableView.estimatedRowHeight = 90;
//        return tableView.rowHeight;
//    }
    if (indexPath.section==1) {
        if (self.type==0) {
            id model=self.sellAry[indexPath.row];
            if ([model isKindOfClass:[HotSellModel class]]) {
                return 190;
            }else if([model isKindOfClass:[YLDSadvertisementModel class]])
            {
                YLDSadvertisementModel * model=self.sellAry[indexPath.row];
                if (model.adsType==1) {
                    return 160;
                }else if (model.adsType==0)
                {
                    return (kWidth-20)*0.24242+25+60;
                }else if (model.adsType==2)
                {
                    tableView.rowHeight = UITableViewAutomaticDimension;//设置cell的高度为自动计算，只有才xib或者storyboard上自定义的cell才会生效，而且需要设置好约束
                    tableView.estimatedRowHeight = (kWidth-20)*0.5606+25+60;
                    return tableView.rowHeight;
                }else if (model.adsType==3)
                {
                    return (kWidth-20)*0.24242+25+60;
                }else if (model.adsType==6)
                {
                    return 160;
                }
            }

            
        }else{
            id model=self.buyAry[indexPath.row];
            if ([model isKindOfClass:[HotBuyModel class]]) {
                return 90;
            }else if([model isKindOfClass:[YLDSadvertisementModel class]])
            {
                YLDSadvertisementModel * model=self.buyAry[indexPath.row];
                if (model.adsType==1) {
                    return 160;
                }else if (model.adsType==0)
                {
                    return (kWidth-20)*0.24242+25+60;
                }else if (model.adsType==2)
                {
                    tableView.rowHeight = UITableViewAutomaticDimension;//设置cell的高度为自动计算，只有才xib或者storyboard上自定义的cell才会生效，而且需要设置好约束
                    tableView.estimatedRowHeight = (kWidth-20)*0.5606+25+60;
                    return tableView.rowHeight;
                }else if (model.adsType==3)
                {
                    return (kWidth-20)*0.24242+25+60;
                }else if (model.adsType==6)
                {
                    return 160;
                }
            }
            
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
//    if (indexPath.section==1) {
//        YLDSPingLunCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDSPingLunCell"];
//        if (!cell) {
//            cell=[YLDSPingLunCell yldSPingLunCell];
//            cell.zanBtn.hidden=YES;
//            cell.deleteBtn.hidden=YES;
//        }
//        YLDSPingLunModel *model=self.pinglunAry[indexPath.row];
////        cell.delgate=self;
//        cell.model=model;
//        return cell;
//    }
    if (indexPath.section==1) {
        if (self.type==1) {
            id model=self.buyAry[indexPath.row];
            
        }
        if (self.type==0) {
            id model=self.sellAry[indexPath.row];
            

        }

    }
    UITableViewCell *cell=[UITableViewCell new];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==1) {
        return 60;
    }else{
        return 0.01;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==1) {
        return self.ppV;
    }else{
        UIView *view=[UIView new];
        return view;
    }
}
-(void)morePLBtnAction
{
    YLDJJRPLListViewController *vc=[YLDJJRPLListViewController new];
    vc.topic_id=self.topic_id;
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)PLBtnAction
{
    if(![APPDELEGATE isNeedLogin])
    {
        YLDLoginViewController *loginViewController=[[YLDLoginViewController alloc]init];
        [ToastView showTopToast:@"请先登录"];
        UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
        
        [self presentViewController:navVC animated:YES completion:^{
            
        }];
        return;
    }
    [self.view addSubview:self.fabiaoV];
    [self.fabiaoV showAction];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==2||section==1) {
        return 50;
    }else{
        return 0.1;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[UIView new];
    if (section==2) {
        return self.gqV;
    }
    if (section==1) {
        return self.plV;
    }
    return view;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==2) {
        if (self.type==0) {
            HotSellModel *model=self.sellAry[indexPath.row];
            
            SellDetialViewController *sellDetialViewC=[[SellDetialViewController alloc]initWithUid:model];

            [self.navigationController pushViewController:sellDetialViewC animated:YES];

        }else{
            if (self.type==1) {
                id model = self.buyAry[indexPath.row];
                if ([model isKindOfClass:[HotBuyModel class]]) {
                    HotBuyModel *model=self.buyAry[indexPath.row];
                    BuyDetialInfoViewController *vc=[[BuyDetialInfoViewController alloc]initWithSaercherInfo:model.uid];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                if ([model isKindOfClass:[YLDSadvertisementModel class]]) {
                    YLDSadvertisementModel *model=self.buyAry[indexPath.row];
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
        }
    }
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
    if (sender.tag==0) {
       
        self.type=0;
    }
    if (sender.tag==1) {
        self.type=1;
    }
    [self.tableView reloadData];
    CGRect frame=_moveView.frame;
    frame.origin.x=kWidth/2*(sender.tag);
    [UIView animateWithDuration:0.3 animations:^{
        _moveView.frame=frame;
    }];
}

-(UIView *)pinglunView
{
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 50)];
    UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(15, 49.5, kWidth-30, 0.5)];
    [view setBackgroundColor:[UIColor whiteColor]];
    [imageV setBackgroundColor:kLineColor];
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, 200, 30)];
    [lab setTextColor:MoreDarkTitleColor];
    lab.tag=11;
    [lab setTextAlignment:NSTextAlignmentLeft];
    [view addSubview:lab];
    [view addSubview:imageV];
    return view;
}
-(void)fabiaoActionWithStr:(NSString *)comment
{
    __weak typeof(self) weakself=self;
    ShowActionV();
    [ChangyanSDK submitComment:self.topic_id content:comment replyID:nil score:@"5" appType:40 picUrls:nil metadata:@"" completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
    
        [weakself getcommentsWithPageNum:@"1"];
        [weakself.fabiaoV clearAvtion];
        RemoveActionV();
    }];
    
}
-(void)getcommentsWithPageNum:(NSString *)pageNum
{
    __weak typeof(self) weakself=self;
    [ChangyanSDK getTopicComments:[NSString stringWithFormat:@"%@",self.topic_id] pageSize:@"5" pageNo:pageNum orderBy:nil style:@"floor" depth:nil subSize:@"5" completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
        if (statusCode == CYSuccess)
        {
            if([pageNum isEqualToString:@"1"])
            {
                [weakself.pinglunAry removeAllObjects];
            }
            NSDictionary *dic=[ZIKFunction dictionaryWithJsonString:responseStr];
            UILabel *lab=[self.plV viewWithTag:11];
            lab.text =[NSString stringWithFormat:@"用户评论（%ld）",[dic[@"cmt_sum"] integerValue]] ;
            NSArray *commentsAry=dic[@"comments"];
            
            if (commentsAry.count>0) {
                YLDSPingLunModel *model=[YLDSPingLunModel modelWithChangYanDic:[commentsAry lastObject]];
                YLDSPingLunModel *model2=[weakself.pinglunAry lastObject];
                if (model.uid!=model2.uid) {
                    [weakself.pinglunAry addObjectsFromArray:[YLDSPingLunModel aryWithChangYanAry:commentsAry]];
                    
                    [weakself.tableView reloadData];
                }
                
            }else{
//                [ToastView showTopToast:@"暂无更多评论"];
            }
//            self.commentV.commentNum=[dic[@"cmt_sum"] integerValue];
        }

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
