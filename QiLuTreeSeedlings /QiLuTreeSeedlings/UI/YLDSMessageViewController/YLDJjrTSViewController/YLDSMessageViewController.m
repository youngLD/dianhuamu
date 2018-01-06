//
//  YLDSMessageViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/2/14.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDSMessageViewController.h"
#import "YLDSMessageCell.h"
#import "UIDefines.h"
#import "YLDChatBaseTabBarController.h"
#import "YLDLoginViewController.h"
#import "UINavController.h"
#import "MyMessageViewController.h"
#import "ZIKMyCustomizedInfoViewController.h"
#import "HttpClient.h"
#import "ZIKFunction.h"
#import "EMConversation.h"
#import "YLDSMiaoShangNewsViewController.h"
#import "YLDJjrTSViewController.h"
@interface YLDSMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSDictionary *dic;
@property (nonatomic) BOOL isShow;
@end

@implementation YLDSMessageViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([APPDELEGATE isNeedLogin]) {
        NSInteger miaoshangquanNum=[APPDELEGATE setupUnreadMessageCount];
     
      
    }else
    {
        if(_isShow==NO)
        {
            _isShow=YES;
            YLDLoginViewController *loginViewController=[[YLDLoginViewController alloc]init];
            [ToastView showTopToast:@"请先登录"];
            UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
            
            [self presentViewController:navVC animated:YES completion:^{
                
            }];
        }
        self.dic=nil;
        [self.tableView reloadData];
        
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BGColor];
    UIView *topVV=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    [topVV setBackgroundColor:NavSColor];
    UILabel *titLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-100, 32, 200, 20)];
    [titLab setFont:[UIFont systemFontOfSize:NavTitleSize]];
    [titLab setTextColor:NavTitleColor];
    [titLab setTextAlignment:NSTextAlignmentCenter];
    [titLab setText:@"消息"];
    [topVV addSubview:titLab];
    [self.view addSubview:topVV];
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-44)];
    self.tableView=tableView;
    tableView.dataSource=self;
    tableView.delegate=self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    UIView *fview = [UIView new];
    fview.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:fview];
    [self.view addSubview:tableView];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushMessageForDingzhiXinXi:) name:@"dingzhixinxituisong" object:nil];
    // Do any additional setup after loading the view.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YLDSMessageCell *cell=[YLDSMessageCell yldSMessageCell];
    NSString *detial=nil;
    NSString *time=nil;
    NSInteger unread=0;
    if (indexPath.row==0) {
        NSDictionary *dic=self.dic[@"LastSystemMessage"];
        if (dic) {
            detial=dic[@"message"];
            NSString *timeStr=dic[@"pushTimeStr"];
            if (timeStr.length>0) {
                time =[ZIKFunction compareCurrentTime:[ZIKFunction getDateFromString:timeStr]];
                unread=[self.dic[@"SystemMessageCount"] integerValue];
            }
        }
    }
    if (indexPath.row==1) {
        NSArray *newsAry=self.dic[@"LastArticles"];
        NSDictionary *dic=[newsAry firstObject];
        if (dic) {
            detial=dic[@"title"];
        }
        
    }
    if (indexPath.row==2) {
        NSDictionary *dic=self.dic[@"LastCustomMessage"];
        if (dic) {
            detial=dic[@"message"];
            NSInteger timeStr=[dic[@"sendTime"] integerValue];
            if (timeStr>0) {
                NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeStr/ 1000.0];
                time =[ZIKFunction compareCurrentTime:date];
            }
            
        
        unread=[self.dic[@"CustomCount"] integerValue];
        }
        
    }
    
    if (indexPath.row==3) {
        unread=[APPDELEGATE setupUnreadMessageCount];
    }
    if (indexPath.row==4) {
        NSDictionary *dic=self.dic[@"LastBrokerMessage"];
        if (dic) {
            detial=dic[@"message"];
            NSInteger timeStr=[dic[@"sendTime"] integerValue];
            if (timeStr>0) {
                NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeStr/ 1000.0];
                time =[ZIKFunction compareCurrentTime:date];
            }
        }
        unread=[self.dic[@"BrokerCount"] integerValue];
    }
    switch (indexPath.row) { 
        case 0:
            
            [cell setimage:@"消息页_系统消息" title:@"系统信息" detial:detial time:time unRead:unread];
            break;
        case 1:
            [cell setimage:@"消息页_苗商头条" title:@"苗商头条" detial:detial time:@"" unRead:0];
            break;
        case 2:
            [cell    setimage:@"消息页_定制消息" title:@"定制信息" detial:detial time:time unRead:unread];
            break;
        case 3:
            [cell setimage:@"消息页_苗商圈" title:@"求购推送" detial:@"多人在线聊天与客服直接沟通" time:@"" unRead:unread];
            break;
        case 4:
            [cell setimage:@"消息-经纪人专属消息" title:@"经纪人专属消息" detial:detial time:time unRead:unread];
            break;
        default:
            break;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![APPDELEGATE isNeedLogin]) {
        YLDLoginViewController *loginViewController=[[YLDLoginViewController alloc]init];
        [ToastView showTopToast:@"请先登录"];
        UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
        
        [self presentViewController:navVC animated:YES completion:^{
            
        }];
        return;
    }
   
    if (indexPath.row==0) {
        MyMessageViewController *myMessageVieController=[[MyMessageViewController alloc]init];
        myMessageVieController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:myMessageVieController animated:YES];
    }
    if (indexPath.row==1) {
        YLDSMiaoShangNewsViewController *newsVC=[[YLDSMiaoShangNewsViewController alloc]init];
        newsVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:newsVC animated:YES];
    }
    if (indexPath.row==2) {
        ZIKMyCustomizedInfoViewController *customInfoVC = [[ZIKMyCustomizedInfoViewController alloc] init];
        customInfoVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:customInfoVC animated:YES];
    }
    if (indexPath.row==3) {
        if (APPDELEGATE.userModel.goldsupplierStatus == 0 || APPDELEGATE.userModel.goldsupplierStatus == 7) {
            [ToastView showTopToast:@"普通用户或工程公司无法使用求购信息功能!"];
            return;
        }
        YLDChatBaseTabBarController *yldGroupList=[[YLDChatBaseTabBarController alloc]init];
        yldGroupList.hidesBottomBarWhenPushed=YES;
        
        [self.navigationController pushViewController:yldGroupList animated:YES];
    }
    if (indexPath.row==4) {
        if (APPDELEGATE.userModel.goldsupplierStatus==11) {
            YLDJjrTSViewController *yldGroupList=[[YLDJjrTSViewController alloc]init];
            yldGroupList.hidesBottomBarWhenPushed=YES;
            
            [self.navigationController pushViewController:yldGroupList animated:YES];
        }else{
            [ToastView showTopToast:@"经纪人专属功能"];
        }
}
}
-(void)pushMessageForDingzhiXinXi:(NSNotification *)notification
{
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    self.tabBarController.selectedIndex=2;
     
    ZIKMyCustomizedInfoViewController *zikMyCustomInfoVC=[[ZIKMyCustomizedInfoViewController alloc]init];
    if ([notification.object isEqualToString:@"1"]) {
        zikMyCustomInfoVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:zikMyCustomInfoVC animated:YES];
    }else if([notification.object isEqualToString:@"2"])
    {
        ZIKMyCustomizedInfoViewController *civc = [[ZIKMyCustomizedInfoViewController alloc] init];
        civc.infoType = InfoTypeStation;
        civc.hidesBottomBarWhenPushed=YES;
        //        civc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:civc animated:YES];
    }
    if([notification.object isEqualToString:@"3"])
    {
        MyMessageViewController *civc = [[MyMessageViewController alloc] init];
        civc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:civc animated:YES];
    }
    if([notification.object isEqualToString:@"4"])
    {
        YLDJjrTSViewController *yldGroupList=[[YLDJjrTSViewController alloc]init];
        yldGroupList.hidesBottomBarWhenPushed=YES;
        
        [self.navigationController pushViewController:yldGroupList animated:YES];
    }
   

    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
