//
//  ZIKPaySuccessViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/4/5.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKPaySuccessViewController.h"
#import "ZIKMyBalanceViewController.h"
#import "BuyDetialInfoViewController.h"
#import "ZIKSingleVoucherCenterViewController.h"
#define Recharge @"Is top-up for the first time"
@interface ZIKPaySuccessViewController ()

@end

@implementation ZIKPaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.vcTitle = @"支付订单";
    self.priceLabel.text = [NSString stringWithFormat:@"充值金额(元) : %@",self.price];
    [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:Recharge];
    
    if (self.type==6) {
        self.successLab.text =@"提交经纪人资料成功!";
        self.priceLabel.text = [NSString stringWithFormat:@"认证费用(元) : %@",self.price];
        [self.backBtn removeFromSuperview];
        UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(12, 26, 30, 30)];
        [backBtn setImage:[UIImage imageNamed:@"backBtnBlack"] forState:UIControlStateNormal];
        [backBtn setEnlargeEdgeWithTop:15 right:60 bottom:10 left:10];
        [self.navBackView addSubview:backBtn];
        self.backBtn=backBtn;
        [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];

    }
//#define Recharge @"Is top-up for the first time"*/
   
}
-(void)backBtnAction:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)finishButton:(id)sender {
    if (APPDELEGATE.isFromSingleVoucherCenter) {
        APPDELEGATE.isFromSingleVoucherCenter = NO;
         for(UIViewController *controller in self.navigationController.viewControllers) {
             if ([controller isKindOfClass:[ZIKSingleVoucherCenterViewController class]]) {
                 ZIKSingleVoucherCenterViewController *svc = (ZIKSingleVoucherCenterViewController*)controller;
                 [self.navigationController popToViewController:svc animated:YES];
             }
         }
        return;
    }
    for(UIViewController *controller in self.navigationController.viewControllers) {
        if([controller isKindOfClass:[ZIKMyBalanceViewController class]]||[controller isKindOfClass:[BuyDetialInfoViewController class]]){
            ZIKMyBalanceViewController *owr = (ZIKMyBalanceViewController *)controller;
            [self.navigationController popToViewController:owr animated:YES];
            return;
        }
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
