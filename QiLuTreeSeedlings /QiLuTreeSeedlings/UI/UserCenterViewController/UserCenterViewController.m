//
//  UserCenterViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/1/28.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "UserCenterViewController.h"
#import "CompanyViewController.h"
#import "UserBigInfoTableViewCell.h"
#import "UIDefines.h"
#import "UserInfoNomerTableViewCell.h"
#import "HttpClient.h"
#import "MyCollectViewController.h"
#import "YLDLoginViewController.h"
#import "MyNuseryListViewController.h"
#import "UINavController.h"
#import "YLDMyBuyListViewController.h"

#import "ZIKUserInfoSetViewController.h"
#import "MyIntegralViewController.h"

#import "ZIKMyCustomizedInfoViewController.h"
#import "SettingViewController.h"
#import "UserBigInfoView.h"
//友盟分享
#import "UMSocialControllerService.h"
#import "UMSocial.h"
//end 友盟分享
#import "BaseTabBarController.h"
#import "ZIKStationAgentViewController.h"//站长通
#import "ZIKMySupplyVC.h"//我的供应列表
#import "ZIKPurchaseRecordsViewController.h"//购买记录
#import "MyMessageViewController.h"
#import "YLDFKeFuViewController.h"
#import "YLDShengJiViewViewController.h"
#import "YLDGCGSZiZhiTiJiaoViewController.h"
#import "ZIKMyShopViewController.h"//我的店铺
#import "ZIKStationTabBarViewController.h"//站长助手
#import "YLDGongChengGongSiViewController.h"//工程助手
#import "LYDGCGSTiShiViewController.h"
#import "ZIKHelpfulHintsViewController.h"
#import "YLDShopMessageViewController.h"//我的店铺第二版
//环信
#import "ChatViewController.h"
#import "UserProfileManager.h"
#import "YLDGroupListViewController.h"
//#import "YLDMessageCenterViewController.h"
#import "MyMessageViewController.h"
#import "YLDChatBaseTabBarController.h"
#import "ZIKCustomizedInfoListViewController.h"
#import "YLDSLianHeShangChengViewController.h"
#import "YLDJJRenShenQing1ViewController.h"
#import "YLDJJRSHZViewController.h"
#import "ZIKVoucherCenterViewController.h"
#import "YLDJJRMyViewController.h"
#import "YLDJJRNotPassViewController.h"
#import "YLDMyAccountViewController.h"
@interface UserCenterViewController ()<UITableViewDataSource,UITableViewDelegate,UserBigInfoViewDelegate,UMSocialUIDelegate>
@property (nonatomic,strong)UserBigInfoView *userBigInfoV;
@property (nonatomic,strong)UIView *logoutView;
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic, strong) NSString       *shareText; //分享文字
@property (nonatomic, strong) NSString       *shareTitle;//分享标题
@property (nonatomic, strong) UIImage        *shareImage;//分享图片
@property (nonatomic, strong) NSString       *shareUrl;  //分享url

@end

@implementation UserCenterViewController
-(void)dealloc
{
       [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   
    self.userBigInfoV.model=APPDELEGATE.userModel;
    [self.tableView reloadData];
    [APPDELEGATE reloadUserInfoSuccess:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"success"]integerValue]) {
            [self.tableView reloadData];
            self.userBigInfoV.model=APPDELEGATE.userModel;
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showTabBar" object:nil];
}

