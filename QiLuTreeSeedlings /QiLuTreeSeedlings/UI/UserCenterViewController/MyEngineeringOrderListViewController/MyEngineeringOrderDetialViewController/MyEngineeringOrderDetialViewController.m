//
//  MyEngineeringOrderDetialViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/10.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "MyEngineeringOrderDetialViewController.h"
#import "YLDFMyEorderDetialInfoTableViewCell.h"
#import "YLDFMyEOrderItemsTableViewCell.h"
#import "YLDFEOrderModel.h"
#import "YLDFMyOrderItemsModel.h"
#import "YLDFEOrderQuoteListViewController.h"
@interface MyEngineeringOrderDetialViewController ()<UITableViewDelegate,UITableViewDataSource,YLDFMyEOrderItemsTableViewCellDelegate>
@property (nonatomic,strong)NSMutableArray *itemsAry;
@property (nonatomic,strong)YLDFEOrderModel *model;
@end

@implementation MyEngineeringOrderDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle = @"订单详情";
    if (@available(iOS 11.0, *)) {
        self.topC.constant=44.f;
    }
    self.itemsAry=[NSMutableArray array];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [HTTPCLIENT MyGongChengDingDanDetialWithorderId:self.orderId Success:^(id responseObject) {
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
        tableView.estimatedRowHeight = 150;
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
        YLDFMyEOrderItemsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDFMyEOrderItemsTableViewCell"];
        if (!cell) {
            cell=[YLDFMyEOrderItemsTableViewCell yldFMyEOrderItemsTableViewCell];
            cell.delegate=self;
        }
        cell.model=self.itemsAry[indexPath.row];
        cell.numLab.text= [NSString stringWithFormat:@"%ld",indexPath.row+1];
        return cell;
    }
}
-(void)itemCloseActionWithModel:(YLDFMyOrderItemsModel *)model{
    __weak typeof(self) weakSelf=self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"关闭苗木" message:@"您确定要关闭该苗木，关闭后无法被其他用户查看或报价。" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ShowActionV();
//        NSMutableString *idstr;
        [HTTPCLIENT MyGongChengDingDanItemCloseWithitemId:model.engineeringProcurementItemId WithorderId:weakSelf.model.engineeringProcurementId Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
//                [weakSelf.itemsAry removeObject:model];
                [ToastView showTopToast:@"关闭成功"];
                model.closed=1;
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
                [weakSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
       
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)itemLookUpActionWithModel:(YLDFMyOrderItemsModel *)model
{
    YLDFEOrderQuoteListViewController *vc=[YLDFEOrderQuoteListViewController new];
    vc.model=model;
    vc.orderStr=self.model.engineeringProcurementId;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return;
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
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
