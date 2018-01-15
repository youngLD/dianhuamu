//
//  YLDFUserCenterViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/12/9.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDFUserCenterViewController.h"
#import "UIDefines.h"
#import "YLFUCuserInfoTableViewCell.h"
#import "YLDFUCSUpplyOrBuyInfoTableViewCell.h"
#import "YLDFUCOtherInfoTableViewCell.h"
//地址管理
#import "YLDFAddressListViewController.h"
#import "YLDLoginViewController.h"
#import "UINavController.h"
#import "YLDFabuSuccessViewController.h"
#import "YLDFSupplyFabuViewController.h"
#import "YLDFBuyFBViewController.h"
#import "YLDFabuSuccessViewController.h"
#import "YLDFUserGCTableViewCell.h"

#import "GetCityDao.h"
#import "YLDFabuSuccessViewController.h"
#import "YLDFUserNormalInfoViewController.h"
#import "YLDFMySupplyListViewController.h"
#import "YLDFBuyListViewController.h"
#import "YLDFRealNameViewController.h"
#import "YLDFSFRZListViewController.h"
#import "YLDFRealNameViewController.h"
#import "YLDFQiYeRenZhengViewController.h"
#import "YLDFUserSettingViewController.h"
#import "YLDFQiYeInfoViewController.h"
#import "YLDFRZzhongViewController.h"
#import "YLDFRealNameInfoViewController.h"
#import "YLDFKeFuViewController.h"
#import "YLDFEOrderFaBuOneViewController.h"
#import "MyEngineeringOrderListViewController.h"
#import "YLDJJRMyViewController.h"
#import "YLDJJRNotPassViewController.h"
#import "YLDFMyQuoteListViewController.h"
@interface YLDFUserCenterViewController ()<UITableViewDelegate,UITableViewDataSource,supplyFabuDelegate,buyFabuDelegate,YLDFabuSuccessDelegate,YLDJJRNotPassViewControllerDelegate>

@end