-(void)pushMessageForDingzhiXinXi:(NSNotification *)notification
{
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    
}
-(void)pushMessageForSaoMa:(NSNotification *)object
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushMessageForSaoMa:) name:@"saosaokanxinwen" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushMessageForDingzhiXinXi:) name:@"dingzhixinxituisong" object:nil];
    // Do any additional setup after loading the view.
    UserBigInfoView *userbigInfoV=[[UserBigInfoView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 180)];
    userbigInfoV.userDelegate=self;
    
    [self.view addSubview:userbigInfoV];
    self.userBigInfoV=userbigInfoV;
    [userbigInfoV.setingBtn addTarget:self action:@selector(setBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationController.navigationBarHidden=YES;
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fabuBtnAction) name:@"fabuBtnAction" object:nil];
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 180, kWidth, kHeight-224) style:UITableViewStyleGrouped];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView setBackgroundColor:BGColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    if ([APPDELEGATE isNeedLogin]) {
        self.userBigInfoV.model=APPDELEGATE.userModel;
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0||section==3||section==4||section==5||section==6) {
        return 1;
    }
    if (section==1) {
        return 4;
    }
    if(section==2)
    {

        return 2;

    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 80;
    }
      return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0.01;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==6) {
        return 70;
    }
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view;
    if (section==6) {
        
        view=[[UIView alloc]init];
        UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(40, 10, kWidth-80, 44)];
        [view addSubview:backView];
        [backView setBackgroundColor:NavColor];
       
        UIImageView *iamgeV=[[UIImageView alloc]initWithFrame:CGRectMake(backView.frame.size.width/2-60, 10, 24, 24)];
        iamgeV.image=[UIImage imageNamed:@"loginoutimage"];
        [backView addSubview:iamgeV];
        UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(backView.frame.size.width/2-20, 0, 100, 44)];
        [titleLab setText:@"退出登录"];
        self.logoutView=backView;
        [backView addSubview:titleLab];
        [titleLab setTextColor:[UIColor whiteColor]];
        UIButton *lgoutBtn=[[UIButton alloc]initWithFrame:backView.bounds];
        if ([APPDELEGATE isNeedLogin]) {
            backView.hidden=NO;
        }else{
            backView.hidden=YES;
        }
        [lgoutBtn addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:lgoutBtn];
    }
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        UserBigInfoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[UserBigInfoTableViewCell IDstr]];

        if (!cell) {
            cell=[[UserBigInfoTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, 80)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.collectBtn addTarget:self action:@selector(mycollectBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.interBtn addTarget:self action:@selector(myJifenBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.messageBtn addTarget:self action:@selector(myMessageBtnAciotn) forControlEvents:UIControlEventTouchUpInside];
            [cell.shengJiBtn addTarget:self action:@selector(shengjiBtnAction) forControlEvents:UIControlEventTouchUpInside];
        }

        if (APPDELEGATE.userModel.name) {
            cell.model=APPDELEGATE.userModel;
        }
       
        return cell;
    }
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            UserInfoNomerTableViewCell *cell=[[UserInfoNomerTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) andImageName:@"mySellImageV" andTitle:@"我的供应"];
            UILabel *shareLabel = [[UILabel alloc] init];
            shareLabel.frame = CGRectMake(Width-35-180, 12, 180, 20);
            shareLabel.text = @"供应信息可分享到微信、QQ";
            shareLabel.font = [UIFont systemFontOfSize:12.0f];
            shareLabel.textColor = detialLabColor;
            shareLabel.textAlignment = NSTextAlignmentRight;
            [cell addSubview:shareLabel];
            return cell;

        }
        if (indexPath.row==1) {
            UserInfoNomerTableViewCell *cell=[[UserInfoNomerTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) andImageName:@"myBuyV" andTitle:@"我的求购"];
            return cell;
        }
        if (indexPath.row==2) {
            UserInfoNomerTableViewCell *cell=[[UserInfoNomerTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) andImageName:@"myReadMessage" andTitle:@"信息定制"];
            return cell;
        }
        if (indexPath.row == 3) {
            UserInfoNomerTableViewCell *cell = [[UserInfoNomerTableViewCell alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) andImageName:@"个人中心_购买信息" andTitle:@"购买信息"];
            return cell;
        }
    }
    if (indexPath.section==2) {
       
        if (indexPath.row==0) {
            UserInfoNomerTableViewCell *cell=[[UserInfoNomerTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) andImageName:@"个人中心_我的企业" andTitle:@"我的企业"];
            return cell;
        }
        if (indexPath.row==1) {
            UserInfoNomerTableViewCell *cell=[[UserInfoNomerTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) andImageName:@"个人中心_我的苗圃" andTitle:@"我的苗圃"];
            return cell;
        }
     
    }
    if (indexPath.section==3) {
        if (indexPath.row==0) {
            UserInfoNomerTableViewCell *cell=[[UserInfoNomerTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) andImageName:@"myPalyInfo" andTitle:@"我的帐户"];
            UILabel *priceLabel = [[UILabel alloc] init];
            priceLabel.frame = CGRectMake(Width-35-180, 12, 180, 20);
            if (APPDELEGATE.userModel.balance) {
                priceLabel.text = [NSString stringWithFormat:@"账户余额:¥%.2f",APPDELEGATE.userModel.balance.floatValue+APPDELEGATE.userModel.creditMargin];
            }
            priceLabel.font = [UIFont systemFontOfSize:12.0f];
            priceLabel.textColor = detialLabColor;
            priceLabel.textAlignment = NSTextAlignmentRight;
            [cell addSubview:priceLabel];
            return cell;
        }
        
    }
    
    
    if (indexPath.section==4 ) {
        if (indexPath.row==0) {
            UserInfoNomerTableViewCell *cell=[[UserInfoNomerTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) andImageName:@"myShareImage" andTitle:@"我的分享"];
            return cell;
        }
    }
    if (indexPath.section==5) {
        if (indexPath.row==0) {
            UserInfoNomerTableViewCell *cell=[[UserInfoNomerTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) andImageName:@"kefuxitong" andTitle:@"客服系统"];
            return cell;
        }
        if (indexPath.row==1) {
            UserInfoNomerTableViewCell *cell=[[UserInfoNomerTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) andImageName:@"kefuxitong" andTitle:@"苗信圈"];
            return cell;
        }
    }
    if (indexPath.section==6) {
        if (indexPath.row==0) {
            UserInfoNomerTableViewCell *cell=[[UserInfoNomerTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) andImageName:@"lianheshangcheng" andTitle:@"联合商城"];
            return cell;
        }
    }
    UITableViewCell *cell=[UITableViewCell new];
    return cell;
}

