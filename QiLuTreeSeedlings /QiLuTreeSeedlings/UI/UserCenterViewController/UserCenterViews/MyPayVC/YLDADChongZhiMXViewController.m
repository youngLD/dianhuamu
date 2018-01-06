//
//  YLDADChongZhiMXViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/7/27.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDADChongZhiMXViewController.h"
#import "YLDADMXCell.h"
#import "KMJRefresh.h"
@interface YLDADChongZhiMXViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *dataAry;
@property (nonatomic,assign)NSInteger page;
@end

@implementation YLDADChongZhiMXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"充值记录";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.dataAry=[NSMutableArray array];
    self.page=1;
    __weak typeof(self)weakSelf=self;
    [ZIKFunction setExtraCellLineHidden:self.tableView];
    [self.tableView addHeaderWithCallback:^{
        weakSelf.page=1;
        [weakSelf dataWithPage:[NSString stringWithFormat:@"%ld",weakSelf.page]];
    }];
    [self.tableView addFooterWithCallback:^{
        weakSelf.page+=1;
        [weakSelf dataWithPage:[NSString stringWithFormat:@"%ld",weakSelf.page]];
    }];
    [self.tableView headerBeginRefreshing];
    // Do any additional setup after loading the view from its nib.
}
-(void)dataWithPage:(NSString *)page
{
    ShowActionV();
//    HttpClient *hh = [HttpClient sharedADClient];
    [HTTPADCLIENT adChongZhiJiLuWithUid:APPDELEGATE.userModel.access_id WithStart:nil WithEnd:nil WithPage_size:@"15" WithPage_index:page Success:^(id responseObject) {
        RemoveActionV();
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            if ([page isEqualToString:@"1"]) {
                [self.dataAry removeAllObjects];
            }
            NSArray *ary=[responseObject objectForKey:@"result"];
            if (ary.count==0) {
                if ([page isEqualToString:@"1"]) {
                    [ToastView showTopToast:@"暂无充值记录"];
                }else{
                    [ToastView showTopToast:@"暂无更多充值记录"];

                }
            }else{
                [self.dataAry addObjectsFromArray:ary];
                [self.tableView reloadData];
            }
            
        }else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
    } failure:^(NSError *error) {
        RemoveActionV();
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataAry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YLDADMXCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDADMXCell"];
    if (!cell) {
        cell=[YLDADMXCell yldADMXCell];
    }
    NSDictionary *dic=self.dataAry[indexPath.row];
    [cell.timeLab setText:dic[@"time_handel"]];
    cell.icon.image = [UIImage imageNamed:@"消费记录-充值"];
    NSInteger record_type=[dic[@"record_type"] integerValue];
    if (record_type ==-1) {
        cell.numLab.text =[NSString stringWithFormat:@"¥:-%@",dic[@"charge_money"]];
    }else{
       cell.numLab.text =[NSString stringWithFormat:@"¥:+%@",dic[@"charge_money"]];
    }
    
    cell.titleLab.text =dic[@"charge_note"];
    cell.timeLab.text =dic[@"timehandel"];
    return cell;
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
