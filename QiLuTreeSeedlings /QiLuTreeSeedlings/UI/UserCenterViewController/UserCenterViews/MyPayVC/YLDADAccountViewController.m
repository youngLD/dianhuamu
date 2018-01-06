//
//  YLDADAccountViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/7/26.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDADAccountViewController.h"
#import "ZIKPayViewController.h"
#import "YLDADChongZhiMXViewController.h"
#import "YLDADKouFeiMXViewController.h"
#import "YLDADClickActionListViewController.h"
#import "YLDADACYuECell.h"
#import "YLDADnomelCell.h"
#import "YKDTADTuifeiViewController.h"
#import "YLDJJRSHZViewController.h"
@interface YLDADAccountViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,assign) CGFloat yue;
@property (nonatomic,assign) CGFloat zengsong;
@property (nonatomic,assign) NSInteger refund_state;
@end

@implementation YLDADAccountViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    HttpClient *hh = [HttpClient sharedADClient];
    [HTTPADCLIENT adYueEWithUid:APPDELEGATE.userModel.access_id Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            self.refund_state=[[responseObject  objectForKey:@"refund_state"] integerValue];
            if (self.refund_state==0) {
               self.yue=[[responseObject  objectForKey:@"charge_balance"] floatValue];
               self.zengsong=[[responseObject  objectForKey:@"giving_balance"] floatValue];
            }else{
               self.yue=[[responseObject  objectForKey:@"refund_charge_money"] floatValue];
               self.zengsong=[[responseObject  objectForKey:@"refund_giving_money"] floatValue];
            }
            
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"广告账户";
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view from its nib.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1) {
        return 3;
    }else
    {
        return 1; 
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 225;
    }else{
        return 60;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        YLDADACYuECell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDADACYuECell"];
        if(!cell)
        {
            cell=[YLDADACYuECell yldADACYuECell];
            
            [cell.chongzhiBtn addTarget:self action:@selector(chongzhiAction) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.yuELab.text=[NSString stringWithFormat:@"%.2lf",self.yue];
        cell.zensongLab.text=[NSString stringWithFormat:@"%.2lf",self.zengsong];
        if (_refund_state!=0) {
            [cell.yuELab setTextColor:kRGB(187, 187, 187, 1)];
            [cell.zensongLab setTextColor:kRGB(187, 187, 187, 1)];
        }
        
        return cell;
    }else if (indexPath.section==1){
        
            YLDADnomelCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDADnomelCell"];
            if (!cell) {
                cell=[YLDADnomelCell yldADnomelCell];
            }
            if (indexPath.row==0) {
                [cell.imageV setImage:[UIImage imageNamed:@"adchongzhijilu"]];
                cell.titleLab.text=@"充值记录";
            }
        if (indexPath.row==1) {
            [cell.imageV setImage:[UIImage imageNamed:@"koufeijilu"]];
            cell.titleLab.text=@"扣费记录";
        }
        if (indexPath.row==2) {
            [cell.imageV setImage:[UIImage imageNamed:@"addianjijilu"]];
            cell.titleLab.text=@"广告点击记录";
        }
            return cell;
        
        
    }else
    {
        YLDADnomelCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDADnomelCell"];
        if (!cell) {
            cell=[YLDADnomelCell yldADnomelCell];
        }
        if (indexPath.row==0) {
            [cell.imageV setImage:[UIImage imageNamed:@"tuifei"]];
            cell.titleLab.text=@"退费";
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            YLDADChongZhiMXViewController *vc=[YLDADChongZhiMXViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row==1) {
            YLDADKouFeiMXViewController *vc=[YLDADKouFeiMXViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row==2) {
            YLDADClickActionListViewController *vc=[YLDADClickActionListViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (indexPath.section==2) {
        if (self.refund_state==0) {
            if (self.yue>0) {
                YKDTADTuifeiViewController *vc=[YKDTADTuifeiViewController new];
                vc.pirce=self.yue;
                vc.zensong=self.zengsong;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [ToastView showTopToast:@"暂无可退余额"];
            }
        }else
        {
            YLDJJRSHZViewController *vc=[YLDJJRSHZViewController new];
            vc.type=1;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        }
}
-(void)chongzhiAction
{
    ZIKPayViewController *payVC  = [[ZIKPayViewController alloc] init];
    payVC.type=7;
    [self.navigationController pushViewController:payVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1||section==2) {
        return 10;
    }else{
        return 0.01;
    }
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
