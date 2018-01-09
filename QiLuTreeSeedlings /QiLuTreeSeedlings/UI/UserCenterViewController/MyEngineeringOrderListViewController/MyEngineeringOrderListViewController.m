//
//  MyEngineeringOrderListViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/9.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "MyEngineeringOrderListViewController.h"
#import "YLDFEOrderModel.h"
#import "YLDEngineeringOrderTableViewCell.h"
@interface MyEngineeringOrderListViewController ()<UITableViewDelegate,UITableViewDataSource,YLDEngineeringOrderTableViewCellDelegate>
@property (nonatomic,strong)NSMutableArray *dataAry;
@property (nonatomic,copy)NSString *lastTime;
@end

@implementation MyEngineeringOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"我的订单";
    if (@available(iOS 11.0, *)) {
        self.topC.constant=44.f;
    }
    self.dataAry=[NSMutableArray array];
    [self getdataList];
    // Do any additional setup after loading the view from its nib.
}
-(void)getdataList
{
    [HTTPCLIENT myGongChengDingDanWithLastTime:nil Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            if (_lastTime==nil) {
                [self.dataAry removeAllObjects];
            }
            NSArray *data=[responseObject objectForKey:@"data"];
            NSArray *modelAry=[YLDFEOrderModel creatModeByAry:data];
            if (modelAry.count==0) {
                [ToastView showTopToast:@"已无更多数据"];
            }else{
                [self.dataAry addObjectsFromArray:modelAry];
                
            }
            [self.tableView reloadData];
//            se
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataAry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.rowHeight = UITableViewAutomaticDimension;//设置cell的高度为自动计算，只有才xib或者storyboard上自定义的cell才会生效，而且需要设置好约束
    tableView.estimatedRowHeight = 185;
    return tableView.rowHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YLDEngineeringOrderTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLDEngineeringOrderTableViewCell"];
    if (!cell) {
        cell=[YLDEngineeringOrderTableViewCell yldEngineeringOrderTableViewCell];
        cell.delegate=self;
    }
    cell.model=self.dataAry[indexPath.row];
    return cell;
}
-(void)cellOpenBtnActionWithCell:(YLDEngineeringOrderTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationLeft];
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
