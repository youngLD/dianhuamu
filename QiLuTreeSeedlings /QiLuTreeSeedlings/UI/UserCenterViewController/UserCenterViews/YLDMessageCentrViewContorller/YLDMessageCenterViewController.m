//
//  YLDMessageCenterViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/12/17.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDMessageCenterViewController.h"
#import "MessageCenterTableViewCell.h"
#import "MyMessageViewController.h"
#import "YLDChatBaseTabBarController.h"
@interface YLDMessageCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation YLDMessageCenterViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBar.hidden==NO) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    [self.tableView reloadData];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    self.tableView=tableView;
    self.vcTitle=@"我的消息";
    [self.view addSubview:tableView];
    // Do any additional setup after loading the view.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageCenterTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MessageCenterTableViewCell"];
    if (!cell) {
        cell=[MessageCenterTableViewCell messageCenterTableViewCell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if(indexPath.section==0)
    {
        cell.imageV.image=[UIImage imageNamed:@"tongzhixiaoxi"];
        cell.titleLab.text=@"通知消息";
        NSInteger nrMc=[APPDELEGATE.userModel.nrMessageCount integerValue];
        cell.numbLab.text=[NSString stringWithFormat:@"%ld",nrMc];
        if (nrMc == 0) {
            cell.numbLab.hidden=YES;
        }else{
           cell.numbLab.hidden=NO;
        }
    }
    if(indexPath.section==1)
    {
        cell.imageV.image=[UIImage imageNamed:@"miaoshangquan"];
        cell.titleLab.text=@"求购信息";
        NSInteger nrMc=[APPDELEGATE setupUnreadMessageCount];
        cell.numbLab.text=[NSString stringWithFormat:@"%ld",nrMc];
        if (nrMc == 0) {
            cell.numbLab.hidden=YES;
        }else{
            cell.numbLab.hidden=NO;
        }
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        MyMessageViewController *mymessageVC=[[MyMessageViewController alloc]init];
        [self.navigationController pushViewController:mymessageVC animated:YES];
    }
    if (indexPath.section==1) {
        if (APPDELEGATE.userModel.goldsupplierStatus == 0 || APPDELEGATE.userModel.goldsupplierStatus == 0) {
            [ToastView showTopToast:@"普通用户或工程公司无法使用苗商圈功能!"];
            return;
        }

        
        YLDChatBaseTabBarController *yldGroupList=[[YLDChatBaseTabBarController alloc]init];

        [self.navigationController pushViewController:yldGroupList animated:YES];

    }
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
