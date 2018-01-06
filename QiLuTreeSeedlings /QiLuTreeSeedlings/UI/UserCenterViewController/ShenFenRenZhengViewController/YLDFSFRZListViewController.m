//
//  YLDFSFRZListViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/4.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFSFRZListViewController.h"
#import "YLDFRealNameViewController.h"
#import "YLDJJRenShenQing1ViewController.h"
#import "YLDFRZzhongViewController.h"
@interface YLDFSFRZListViewController ()

@end
@implementation YLDFSFRZListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        _topC.constant=54.0;
    }
    self.vcTitle=@"身份认证";
    if ([APPDELEGATE.userModel.roles containsObject:@"broker"])
    {
        [self.JJRBtn setBackgroundImage:[UIImage imageNamed:@"SFRZJJRL"] forState:UIControlStateNormal];
    }
    if ([APPDELEGATE.userModel.roles containsObject:@"engineering_company"])
    {
        [self.GCGSBtn setBackgroundImage:[UIImage imageNamed:@"SFRZGCGSL"] forState:UIControlStateNormal];
    }
    if ([APPDELEGATE.userModel.roles containsObject:@"author"])
    {
        [self.GCGSBtn setBackgroundImage:[UIImage imageNamed:@"SFRZJLJL"] forState:UIControlStateNormal];
    }
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)jjrBtnAction:(UIButton *)sender {
    if ([APPDELEGATE.userModel.roles containsObject:@"users"]) {
        if ([APPDELEGATE.userModel.roles containsObject:@"broker"])
        {
            
        }else{
            ShowActionV();
            [HTTPCLIENT jjrshenheStatueSuccess:^(id responseObject) {
                if ([[responseObject objectForKey:@"success"] integerValue]) {
                    NSDictionary *data=[responseObject objectForKey:@"data"];
                    NSString *status=data[@"status"];
                    
                    if ([status isEqualToString:@"not_apply"]||[status isEqualToString:@"expired"]) {
                        YLDJJRenShenQing1ViewController *vc=[YLDJJRenShenQing1ViewController new];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    if ([status isEqualToString:@"audited"]||[status isEqualToString:@"submission"]) {
                        //                        [ToastView showTopToast:@"您的实名认证正在审核中，请耐心等待"];
                        YLDFRZzhongViewController *vc=[YLDFRZzhongViewController new];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    if ([status isEqualToString:@"fail"]) {

                        [ToastView showTopToast:@"您的经纪人认证已被退回，请重新编辑"];
                        YLDJJRenShenQing1ViewController *vc=[YLDJJRenShenQing1ViewController new];
                        vc.dic=[responseObject objectForKey:@"data"];
                        [self.navigationController pushViewController:vc animated:YES];
//
 
                    }
                    
                }else{
                    [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
                }
            } failure:^(NSError *error) {
                
            }];

        }
    }else{
        [ToastView showTopToast:@"请先实名认证"];
        YLDFRealNameViewController *vc=[YLDFRealNameViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (IBAction)gcgsBtnAction:(UIButton *)sender {
    if ([APPDELEGATE.userModel.roles containsObject:@"users"]) {
        
    }else{
        [ToastView showTopToast:@"请先实名认证"];
        YLDFRealNameViewController *vc=[YLDFRealNameViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (IBAction)ylhBtnAction:(UIButton *)sender {
    if ([APPDELEGATE.userModel.roles containsObject:@"users"]) {
        
    }else{
        [ToastView showTopToast:@"请先实名认证"];
        YLDFRealNameViewController *vc=[YLDFRealNameViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
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
