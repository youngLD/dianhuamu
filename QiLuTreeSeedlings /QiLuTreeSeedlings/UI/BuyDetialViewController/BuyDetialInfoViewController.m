//
//  BuyDetialInfoViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/7.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "BuyDetialInfoViewController.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "BuyUserInfoTableViewCell.h"
#import "BuyOtherInfoTableViewCell.h"
#import "QIYeMessageTableViewCell.h"
#import "BuySearchTableViewCell.h"
#import "HotBuyModel.h"
#import "BuySearchTableViewCell.h"
#import "BuyDetialModel.h"
//#import "buyFabuViewController.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
#import "BuyMessageAlertView.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "YLDLoginViewController.h"
#import "UINavController.h"
#import "ZIKPayViewController.h"
#import "KMJRefresh.h"
//友盟
#import "UMSocialControllerService.h"
#import "UMSocial.h"

#import "ZIKSingleVoucherCenterViewController.h"
#import "ZIKMyShopViewController.h"

#import "ZIKStationOrderDetailViewController.h"//站长订单详情
#import "ZIKCaiGouDetailHaveBuyTopView.h"//站长中心定制信息已购买详情顶部页面
#import "ZIKHeZuoMiaoQiKeFuViewController.h"
#import "YLDSCommentAView.h"//评论框
#import "YLDSPingLunSrView.h"
#import "YLDSPingLunModel.h"
#import "YLDSPingLunCell.h"
#import "YLDTBuyListCell.h"
#import "YLDSadvertisementModel.h"
#import "ZIKFunction.h"
#import "AdvertView.h"
#import "YLDSAdLunBoView.h"
#import "YLDSADViewController.h"
#import "UIImageView+AFNetworking.h"
#import "YLDSBuyBrifTableViewCell.h"
#import "ChangyanSDK.h"
#import "YLDCommentRepliesViewController.h"
#import "YLDSBigImageVadCell.h"
#import "YLDStextAdCell.h"
#import "YLDTADThreePicCell.h"
#import "YLDTLeftTextAdCell.h"
#import "YLDTMoreBigImageADCell.h"
@interface BuyButton : UIButton
@property (nonatomic, assign) float price;
@property (nonatomic, strong) NSString *buyUid;
@property (nonatomic, strong) NSMutableArray *imageAry;
@end
@implementation BuyButton
@end

static BOOL isCaiGou = NO;
static BOOL isCaiGouSuccess = NO;

static BOOL isHezuo = NO;

@interface BuyDetialInfoViewController ()<UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate,UMSocialUIDelegate,ZIKCaiGouDetailHaveBuyTopViewDelegate,fabiaoDelgate,YLDSPingLunCellDelgate,AdvertDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UILabel *navTitleLab;
@property (nonatomic,strong)UIButton *collectionBtn;
@property (nonatomic,strong)NSDictionary *infoDic;
@property (nonatomic,strong)NSArray *specAry;
@property (nonatomic,strong)NSArray *recommendeAry;
@property (nonatomic,strong)NSString *uid;

@property (nonatomic,strong)BuyDetialModel *model;
@property (nonatomic) BOOL isPuy;
@property (nonatomic) BOOL isShow;
@property (nonatomic,strong) UIView *messageView;
@property (nonatomic,strong) UIView *BuyMessageView;
@property (nonatomic,strong) UIImageView *biaoqianView;
@property (nonatomic,weak)BuyMessageAlertView *buyAlertView;
@property (nonatomic,strong) NSMutableArray *miaomuzhiAry;
@property (nonatomic,strong) NSMutableArray *pingluAry;
@property (nonatomic,weak) UIButton *editingBtn;
@property (nonatomic)NSInteger push_;
@property (nonatomic,copy) NSString *memberCustomUid;
@property (nonatomic,assign) NSInteger goldsupplier;
@property (nonatomic,strong)YLDSCommentAView *commentV;
@property (nonatomic,strong)YLDSPingLunSrView *fabiaoV;
@property (nonatomic,strong) NSArray *luoboAry;
//@property (nonatomic, strong) NSString *state;//用于求购中 1:热门求购（热门求购中除去已定制和已购买的）；2：我的求购；3：已定制；4：已购买
@property (nonatomic, strong) NSString       *shareText; //分享文字
@property (nonatomic, strong) NSString       *shareTitle;//分享标题
@property (nonatomic, strong) UIImage        *shareImage;//分享图片
@property (nonatomic, strong) NSString       *shareUrl;  //分享url
@property (nonatomic, assign) NSInteger   commentNum;
@property (nonatomic, assign) BOOL isFromDingzhi;
@property (nonatomic, strong) NSString *memberUid;
@property (nonatomic, weak)ZIKCaiGouDetailHaveBuyTopView *topView;
@property (nonatomic, assign) BOOL isCaiGou;
@property (nonatomic, assign) BOOL isGouMai;//采购信息是否已购买
@property (nonatomic, copy) NSString       *topic_id;  //文章id
@end