@implementation YLDFUserCenterViewController
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [APPDELEGATE reloadUserInfoSuccess:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"success"]integerValue]) {
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];

         }
        
    } failure:^(NSError *error) {
        
    }];
    
 
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    UIView *foodView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 50)];
    [foodView setBackgroundColor:BGColor];
    self.tableView.tableFooterView=foodView;
    self.tableView.bounces=NO;
    
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.edgesForExtendedLayout = UIRectEdgeNone;
                // Fallback on earlier versions
        }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logoutSuccess) name:@"logoutSuccess" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fabuSuccessWithOrderId:) name:@"GCDDFB" object:nil];
    // Do any additional setup after loading the view from its nib.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0)
    {
      return  118/375.f*kWidth+80;
    }
    if(indexPath.row==1)
    {
        return 180;
    }
    if(indexPath.row==2)
    {
        if ([APPDELEGATE.userModel.roles containsObject:@"broker"]||[APPDELEGATE.userModel.roles containsObject:@"engineering_company"]) {
            return 130;
        }else{
            return 0.01;
        }
        
    }
    if(indexPath.row==3)
    {
        return 180;
    }
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0)
    {
        YLFUCuserInfoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLFUCuserInfoTableViewCell"];
        if (!cell) {
            cell=[YLFUCuserInfoTableViewCell yldFUCuserInfoTableViewCell];
            [cell.userInfoBtn addTarget:self action:@selector(cell1ActionWithBtn:) forControlEvents:UIControlEventTouchUpInside];
            [cell.companyInfoBtn addTarget:self action:@selector(cell1ActionWithBtn:) forControlEvents:UIControlEventTouchUpInside];
            [cell.shopBtn addTarget:self action:@selector(cell1ActionWithBtn:) forControlEvents:UIControlEventTouchUpInside];
            [cell.addressBtn addTarget:self action:@selector(cell1ActionWithBtn:) forControlEvents:UIControlEventTouchUpInside];
            [cell.setBtn addTarget:self action:@selector(setBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.loginAndUserInfoBtn addTarget:self action:@selector(loginAndUserInfoBtnAction) forControlEvents:UIControlEventTouchUpInside];
        }
        [cell reloadselfInfo];
        return cell;
    }
    if(indexPath.row==1)
    {
        YLDFUCSUpplyOrBuyInfoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDFUCSUpplyOrBuyInfoTableViewCell"];
        if (!cell) {
            cell=[YLDFUCSUpplyOrBuyInfoTableViewCell yldFUCSUpplyOrBuyInfoTableViewCell];
            [cell.fabuSupplyBtn addTarget:self action:@selector(fabusupplyBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.fabuBuyBtn addTarget:self action:@selector(fabuBuyBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.mySupplyBtn addTarget:self action:@selector(mySupplyListAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.myBuyBtn addTarget:self action:@selector(myBuyLsitAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.myBaojiaBtn addTarget:self action:@selector(myQuoqeListBtnAction) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }
    if(indexPath.row==2)
    {
        if ([APPDELEGATE.userModel.roles containsObject:@"broker"]||[APPDELEGATE.userModel.roles containsObject:@"engineering_company"]) {
            YLDFUserGCTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDFUserGCTableViewCell"];
            if (!cell) {
                cell=[YLDFUserGCTableViewCell yldFUserGCTableViewCell];
                [cell.wodedingdanBtn addTarget:self action:@selector(privilegeCellClickAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell.fabuDingdanBtn addTarget:self action:@selector(privilegeCellClickAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell.jingrenZLBtn addTarget:self action:@selector(privilegeCellClickAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            [cell cellReoldAction];
            return cell;
        }
        
    }
    if(indexPath.row==3)
    {
        YLDFUCOtherInfoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDFUCOtherInfoTableViewCell"];
        if (!cell) {
            cell=[YLDFUCOtherInfoTableViewCell yldFUCOtherInfoTableViewCell];
            [cell.helpBtn addTarget:self action:@selector(otherCellClickAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.biaoshiRZBtn addTarget:self action:@selector(otherCellClickAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.myCollectBtn addTarget:self action:@selector(otherCellClickAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.biaoshiRZBtn addTarget:self action:@selector(otherCellClickAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.myPayListBtn addTarget:self action:@selector(otherCellClickAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.shenfenRZBtn addTarget:self action:@selector(otherCellClickAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.myPingLunBtn addTarget:self action:@selector(otherCellClickAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }
    UITableViewCell *cell=[UITableViewCell new];
    return cell;
}
#pragma mark -cell1点击Action
-(void)cell1ActionWithBtn:(UIButton *)sender
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
    if (sender.tag==11) {
        if ([APPDELEGATE.userModel.roles containsObject:@"users"]) {
//            [ToastView showTopToast:@"审核通过"];
            YLDFRealNameInfoViewController *vc=[YLDFRealNameInfoViewController new];
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [HTTPCLIENT getRealNameStateSuccess:^(id responseObject) {
                if ([[responseObject objectForKey:@"success"] integerValue]) {
                  
                    NSDictionary *data=[responseObject objectForKey:@"data"];
                    NSString *status=data[@"status"];

                    if ([status isEqualToString:@"not_apply"]||[status isEqualToString:@"expired"]) {
                        YLDFRealNameViewController *vc=[YLDFRealNameViewController new];
                        vc.hidesBottomBarWhenPushed=YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    if ([status isEqualToString:@"audited"]||[status isEqualToString:@"submission"]) {
//                        [ToastView showTopToast:@"您的实名认证正在审核中，请耐心等待"];
                        YLDFRZzhongViewController *vc=[YLDFRZzhongViewController new];
                        vc.titleNameStr=@"实名";
                        vc.hidesBottomBarWhenPushed=YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    if ([status isEqualToString:@"normal"]) {
                        //                        [ToastView showTopToast:@"您的实名认证正在审核中，请耐心等待"];
                        YLDFRealNameInfoViewController *vc=[YLDFRealNameInfoViewController new];
                        vc.hidesBottomBarWhenPushed=YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    if ([status isEqualToString:@"fail"]) {
                        YLDJJRNotPassViewController * vc=[YLDJJRNotPassViewController new];
                        vc.hidesBottomBarWhenPushed=YES;
//                        [ToastView showTopToast:@"您的实名认证已被退回，请重新编辑"];
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
    }
    if(sender.tag==12)
    {
        if ([APPDELEGATE.userModel.roles containsObject:@"enterprise"]) {
            YLDFQiYeInfoViewController *vc=[YLDFQiYeInfoViewController new];
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [HTTPCLIENT getEnterpriseStateSuccess:^(id responseObject) {
                if ([[responseObject objectForKey:@"success"] integerValue]) {
                    
                    NSDictionary *data=[responseObject objectForKey:@"data"];
                    NSString *status=data[@"status"];
                    
                    if ([status isEqualToString:@"not_apply"]||[status isEqualToString:@"expired"]) {
                        YLDFQiYeRenZhengViewController * vc=[YLDFQiYeRenZhengViewController new];
                        vc.hidesBottomBarWhenPushed=YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    if ([status isEqualToString:@"audited"]||[status isEqualToString:@"submission"]) {
//                        [ToastView showTopToast:@"您的企业认证正在审核中，请耐心等待"];
                        YLDFRZzhongViewController *vc=[YLDFRZzhongViewController new];
                        vc.titleNameStr=@"企业";
                        vc.hidesBottomBarWhenPushed=YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    if ([status isEqualToString:@"normal"]) {
                        YLDFQiYeInfoViewController *vc=[YLDFQiYeInfoViewController new];
                        vc.hidesBottomBarWhenPushed=YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    if ([status isEqualToString:@"fail"]) {
                        

                  
                        YLDJJRNotPassViewController * vc=[YLDJJRNotPassViewController new];
                        vc.hidesBottomBarWhenPushed=YES;
            
                        vc.wareStr=@"企业";
                        vc.delegate=self;
                        vc.dic=[responseObject objectForKey:@"data"];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    
                }else{
                    
                }
            } failure:^(NSError *error) {
                
            }];
        }
        
    }
    if (sender.tag==14) {
        YLDFAddressListViewController *vc=[YLDFAddressListViewController new];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)shenheweitongguoChongxintijiaoDic:(NSDictionary *)dic WithwareStr:(NSString *)wareStr
{
    if ([wareStr isEqualToString:@"实名"]) {
         YLDFRealNameViewController* vc=[YLDFRealNameViewController new];
        vc.hidesBottomBarWhenPushed=YES;
//        [ToastView showTopToast:@"您的实名认证已被退回，请重新编辑"];
      
        vc.dic=dic;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([wareStr isEqualToString:@"企业"]) {
        YLDFQiYeRenZhengViewController * vc=[YLDFQiYeRenZhengViewController new];
        vc.hidesBottomBarWhenPushed=YES;
//        [ToastView showTopToast:@"您的企业认证已被退回，请重新编辑"];
        vc.dic=dic;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark -特权功能资料点击Action
-(void)privilegeCellClickAction:(UIButton *)sender
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
    if (sender.tag==11) {
        MyEngineeringOrderListViewController *vc=[MyEngineeringOrderListViewController new];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (sender.tag==12) {
        YLDFEOrderFaBuOneViewController *vc=[YLDFEOrderFaBuOneViewController new];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (sender.tag==13) {
        YLDJJRMyViewController *vc=[YLDJJRMyViewController new];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark -其它资料点击Action
-(void)otherCellClickAction:(UIButton *)sender
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
    if (sender.tag==4) {
        YLDFSFRZListViewController *vc=[YLDFSFRZListViewController new];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if(sender.tag==6)
    {
        YLDFKeFuViewController *vc=[[YLDFKeFuViewController alloc]init];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)setBtnAction
{
    YLDFUserSettingViewController *vc=[YLDFUserSettingViewController new];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)loginAndUserInfoBtnAction
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
    YLDFUserNormalInfoViewController *vc=[YLDFUserNormalInfoViewController new];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)fabuBuyBtnAction
{
    YLDFBuyFBViewController *vc=[YLDFBuyFBViewController new];
    vc.hidesBottomBarWhenPushed=YES;
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)fabuSuccessWithbuyId:(NSDictionary *)buydic
{
    YLDFabuSuccessViewController *vc=[YLDFabuSuccessViewController new];
    vc.hidesBottomBarWhenPushed=YES;
    vc.buyDic=buydic;
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)fabuSuccessWithOrderId:(NSNotification *)obj
{
    NSDictionary *orderDic = obj.object;
    YLDFabuSuccessViewController *vc=[YLDFabuSuccessViewController new];
    vc.hidesBottomBarWhenPushed=YES;
    vc.orderDic=orderDic;
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)fabusupplyBtnAction
{
    YLDFSupplyFabuViewController *vc=[YLDFSupplyFabuViewController new];
    vc.delegate=self;
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)fabuSuccessWithSupplyId:(NSDictionary *)supplydic
{
    YLDFabuSuccessViewController *vc=[YLDFabuSuccessViewController new];
    vc.hidesBottomBarWhenPushed=YES;
    vc.supplyDic=supplydic;
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)mySupplyListAction
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
    YLDFMySupplyListViewController *vc=[YLDFMySupplyListViewController new];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)myBuyLsitAction
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
    YLDFBuyListViewController *vc=[YLDFBuyListViewController new];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)YLfabuSuccessWithBuyDic:(NSDictionary *)buyDic
{
    
}
-(void)YLfabuSuccessWithSupplyDic:(NSDictionary *)supplydic
{
    
}
-(void)YLfabuSuccessWithContinueType:(NSInteger)type{
    if (type==1) {
        [self fabusupplyBtnAction];
    }else if (type==2)
    {
        [self fabuBuyBtnAction];
    }else if (type==3)
    {
        YLDFEOrderFaBuOneViewController *vc=[YLDFEOrderFaBuOneViewController new];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)YLfabuSuccessWithAdministrationType:(NSInteger)type{
    if (type==1) {
        [self mySupplyListAction];
    }else if (type==2)
    {
        [self myBuyLsitAction];
    }else if (type==3)
    {
        YLDJJRMyViewController *vc=[YLDJJRMyViewController new];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)myQuoqeListBtnAction
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
    YLDFMyQuoteListViewController *vc=[YLDFMyQuoteListViewController new];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)logoutSuccess
{
    [self.tableView reloadData];
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
