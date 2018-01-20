//
//  YLDFSupplyViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/15.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFSupplyViewController.h"
#import "YLDLoginViewController.h"
#import "UINavController.h"
@interface YLDFSupplyViewController ()<UIWebViewDelegate>

@end

@implementation YLDFSupplyViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self checkCollectState];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    if (@available(iOS 11.0, *)) {
//        self.topC.constant=44.f;
//    }
//    self.webView.delegate=self;
    
    self.vcTitle=@"供应详情";
    if (self.model.htmlUrl) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.model.htmlUrl]];
        [self.webView loadRequest:request];
    }
    self.webView.scalesPageToFit = YES;
    [self.back2Btn removeFromSuperview];
    self.back2Btn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-55, self.navBackView.frame.size.height-40, 50, 30)];
    [self.back2Btn setImage:[UIImage imageNamed:@"detialSCoff"] forState:UIControlStateNormal];
    [self.back2Btn setImage:[UIImage imageNamed:@"detialSCon"] forState:UIControlStateSelected];
    [self.back2Btn addTarget:self action:@selector(collectionAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBackView addSubview:self.back2Btn];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)checkCollectState
{
    if ([APPDELEGATE isNeedLogin]) {
        self.back2Btn.enabled=NO;
        [HTTPCLIENT collectStateWithId:self.model.supplyId Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                NSInteger data=[[responseObject objectForKey:@"data"] integerValue];
                if (data) {
                    self.back2Btn.enabled=YES;
                    self.back2Btn.selected=YES;
                }else{
                    self.back2Btn.enabled=YES;
                    self.back2Btn.selected=NO;
                }
            }else{
                
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    
}
-(void)collectionAction:(UIButton *)sender
{
    if(![APPDELEGATE isNeedLogin])
    {
        YLDLoginViewController *loginViewController=[[YLDLoginViewController alloc]init];
        [ToastView showTopToast:@"请先登录"];
        UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
        
        [self presentViewController:navVC animated:YES completion:^{
            
        }];
        return;
    }
    ShowActionV();
    if (!sender.selected) {
        [HTTPCLIENT collectActionWithIds:self.model.supplyId WithcollectionTypeId:@"supply" Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                [ToastView showTopToast:@"收藏成功"];
                sender.selected=YES;
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
    }else{
        [HTTPCLIENT deletesenderCollectWithIds:self.model.supplyId Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                [ToastView showTopToast:@"取消收藏"];
                sender.selected=NO;
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}
- (IBAction)goShopBtnAction:(UIButton *)sender {
}
- (IBAction)shareBtnAction:(UIButton *)sender {
}
- (IBAction)chatBtnAction:(id)sender {
}
- (IBAction)callBtnAction:(UIButton *)sender {
    if (self.model.phone.length>0) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.model.phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else
    {
        [ToastView showTopToast:@"暂无联系方式"];
    }
    if ([APPDELEGATE isNeedLogin]) {
        [HTTPCLIENT supplyDetialCallActionWithSupplyId:self.model.supplyId Success:^(id responseObject) {
            
        } failure:^(NSError *error) {
            
        }];
    }
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