@implementation BuyDetialInfoViewController
{
    UIButton *myshareBtn;
}
-(void)fabiaoActionWithStr:(NSString *)comment
{
    __weak typeof(self) weakself=self;
    [ChangyanSDK submitComment:self.topic_id content:comment replyID:nil score:@"5" appType:40 picUrls:nil metadata:@"" completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
        weakself.commentNum=1;
        [weakself getcommentsWithPageNum:[NSString stringWithFormat:@"%ld",weakself.commentNum]];
        [weakself.fabiaoV clearAvtion];
    }];

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.type==2) {
        [HTTPCLIENT buyDetailWithUid:self.uid WithAccessID:APPDELEGATE.userModel.access_id
                            WithType:[NSString stringWithFormat:@"%ld",(long)_push_] WithmemberCustomUid:@""                             Success:^(id responseObject) {
                                if (![[responseObject objectForKey:@"success"] integerValue]) {
                                    [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
                                [self.navigationController popViewControllerAnimated:YES];
                                    return ;
                                }
                                NSDictionary *dic=[responseObject objectForKey:@"result"];
                                self.infoDic=dic;
                                self.memberUid = dic[@"memberUid"];

                                self.model=[BuyDetialModel creatBuyDetialModelByDic:[dic objectForKey:@"detail"] withResult:dic];
                                
                                if (self.model.state==4) {
                                }
                                else {
                                    self.tableView.frame=CGRectMake(0, 64, kWidth, kHeight-64-50);
                                }
  
                                self.model.uid=self.uid;
                                [self reloadMyView];
                            } failure:^(NSError *error) {
                                
                            }];
        return;
    }

    if (isHezuo) {
        return;
    }
    if (isCaiGou) {
        
            [HTTPCLIENT workstationPushPurchaseInfo:self.uid type:[NSString stringWithFormat:@"%ld",self.type] Success:^(id responseObject) {
                if (![[responseObject objectForKey:@"success"] integerValue]) {
                    [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
                    [self.navigationController popViewControllerAnimated:YES];
                    return ;
                }
                //NSLog(@"%@",responseObject);
                NSDictionary *dic=[responseObject objectForKey:@"result"];
                self.infoDic=dic;
                self.memberUid = dic[@"memberUid"];
                self.model=[BuyDetialModel creatBuyDetialModelByDic:[dic objectForKey:@"detail"] withResult:dic];
                if ([[dic objectForKey:@"supplybuyName"] length] <= 0 ) {
                    self.model.supplybuyName = @"";
                }
                self.model.buy=1;
                self.model.uid=self.uid;
                self.topView.orderNo   = dic[@"detail"][@"orderNo"];
                self.topView.orderUid  = dic[@"detail"][@"orderUid"];
                self.topView.recordUid = dic[@"detail"][@"recordUid"];
                if (![ZIKFunction xfunc_check_strEmpty:self.model.phone]) {
                    self.isPuy=YES;
                    _biaoqianView.hidden=NO;
                    self.topView.hidden = NO;


                    [_biaoqianView setImage:[UIImage imageNamed:@"buybiaoqian"]];

                }else
                {

                    
                    self.isPuy=YES;
                    
                    self.topView.hidden = YES;
                }
//                if (!self.isPuy) {//未购买
//                    self.isGouMai = NO;
//                } else {
                    self.isGouMai = YES;
//                }

                if (!self.isPuy) {


                    if ([self.model.publishUid isEqualToString:APPDELEGATE.userModel.access_id]) {
                        [_BuyMessageView removeFromSuperview];
                        _BuyMessageView =nil;
                        CGRect r = self.commentV.frame;
                        r.origin.y=kHeight-self.commentV.frame.size.height;
                        self.commentV.frame=r;
                    }else
                    {
                       
                        if (_BuyMessageView==nil) {
                      
                                                                        if (self.model.state == 4) {
                            _BuyMessageView = [self laobanViewWithPrice:self.model.buyPrice];
                            }

                            [_messageView removeFromSuperview];
                            _messageView = nil;

                        }
                    }


                }else{
                    if (_messageView==nil) {
                        _messageView = [self lianxiMessageView];
                        //}
                        [_BuyMessageView removeFromSuperview];
                        _BuyMessageView = nil;
                    }
                }
                [self reloadMyView];
            } failure:^(NSError *error) {

            }];

        return;
    }
    [HTTPCLIENT buyDetailWithUid:self.uid WithAccessID:APPDELEGATE.userModel.access_id
                        WithType:[NSString stringWithFormat:@"%ld",(long)_push_] WithmemberCustomUid:_memberCustomUid                             Success:^(id responseObject) {
                            if (![[responseObject objectForKey:@"success"] integerValue]) {
                                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
                               [self.navigationController popViewControllerAnimated:YES];
                            }
                            NSDictionary *dic=[responseObject objectForKey:@"result"];
                            self.infoDic=dic;
                            self.memberUid = dic[@"memberUid"];
                            self.model=[BuyDetialModel creatBuyDetialModelByDic:[dic objectForKey:@"detail"] withResult:dic];
                            self.model.uid=self.uid;
                            self.model.goldsupplier=[[dic objectForKey:@"goldsupplier"] integerValue];

                            if (self.model.push||self.model.buy||self.model.isBuyTime==0) {
                                self.isPuy=YES;
                            }else
                            {
                                
                                self.isPuy=NO;
                            }
                            if (!self.isPuy) {
                                if ([self.model.publishUid isEqualToString:APPDELEGATE.userModel.access_id]) {
                                     [_BuyMessageView removeFromSuperview];
                                    _BuyMessageView =nil;
                                
                                }else
                                {
                                    if (_BuyMessageView==nil) {
                                            
                                                _BuyMessageView =[self laobanViewWithPrice:self.model.buyPrice];
                                        [_messageView removeFromSuperview];
                                        _messageView = nil;

                                    }
                                }

                             
                            }else{
                                if (_messageView==nil) {
                                    if (self.model.state == 4 && APPDELEGATE.isNeedLogin) {
                                        _messageView = [self lianxiMessageShareView];

                                    }
                                    else {
                                        _messageView = [self lianxiMessageView];
                                    }
                                    [_BuyMessageView removeFromSuperview];
                                    _BuyMessageView = nil;
                                }
                            }
                            [self reloadMyView];
                        } failure:^(NSError *error) {
                            
                        }];
}
-(id)initWithDingzhiModel:(ZIKCustomizedInfoListModel *)model
{
    self=[super init];
    if (self) {
        self.isPuy=NO;
        self.uid=model.uid;
        self.type=1;
        _push_=1;
        self.memberCustomUid=model.memberCustomUid;
        self.isFromDingzhi = YES;
    }
    return self;
}-(id)initWithbrokerModel:(ZIKCustomizedInfoListModel *)model
{
    self=[super init];
    if (self) {
     
        self.isGouMai = YES;
        
        self.isPuy=YES;
        self.uid=model.mesUid;
        self.type=1;
        _push_=1;
        self.memberCustomUid=model.memberCustomUid;
        self.isFromDingzhi = YES;
        _isCaiGou = YES;
        self.topView = [ZIKCaiGouDetailHaveBuyTopView instanceTopView];
        self.topView.frame = CGRectMake(0, 64, kWidth, 50);
        self.topView.delegate = self;
        [self.view addSubview:self.topView];
        self.topView.hidden = YES;
        
    }
    return self;
    
}
-(id)initWithCaiGouModel:(ZIKCustomizedInfoListModel *)model {
    self=[super init];
    if (self) {
        if (model.buy == 0) {//未购买
            self.isGouMai = NO;
        } else if (model.buy == 1) {
            self.isGouMai = YES;
        }
        self.isPuy=NO;
        self.uid=model.uid;
        self.type=1;
        _push_=1;
        self.memberCustomUid=model.memberCustomUid;
        self.isFromDingzhi = YES;
        _isCaiGou = YES;
        self.topView = [ZIKCaiGouDetailHaveBuyTopView instanceTopView];
        self.topView.frame = CGRectMake(0, 64, kWidth, 50);
        self.topView.delegate = self;
        [self.view addSubview:self.topView];
        self.topView.hidden = YES;

    }
    return self;

}

-(void)gotoDetail {
    ZIKStationOrderDetailViewController *sodvc = [[ZIKStationOrderDetailViewController alloc] init];
    sodvc.orderUid = self.topView.orderUid;
    sodvc.statusType = StationOrderStatusTypeQuotation;
    [self.navigationController pushViewController:sodvc animated:YES];
}
-(id)initWithHeZuoMiaoQiInfo:(NSString *)uid {
    self=[super init];
    if (self) {
        self.isPuy=NO;
        self.uid=uid;
        self.type=1;

        self.isFromDingzhi = YES;//不是从定制列表进入的
        isHezuo = YES;
        [HTTPCLIENT buyDetailWithUid:uid WithAccessID:APPDELEGATE.userModel.access_id
                            WithType:@"0" WithmemberCustomUid:@""                             Success:^(id responseObject) {
                                if (![[responseObject objectForKey:@"success"] integerValue]) {
                                    [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
                                    [self.navigationController popViewControllerAnimated:YES];
                                }
                                NSDictionary *dic=[responseObject objectForKey:@"result"];
                                self.infoDic=dic;
                                self.memberUid = dic[@"memberUid"];
                                self.model=[BuyDetialModel creatBuyDetialModelByDic:[dic objectForKey:@"detail"] withResult:dic];
                                self.model.uid=uid;
                                self.model.goldsupplier=[[dic objectForKey:@"goldsupplier"] integerValue];
                                if (self.model.push||self.model.buy||self.model.isBuyTime==0) {
                                    self.isPuy=YES;
    
                                }else
                                {
                                    self.isPuy=NO;
                                }
                                if (!self.isPuy) {
                                    if ([self.model.publishUid isEqualToString:APPDELEGATE.userModel.access_id]) {
                                    }else
                                    {
                                        if (_BuyMessageView==nil) {
                                            _BuyMessageView = [self kefuView];
                                            [_messageView removeFromSuperview];
                                            _messageView = nil;
                                        }
                                    }

                                }else{
                                    _messageView = [self kefuView];
                                }
                                
                                [self reloadMyView];
                            } failure:^(NSError *error) {
                                
                            }];
        

    }
    return self;

}
-(id)initWithSaercherInfo:(NSString *)uid
{
    self=[super init];
    if (self) {
        self.isPuy=NO;
        self.uid=uid;
        self.type=1;

        self.isFromDingzhi = NO;//不是从定制列表进入的

    }
    return self;
}
-(id)initMyDetialWithSaercherInfo:(NSString *)uid
{
    self=[super init];
    if (self) {
        self.uid=uid;
        self.type=2;
        self.isFromDingzhi = NO;//不是从定制列表进入的
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.pingluAry=[NSMutableArray array];
   
    isCaiGou = _isCaiGou;
    
    UIView *navView =  [self makeNavView];
    [self.view addSubview:navView];
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-50-50) style:UITableViewStyleGrouped];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];
    self.isShow=NO;
    [self.view setBackgroundColor:BGColor];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(caiGouPaySuccess:) name:@"CaiGouSinglePaySuccessNotification" object:nil];
    YLDSCommentAView *yldcommentAV=[[YLDSCommentAView alloc]initWithFrame:CGRectMake(0, kHeight-50-50, kWidth, 50)];
    self.commentV=yldcommentAV;
    [yldcommentAV.shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [yldcommentAV.collectBtn addTarget:self action:@selector(collectionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [yldcommentAV.commentBtn addTarget:self action:@selector(commentBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.collectionBtn=yldcommentAV.collectBtn;
    [yldcommentAV.fabiaoBtn addTarget:self action:@selector(fabiaoAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:yldcommentAV];
    YLDSPingLunSrView *VVVVZ=[[YLDSPingLunSrView alloc]initWithFrame:CGRectMake(0, kHeight, kWidth, kHeight)];
    VVVVZ.delegate=self;
    self.fabiaoV=VVVVZ;
    self.commentNum=1;
   
    __weak typeof(self) weakSelf=self;
    [self.tableView addFooterWithCallback:^{
        weakSelf.commentNum+=1;
        [weakSelf getcommentsWithPageNum:[NSString stringWithFormat:@"%ld",weakSelf.commentNum]];
    }];

    [ChangyanSDK loadTopic:@"" topicTitle:nil topicSourceID:self.uid topicCategoryID:nil pageSize:@"30" hotSize:@"3" orderBy:nil style:@"indent" depth:nil subSize:nil completeBlock:^(CYStatusCode statusCode, NSString *responseStr)
     {
         if (statusCode==CYSuccess) {
             NSDictionary *dic=[ZIKFunction dictionaryWithJsonString:responseStr];
             weakSelf.topic_id=dic[@"topic_id"];
             self.commentV.commentNum=[dic[@"cmt_sum"] integerValue];
             APPDELEGATE.userModel.chanyanUser_id=[dic[@"user_id"] integerValue];
             [weakSelf.pingluAry removeAllObjects];
             [weakSelf.pingluAry addObjectsFromArray:[YLDSPingLunModel aryWithChangYanAry:dic[@"comments"]]];
             [weakSelf.tableView reloadData];
         }else{
             [ToastView showTopToast:responseStr];
         }
         
     }];

}
-(void)commentBtnAction
{
    
    if (self.pingluAry.count>0) {

        NSIndexPath * dayOne = [NSIndexPath indexPathForRow:0 inSection:6];
        
        [self.tableView scrollToRowAtIndexPath:dayOne atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }else
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        
        [self.tableView setContentOffset:offset animated:YES];
    }
    
}
-(void)fabiaoAction
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
-(void)deleteActionWithModel:(YLDSPingLunModel *)model{

    YLDCommentRepliesViewController *vvbb=[[YLDCommentRepliesViewController alloc]init];
    vvbb.topic_id=self.topic_id;
    vvbb.comment_id=model.uid;

    vvbb.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    vvbb.providesPresentationContextTransitionStyle = YES;
    
    vvbb.definesPresentationContext = YES;
    
    vvbb.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:vvbb animated:YES completion:^{
        [vvbb.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
        
    }];
}
-(void)getcommentsWithPageNum:(NSString *)pageNum
{
    __weak typeof(self) weakself=self;
     [ChangyanSDK getTopicComments:[NSString stringWithFormat:@"%@",self.topic_id] pageSize:@"30" pageNo:pageNum orderBy:nil style:@"indent" depth:nil subSize:@"10" completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
         if (statusCode == CYSuccess)
         {
             if([pageNum isEqualToString:@"1"])
             {
                 [weakself.pingluAry removeAllObjects];
             }
             NSDictionary *dic=[ZIKFunction dictionaryWithJsonString:responseStr];
             NSArray *commentsAry=dic[@"comments"];
             
             if (commentsAry.count>0) {
                 YLDSPingLunModel *model=[YLDSPingLunModel modelWithChangYanDic:[commentsAry lastObject]];
                 YLDSPingLunModel *model2=[weakself.pingluAry lastObject];
                 if (model.uid!=model2.uid) {
                     [weakself.pingluAry addObjectsFromArray:[YLDSPingLunModel aryWithChangYanAry:commentsAry]];
                     [weakself.tableView reloadData];
                 }

             }else{
                 [ToastView showTopToast:@"暂无更多评论"];
             }
             self.commentV.commentNum=[dic[@"cmt_sum"] integerValue];
         }
         [weakself.tableView footerEndRefreshing];
     }];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CaiGouSinglePaySuccessNotification" object:nil];
}

- (void)caiGouPaySuccess:(NSDictionary *)dictionary
{
    isCaiGouSuccess = YES;
}


- (void)shopBtnAction {


    if ([ZIKFunction xfunc_check_strEmpty:_memberUid]) {
        [ToastView showTopToast:@"无店铺信息"];
        return;
    }
    ZIKMyShopViewController *shopVC = [[ZIKMyShopViewController alloc] init];
    shopVC.memberUid = _memberUid;
    shopVC.type = 1;
    [self.navigationController pushViewController:shopVC animated:YES];

}
-(UIView *)lianxiMessageView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, kHeight-50, kWidth, 50)];
 
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(kWidth*1/5, 0, kWidth*2/5, 1)];
    topLineView.backgroundColor = kLineColor;
    [view addSubview:topLineView];

    if (![ZIKFunction xfunc_check_strEmpty:_memberUid]) {
        UIButton *shopBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, kWidth*1/5, 50)];
        [shopBtn setBackgroundColor:kBlueShopColor];
        [shopBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [shopBtn setTitle:@"店铺" forState:UIControlStateNormal];
        [shopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        shopBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
        [shopBtn addTarget:self action:@selector(shopBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [shopBtn setImage:[UIImage imageNamed:@"1求购供应详情-店铺图标2"] forState:UIControlStateNormal];
        [view addSubview:shopBtn];
        UIButton *messageBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth*1/5, 1, kWidth*2/5, 50-1)];
        //    [messageBtn setBackgroundColor:[UIColor colorWithRed:222/255.f green:222/255.f blue:222/255.f alpha:0.7]];
        [messageBtn setBackgroundColor:[UIColor whiteColor]];
        [messageBtn setTitle:@"短信留言" forState:UIControlStateNormal];
        [messageBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
        messageBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
        [messageBtn addTarget:self action:@selector(meaageAction) forControlEvents:UIControlEventTouchUpInside];
        [messageBtn setImage:[UIImage imageNamed:@"shotMessageImage"] forState:UIControlStateNormal];
        [view addSubview:messageBtn];
        
        UIButton *phoneBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth*3/5,0, kWidth*2/5, 50)];
        [phoneBtn setTitle:@"联系商家" forState:UIControlStateNormal];
        [phoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        phoneBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
        [phoneBtn setImage:[UIImage imageNamed:@"phoneImage"] forState:UIControlStateNormal];
        [phoneBtn setBackgroundColor:NavColor];
        [phoneBtn addTarget:self action:@selector(CallAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:phoneBtn];
    }else{
        UIButton *messageBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 1, kWidth*2.5/5, 50-1)];
        //    [messageBtn setBackgroundColor:[UIColor colorWithRed:222/255.f green:222/255.f blue:222/255.f alpha:0.7]];
        [messageBtn setBackgroundColor:[UIColor whiteColor]];
        [messageBtn setTitle:@"短信留言" forState:UIControlStateNormal];
        [messageBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
        messageBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
        [messageBtn addTarget:self action:@selector(meaageAction) forControlEvents:UIControlEventTouchUpInside];
        [messageBtn setImage:[UIImage imageNamed:@"shotMessageImage"] forState:UIControlStateNormal];
        [view addSubview:messageBtn];
        
        UIButton *phoneBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth*2.5/5,0, kWidth*2.5/5, 50)];
        [phoneBtn setTitle:@"联系商家" forState:UIControlStateNormal];
        [phoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        phoneBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
        [phoneBtn setImage:[UIImage imageNamed:@"phoneImage"] forState:UIControlStateNormal];
        [phoneBtn setBackgroundColor:NavColor];
        [phoneBtn addTarget:self action:@selector(CallAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:phoneBtn];

    }
  


   
    [self.view addSubview:view];
    return view;
}
//合作苗企客服底部view
- (UIView *)kefuView {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, kHeight-50, kWidth, 50)];
    view.backgroundColor = [UIColor redColor];

    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(kWidth*1/5, 0, kWidth*2.5/5, 1)];
    topLineView.backgroundColor = kLineColor;
    [view addSubview:topLineView];

    UIButton *shopBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, kWidth*1/5, 50)];
    [shopBtn setBackgroundColor:kBlueShopColor];
    [shopBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [shopBtn setTitle:@"店铺" forState:UIControlStateNormal];
    [shopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shopBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
    [shopBtn addTarget:self action:@selector(shopBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [shopBtn setImage:[UIImage imageNamed:@"1求购供应详情-店铺图标2"] forState:UIControlStateNormal];
    [view addSubview:shopBtn];

    UIButton *kefuBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth*1/5,0, kWidth*3/5, 50)];
    [kefuBtn setBackgroundColor:[UIColor whiteColor]];
    [kefuBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [kefuBtn setTitle:@"专属客服" forState:UIControlStateNormal];
    [kefuBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
    kefuBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
    [kefuBtn setImage:[UIImage imageNamed:@"形状-6"] forState:UIControlStateNormal];
    [kefuBtn addTarget:self action:@selector(kefuBtnClcik) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:kefuBtn];


    UIButton *shareBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth*4/5,0, kWidth*1/5, 50)];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shareBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
    [shareBtn setImage:[UIImage imageNamed:@"分享.png"] forState:UIControlStateNormal];
    [shareBtn setBackgroundColor:yellowButtonColor];
    [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:shareBtn];

    [self.view addSubview:view];

    return view;
}
- (void)kefuBtnClcik {
    ZIKHeZuoMiaoQiKeFuViewController *kefuVC = [[ZIKHeZuoMiaoQiKeFuViewController alloc] initWithNibName:@"ZIKHeZuoMiaoQiKeFuViewController" bundle:nil];
    [self.navigationController pushViewController:kefuVC animated:YES];
}
-(UIView *)lianxiMessageShareView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, kHeight-50, kWidth, 50)];

    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth*2.5/5, 1)];
    topLineView.backgroundColor = kLineColor;
    [view addSubview:topLineView];
    if (![ZIKFunction xfunc_check_strEmpty:_memberUid]) {
        UIButton *shopBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, kWidth*1/5, 50)];
        [shopBtn setBackgroundColor:kBlueShopColor];
        [shopBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [shopBtn setTitle:@"店铺" forState:UIControlStateNormal];
        [shopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        shopBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
        [shopBtn addTarget:self action:@selector(shopBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [shopBtn setImage:[UIImage imageNamed:@"1求购供应详情-店铺图标2"] forState:UIControlStateNormal];
        [view addSubview:shopBtn];

        UIButton *messageBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth*1/5, 1, kWidth*2/5, 50-1)];
        messageBtn.backgroundColor = [UIColor whiteColor];

        [messageBtn setTitle:@"短信留言" forState:UIControlStateNormal];
        [messageBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
        messageBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
        [messageBtn addTarget:self action:@selector(meaageAction) forControlEvents:UIControlEventTouchUpInside];
        [messageBtn setImage:[UIImage imageNamed:@"shotMessageImage"] forState:UIControlStateNormal];
        [messageBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [view addSubview:messageBtn];
        UIButton *phoneBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth*3/5,0, kWidth*2/5, 50)];
        [phoneBtn setTitle:@"联系商家" forState:UIControlStateNormal];
        [phoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        phoneBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
        [phoneBtn setImage:[UIImage imageNamed:@"phoneImage"] forState:UIControlStateNormal];
        [phoneBtn setBackgroundColor:NavColor];
        [phoneBtn addTarget:self action:@selector(CallAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:phoneBtn];
        [phoneBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];

    }else{
        UIButton *messageBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 1, kWidth*2.5/5, 50-1)];
        messageBtn.backgroundColor = [UIColor whiteColor];
 
        [messageBtn setTitle:@"短信留言" forState:UIControlStateNormal];
        [messageBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
        messageBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
        [messageBtn addTarget:self action:@selector(meaageAction) forControlEvents:UIControlEventTouchUpInside];
        [messageBtn setImage:[UIImage imageNamed:@"shotMessageImage"] forState:UIControlStateNormal];
        [messageBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [view addSubview:messageBtn];
        UIButton *phoneBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth*2.5/5,0, kWidth*2.5/5, 50)];
        [phoneBtn setTitle:@"联系商家" forState:UIControlStateNormal];
        [phoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        phoneBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
        [phoneBtn setImage:[UIImage imageNamed:@"phoneImage"] forState:UIControlStateNormal];
        [phoneBtn setBackgroundColor:NavColor];
        [phoneBtn addTarget:self action:@selector(CallAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:phoneBtn];
        [phoneBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];

    }
    [self.view addSubview:view];
    return view;
}

-(UIView *)laobanViewWithPrice:(float)price
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, kHeight-50, kWidth, 50)];

    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth*3/5+2, 1)];
    topLineView.backgroundColor = kLineColor;
    [view addSubview:topLineView];
    if (![ZIKFunction xfunc_check_strEmpty:_memberUid]) {
        UIButton *shopBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, kWidth*1/5, 50)];
        [shopBtn setBackgroundColor:kBlueShopColor];

        [shopBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [shopBtn setTitle:@"店铺" forState:UIControlStateNormal];
        [shopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        shopBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
        [shopBtn addTarget:self action:@selector(shopBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [shopBtn setImage:[UIImage imageNamed:@"1求购供应详情-店铺图标2"] forState:UIControlStateNormal];
        [view addSubview:shopBtn];
        


        UIButton *messageBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth*1/5, 1, kWidth*2/5, 50-1)];
        [messageBtn setTitle:[NSString stringWithFormat:@"¥%.2f",price] forState:UIControlStateNormal];
        [messageBtn setTitleColor:yellowButtonColor forState:UIControlStateNormal];
        messageBtn.backgroundColor = [UIColor whiteColor];
        [view addSubview:messageBtn];
        BuyButton *phoneBtn=[[BuyButton alloc]initWithFrame:CGRectMake(kWidth*3/5,0, kWidth*2/5, 50)];
        
        [phoneBtn setTitle:@"查看联系方式" forState:UIControlStateNormal];
        phoneBtn.price = price;
        phoneBtn.buyUid = self.model.uid;
        [phoneBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [phoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        phoneBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
        [phoneBtn setImage:[UIImage imageNamed:@"phoneImage"] forState:UIControlStateNormal];
        [phoneBtn setBackgroundColor:yellowButtonColor];
        [phoneBtn addTarget:self action:@selector(buyAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:phoneBtn];

    }else{
        UIButton *messageBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 1, kWidth*2.5/5, 50-1)];
        [messageBtn setTitle:[NSString stringWithFormat:@"¥%.2f",price] forState:UIControlStateNormal];
        [messageBtn setTitleColor:yellowButtonColor forState:UIControlStateNormal];
        messageBtn.backgroundColor = [UIColor whiteColor];
        [view addSubview:messageBtn];
        BuyButton *phoneBtn=[[BuyButton alloc]initWithFrame:CGRectMake(kWidth*2.5/5,0, kWidth*2.5/5, 50)];
        
        [phoneBtn setTitle:@"查看联系方式" forState:UIControlStateNormal];
        phoneBtn.price = price;
        phoneBtn.buyUid = self.model.uid;
        [phoneBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [phoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        phoneBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
        [phoneBtn setImage:[UIImage imageNamed:@"phoneImage"] forState:UIControlStateNormal];
        [phoneBtn setBackgroundColor:yellowButtonColor];
        [phoneBtn addTarget:self action:@selector(buyAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:phoneBtn];

    }
    
    [self.view addSubview:view];
    return view;
}

-(void)buyAction:(BuyButton *)button
{
    if (![APPDELEGATE isNeedLogin]) {
        [ToastView showTopToast:@"请先登录"];
        YLDLoginViewController *loginViewController=[[YLDLoginViewController alloc]init];
        [ToastView showTopToast:@"请先登录"];
        UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
        
        [self presentViewController:navVC animated:YES completion:^{
            
        }];
        return;
    }

    ZIKSingleVoucherCenterViewController *svcvc =  [[ZIKSingleVoucherCenterViewController alloc]initWithNibName:@"ZIKSingleVoucherCenterViewController" bundle:nil];
    svcvc.price  = button.price;
    svcvc.buyUid = button.buyUid;
    if (isCaiGou) {
        svcvc.recordUid = self.topView.recordUid;
        svcvc.infoType = InfoTypeStation;
        svcvc.buyUid = self.topView.recordUid;
    }
    [self.navigationController pushViewController:svcvc animated:YES];
    return;
    [HTTPCLIENT getAmountInfo:nil Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            float moneyNum =[[[responseObject objectForKey:@"result"] objectForKey:@"money"]floatValue];
            if (moneyNum<self.model.buyPrice) {
                [ToastView showTopToast:@"您的余额不足，请先充值"];
                
                ZIKPayViewController *zikPayVC=[[ZIKPayViewController alloc]init];
                [self.navigationController pushViewController:zikPayVC animated:YES];
                return ;
            }
            _buyAlertView =[BuyMessageAlertView addActionVieWithPrice:[NSString stringWithFormat:@"%.2f",self.model.buyPrice               ] AndMone:[NSString stringWithFormat:@"%.2f",moneyNum]];
            [_buyAlertView.rightBtn addTarget:self action:@selector(buySureAction) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)buySureAction
{
    ShowActionV();
    [HTTPCLIENT payForBuyMessageWithBuyUid:self.model.uid type:nil Success:^(id responseObject) {
        RemoveActionV();
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            [ToastView showTopToast:@"购买成功"];
            ShowActionV();
    [HTTPCLIENT buyDetailWithUid:self.uid WithAccessID:APPDELEGATE.userModel.access_id
                                WithType:@"0" WithmemberCustomUid:@""                             Success:^(id responseObject) {
                                    //NSLog(@"%@",responseObject);
                                    RemoveActionV();
                                    NSDictionary *dic=[responseObject objectForKey:@"result"];
                                    self.infoDic=dic;
                                    self.memberUid = dic[@"memberUid"];
                                    self.model=[BuyDetialModel creatBuyDetialModelByDic:[dic objectForKey:@"detail"] withResult:dic];
                                    self.model.uid=self.uid;
                                    if (self.model.push||self.model.buy||self.model.isBuyTime==0) {
                                        self.isPuy=YES;
                      
                                    }else
                                    {
                                        self.isPuy=NO;
                                    }
                                    if (!self.isPuy) {
                                        if (_BuyMessageView==nil) {
                                            if (APPDELEGATE.isNeedLogin) {
                                                _BuyMessageView =[self laobanViewWithPrice:self.model.buyPrice];

                                            } else {
                                                _BuyMessageView =[self laobanViewWithPrice:self.model.buyPrice];

                                            }
                                            [_messageView removeFromSuperview];
                                            _messageView = nil;
                                        }
                                    }else{
                                        if (_messageView==nil) {
                                            if (APPDELEGATE.isNeedLogin) {
                                                _messageView = [self lianxiMessageShareView];

                                            } else {
                                                _messageView = [self lianxiMessageView];

                                            }

                                            [_BuyMessageView removeFromSuperview];
                                            _BuyMessageView = nil;
                                        }
                                    }
                                    [self reloadMyView];
                                } failure:^(NSError *error) {
                                    RemoveActionV();
                                }];


        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        RemoveActionV();
    }];
    [BuyMessageAlertView removeActionView];
}
-(void)CallAction
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[[self.infoDic objectForKey:@"detail"] objectForKey:@"phone"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
-(void)meaageAction
{
    [self showMessageView:[NSArray arrayWithObjects:[[self.infoDic objectForKey:@"detail"] objectForKey:@"phone"], nil] title:@"苗木求购" body:[NSString stringWithFormat:@"我对您在点花木APP发布的求购信息:%@ 很感兴趣",[[self.infoDic objectForKey:@"detail"] objectForKey:@"productName"]]];
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

-(void)reloadMyView
{
    if ([self.model.publishUid isEqualToString:APPDELEGATE.userModel.access_id]) {
        [_BuyMessageView removeFromSuperview];
        _BuyMessageView =nil;
        [_messageView removeFromSuperview];
        _messageView = nil;
        CGRect r = self.commentV.frame;
        r.origin.y=kHeight-self.commentV.frame.size.height;
        self.commentV.frame=r;
    }
    if (_BuyMessageView == nil && _messageView == nil && myshareBtn == nil) {
        self.tableView.frame=CGRectMake(0, 64, kWidth, kHeight-64-50);
    }
    if (self.type==1||self.type==5) {
        if (self.model.state==1) {
        }
        if (self.model.state==0) {
            if (!_isPuy) {
                [_BuyMessageView removeFromSuperview];
                _BuyMessageView=nil;
            }else{
                [_BuyMessageView removeFromSuperview];
                _BuyMessageView=nil;
                _messageView = [self lianxiMessageView];
            }
        }

        if (self.model.state == 5) {//已删除
            
            _BuyMessageView.hidden = YES;
            _messageView.hidden = YES;
            _biaoqianView.hidden = YES;
            self.tableView.frame=CGRectMake(0, 64, kWidth, kHeight-64 - 50);
        }
        if (_isCaiGou) {
            if (self.isPuy) {
                self.tableView.frame = CGRectMake(0, 64+50, kWidth, kHeight-64-50-50-50);
            } else {
                if (self.model.state == 4) {
                    self.tableView.frame = CGRectMake(0, 64, kWidth, kHeight-64-50-50);
                } else {
                    self.tableView.frame = CGRectMake(0, 64, kWidth, kHeight-64-50);
                }
            }
        }

    }
    if (self.type==2) {
        if (self.model.state==1||self.model.state==3) {
            [self.editingBtn setTitle:@"编辑" forState:UIControlStateNormal];
            [self.editingBtn addTarget:self action:@selector(editingBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (self.model.state==0||self.model.state==4||self.model.state==2) {
            //0  已关闭 可打开  4 审核通过 可关闭
            [self.editingBtn setTitle:@"关闭" forState:UIControlStateNormal];
            [self.editingBtn setTitle:@"" forState:UIControlStateHighlighted];
            [self.editingBtn setTitle:@"打开" forState:UIControlStateSelected];
            [self.editingBtn addTarget:self action:@selector(openAndColseBtn:) forControlEvents:UIControlEventTouchUpInside];
            if (self.model.state==0) {
                self.editingBtn.selected=YES;
            }
            if (self.model.state==2||self.model.state==4) {
                self.editingBtn.selected=NO;
                
            }
        }
    }
    NSString *titleStr=[[self.infoDic objectForKey:@"detail"] objectForKey:@"title"];
    [self.navTitleLab setText:titleStr];
    
    if ([[[self.infoDic objectForKey:@"detail"] objectForKey:@"collect"] integerValue]) {
        self.collectionBtn.selected=YES;
    }
    self.specAry=[[self.infoDic objectForKey:@"detail"]objectForKey:@"spec"];
    _miaomuzhiAry=[NSMutableArray array];
    for (int i=0; i<self.specAry.count; i++) {
        NSDictionary *dic=self.specAry[i];
        NSArray *aryyyyy=[dic objectForKey:@"value"];
        if (![[aryyyyy firstObject] isEqualToString:@"不限"]) {
            [_miaomuzhiAry addObject:dic];
        }
    }
    NSArray *rocomAry=[HotBuyModel creathotBuyModelAryByAry:[self.infoDic objectForKey:@"list"]];
    
    NSString *advertisementsStr=[self.infoDic objectForKey:@"advertisements"];
    NSDictionary *advertisementsDic=[ZIKFunction dictionaryWithJsonString:advertisementsStr];
    NSArray *adary=[YLDSadvertisementModel aryWithAry:[advertisementsDic objectForKey:@"result"]];

    self.recommendeAry = [ZIKFunction aryWithMessageAry:rocomAry withADAry:adary andIndex:0];

    NSString *luoboAdvertisementsStr=[self.infoDic objectForKey:@"carousels"];
    NSDictionary *luoboAdvertisementsDic=[ZIKFunction dictionaryWithJsonString:luoboAdvertisementsStr];
    self.luoboAry=[YLDSadvertisementModel aryWithAry:luoboAdvertisementsDic[@"result"]];
    [self.tableView reloadData];
    
}
-(UIView *)makeNavView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,0, kWidth, 64)];
    [view setBackgroundColor:NavColor];
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(12, 26, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"backBtnBlack"] forState:UIControlStateNormal];
    [view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setEnlargeEdgeWithTop:10 right:80 bottom:10 left:10];
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-80,26, 160, 30)];
    [titleLab setTextColor:[UIColor whiteColor]];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    [titleLab setText:@"求购详情"];
    [titleLab setFont:[UIFont systemFontOfSize:NavTitleSize]];
    self.navTitleLab=titleLab;
    [view addSubview:titleLab];
    if (self.type==2) {
         UIButton *editingBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-60, 26, 50, 30)];
        [editingBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        self.editingBtn=editingBtn;
        [view addSubview:editingBtn];
    }else
    {
        if (!isCaiGou) {
          

        }
     }
    
    return view;
}
-(void)editingBtn:(UIButton *)sender
{
//    if (self.model.state==1||self.model.state==3) {
//        self.model.uid=self.uid;
//        buyFabuViewController *buyFabuVC=[[buyFabuViewController alloc]initWithModel:self.model];
//        [self.navigationController pushViewController:buyFabuVC animated:YES];
//    }else{
//        [ToastView showTopToast:@"该条求购不可编辑"];
//        return;
//    }
    
}
-(void)openAndColseBtn:(UIButton *)sender
{
    if (sender.selected==YES) {
        ShowActionV();
        [HTTPCLIENT openMyBuyMessageWithUids:self.model.uid Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                [ToastView showTopToast:@"打开成功"];
                sender.selected=NO;
                
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
        
        return;
    }
    if(sender.selected==NO)
    {
        ShowActionV();
        [HTTPCLIENT closeMyBuyMessageWithUids:self.model.uid Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                [ToastView showTopToast:@"关闭成功"];
                sender.selected=YES;
                
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }

        } failure:^(NSError *error) {
            
        }];
    }
}
-(void)collectionBtn:(UIButton *)sender
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
    if (sender.selected==NO) {
        [HTTPCLIENT collectBuyWithSupplyID:self.uid Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                [ToastView showTopToast:@"收藏成功"];
                sender.selected=YES;
                [HTTPCLIENT buyDetailWithUid:self.uid WithAccessID:APPDELEGATE.userModel.access_id
                 WithType:@"0" WithmemberCustomUid:@""
                                     Success:^(id responseObject) {
                    if ([[responseObject objectForKey:@"success"] integerValue]) {
                        self.infoDic=[responseObject objectForKey:@"result"];
                    }else{
                        [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
                    }
                } failure:^(NSError *error) {
                    
                }];
            }
        } failure:^(NSError *error) {
            
        }];
        return;
    }
    if (sender.selected) {
        [HTTPCLIENT deletesenderCollectWithIds:[[self.infoDic objectForKey:@"detail"] objectForKey:@"collectUid"] Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                sender.selected=NO;
                [ToastView showTopToast:@"取消收藏成功"];
            }else
            {
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
            
        } failure:^(NSError *error) {
            
        }];
    }
}
-(void)backBtnAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==5) {
 
       
        return self.recommendeAry.count;
    }
    if (section==6) {
        return self.pingluAry.count;
    }
    if (section==0) {
        if (self.luoboAry.count>0) {
            return 1;
        }else{
            return 0;
        }
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        AdvertView *adVcell=[[AdvertView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 0.368*kWidth)];
        adVcell.delegate=self;
        [adVcell setAdInfoWithAry:self.luoboAry];
        [adVcell adStart];
        return adVcell;
    }
    if (indexPath.section==1) {
        BuyUserInfoTableViewCell *cell = nil;
        if (isCaiGou) {
            cell=[[BuyUserInfoTableViewCell alloc]initWithCaiGouFrame:CGRectMake(0, 0, kWidth, 125)];
            cell.isGouMai = self.isGouMai;
          } else {
            cell=[[BuyUserInfoTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, 125)];
        }
        if (self.type!=2) {
            if (self.model.push) {
                [cell.biaoshiImageV setImage:[UIImage imageNamed:@"dibgzhibiaoqian"]];
            }else if (self.model.buy) {
                [cell.biaoshiImageV setImage:[UIImage imageNamed:@"buybiaoqian"]];
            }else
            {
                [cell.biaoshiImageV setImage:[UIImage imageNamed:@""]];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.type==2) {
            self.model.goldsupplier=APPDELEGATE.userModel.goldsupplierStatus;
        }
        if (self.model) {
            if (self.type==1&&!_isPuy) {
                self.model.supplybuyName=@"请付费查看";
            }
            cell.model=self.model;
        }
        return cell;

    }else if(indexPath.section==2)
    {
        BuyOtherInfoTableViewCell *cell=[[BuyOtherInfoTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, self.specAry.count*30+40) andName:self.model.productName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.specAry) {
                cell.ary=self.specAry;

        }
        return cell;
    }else if (indexPath.section==3)
    {
        QIYeMessageTableViewCell *cell = nil;

            cell=[[QIYeMessageTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, 140)];
 
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.infoDic) {
            NSMutableDictionary *dic= [NSMutableDictionary dictionaryWithDictionary:[self.infoDic objectForKey:@"detail"]];
            if(!_isPuy&&self.type==1)
            {
                if ([self.model.publishUid isEqualToString:APPDELEGATE.userModel.access_id]) {
                    
                }else
                {
                    [dic setValue:@"请付费查看" forKey:@"phone"];
                }
                
            }
            cell.dic=dic;
        }
        return cell;
    }else if(indexPath.section==4)
    {
        
        NSString *labelText=[[self.infoDic objectForKey:@"detail"] objectForKey:@"description"];
        
        YLDSBuyBrifTableViewCell *cell=[YLDSBuyBrifTableViewCell yldSBuyBrifTableViewCell];
        NSInteger zzx =0;
        for (int i=0; i<self.model.imagesAry.count; i++) {
            NSString *imageStr=self.model.imagesAry[i];
            zzx +=5;
            
            if (i==0) {
                [cell.imageV1 setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"MoRentu"]];
                cell.imageVW1.constant=(kWidth-40)*0.7;
            }
            if (i==1) {
                [cell.imageV2 setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"MoRentu"]];
                cell.imageVW2.constant=(kWidth-40)*0.7;
            }
            if (i==2) {
                [cell.imageV3 setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"MoRentu"]];
                cell.imageVW3.constant=(kWidth-40)*0.7;
            }
        }
        cell.birfLab.text=labelText;
        return cell;

    }
    if (indexPath.section==5) {
        
        id model=self.recommendeAry[indexPath.row];
        if ([model isKindOfClass:[HotBuyModel class]]) {
            YLDTBuyListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDTBuyListCell"];
            if (!cell) {
                cell=[YLDTBuyListCell yldTBuyListCell];
                
            }
            cell.model=model;
            return cell;
        }else if([model isKindOfClass:[YLDSadvertisementModel class]])
        {
            YLDSadvertisementModel *model=self.recommendeAry[indexPath.row];
            if (model.adsType==0) {
                YLDSBigImageVadCell *cell=[YLDSBigImageVadCell yldSBigImageVadCell];
                cell.model=model;
                return cell;
            }else if (model.adsType==1){
                YLDStextAdCell *cell=[YLDStextAdCell yldStextAdCell];
                cell.model=model;
                return cell;
            }else if (model.adsType==2){
                YLDTMoreBigImageADCell *cell=[YLDTMoreBigImageADCell yldTMoreBigImageADCell];
                cell.model=model;
                return cell;
            }else if (model.adsType==3){
                YLDTADThreePicCell *cell=[YLDTADThreePicCell yldTADThreePicCell];
                cell.model=model;
                return cell;
            }else if (model.adsType==6){
                YLDTLeftTextAdCell *cell=[YLDTLeftTextAdCell yldTLeftTextAdCell];
                cell.model=model;
                return cell;
            }
        }
       
    }
    
    if (indexPath.section==6) {
        YLDSPingLunCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDSPingLunCell"];
        if (!cell) {
            cell=[YLDSPingLunCell yldSPingLunCell];
        }
        YLDSPingLunModel *model=self.pingluAry[indexPath.row];
        cell.delgate=self;
        cell.model=model;
        return cell;
    }
    UITableViewCell *cell=[UITableViewCell new];
    return cell;
}
-(void)zanActionWith:(UIButton *)sender Uid:(YLDSPingLunModel *)model{
    if(![APPDELEGATE isNeedLogin])
    {
        YLDLoginViewController *loginViewController=[[YLDLoginViewController alloc]init];
        [ToastView showTopToast:@"请先登录"];
        UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
        
        [self presentViewController:navVC animated:YES completion:^{
            
        }];
        return;
    }
    [ChangyanSDK commentAction:1 topicID:[NSString stringWithFormat:@"%@",self.topic_id] commentID:[NSString stringWithFormat:@"%@",model.uid] completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
        if (statusCode==CYSuccess) {
//            sender.selected=YES;
            NSDictionary *dic=[ZIKFunction dictionaryWithJsonString:responseStr];
            [sender setTitle:[NSString stringWithFormat:@"%ld",[dic[@"count"] integerValue]] forState:UIControlStateNormal];
            [sender setTitle:[NSString stringWithFormat:@"%ld",[dic[@"count"] integerValue]] forState:UIControlStateSelected];
        }else{
            [ToastView showTopToast:responseStr];
        }
    }];

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 0.368*kWidth;
    }
    if (indexPath.section==1) {
        if (self.model.goldsupplier==0||self.model.goldsupplier==10) {
            return 100;
        }else{
            return 125;
        }
    }
    if (indexPath.section==2) {
        if (self.specAry) {

                return self.specAry.count*30+40;
            
        }
    }
    if (indexPath.section==3) {

            NSMutableDictionary *dic= [NSMutableDictionary dictionaryWithDictionary:[self.infoDic objectForKey:@"detail"]];
            NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
            CGSize size = [dic[@"address"] boundingRectWithSize:CGSizeMake(kWidth-130-15, CGFLOAT_MAX) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
            if (size.height == 0) {
                return 15+110;
            }
            return size.height+110;

    }
    if(indexPath.section==4)
    {
        self.tableView.rowHeight = UITableViewAutomaticDimension;//设置cell的高度为自动计算，只有才xib或者storyboard上自定义的cell才会生效，而且需要设置好约束
        self.tableView.estimatedRowHeight = 60;
        return tableView.rowHeight;
       
    }
    if (indexPath.section==5) {
        id model=self.recommendeAry[indexPath.row];
        if ([model isKindOfClass:[YLDSadvertisementModel class]]) {
            YLDSadvertisementModel *model=self.recommendeAry[indexPath.row];
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
        }else{
            return 90;
        }

    }
    
    if (indexPath.section==6) {
        self.tableView.rowHeight = UITableViewAutomaticDimension;//设置cell的高度为自动计算，只有才xib或者storyboard上自定义的cell才会生效，而且需要设置好约束
        self.tableView.estimatedRowHeight = 90;
        return tableView.rowHeight;
        
    }
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        UIView *view=[[UIView alloc]init];
            return view;
    }
    if (section==1) {

        UIView *view=[[UIView alloc]init];
        return view;
    }
    if (section==6) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 30)];
        [view setBackgroundColor:BGColor];
        UIImageView *lineView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 15, kWidth, 0.5)];
        [lineView setBackgroundColor:kLineColor];
        [view addSubview:lineView];
        UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-25, 0, 50, 30)];
        [titleLab setTextColor:titleLabColor];
        [titleLab setBackgroundColor:[UIColor whiteColor]];
        [titleLab setFont:[UIFont systemFontOfSize:15]];
        [titleLab setTextAlignment:NSTextAlignmentCenter];
        [titleLab setText:@"评论"];
        [view addSubview:titleLab];
        [view setBackgroundColor:[UIColor whiteColor]];
        return view;
    }
    if (section==5) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 50)];
        [view setBackgroundColor:BGColor];
        UIImageView *lineView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 24.25, kWidth, 0.5)];
        [lineView setBackgroundColor:kLineColor];
        [view addSubview:lineView];
        UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-35, 0, 70, 50)];
        [titleLab setTextColor:titleLabColor];
        [titleLab setBackgroundColor:BGColor];
        [titleLab setTextAlignment:NSTextAlignmentCenter];
        [titleLab setText:@"猜你喜欢"];
        [view addSubview:titleLab];
        return view;
    }
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 30)];
    [view setBackgroundColor:BGColor];
    UIImageView *linImag=[[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 2.3, 16)];
    [linImag setBackgroundColor:NavColor];
    [view addSubview:linImag];
    UILabel *messageLab=[[UILabel alloc]initWithFrame:CGRectMake(15, 5, 60, 20)];
    [messageLab setFont:[UIFont systemFontOfSize:13]];
    [messageLab setTextColor:detialLabColor];
    [view addSubview:messageLab];
    if (section==2) {
        messageLab.text=@"苗木信息";
        UILabel *rightLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth-160, 0, 155, 30)];
        [rightLab setFont:[UIFont systemFontOfSize:12]];
        [rightLab setTextColor:titleLabColor];
        [rightLab setTextAlignment:NSTextAlignmentRight];
        [rightLab setText:@"供应信息可分享到微信、QQ"];
        [view addSubview:rightLab];
    }else if (section==3){
        messageLab.text=@"其他信息";
    }else if (section==4){
        messageLab.text=@"备注";
    }
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0.01;
    }
    if (section==1) {
//        if (self.isCaiGou) {
//            return 50;
//        }else
//        {
            return 0.01;
//        }
        
        
    }
    if (section==5) {
        return 50;
    }else{
    return 30;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section==5) {
        id model = self.recommendeAry[indexPath.row];
        if ([model isKindOfClass:[HotBuyModel class]]) {
            HotBuyModel *model=self.recommendeAry[indexPath.row];
            BuyDetialInfoViewController *vc=[[BuyDetialInfoViewController alloc]initWithSaercherInfo:model.uid];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if ([model isKindOfClass:[YLDSadvertisementModel class]]) {
            YLDSadvertisementModel *model=self.recommendeAry[indexPath.row];
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
    if (indexPath.section==6) {
        YLDSPingLunModel *model=self.pingluAry[indexPath.row];
        YLDCommentRepliesViewController *vvbb=[[YLDCommentRepliesViewController alloc]init];
        vvbb.topic_id=self.topic_id;
        vvbb.comment_id=model.uid;
        
        vvbb.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        vvbb.providesPresentationContextTransitionStyle = YES;
        
        vvbb.definesPresentationContext = YES;
        
        vvbb.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:vvbb animated:YES completion:^{
            [vvbb.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
            
        }];

    }

}
-(void)advertPush:(NSInteger)index
{
    if (index<self.luoboAry.count) {
        YLDSadvertisementModel *model=self.luoboAry[index];
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

//获取字符串的高度
-(CGFloat)getHeightWithContent:(NSString *)content width:(CGFloat)width font:(CGFloat)font{
    
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, 999)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                        context:nil];
    return rect.size.height;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)shareBtnClick {
    
//    self.type 1 热门求购  2我的求购
//    self.isPuy YES 已定制或已付款  NO 未付款且未定制
//    self.model.state  4 已通过
    if ([APPDELEGATE isNeedLogin]) {
       [self requestShareData]; 
    }else{
        YLDLoginViewController *loginViewController=[[YLDLoginViewController alloc]init];
        [ToastView showTopToast:@"请先登录"];
        UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
        
        [self presentViewController:navVC animated:YES completion:^{
            
        }];

    }
    
}
#pragma mark - 求购分享
- (void)requestShareData {

    ShowActionV();
    NSString *state = nil;
    if (self.type == 1 && self.model.push != 1 && self.model.buy != 1 ) {//:热门求购（热门求购中除去已定制和已购买的）
        state = @"1";
    }
    else if (self.type == 2) {//我的求购
        state = @"2";
    }
    else if (self.model.push == 1) {//已定制
        state = @"3";
    }
    else if (self.model.buy ) {//已购买
        state  = @"4";
    }
    [HTTPCLIENT buyShareWithUid:self.model.supplybuyUid state:state Success:^(id responseObject) {
        if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]] withOriginY:Width/2 withSuperView:self.view];
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
    //NSLog(@"finish share with response is %@",response);
}

@end
