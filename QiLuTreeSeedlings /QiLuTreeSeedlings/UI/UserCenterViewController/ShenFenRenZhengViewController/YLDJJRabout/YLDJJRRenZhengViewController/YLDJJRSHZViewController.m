//
//  YLDJJRSHZViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/5.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDJJRSHZViewController.h"

@interface YLDJJRSHZViewController ()

@end

@implementation YLDJJRSHZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"苗木经纪人";
    if (_type==1) {
        self.vcTitle=@"退费";
    }
    [self.sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
}
-(void)sureBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
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
