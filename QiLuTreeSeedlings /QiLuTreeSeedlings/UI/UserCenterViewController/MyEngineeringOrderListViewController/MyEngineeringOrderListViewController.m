//
//  MyEngineeringOrderListViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/9.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "MyEngineeringOrderListViewController.h"
#import "YLDFEOrderModel.h"
@interface MyEngineeringOrderListViewController ()
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