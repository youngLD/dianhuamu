//
//  YLDFBuyDetialViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/15.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFBuyDetialViewController.h"
#import "YLDLoginViewController.h"
#import "UINavController.h"
#import "YLDFBaoJiaView.h"
@interface YLDFBuyDetialViewController ()<UIWebViewDelegate,YLDFBaoJiaViewCellDelegate>

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
    [self.back2Btn removeFromSuperview];
    self.back2Btn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-55, self.navBackView.frame.size.height-40, 50, 30)];
    [self.back2Btn setImage:[UIImage imageNamed:@"detialSCoff"] forState:UIControlStateNormal];
    [self.back2Btn setImage:[UIImage imageNamed:@"detialSCon"] forState:UIControlStateSelected];
    [self.back2Btn addTarget:self action:@selector(collectionAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBackView addSubview:self.back2Btn];
    // Do any additional setup after loading the view from its nib.
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
    if (!sender.selected) {
        [HTTPCLIENT collectActionWithIds:self.model.buyId WithcollectionTypeId:@"buy" Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                [ToastView showTopToast:@"收藏成功"];
                sender.selected=YES;
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
    }else{
        [HTTPCLIENT deletesenderCollectWithIds:self.model.buyId Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                [ToastView showTopToast:@"取消收藏"];
                sender.selected=YES;
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
    }
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
- (IBAction)baojiaBtnAction:(UIButton *)sender {
    
    if(![APPDELEGATE isNeedLogin])
    {
        YLDLoginViewController *loginViewController=[[YLDLoginViewController alloc]init];
        [ToastView showTopToast:@"请先登录"];
        UINavController *navVC=[[UINavController alloc]initWithRootViewController:loginViewController];
        
        [self presentViewController:navVC animated:YES completion:^{
            
        }];
        return;
    }
    if ([self.model.status isEqualToString:@"已报价"]) {
        [ToastView showTopToast:@"不可重复报价"];
        return;
    }
    YLDFBaoJiaView *view=[YLDFBaoJiaView yldFBaoJiaView];
    view.controller=self;
    view.buyModel=self.model;
    view.delegate=self;
    [self.view addSubview:view];
    [view show];
}
-(void)itemsBaojiaActionWithBuyModel:(YLDFBuyModel *)model withDic:(NSDictionary *)dic
{
    NSString *bodyStr=[ZIKFunction convertToJsonData:dic];
    [HTTPCLIENT eOrderBaoJiaWithobodyStr:bodyStr Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            [ToastView showTopToast:@"报价成功"];
            model.status=@"已报价";
           
        }else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
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
