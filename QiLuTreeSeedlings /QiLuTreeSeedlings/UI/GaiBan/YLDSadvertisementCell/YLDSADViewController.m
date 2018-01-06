//
//  YLDSADViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/2/25.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDSADViewController.h"
#import "UIWebView+AFNetworking.h"
#import "YLDTHZSonViewController.h"
@interface YLDSADViewController ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *adWebView;
@end

@implementation YLDSADViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    RemoveActionV();
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"推广详情";
    CGFloat xxx=0;
    if (_type==1) {
       self.vcTitle=_name;
    }
    if (_type==2) {
        self.vcTitle=_name;
    }
    
    if (_type==3) {
        self.vcTitle=_name;
        xxx=60;
        
    }
    self.adWebView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64-xxx)];
    self.adWebView.delegate=self;
    self.adWebView.scalesPageToFit = YES;
    [self.view addSubview:self.adWebView];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    [self.adWebView loadRequest:request];
    [self.backBtn removeFromSuperview];
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(12, 26, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"backBtnBlack"] forState:UIControlStateNormal];
    [backBtn setEnlargeEdgeWithTop:15 right:60 bottom:10 left:10];
    [self.navBackView addSubview:backBtn];
    self.backBtn=backBtn;
    [backBtn addTarget:self action:@selector(backbtnAcion:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_type==3) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, kHeight-60, kWidth, 60)];
        [view setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:view];
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(40, 10, kWidth-80, 40)];
        [btn setBackgroundImage:[UIImage imageNamed:@"jianbianBtn"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"jianbianBtn"] forState:UIControlStateHighlighted];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(huiyuanBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"会员单位" forState:UIControlStateNormal];
        [view addSubview:btn];
    }
    ShowActionV();

}
-(void)huiyuanBtnAction
{
    YLDTHZSonViewController *vc=[YLDTHZSonViewController new];
    vc.uid=self.uid;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)backbtnAcion:(UIButton *)sender
{
    if ([self.adWebView canGoBack]){
        [self.adWebView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
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
