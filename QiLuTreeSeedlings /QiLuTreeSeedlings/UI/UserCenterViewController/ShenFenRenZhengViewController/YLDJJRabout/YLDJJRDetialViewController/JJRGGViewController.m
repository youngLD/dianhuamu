//
//  JJRGGViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/29.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "JJRGGViewController.h"

@interface JJRGGViewController ()

@end

@implementation JJRGGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"经纪人优势介绍";
    UIWebView *view=[[UIWebView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];

    view.scalesPageToFit = YES;
    [self.view addSubview:view];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://testimg.miaoxintong.cn/admin/image/adv/det/Jy5R7tKThf.png"]];
    [view loadRequest:request];
//    UIImageView *iamgeV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kWidth*5.83889)];
//    [self.scrollView addSubview:iamgeV];
//    [self.scrollView setContentSize:CGSizeMake(0, kWidth*5.83889)];
//    [iamgeV setImage:[UIImage imageNamed:@"jjryslongImage"]];
    // Do any additional setup after loading the view from its nib.
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
