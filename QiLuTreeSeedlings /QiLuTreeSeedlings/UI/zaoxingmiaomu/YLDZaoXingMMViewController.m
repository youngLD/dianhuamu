//
//  YLDZaoXingMMViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/11/11.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDZaoXingMMViewController.h"

@interface YLDZaoXingMMViewController ()

@end

@implementation YLDZaoXingMMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"造型苗木";
    UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    [self.view addSubview:imageV];
    imageV.image=[UIImage imageNamed:@"造型苗木展示专区720x1280"];
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
