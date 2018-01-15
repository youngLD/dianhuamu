//
//  YLDFSupplyViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/15.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFSupplyViewController.h"

@interface YLDFSupplyViewController ()

@end

@implementation YLDFSupplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.topC.constant=44.f;
    }
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)goShopBtnAction:(UIButton *)sender {
}
- (IBAction)shareBtnAction:(UIButton *)sender {
}
- (IBAction)chatBtnAction:(id)sender {
}
- (IBAction)callBtnAction:(UIButton *)sender {
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
