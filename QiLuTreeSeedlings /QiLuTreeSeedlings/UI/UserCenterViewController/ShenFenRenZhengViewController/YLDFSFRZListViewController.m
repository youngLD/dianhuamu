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
#import "YLDGCGSZiZhiTiJiaoViewController.h"
#import "ZIKVoucherCenterViewController.h"
#import "YLDJJRNotPassViewController.h"
#import "YLDFQiYeRenZhengViewController.h"
@interface YLDFSFRZListViewController ()<YLDJJRenShenQing1ViewControllerDelegate,YLDJJRNotPassViewControllerDelegate>

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
            [ToastView showTopToast:@"您已通过经纪人认证"];
        }else{
            ShowActionV();
            [HTTPCLIENT jjrshenheStatueSuccess:^(id responseObject) {
                if ([[responseObject objectForKey:@"success"] integerValue]) {
                    NSDictionary *data=[responseObject objectForKey:@"data"];
                    NSString *status=data[@"status"];
                    
                    if ([status isEqualToString:@"not_apply"]||[status isEqualToString:@"expired"]) {
                        YLDJJRenShenQing1ViewController *vc=[YLDJJRenShenQing1ViewController new];
                        vc.type=1;
                        vc.deleagte=self;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    if ([status isEqualToString:@"audited"]||[status isEqualToString:@"submission"]) {
                        YLDFRZzhongViewController *vc=[YLDFRZzhongViewController new];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    if ([status isEqualToString:@"normal"]) {
                        [ToastView showTopToast:@"您已通过经纪人认证"];
                    }
                    if ([status isEqualToString:@"fail"]) {

                        YLDJJRNotPassViewController * vc=[YLDJJRNotPassViewController new];
                        vc.wareStr=@"经纪人";
                        vc.delegate=self;
                        vc.dic=[responseObject objectForKey:@"data"];
                        [self.navigationController pushViewController:vc animated:YES];
                        
 
                    }
                    if ([status isEqualToString:@"unpaid"]) {
                        [ToastView showTopToast:@"您还未支付经纪人审核费"];
                        ZIKVoucherCenterViewController *vc=[ZIKVoucherCenterViewController new];
                        vc.dic=[responseObject objectForKey:@"data"];
                        vc.infoType=6;
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }
                    
                }else{
                    [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
                }
            } failure:^(NSError *error) {
                
            }];

        }
    }else{
        __weak typeof(self)weakSelf=self;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"实名认证" message:@"经纪人认证前需要实名认证，是否实名认证？" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
           
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"实名认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ShowActionV();
            
            [weakSelf shimingrenzheng];
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (IBAction)gcgsBtnAction:(UIButton *)sender {
    if ([APPDELEGATE.userModel.roles containsObject:@"enterprise"]) {
        if ([APPDELEGATE.userModel.roles containsObject:@"engineering_company"])
        {
            [ToastView showTopToast:@"您已通过工程公司认证"];
        }else{
            [HTTPCLIENT projectCompanyStatusSuccess:^(id responseObject) {
                if ([[responseObject objectForKey:@"success"] integerValue]) {
                    NSDictionary *data=[responseObject objectForKey:@"data"];
                    NSString *status=data[@"status"];
                    
                    if ([status isEqualToString:@"not_apply"]||[status isEqualToString:@"expired"]) {
                        YLDGCGSZiZhiTiJiaoViewController *vc=[YLDGCGSZiZhiTiJiaoViewController new];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    if ([status isEqualToString:@"audited"]||[status isEqualToString:@"submission"]) {
                        YLDFRZzhongViewController *vc=[YLDFRZzhongViewController new];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    if ([status isEqualToString:@"normal"]) {
                        [ToastView showTopToast:@"您已通过工程公司认证"];
                    }
                    if ([status isEqualToString:@"fail"]) {
                        YLDJJRNotPassViewController *vc=[YLDJJRNotPassViewController new];
                        vc.wareStr=@"经纪人";
                        vc.delegate=self;
                        vc.dic=data;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    if ([status isEqualToString:@"normal"]) {
                        [ToastView showTopToast:@"您已通过工程公司认证"];
                    }
                    //
                }else{
                    [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
                }
            } failure:^(NSError *error) {
               
            }];

        }
        
    }else{
        __weak typeof(self)weakSelf=self;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"企业认证" message:@"工程公司认证前需要企业认证，是否企业认证？" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            
            
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"企业认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            ShowActionV();
            [weakSelf qiyerenzheng];
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
- (IBAction)ylhBtnAction:(UIButton *)sender {
    if ([APPDELEGATE.userModel.roles containsObject:@"users"]) {
        [ToastView showTopToast:@"敬请期待"];
    }else{
        [ToastView showTopToast:@"请先实名认证"];
        YLDFRealNameViewController *vc=[YLDFRealNameViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)shimingrenzheng
{
    [HTTPCLIENT getRealNameStateSuccess:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            
            NSDictionary *data=[responseObject objectForKey:@"data"];
            NSString *status=data[@"status"];
            
            if ([status isEqualToString:@"not_apply"]||[status isEqualToString:@"expired"]) {
                YLDFRealNameViewController *vc=[YLDFRealNameViewController new];
//                vc.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            if ([status isEqualToString:@"audited"]||[status isEqualToString:@"submission"]) {
                YLDFRZzhongViewController *vc=[YLDFRZzhongViewController new];

                [self.navigationController pushViewController:vc animated:YES];
            }
            if ([status isEqualToString:@"normal"]) {
                
                [APPDELEGATE reloadUserInfoSuccess:^(id responseObject) {
                    [self jjrBtnAction:nil];
                } failure:^(NSError *error) {
                    
                }];
            }
            if ([status isEqualToString:@"fail"]) {
                YLDJJRNotPassViewController * vc=[YLDJJRNotPassViewController new];
//                vc.hidesBottomBarWhenPushed=YES;
                //                        [ToastView showTopToast:@"您的实名认证已被退回，请重新编辑"];
                vc.wareStr=@"实名";
                vc.delegate=self;
                vc.dic=[responseObject objectForKey:@"data"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
            
        }else{
            
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)qiyerenzheng
{
    [HTTPCLIENT getEnterpriseStateSuccess:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            
            NSDictionary *data=[responseObject objectForKey:@"data"];
            NSString *status=data[@"status"];
            
            if ([status isEqualToString:@"not_apply"]||[status isEqualToString:@"expired"]) {
                YLDFQiYeRenZhengViewController * vc=[YLDFQiYeRenZhengViewController new];
                [self.navigationController pushViewController:vc animated:YES];
            }
            if ([status isEqualToString:@"audited"]||[status isEqualToString:@"submission"]) {
                YLDFRZzhongViewController *vc=[YLDFRZzhongViewController new];
                [self.navigationController pushViewController:vc animated:YES];
            }
            if ([status isEqualToString:@"normal"]) {
                
                [APPDELEGATE reloadUserInfoSuccess:^(id responseObject) {
                    [self gcgsBtnAction:nil];
                } failure:^(NSError *error) {
                    
                }];
            }
            if ([status isEqualToString:@"fail"]) {
                 
                YLDJJRNotPassViewController * vc=[YLDJJRNotPassViewController new];
                vc.wareStr=@"企业";
                vc.delegate=self;
                vc.dic=[responseObject objectForKey:@"data"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else{
            
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)shenheweitongguoChongxintijiaoDic:(NSDictionary *)dic WithwareStr:(NSString *)wareStr
{
    if ([wareStr isEqualToString:@"经纪人"]) {
        [ToastView showTopToast:@"您的经纪人认证已被退回，请重新编辑"];
        YLDJJRenShenQing1ViewController *vc=[YLDJJRenShenQing1ViewController new];
        vc.dic=dic;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([wareStr isEqualToString:@"工程公司"]) {
        [ToastView showTopToast:@"您的工程公司申请已被退回，请重新编辑"];
        YLDGCGSZiZhiTiJiaoViewController *vc=[YLDGCGSZiZhiTiJiaoViewController new];
        vc.dic=dic;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([wareStr isEqualToString:@"实名"]) {
        YLDFRealNameViewController* vc=[YLDFRealNameViewController new];
        [ToastView showTopToast:@"您的实名认证已被退回，请重新编辑"];
        
        vc.dic=dic;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([wareStr isEqualToString:@"企业"]) {
        YLDFQiYeRenZhengViewController * vc=[YLDFQiYeRenZhengViewController new];
        [ToastView showTopToast:@"您的企业认证已被退回，请重新编辑"];
        vc.dic=dic;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}
-(void)jjrTiJiaoSuccessWithDic:(NSDictionary *)dic{
    ZIKVoucherCenterViewController *vc=[ZIKVoucherCenterViewController new];
    vc.dic=[dic objectForKey:@"data"];
    vc.infoType=6;
    [self.navigationController pushViewController:vc animated:YES];
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
