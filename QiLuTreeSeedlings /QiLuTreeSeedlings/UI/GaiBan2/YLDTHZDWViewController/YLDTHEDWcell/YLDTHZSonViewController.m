//
//  YLDTHZSonViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/9/16.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDTHZSonViewController.h"
#import "YLDSADViewController.h"
#import "YLDTHEDWModel.h"
#import "YLDTHYDWCell.h"
#import "KMJRefresh.h"
@interface YLDTHZSonViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,copy)NSString *lastTime;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataAry;
@property (nonatomic,assign)NSInteger page;
@end

@implementation YLDTHZSonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.vcTitle=@"会员单位";
    
    self.dataAry=[NSMutableArray array];
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64) style:UITableViewStylePlain];
    _tableView=tableView;
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    [ZIKFunction setExtraCellLineHidden:tableView];
    self.page=1;
    __weak typeof(self)  weakSelf=self;
    [weakSelf.tableView addHeaderWithCallback:^{
        weakSelf.page=1;
        [weakSelf reloadWithPage:[NSString stringWithFormat:@"%ld",weakSelf.page]];
    }];
    [weakSelf.tableView addFooterWithCallback:^{
        weakSelf.page+=1;
        [weakSelf reloadWithPage:[NSString stringWithFormat:@"%ld",weakSelf.page]];
    }];
    [self.tableView headerBeginRefreshing];
    // Do any additional setup after loading the view.
}
-(void)reloadWithPage:(NSString *)page
{
    if ([page isEqualToString:@"1"]) {
        _lastTime=nil;
    }
    ShowActionV();
    [HTTPCLIENT huiyuanDanweiWithPageSize:@"15" WithlastTime:_lastTime WithentType:nil WithparentUid:_uid Success:^(id responseObject) {
        if([[responseObject objectForKey:@"success"] integerValue])
        {
            NSDictionary *result=[responseObject objectForKey:@"result"];
            if ([page isEqualToString:@"1"]) {
                [self.dataAry removeAllObjects];
            }
            NSArray *ary=[result objectForKey:@"excellentEnterprises"];
            if (ary.count==0) {
                if([page isEqualToString:@"1"])
                {
                    [ToastView showTopToast:@"暂无数据"];
                }else
                {
                    [ToastView showTopToast:@"暂无更多数据"];
                }
                
            }else{
                NSArray *Ary=[YLDTHEDWModel creatByAry:ary];
                [self.dataAry addObjectsFromArray:Ary];
                [self.tableView reloadData];
                _lastTime=result[@"lastTime"];
            }
            
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
        RemoveActionV();
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    } failure:^(NSError *error) {
        RemoveActionV();
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataAry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableView.rowHeight = UITableViewAutomaticDimension;//设置cell的高度为自动计算，只有才xib或者storyboard上自定义的cell才会生效，而且需要设置好约束
    self.tableView.estimatedRowHeight = 70;
    return tableView.rowHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YLDTHYDWCell *cell=[YLDTHYDWCell yldTHYDWCell];
    cell.model=_dataAry[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
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
