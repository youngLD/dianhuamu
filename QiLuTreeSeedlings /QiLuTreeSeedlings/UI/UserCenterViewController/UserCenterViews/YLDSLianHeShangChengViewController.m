//
//  YLDSLianHeShangChengViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/4/11.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDSLianHeShangChengViewController.h"
#import "UIWebView+AFNetworking.h"
@interface YLDSLianHeShangChengViewController ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *adWebView;
@end

@implementation YLDSLianHeShangChengViewController
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    RemoveActionV();
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"联合商城";

    self.adWebView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64)];
    self.adWebView.delegate=self;
    self.adWebView.scalesPageToFit = YES;
    [self.view addSubview:self.adWebView];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://shop.jbhmw.com/mobile/index.php"]];
    [self.adWebView loadRequest:request];
   
    // Do any additional setup after loading the view.
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    ShowActionV();
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    RemoveActionV();
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:( NSError *)error {
    [ToastView showTopToast:@"加载失败"];
    RemoveActionV();
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