-(void)fabuBtnAction
{
  
    if (self.tabBarController.selectedIndex==0) {
        return;
    }
    if([APPDELEGATE isNeedLogin]==NO)
    {
        
        YLDLoginViewController *loginViewController=[[YLDLoginViewController alloc]init];
        [ToastView showTopToast:@"请先登录"];
        UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
        
        [self presentViewController:navVC animated:YES completion:^{
            
        }];
        
        return;
    }
    
//    FaBuViewController *fbVC=[[FaBuViewController alloc]init];
//    fbVC.hidesBottomBarWhenPushed=YES;
//    [self.navigationController pushViewController:fbVC animated:YES];
}

#pragma mark - 设置
- (void)setBtnAction {
    SettingViewController *setVC =  [[SettingViewController alloc] init];
    setVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:setVC animated:YES];
}

#pragma mark - 我的设置
-(void)clickedHeadImage
{
    if (![APPDELEGATE isNeedLogin]) {
        YLDLoginViewController *loginViewController=[[YLDLoginViewController alloc]init];
         [ToastView showTopToast:@"请先登录"];
        UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
        
        [self presentViewController:navVC animated:YES completion:^{
            
        }];
        return;
    }
    ZIKUserInfoSetViewController *setVC = [[ZIKUserInfoSetViewController alloc] init];
    setVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:setVC animated:YES];
}

