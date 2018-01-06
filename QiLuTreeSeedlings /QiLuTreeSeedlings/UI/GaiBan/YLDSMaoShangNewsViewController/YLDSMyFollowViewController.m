//
//  YLDSMyFollowViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/4/11.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDSMyFollowViewController.h"
#import "HttpClient.h"
#import "YLDSMyFollowTableViewCell.h"
#import "KMJRefresh.h"
#import "YLDSAuthorModel.h"
#import "YLDAuthorDetialViewController.h"
@interface YLDSMyFollowViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray *dataAry;
@end

@implementation YLDSMyFollowViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView headerBeginRefreshing];;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"我的关注";
    self.dataAry=[NSMutableArray array];
    [self.view setBackgroundColor:BGColor];
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    tableView.delegate=self;
    tableView.dataSource=self;
    [tableView setBackgroundColor:BGColor];
    self.tableView=tableView;
    UIView *foodV = [[UIView alloc] init];
    [foodV setBackgroundColor:BGColor];
    tableView.tableFooterView = foodV;
    [self.view addSubview:tableView];
    tableView.separatorColor = kLineColor;
    tableView.separatorInset = UIEdgeInsetsMake(0,10, 0,10);        // 设置端距，tableViw表示separator离左边和右边均10像素
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    __weak typeof(self)weakself=self;
    
    [tableView addHeaderWithCallback:^{
        weakself.page=1;
        [weakself getFollowListWithPage:[NSString stringWithFormat:@"%ld",weakself.page]];
    }];
    [tableView addFooterWithCallback:^{
        weakself.page+=1;
        [weakself getFollowListWithPage:[NSString stringWithFormat:@"%ld",weakself.page]];
    }];
    
    // Do any additional setup after loading the view.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataAry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YLDSMyFollowTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDSMyFollowTableViewCell"];
    if (!cell) {
        cell=[YLDSMyFollowTableViewCell yldSMyFollowTableViewCell];
    }
    cell.model =self.dataAry[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YLDAuthorDetialViewController *vc=[YLDAuthorDetialViewController new];
    YLDSAuthorModel *model=self.dataAry[indexPath.row];
    vc.authorUid=model.uid;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)getFollowListWithPage:(NSString *)page
{
    ShowActionV();
    [HTTPCLIENT myFollowListWithPage:page WithPageSize:nil WithKeyWord:nil Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            if (self.page==1) {
                [self.dataAry removeAllObjects];
            }
            NSArray *aryss=[responseObject objectForKey:@"result"];
            if (aryss.count==0) {
                if (self.page==1) {
                    [ToastView showTopToast:@"您还没有任何关注"];
                }else{
                    [ToastView showTopToast:@"暂无更多信息"];
                }
                [self.tableView footerEndRefreshing];
                [self.tableView headerEndRefreshing];
            }else{
               [self.dataAry addObjectsFromArray:[YLDSAuthorModel modelWithAry:aryss]];
                
                [self.tableView reloadData];
                [self.tableView footerEndRefreshing];
                [self.tableView headerEndRefreshing];
                
            }
        }else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            [self.tableView footerEndRefreshing];
            [self.tableView headerEndRefreshing];
        }
    
    } failure:^(NSError *error) {
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
    }];
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
