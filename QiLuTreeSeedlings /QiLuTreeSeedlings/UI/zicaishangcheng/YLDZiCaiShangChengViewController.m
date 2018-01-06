//
//  YLDZiCaiShangChengViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/11/11.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDZiCaiShangChengViewController.h"

@interface YLDZiCaiShangChengViewController ()

@end

@implementation YLDZiCaiShangChengViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"资材商城";
    UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    [self.view addSubview:imageV];
    imageV.image=[UIImage imageNamed:@"资材商城展示专区720x1280"];
    // Do any additional setup after loading the view.
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
