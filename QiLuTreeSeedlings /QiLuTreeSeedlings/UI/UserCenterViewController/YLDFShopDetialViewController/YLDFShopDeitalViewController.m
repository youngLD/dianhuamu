//
//  YLDFShopDeitalViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/17.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFShopDeitalViewController.h"
#import "UIDefines.h"
#import "YLDLoginViewController.h"
#import "UINavController.h"
#import "UIDefines.h"
#import "HttpClient.h"
@interface YLDFShopDeitalViewController ()

@end
@implementation YLDFShopDeitalViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self checkCollectState];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        // Fallback on earlier versions
    }
    if (self.model.url) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.model.url]];
        [self.webView loadRequest:request];

    }
    [self.back2Btn addTarget:self action:@selector(collectionAction:) forControlEvents:UIControlEventTouchUpInside];
//    self.webView.scalesPageToFit = YES;
    // Do any additional setup after loading the view from its nib.
}
-(void)checkCollectState
{
    if ([APPDELEGATE isNeedLogin]) {
        self.back2Btn.enabled=NO;
        [HTTPCLIENT collectStateWithId:nil Success:^(id responseObject) {
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
        [HTTPCLIENT collectActionWithIds:nil WithcollectionTypeId:@"supply" Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                [ToastView showTopToast:@"收藏成功"];
                sender.selected=YES;
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
    }else{
        [HTTPCLIENT deletesenderCollectWithIds:nil Success:^(id responseObject) {
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
- (IBAction)shareBtnAction:(UIButton *)sender {
}
- (IBAction)chatBtnAction:(id)sender {
}
- (IBAction)callBtnAction:(UIButton *)sender {
//    if (self.model.phone.length>0) {
//        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.model.phone];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//    }else
//    {
//        [ToastView showTopToast:@"暂无联系方式"];
//    }
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    //    ShowActionV();
}
- (IBAction)backBtnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
