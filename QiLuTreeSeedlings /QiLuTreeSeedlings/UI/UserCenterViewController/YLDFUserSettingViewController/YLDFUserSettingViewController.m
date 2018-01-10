//
//  YLDFUserSettingViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/5.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFUserSettingViewController.h"
#import"AbountUsViewController.h"
@interface YLDFUserSettingViewController ()

@end

@implementation YLDFUserSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([APPDELEGATE isNeedLogin]) {
        self.logOutBtn.hidden=NO;
    }else{
        self.logOutBtn.hidden=YES;
    }
    self.vcTitle=@"设置";
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)logOutBtnAction:(UIButton *)sender {
    
    [APPDELEGATE logoutAction];
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"logoutSuccess" object:nil];
}
- (IBAction)aboutUsBtn:(id)sender {
    AbountUsViewController *abountUnsVC=[[AbountUsViewController alloc]init];
    [self.navigationController pushViewController:abountUnsVC animated:YES];
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
