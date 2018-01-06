//
//  YLDPenJingMiMuViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/11/11.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDPenJingMiMuViewController.h"
#import "UIDefines.h"
@interface YLDPenJingMiMuViewController ()

@end

@implementation YLDPenJingMiMuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"盆景苗木";
    UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    imageV.image=[UIImage imageNamed:@"盆景苗木展示专区720x1280"];
    [self.view addSubview:imageV];
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