#pragma mark-我的收藏
-(void)mycollectBtnAction
{
    if (![APPDELEGATE isNeedLogin]) {
        YLDLoginViewController *loginViewController=[[YLDLoginViewController alloc]init];
         [ToastView showTopToast:@"请先登录"];
        UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
        
        [self presentViewController:navVC animated:YES completion:^{
            
        }];

        return;
    }
    MyCollectViewController *myCollectVC=[MyCollectViewController new];
    myCollectVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:myCollectVC animated:YES];
}
#pragma mark-我的店铺
-(void)myMessageBtnAciotn
{
    if (![APPDELEGATE isNeedLogin]) {
        YLDLoginViewController *loginViewController=[[YLDLoginViewController alloc]init];
        [ToastView showTopToast:@"请先登录"];
        UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
        
        [self presentViewController:navVC animated:YES completion:^{
            
        }];
        return;
    }
    YLDShopMessageViewController *myShopMessageVieController=[[YLDShopMessageViewController alloc]init];
    myShopMessageVieController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:myShopMessageVieController animated:YES];
}
#pragma mark-苗商圈
-(void)myJifenBtnAction
{
    if (![APPDELEGATE isNeedLogin]) {
        YLDLoginViewController *loginViewController=[[YLDLoginViewController alloc]init];
        [ToastView showTopToast:@"请先登录"];
        UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
        
        [self presentViewController:navVC animated:YES completion:^{
            
        }];
        return;
    }

    MyIntegralViewController *yldIntList=[[MyIntegralViewController alloc]init];
    yldIntList.hidesBottomBarWhenPushed=YES;

    [self.navigationController pushViewController:yldIntList animated:YES];
}
#pragma mark-退出登录
-(void)logoutAction
{
//   [HTTPCLIENT logoutInfoByToken:APPDELEGATE.userModel.access_token byAccessId:APPDELEGATE.userModel.access_id Success:^(id responseObject) {
//       
//       if ([[responseObject objectForKey:@"success"] integerValue]) {
//          
//           self.logoutView.hidden=NO;
//           [APPDELEGATE logoutAction];
//           self.userBigInfoV.model=APPDELEGATE.userModel;
//           [self.tableView reloadData];
//            
//       }else{
//           [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
//       }
//   } failure:^(NSError *error) {
//       
//   }];
    
}
-(void)hiddingSelfTabBar
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"HidenTabBar" object:nil];
}
#pragma mark-身份升级
-(void)shengjiBtnAction
{
    if (![APPDELEGATE isNeedLogin]) {
        YLDLoginViewController *loginViewController=[[YLDLoginViewController alloc]init];
        [ToastView showTopToast:@"请先登录"];
        UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
        
        [self presentViewController:navVC animated:YES completion:^{
            
        }];
        return;
    }
    if (APPDELEGATE.userModel.goldsupplierStatus==11) {
        YLDJJRMyViewController *vc=[YLDJJRMyViewController new];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (APPDELEGATE.userModel.goldsupplierStatus!=0) {
        [ToastView showTopToast:@"您已具备身份，不需升级"];
        return;
    }else{
        ShowActionV();
      [HTTPCLIENT jjrshenheStatueSuccess:^(id responseObject) {
          if ([[responseObject objectForKey:@"success"] integerValue]) {
              NSDictionary  *result=[responseObject objectForKey:@"result"];
              NSInteger xx=[[result objectForKey:@"status"] integerValue];
              if (xx==-1) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      
                      YLDJJRenShenQing1ViewController *vc=[YLDJJRenShenQing1ViewController new];
                      vc.hidesBottomBarWhenPushed=YES;
                      vc.type=xx;
                      [self.navigationController pushViewController:vc animated:YES];
                  });
              }
              
              if (xx==-2) {
//                  NSString *uid=[result objectForKey:@"uid"];
                  dispatch_async(dispatch_get_main_queue(), ^{
                      dispatch_async(dispatch_get_main_queue(), ^{
                          YLDJJRenShenQing1ViewController *vc=[YLDJJRenShenQing1ViewController new];
                          vc.hidesBottomBarWhenPushed=YES;
                          vc.type=xx;
                          [self.navigationController pushViewController:vc animated:YES];
                          
                      });
                      
                  });
              }
              if (xx==0) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      
                      YLDJJRSHZViewController *vc=[YLDJJRSHZViewController new];
                      vc.hidesBottomBarWhenPushed=YES;
                      [self.navigationController pushViewController:vc animated:YES];
                  });
              }
              if (xx==1){
                  dispatch_async(dispatch_get_main_queue(), ^{
                      
                      YLDJJRMyViewController *vc=[YLDJJRMyViewController new];
                      vc.hidesBottomBarWhenPushed=YES;
                      [self.navigationController pushViewController:vc animated:YES];
                  });
              }
              if (xx==2) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      
                      YLDJJRNotPassViewController *vc=[[YLDJJRNotPassViewController alloc]init];
                      vc.hidesBottomBarWhenPushed=YES;
                      NSString *msg=[result objectForKey:@"msg"];
                      vc.wareStr=msg;
                      [self.navigationController pushViewController:vc animated:YES];
                  });
              }
              if (xx==3) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      
                      YLDJJRenShenQing1ViewController *vc=[YLDJJRenShenQing1ViewController new];
                      vc.hidesBottomBarWhenPushed=YES;
                      vc.type=-xx;
                      [self.navigationController pushViewController:vc animated:YES];
                  });
              }
          }
      } failure:^(NSError *error) {
          
      }];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
      if (indexPath.section==5) {
          if (indexPath.row==0) {
            YLDFKeFuViewController *kefuViewC=[[YLDFKeFuViewController alloc]init];
            
            kefuViewC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:kefuViewC animated:YES];
            
            return;
          }
          
      }
    if (indexPath.section==6) {
        if (indexPath.row==0) {
            YLDSLianHeShangChengViewController *viccc=[YLDSLianHeShangChengViewController new];
            viccc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:viccc animated:YES];
            return;
        }
        
    }

    if (![APPDELEGATE isNeedLogin]) {
        YLDLoginViewController *loginViewController=[[YLDLoginViewController alloc]init];
        [ToastView showTopToast:@"请先登录"];
        UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
        
        [self presentViewController:navVC animated:YES completion:^{
            
        }];
        return;
    }
    if (indexPath.section==2) {
      
        if (indexPath.row==0) {
            //NSLog(@"企业信息");
            
            CompanyViewController *companyVC=[[CompanyViewController alloc]init];
            companyVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:companyVC animated:YES];
            return;
        }
        if (indexPath.row==1) {
            
            MyNuseryListViewController *nuserListVC=[[MyNuseryListViewController alloc]init];
            nuserListVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:nuserListVC animated:YES];
            return;
        }
       
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
            ZIKMySupplyVC *mySupplyVC = [[ZIKMySupplyVC alloc] init];
            mySupplyVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:mySupplyVC animated:YES];
        }
        if (indexPath.row==1) {
            
            //我的求购
            YLDMyBuyListViewController *myBuyListVC=[[YLDMyBuyListViewController alloc]init];
            myBuyListVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:myBuyListVC animated:YES];
            return ;
        }
        if (indexPath.row == 2) {

            ZIKCustomizedInfoListViewController *listVC = [[ZIKCustomizedInfoListViewController alloc] init];
            listVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:listVC animated:YES];
            return;
        }
        if (indexPath.row == 3) {
            //购买记录
            ZIKPurchaseRecordsViewController *prvc = [[ZIKPurchaseRecordsViewController alloc] init];
            prvc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:prvc animated:YES];
            return;
        }

    }
    else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            
            YLDMyAccountViewController *balanceVC = [[YLDMyAccountViewController alloc] init];
            balanceVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:balanceVC animated:YES];
        }
    }
    else if (indexPath.section == 4) {
        //[self umengShare];
        ShowActionV();
        [HTTPCLIENT getMyShareSuccess:^(id responseObject) {
            if ([responseObject[@"success"] integerValue] == 0) {
                RemoveActionV();
                [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]] withOriginY:kWidth/2 withSuperView:self.view];
                return ;
            }
            NSDictionary *shareDic = responseObject[@"result"];
            self.shareText   = shareDic[@"description"];
            self.shareTitle  = shareDic[@"title"];
            NSString *urlStr = shareDic[@"pic"];
            NSData * data    = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlStr]];
            self.shareImage  = [[UIImage alloc] initWithData:data];
            self.shareUrl    = shareDic[@"url"];
            RemoveActionV();
            [self umengShare];

        } failure:^(NSError *error) {
            RemoveActionV();
        }];
    }
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
