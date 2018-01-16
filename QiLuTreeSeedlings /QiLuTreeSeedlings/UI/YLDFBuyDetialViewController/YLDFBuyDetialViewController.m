//
//  YLDFBuyDetialViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/15.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFBuyDetialViewController.h"

@interface YLDFBuyDetialViewController ()<UIWebViewDelegate>

@end

@implementation YLDFBuyDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle = @"求购详情";
    if (@available(iOS 11.0, *)) {
        self.topC.constant=44.f;
    }
    self.webView.scalesPageToFit = YES;
    if (self.model.htmlUrl) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.model.htmlUrl]];
        [self.webView loadRequest:request];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)shopBtnAcction:(UIButton *)sender {
}
- (IBAction)shareBtnAction:(id)sender {
}
- (IBAction)chatBtnAction:(UIButton *)sender {
}
- (IBAction)callBtnAction:(UIButton *)sender {
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    //    ShowActionV();
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    RemoveActionV();
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:( NSError *)error {
    [ToastView showTopToast:@"加载失败"];
    RemoveActionV();
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
