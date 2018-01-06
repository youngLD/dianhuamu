//
//  YLDMyAccountViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/7/25.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDMyAccountViewController.h"
#import "ZIKMyBalanceViewController.h"
#import "YLDADAccountViewController.h"
#import "YLDMYAccountCell.h"
@interface YLDMyAccountViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation YLDMyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle =@"我的账户";
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view from its nib.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YLDMYAccountCell *cell=[YLDMYAccountCell yldMYAccountCell];
    if (indexPath.row==0) {
        [cell.imageV setImage:[UIImage imageNamed:@"gerenzhanghu"]];
        cell.titleLab.text=@"个人账户";
        cell.detialLab.text=@"查看个人账户详情";
    }else{
        [cell.imageV setImage:[UIImage imageNamed:@"guanggaozhanghu"]];
        cell.titleLab.text=@"广告账户";
        cell.detialLab.text=@"查看广告账户详情";
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        ZIKMyBalanceViewController *vc=[[ZIKMyBalanceViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        YLDADAccountViewController *vc=[[YLDADAccountViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
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
