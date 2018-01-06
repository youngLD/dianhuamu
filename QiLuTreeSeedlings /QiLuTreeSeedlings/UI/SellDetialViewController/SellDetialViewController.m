//
//  SellDetialViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/14.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "SellDetialViewController.h"
#import "UIDefines.h"
#import "HttpClient.h"
#import "SupplyDetialMode.h"
#import "HotSellModel.h"
#import "SellBanderTableViewCell.h"
#import "SellSearchTableViewCell.h"
#import "BuyOtherInfoTableViewCell.h"
#import "SellQiyeInfoTableViewCell.h"
#import "SellSearchTableViewCell.h"
#import "BigImageViewShowView.h"
#import "UIButton+ZIKEnlargeTouchArea.h"

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

//友盟
#import "UMSocialControllerService.h"
#import "UMSocial.h"

#import "ZIKMyShopViewController.h"
#import "ZIKHeZuoMiaoQiKeFuViewController.h"

#import "YLDLoginViewController.h"
#import "UINavController.h"

#import "YLDSPingLunCell.h"
#import "YLDSCommentAView.h"
#import "YLDSPingLunSrView.h"
#import "YLDSPingLunModel.h"
#import "KMJRefresh.h"
#import "YLDSadvertisementModel.h"
#import "YLDSsupplyBaseCell.h"
#import "ZIKFunction.h"
#import "YLDStextAdCell.h"
#import "YLDSBigImageVadCell.h"
#import "ZIKMyShopViewController.h"
#import "YLDSADViewController.h"
#import "ChangyanSDK.h"
#import "YLDCommentRepliesViewController.h"
#import "YLDTADThreePicCell.h"
#import "YLDTLeftTextAdCell.h"
#import "YLDTMoreBigImageADCell.h"
@interface SellDetialViewController ()<UITableViewDataSource,UITableViewDelegate,SellBanderDelegate,MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate,UMSocialUIDelegate,fabiaoDelgate,YLDSPingLunCellDelgate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) UIButton *collectionBtn;
@property (nonatomic,strong)SupplyDetialMode *model;
@property (nonatomic,strong)NSArray *guseLikeAry;
@property (nonatomic,strong)HotSellModel *hotModel;
@property (nonatomic,strong)BigImageViewShowView *bigImageVShowV;
@property (nonatomic,strong)YLDSPingLunSrView *fabiaoV;
@property (nonatomic,strong)YLDSCommentAView *yldscommetnV;
@property (nonatomic,strong)NSMutableArray *pingluAry;
@property (nonatomic,assign)NSInteger commentNum;
@property (nonatomic,copy)NSString *topic_id;

//新增
//@property (nonatomic,strong ) NSMutableArray *miaomuzhiAry;
//@property (nonatomic        ) BOOL           isShow;
//@property (nonatomic,strong ) NSArray        *specAry;

@property (nonatomic, strong) NSString       *shareText; //分享文字
@property (nonatomic, strong) NSString       *shareTitle;//分享标题
@property (nonatomic, strong) UIImage        *shareImage;//分享图片
@property (nonatomic, strong) NSString       *shareUrl;  //分享url


@property (nonatomic, strong) NSString *memberUid;

@end

@implementation SellDetialViewController


-(id)initWithUid:(HotSellModel *)model
{
    self.hotModel=model;
    self=[super init];
    if (self) {
        
        [self getrefrchData];
}
    return self;
   
}

