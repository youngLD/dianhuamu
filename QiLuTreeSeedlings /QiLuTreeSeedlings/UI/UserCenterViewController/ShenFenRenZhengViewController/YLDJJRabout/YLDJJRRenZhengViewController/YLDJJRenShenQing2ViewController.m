//
//  YLDJJRenShenQing2ViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/6.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDJJRenShenQing2ViewController.h"

#import "YLDJJRenShenQing3ViewController.h"
#import "ZIKVoucherCenterViewController.h"

@interface YLDJJRenShenQing2ViewController ()<UITextFieldDelegate,UIAlertViewDelegate>

@end

@implementation YLDJJRenShenQing2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"经纪人认证";
    self.bankCardNField.rangeNumber=19;
    self.bankCardNField.delegate=self;
    self.bankCardNField.keyboardType=UIKeyboardTypeNumberPad;
    self.bankNameLab.rangeNumber=250;
    self.bankNameLab.delegate=self;
    self.nameLab.delegate=self;
    self.nameLab.rangeNumber=250;
    if (self.type==-1||self.type==-2||self.type==2) {
        NSUserDefaults *userDefau = [NSUserDefaults standardUserDefaults];
        NSDictionary *dic =  [userDefau objectForKey:@"jjrRenZheng"];
        if (dic) {
            self.bankCardNField.text=dic[@"bankCardNumber"];
            self.bankNameLab.text=dic[@"openingBank"];
            self.nameLab.text=dic[@"accountHolder"];
        }
    }

    // Do any additional setup after loading the view from its nib.
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag==11) {
        NSUserDefaults *userDefau = [NSUserDefaults standardUserDefaults];
        NSDictionary *dic1 =  [userDefau objectForKey:@"jjrRenZheng"];
        NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:dic1];
        if (textField.text.length==0) {
            [dic removeObjectForKey:@"accountHolder"];
        }else{
            dic[@"accountHolder"]=textField.text;
        }
        [userDefau setObject:dic forKey:@"jjrRenZheng"];
        [userDefau synchronize];
        
    }
    if (textField.tag==12) {
        NSUserDefaults *userDefau = [NSUserDefaults standardUserDefaults];
        NSDictionary *dic1 =  [userDefau objectForKey:@"jjrRenZheng"];
        NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:dic1];
        if (textField.text.length==0) {
            [dic removeObjectForKey:@"bankCardNumber"];
        }else{
            dic[@"bankCardNumber"]=textField.text;
        }
        [userDefau setObject:dic forKey:@"jjrRenZheng"];
        [userDefau synchronize];

    }
    
    if (textField.tag==13) {
        NSUserDefaults *userDefau = [NSUserDefaults standardUserDefaults];
        NSDictionary *dic1 =  [userDefau objectForKey:@"jjrRenZheng"];
        NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:dic1];
        if (textField.text.length==0) {
            [dic removeObjectForKey:@"openingBank"];
        }else{
            dic[@"openingBank"]=textField.text;
        }
        [userDefau setObject:dic forKey:@"jjrRenZheng"];
        [userDefau synchronize];
        
    }
   
}
- (IBAction)nextBtnAction:(id)sender {
    if (self.bankCardNField.text.length!=19) {
        [ToastView showTopToast:@"请输入正确的银行卡号"];
        return;
    }
   self.nameLab.text = [self.nameLab.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (self.nameLab.text.length==0) {
        [ToastView showTopToast:@"请输入开户人姓名"];
        return;
    }
    if (self.bankNameLab.text.length==0) {
        [ToastView showTopToast:@"请输入开户银行"];
        return;
    }
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:self.dic];
    dic[@"bankCardNumber"]=self.bankCardNField.text;
    dic[@"openingBank"]=self.bankNameLab.text;
    dic[@"accountHolder"]=self.nameLab.text;
    if (self.type==-1||self.type==3) {
        NSUserDefaults *userDefau = [NSUserDefaults standardUserDefaults];
        [userDefau setObject:dic forKey:@"jjrRenZheng"];
        [userDefau synchronize];
    }
    
   
    [HTTPCLIENT jjrshenheWithDic:dic Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSString *uid=[responseObject objectForKey:@"result"];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.type==2) {
                    [ToastView showTopToast:@"提交审核资料成功，请耐心等待"];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    ZIKVoucherCenterViewController *voucherVC = [[ZIKVoucherCenterViewController alloc] init];
                    voucherVC.price = @"0.01";
                    voucherVC.wareStr=@"支付认证费用(元):";
                    voucherVC.uid=uid;
                    voucherVC.infoType=6;
                    [self.navigationController pushViewController:voucherVC animated:YES];
                }

                
            });
        }else{
            [ToastView showTopToast:@"请求失败"];
        }
    } failure:^(NSError *error) {
        
    }];

//    YLDJJRenShenQing3ViewController *vcc=[YLDJJRenShenQing3ViewController new];
//    vcc.dic=dic;
//    [self.navigationController pushViewController:vcc animated:YES];


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
