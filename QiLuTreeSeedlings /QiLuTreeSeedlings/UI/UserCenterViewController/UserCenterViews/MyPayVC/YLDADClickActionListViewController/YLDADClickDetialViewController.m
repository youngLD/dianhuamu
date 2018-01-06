//
//  YLDADClickDetialViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/7/28.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDADClickDetialViewController.h"
#import "YLDADCDetialCell.h"
#import "YLDADCDetialNCell.h"
#import "KMJRefresh.h"
#import "UIImageView+AFNetworking.h"
#import "ZIKMyShopViewController.h"
@interface YLDADClickDetialViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *dataAry;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,assign)NSInteger allNum;
@property (nonatomic,assign)NSInteger todayNum;
@end

@implementation YLDADClickDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"广告点击记录";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.page=1;
    self.dataAry=[NSMutableArray array];
    __weak typeof(self) weakself=self;
    [self.tableView addHeaderWithCallback:^{
        weakself.page=1;
        [weakself getDataAryWithPage:[NSString stringWithFormat:@"%ld",weakself.page]];
    }];
    [self.tableView addFooterWithCallback:^{
        weakself.page+=1;
        [weakself getDataAryWithPage:[NSString stringWithFormat:@"%ld",weakself.page]];
    }];
    [self.tableView headerBeginRefreshing];
    // Do any additional setup after loading the view from its nib.
}
-(void)getDataAryWithPage:(NSString *)page
{  ShowActionV();

    [HTTPADCLIENT adClickListWithUid:self.uid WithStart:nil WithEnd:nil WithPage_size:@"15" WithPage_index:page Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            self.allNum=[[responseObject objectForKey:@"click_count_totoal"] integerValue];
            self.todayNum=[[responseObject objectForKey:@"click_count_today"] integerValue];
            if ([page isEqualToString:@"1"]) {
                [self.dataAry removeAllObjects];
            }
            NSArray *ary=[responseObject objectForKey:@"result"];
            if (ary.count==0) {
                if ([page isEqualToString:@"1"]) {
                    [ToastView showTopToast:@"暂无点击记录"];
                }else{
                    [ToastView showTopToast:@"暂无更多点击记录"];
                }
            }else{
                [self.dataAry addObjectsFromArray:ary];
            }
            [self.tableView reloadData];
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
        RemoveActionV();
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
    } failure:^(NSError *error) {
        RemoveActionV();
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else{
        return self.dataAry.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        YLDADCDetialCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDADCDetialCell"];
        if (!cell) {
            cell=[YLDADCDetialCell yldADCDetialCell];
            [cell.imageVV setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage imageNamed:@"MoRentuLong"]];
        }
        cell.allClickNumLab.text=[NSString stringWithFormat:@"总点击量：%ld",self.allNum];
        cell.tadayClickNumLab.text=[NSString stringWithFormat:@"今日点击量：%ld",self.todayNum];
        return cell;
    }else{
        YLDADCDetialNCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDADCDetialNCell"];
        if (!cell) {
            cell=[YLDADCDetialNCell yldADCDetialNCell];
        }
        NSDictionary *dic=self.dataAry[indexPath.row];
        NSString *headUrl=dic[@"browse_user_head_url"];
        if (headUrl.length>0) {
           [cell.imageVV setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"qiugouxiangqingye.png"]];
        }else{
            [cell.imageVV setImage:[UIImage imageNamed:@"qiugouxiangqingye.png"]];
        }
        NSString *account_name=dic[@"account_name"];
        cell.titleLab.text=account_name;
       NSDate *timeDate =  [ZIKFunction getDateFromString:dic[@"time_handel"]];
       cell.timeLab.text = [ZIKFunction compareCurrentTime:timeDate];
        cell.detialLab.text=[NSString stringWithFormat:@"点击了广告“%@”",dic[@"advertisement_name"]];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return kWidth*0.36667+30;
    }else{
       return 60; 
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1) {
        ZIKMyShopViewController *shopVC = [[ZIKMyShopViewController alloc] init];
        
        NSDictionary *dic=self.dataAry[indexPath.row];
        shopVC.memberUid = dic[@"member_uid"];
        shopVC.type = 1;
        [self.navigationController pushViewController:shopVC animated:YES];
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
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