- (void)setType:(NSInteger)type {
    _type = type;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pingluAry = [NSMutableArray array];
    [self.view setBackgroundColor:BGColor];
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-50-50) style:UITableViewStyleGrouped];
    self.tableView=tableView;
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *navView=[self makeNavView];
    [self.view addSubview:navView];
    if (self.type == 2) {
        self.tableView.frame = CGRectMake(0, 44, kWidth, kHeight-50-44);
        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(kWidth*1/5, kHeight-50, kWidth*2.5/5, 1)];
        topLineView.backgroundColor = kLineColor;
        [self.view addSubview:topLineView];

        UIButton *shopBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, kHeight-50, kWidth*1/5, 50)];
        [shopBtn setBackgroundColor:kBlueShopColor];
        [shopBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [shopBtn setTitle:@"店铺" forState:UIControlStateNormal];
        [shopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        shopBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
        [shopBtn addTarget:self action:@selector(shopBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [shopBtn setImage:[UIImage imageNamed:@"1求购供应详情-店铺图标2"] forState:UIControlStateNormal];
        [self.view addSubview:shopBtn];

        UIButton *kefuBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth*1/5, kHeight-50, kWidth*4/5, 50)];
        [kefuBtn setBackgroundColor:[UIColor whiteColor]];
        [kefuBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [kefuBtn setTitle:@"专属客服" forState:UIControlStateNormal];
        [kefuBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
        kefuBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
        [kefuBtn setImage:[UIImage imageNamed:@"形状-6"] forState:UIControlStateNormal];

        [kefuBtn addTarget:self action:@selector(kefuBtnClcik) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:kefuBtn];

        return;
    }

        YLDSCommentAView *yldcommentAV=[[YLDSCommentAView alloc]initWithFrame:CGRectMake(0, kHeight-50-50, kWidth, 50)];
    self.yldscommetnV=yldcommentAV;
    [yldcommentAV.shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [yldcommentAV.collectBtn addTarget:self action:@selector(collectionBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.collectionBtn=yldcommentAV.collectBtn;
    [yldcommentAV.commentBtn addTarget:self action:@selector(commentBtnAction) forControlEvents:UIControlEventTouchUpInside];
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
    
    [ChangyanSDK loadTopic:@"" topicTitle:nil topicSourceID:self.hotModel.uid topicCategoryID:nil pageSize:@"30" hotSize:@"3" orderBy:nil style:@"indent" depth:nil subSize:nil completeBlock:^(CYStatusCode statusCode, NSString *responseStr)
     {
         if (statusCode==CYSuccess) {
             NSDictionary *dic=[ZIKFunction dictionaryWithJsonString:responseStr];
             weakSelf.topic_id=dic[@"topic_id"];
             self.yldscommetnV.commentNum=[dic[@"cmt_sum"] integerValue];
             APPDELEGATE.userModel.chanyanUser_id=[dic[@"user_id"] integerValue];
             [weakSelf.pingluAry removeAllObjects];
             [weakSelf.pingluAry addObjectsFromArray:[YLDSPingLunModel aryWithChangYanAry:dic[@"comments"]]];
             [weakSelf.tableView reloadData];
         }else{
             [ToastView showTopToast:responseStr];
         }
         
     }];


}
-(void)zanActionWith:(UIButton *)sender Uid:(YLDSPingLunModel *)model{
    if (![APPDELEGATE isNeedLogin]) {
        YLDLoginViewController *loginViewController=[[YLDLoginViewController alloc]init];
        [ToastView showTopToast:@"请先登录"];
        UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
        
        [self presentViewController:navVC animated:YES completion:^{
            
        }];;
        return;
    }
    [HTTPCLIENT gongqiucommentsZanWithUid:model.uid Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            sender.selected=YES;
            model.appreciateCount+=1;
            model.isAppreciate=1;
            [sender setTitle:[NSString stringWithFormat:@"%ld",model.appreciateCount] forState:UIControlStateNormal];
            [sender setTitle:[NSString stringWithFormat:@"%ld",model.appreciateCount] forState:UIControlStateSelected];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)commentBtnAction
{
    if (self.pingluAry.count>0) {
        NSIndexPath * dayOne = [NSIndexPath indexPathForRow:0 inSection:5];
        
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
-(void)fabiaoActionWithStr:(NSString *)comment
{
    __weak typeof(self) weakself=self;
    [ChangyanSDK submitComment:self.topic_id content:comment replyID:nil score:@"5" appType:40 picUrls:nil metadata:@"" completeBlock:^(CYStatusCode statusCode, NSString *responseStr) {
        weakself.commentNum=1;
        [weakself getcommentsWithPageNum:[NSString stringWithFormat:@"%ld",weakself.commentNum]];
        [weakself.fabiaoV clearAvtion];
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
            self.yldscommetnV.commentNum=[dic[@"cmt_sum"] integerValue];
        }
        
        [weakself.tableView footerEndRefreshing];
    }];

}
- (void)kefuBtnClcik {
    ZIKHeZuoMiaoQiKeFuViewController *kefuVC = [[ZIKHeZuoMiaoQiKeFuViewController alloc] initWithNibName:@"ZIKHeZuoMiaoQiKeFuViewController" bundle:nil];
    [self.navigationController pushViewController:kefuVC animated:YES];
}
- (void)shopBtnAction {
  
    if (_memberUid.length<=0) {
        [ToastView showTopToast:@"该店铺歇业中"];
        return;
    }
    ZIKMyShopViewController *shopVC = [[ZIKMyShopViewController alloc] init];
//    self.memberUid = dic[@"memberUid"];
    shopVC.memberUid = _memberUid;
    shopVC.type = 1;
    [self.navigationController pushViewController:shopVC animated:YES];

}
-(void)CallAction
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.model.memberPhone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
#pragma mark -- 短信留言
-(void)meaageAction
{
    [self showMessageView:[NSArray arrayWithObjects:self.model.memberPhone, nil] title:@"苗木供应" body:[NSString stringWithFormat:@"我对您在点花木APP发布的供应信息:%@ 很感兴趣",self.model.title]];
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
- (void)getrefrchData
{
    [HTTPCLIENT sellDetailWithUid:self.hotModel.uid WithAccessID:APPDELEGATE.userModel.access_id Success:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSDictionary *dic=[responseObject objectForKey:@"result"];
            SupplyDetialMode *model=[SupplyDetialMode creatSupplyDetialModelByDic:[dic objectForKey:@"detail"]];
            model.goldsupplier=[dic[@"goldsupplier"] integerValue];
            if (model.uid.length<=0) {
                [ToastView showTopToast:@"请刷新列表后重新进入该供应"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            model.commentCount=[dic[@"commentCount"] integerValue];
            self.memberUid = dic[@"memberUid"];
            if (self.type!=2) {
                if (self.memberUid.length>0) {
                    
                    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(kWidth*1/5, kHeight-50, kWidth*2/5, 1)];
                    topLineView.backgroundColor = kLineColor;
                    [self.view addSubview:topLineView];
                    
                    UIButton *shopBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, kHeight-50, kWidth*1/5, 50)];
                    [shopBtn setBackgroundColor:kBlueShopColor];
                    [shopBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
                    [shopBtn setTitle:@"店铺" forState:UIControlStateNormal];
                    [shopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    shopBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
                    [shopBtn addTarget:self action:@selector(shopBtnAction) forControlEvents:UIControlEventTouchUpInside];
                    [shopBtn setImage:[UIImage imageNamed:@"1求购供应详情-店铺图标2"] forState:UIControlStateNormal];
                    [self.view addSubview:shopBtn];
                    
                    UIButton *messageBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth*1/5, kHeight-50+1, kWidth*2/5, 50-1)];
                    [messageBtn setBackgroundColor:[UIColor whiteColor]];
                    [messageBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
                    [messageBtn setTitle:@"短信留言" forState:UIControlStateNormal];
                    [messageBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
                    messageBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
                    [messageBtn addTarget:self action:@selector(meaageAction) forControlEvents:UIControlEventTouchUpInside];
                    [messageBtn setImage:[UIImage imageNamed:@"shotMessageImage"] forState:UIControlStateNormal];
                    [self.view addSubview:messageBtn];
                    UIButton *phoneBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth*3/5, kHeight-50, kWidth*2/5, 50)];
                    [phoneBtn   .titleLabel setFont:[UIFont systemFontOfSize:15]];
                    [phoneBtn setTitle:@"联系供应商" forState:UIControlStateNormal];
                    [phoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    phoneBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
                    [phoneBtn setImage:[UIImage imageNamed:@"phoneImage"] forState:UIControlStateNormal];
                    [phoneBtn setBackgroundColor:NavColor];
                    [phoneBtn addTarget:self action:@selector(CallAction) forControlEvents:UIControlEventTouchUpInside];
                    [self.view addSubview:phoneBtn];
                    
                } else {
                    
                    UIButton *messageBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, kHeight-50+1, kWidth*0.5, 50-1)];
                    [messageBtn setBackgroundColor:[UIColor whiteColor]];
                    [messageBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
                    [messageBtn setTitle:@"短信留言" forState:UIControlStateNormal];
                    [messageBtn setTitleColor:detialLabColor forState:UIControlStateNormal];
                    messageBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
                    [messageBtn addTarget:self action:@selector(meaageAction) forControlEvents:UIControlEventTouchUpInside];
                    [messageBtn setImage:[UIImage imageNamed:@"shotMessageImage"] forState:UIControlStateNormal];
                    [self.view addSubview:messageBtn];
                    UIButton *phoneBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth*0.5, kHeight-50, kWidth*0.5, 50)];
                    [phoneBtn   .titleLabel setFont:[UIFont systemFontOfSize:15]];
                    [phoneBtn setTitle:@"联系供应商" forState:UIControlStateNormal];
                    [phoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    if (self.view.frame.size.width == 320) {
                        phoneBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 0);
                        phoneBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
                    } else {
                        phoneBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
                    }
                    [phoneBtn setImage:[UIImage imageNamed:@"phoneImage"] forState:UIControlStateNormal];
                    [phoneBtn setBackgroundColor:NavColor];
                    [phoneBtn addTarget:self action:@selector(CallAction) forControlEvents:UIControlEventTouchUpInside];
                    
                    [self.view addSubview:phoneBtn];
                    
                }

            }
            
//            self.yldscommetnV.commentNum=model.commentCount;
            self.model=model;
            BigImageViewShowView *bigImageVShowV=[[BigImageViewShowView  alloc]initWithImageAry:model.images];
            self.hotModel.title=model.title;
            self.bigImageVShowV=bigImageVShowV;
            [self.view addSubview:bigImageVShowV];
            
            if(model.collect)
            {
                self.collectionBtn.selected=YES;
            }
            NSArray *guseLikeAry=[HotSellModel hotSellAryByAry:[dic objectForKey:@"list"]];
            NSString *advertisementsStr=[dic objectForKey:@"advertisements"];
            NSDictionary *advertisementsDic=[ZIKFunction dictionaryWithJsonString:advertisementsStr];
            NSArray *adAry=[YLDSadvertisementModel aryWithAry:[advertisementsDic objectForKey:@"result"]];
            NSArray *dataAry=[ZIKFunction aryWithMessageAry:guseLikeAry withADAry:adAry andIndex:0];
            self.guseLikeAry= dataAry;
            [self.pingluAry addObjectsFromArray:[YLDSPingLunModel aryWithAry:dic[@"comments"]]];
            [self.tableView reloadData];
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
       return 365;
    }
    if (indexPath.section==1) {
        if (self.model.spec.count>0) {
             return self.model.spec.count*30+35;
        }
        else return 44;
       
    }
    if (indexPath.section==2) {
        return 130;
    }
    if (indexPath.section==3) {
        NSString *labelText=self.model.descriptions;

        if (labelText.length==0) {
            labelText=@"暂无";
        }
        return [self getHeightWithContent:labelText width:kWidth-40 font:13]+20;
    }
    if (indexPath.section==4) {
        id model=self.guseLikeAry[indexPath.row];
        if ([model isKindOfClass:[HotSellModel class]]) {
          return 190;
        }else if ([model isKindOfClass:[YLDSadvertisementModel class]])
        {
            YLDSadvertisementModel * model=self.guseLikeAry[indexPath.row];
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
        return 190;
    }
    if (indexPath.section==5) {
        self.tableView.rowHeight = UITableViewAutomaticDimension;//设置cell的高度为自动计算，只有才xib或者storyboard上自定义的cell才会生效，而且需要设置好约束
        self.tableView.estimatedRowHeight = 90;
        return tableView.rowHeight;
    }
    return 100;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==5)
    {
        return self.pingluAry.count;
    }
    if (section==4) {
        return self.guseLikeAry.count;
    }else
    {
    return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0.01;
    }
    if(section==4)
    {
        return 50;
    }else
    {
        return 30;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        UIView *view=[[UIView alloc]init];
        return view;
    }
    if (section==5) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 30)];
        [view setBackgroundColor:[UIColor whiteColor]];
        UIImageView *lineView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 14.5, kWidth, 0.5)];
        [lineView setBackgroundColor:kLineColor];
        [view addSubview:lineView];
        UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-25, 0, 50, 30)];
        [titleLab setTextColor:titleLabColor];
        [titleLab setBackgroundColor:[UIColor whiteColor]];
        [titleLab setTextAlignment:NSTextAlignmentCenter];
        [titleLab setFont:[UIFont systemFontOfSize:15]];
        [titleLab setText:@"评论"];
        [view addSubview:titleLab];
        return view;
    }
    if (section==4) {
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
    if (section==1) {
        messageLab.text=@"苗木信息";
    }else if (section==2){
        messageLab.text=@"其他信息";
    }else if (section==3){
        messageLab.text=@"产品描述";
    }
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.model) {
        if (indexPath.section==0) {
            SellBanderTableViewCell *cell=[[SellBanderTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, 365) andModel:self.model andHotSellModel:self.hotModel];
            cell.delegate=self;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (indexPath.section==1) {
            BuyOtherInfoTableViewCell *cell=[[BuyOtherInfoTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, self.model.spec.count*30+35) andName:self.model.productName];
            cell.ary=self.model.spec;
             cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.showBtn.hidden = YES;

            return cell;
        }
        if(indexPath.section==2)
        {
            SellQiyeInfoTableViewCell *cell = [[SellQiyeInfoTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, 30*4+10)];
            cell.model = self.model;
             cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
    if(indexPath.section==3)
    {
        
        NSString *labelText=self.model.descriptions;
        if (labelText.length==0) {
            labelText=@"暂无";
        }
        
        CGFloat height = [self getHeightWithContent:labelText width:kWidth-40 font:13];
        //NSLog(@"%f",height);
        UITableViewCell *cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, kWidth, height+20)];
        UILabel *cellLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, kWidth-40, height)];
        [cellLab setTextColor:titleLabColor];
        [cellLab setFont:[UIFont systemFontOfSize:13]];
        cellLab.numberOfLines=0;
        [cell addSubview:cellLab];
        [cellLab setText:labelText];
         cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    if (indexPath.section==4) {
        id model=self.guseLikeAry[indexPath.row];
        if ([model isKindOfClass:[HotSellModel class]]) {
            YLDSsupplyBaseCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDSsupplyBaseCell"];
            if (!cell) {
                cell=[YLDSsupplyBaseCell yldSsupplyBaseCell];
            }
            cell.model=self.guseLikeAry[indexPath.row];
            return cell;
        }else if ([model isKindOfClass:[YLDSadvertisementModel class]])
        {
            YLDSadvertisementModel* model=self.guseLikeAry[indexPath.row];
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
    if (indexPath.section==5) {
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
//图片点击效果
-(void)showBigImageWtihIndex:(NSInteger)index
{
    if (self.bigImageVShowV) {
      [self.bigImageVShowV showWithIndex:index];
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

-(UIView *)makeNavView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,0, kWidth, 64)];
    [view setBackgroundColor:NavSColor];
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(12, 26, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"backBtnBlack"] forState:UIControlStateNormal];
    [backBtn setEnlargeEdgeWithTop:15 right:60 bottom:10 left:10];
    [view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-80,26, 160, 30)];
    [titleLab setTextColor:NavTitleColor];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    [titleLab setText:@"供应详情"];
    [titleLab setFont:[UIFont systemFontOfSize:NavTitleSize]];
        [view addSubview:titleLab];
  
    return view;
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
            [HTTPCLIENT collectSupplyWithSupplyNuresyid:self.model.uid Success:^(id responseObject) {
                
                if ([[responseObject objectForKey:@"success"] integerValue]) {
                    [ToastView showTopToast:@"收藏成功"];
                    sender.selected=YES;
                    [HTTPCLIENT sellDetailWithUid:self.hotModel.uid WithAccessID:APPDELEGATE.userModel.access_id Success:^(id responseObject) {
                        //NSLog(@"供应详情：%@",responseObject);
                        if ([[responseObject objectForKey:@"success"] integerValue]) {
                            NSDictionary *dic=[responseObject objectForKey:@"result"];
                            SupplyDetialMode *model=[SupplyDetialMode creatSupplyDetialModelByDic:[dic objectForKey:@"detail"]];
                            self.model=model;
                            
                        }
                    } failure:^(NSError *error) {
                        
                    }];

                    return ;
                }
            } failure:^(NSError *error) {
                return ;
            }];
        }
    if (sender.selected) {
        
//        NSArray *ary=[NSArray arrayWithObject:self.model.collectUid];
        NSMutableString *keystr=[NSMutableString new];
        [keystr appendFormat:@"%@",self.model.collectUid];
        [HTTPCLIENT deletesenderCollectWithIds:keystr Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                sender.selected=NO;
                [ToastView showTopToast:@"取消收藏成功"];
                }
        } failure:^(NSError *error) {
            
        }];
    }
    //NSLog(@"collectionBtnAction");
}
-(void)backBtnAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSString *)jsonAnswerStrWithAry:(NSArray *)ary
{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:ary options:NSJSONWritingPrettyPrinted error:&parseError];
    
   NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return str;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==5){
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
    if (indexPath.section==4) {
        id model=self.guseLikeAry[indexPath.row];
        if ([model isKindOfClass:[HotSellModel class]]) {
            HotSellModel  *model=self.guseLikeAry[indexPath.row];
            
            SellDetialViewController *vc=[[SellDetialViewController alloc]initWithUid:model];
            [self.navigationController pushViewController:vc
                                                 animated:YES];
        }else if ([model isKindOfClass:[YLDSadvertisementModel class]])
        {
            YLDSadvertisementModel *model=self.guseLikeAry[indexPath.row];
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

- (void)shareBtnClick {
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

#pragma mark - 热门供应分享
- (void)requestShareData {
    ShowActionV();
    //CLog(@"hotuid:%@,  hotsupplyuid:%@  ,selfmodelsupplyuid:%@",self.hotModel.uid,self.hotModel.supplybuyUid,self.model.supplybuyUid)
    [HTTPCLIENT supplyShareWithUid:self.model.supplybuyUid nurseryUid:self.model.nurseryUid Success:^(id responseObject) {
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
        ShowActionV();
        [HTTPCLIENT supplybuyrRefreshWithUid:self.model.supplybuyUid Success:^(id responseObject) {
            RemoveActionV();
            if ([responseObject[@"success"] integerValue] == 0) {
                [ToastView showTopToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]]];
                return ;
            }
            [ToastView showTopToast:@"本条信息已刷新"];
            
        } failure:^(NSError *error) {
            RemoveActionV();
        }];

    }
    else {
        CLog(@"%@",response);
    }
}

-(void)didFinishShareInShakeView:(UMSocialResponseEntity *)response
{
    NSLog(@"finish share with response is %@",response);
}

@end
