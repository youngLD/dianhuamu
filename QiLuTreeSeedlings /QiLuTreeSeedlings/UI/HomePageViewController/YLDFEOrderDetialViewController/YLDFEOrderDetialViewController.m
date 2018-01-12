//
//  YLDFEOrderDetialViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/12.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFEOrderDetialViewController.h"
#import "YLDFMyEorderDetialInfoTableViewCell.h"
#import "YLDFEOrderModel.h"
#import "YLDFEOrderTableViewCell.h"
@interface YLDFEOrderDetialViewController ()<UITableViewDelegate,UITableViewDataSource,YLDFEOrderTableViewCellDelegate>
@property (nonatomic,strong)NSMutableArray *itemsAry;
@property (nonatomic,strong)YLDFEOrderModel *model;
@end

@implementation YLDFEOrderDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle = @"订单详情";
    if (@available(iOS 11.0, *)) {
        self.topC.constant=44.f;
    }
    self.itemsAry=[NSMutableArray array];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [HTTPCLIENT getEOrderDetialWithEngineeringProcurementId:self.orderId Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSDictionary *data=[responseObject objectForKey:@"data"];
            self.model=[YLDFEOrderModel creatModeByDic:data];
            NSArray *itemsAry=data[@"items"];
            NSArray *modelAry=[YLDFMyOrderItemsModel creatModelByAry:itemsAry];
            [self.itemsAry addObjectsFromArray:modelAry];
            
            [self.tableView reloadData];
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
    // Do any additional setup after loading the view from its nib.
}
-(void)itemBaojiaActionWithModel:(YLDFMyOrderItemsModel *)model
{
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else{
        return self.itemsAry.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        tableView.rowHeight = UITableViewAutomaticDimension;//设置cell的高度为自动计算，只有才xib或者storyboard上自定义的cell才会生效，而且需要设置好约束
        tableView.estimatedRowHeight = 187;
        return tableView.rowHeight;
    }else{
        tableView.rowHeight = UITableViewAutomaticDimension;//设置cell的高度为自动计算，只有才xib或者storyboard上自定义的cell才会生效，而且需要设置好约束
        tableView.estimatedRowHeight = 70;
        return tableView.rowHeight;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        YLDFMyEorderDetialInfoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDFMyEorderDetialInfoTableViewCell"];
        if (!cell) {
            cell=[YLDFMyEorderDetialInfoTableViewCell yldFMyEorderDetialInfoTableViewCell];
        }
        if (self.model) {
            cell.model=self.model;
        }
        
        return cell;
        
    }else{
        YLDFEOrderTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDFEOrderTableViewCell"];
        if (!cell) {
            cell=[YLDFEOrderTableViewCell yldFEOrderTableViewCell];
            cell.delegate=self;
        }
        cell.model=self.itemsAry[indexPath.row];
        cell.numLab.text= [NSString stringWithFormat:@"%ld",indexPath.row+1];
        return cell;
    }
    UITableViewCell *cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    return cell;
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 0.1)];
    [view setBackgroundColor:kRGB(240, 240, 240, 1)];
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 0.1)];
    [view setBackgroundColor:kRGB(240, 240, 240, 1)];
    return view;
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
