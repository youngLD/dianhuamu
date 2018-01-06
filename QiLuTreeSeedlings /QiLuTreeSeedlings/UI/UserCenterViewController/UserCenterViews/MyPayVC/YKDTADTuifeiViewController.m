//
//  YKDTADTuifeiViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/9/16.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YKDTADTuifeiViewController.h"

@interface YKDTADTuifeiViewController ()

@end

@implementation YKDTADTuifeiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"退费";
    [self.view setBackgroundColor:BGColor];
    self.pirceLab.text=[NSString stringWithFormat:@"%.2lf",self.pirce];
    [self.sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
}
-(void)sureBtnAction
{
    ShowActionV();
    [HTTPADCLIENT tuifeiWithUid:APPDELEGATE.userModel.access_id WithName:APPDELEGATE.userModel.name WithYuE:[NSString stringWithFormat:@"%.2lf",self.pirce] Withrfgivingmoney:[NSString stringWithFormat:@"%.2lf",self.zensong] Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            [ToastView showTopToast:@"退费成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
        RemoveActionV();
    } failure:^(NSError *error) {
        RemoveActionV();
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
