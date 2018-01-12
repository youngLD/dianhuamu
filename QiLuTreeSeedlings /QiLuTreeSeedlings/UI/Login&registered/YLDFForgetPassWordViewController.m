//
//  YLDFForgetPassWordViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/12/5.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDFForgetPassWordViewController.h"

@interface YLDFForgetPassWordViewController ()
@property (nonatomic,strong)NSTimer *timer2;
@property (nonatomic,assign)NSInteger codeCount2;
@end

@implementation YLDFForgetPassWordViewController
@synthesize codeCount2,timer2;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"密码找回";
    [self.getBtnCodeBtn addTarget:self action:@selector(getShotMessageCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.changePassTypeBtn addTarget:self action:@selector(changePassTypeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    if (@available(iOS 11.0, *)) {
        self.topC.constant=60.f;
    }
    [self.sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
}
-(void)sureBtnAction
{
    [self.codeTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    [self.passWordTextField resignFirstResponder];
    if (self.phoneTextField.text.length!=11) {
        [ToastView showTopToast:@"手机号不正确"];
        return;
    }
    if (self.codeTextField.text.length==0) {
        [ToastView showTopToast:@"验证码不能为空"];
        return;
    }
    if (self.passWordTextField.text.length<6) {
        [ToastView showTopToast:@"密码不能小于6位"];
        return;
    }
    [HTTPCLIENT resetPassWordWithPhone:self.phoneTextField.text WithverificationCode:self.codeTextField.text WithNewPassWord:self.passWordTextField.text Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                [ToastView showTopToast:@"重置成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
    
}
-(void)changePassTypeBtnAction:(UIButton *)sender
{
    sender.selected=!sender.selected;
    if (sender.selected) {
        self.passWordTextField.secureTextEntry = NO;
    }else{
        self.passWordTextField.secureTextEntry = YES;
    }
}
-(void)getShotMessageCode:(UIButton *)sender
{
    [self.codeTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    [self.passWordTextField resignFirstResponder];
    [HTTPCLIENT getCodeShotMessageWtihPhone:self.phoneTextField.text andType:nil Success:^(id responseObject) {
        if([[responseObject objectForKey:@"success"] integerValue])
        {
            [ToastView showTopToast:@"验证码发送成功，请稍后"];
            self.codeTextField.text=[responseObject objectForKey:@"msg"];
            codeCount2=60;
            self.getBtnCodeBtn.enabled=NO;
            [self.getBtnCodeBtn setTitle:@"60" forState:UIControlStateNormal];
            [self.getBtnCodeBtn setImage:nil forState:UIControlStateNormal];
            [self changBackTime];
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)changBackTime
{
    timer2 = [NSTimer scheduledTimerWithTimeInterval:1
                                              target:self
                                            selector:@selector(changeTime2) userInfo:nil repeats:YES];
}
-(void)changeTime2
{
    if (codeCount2 <= 1) {
        
        if (timer2) {
            [timer2 invalidate];
            timer2 = nil;
            self.getBtnCodeBtn.enabled=YES;
            [self.getBtnCodeBtn setImage:[UIImage imageNamed:@"rejistedGetCode.png"] forState:UIControlStateNormal];
            [self.getBtnCodeBtn setTitle:nil forState:UIControlStateNormal];
            return;
        }
    }
    codeCount2--;
    NSString *numStr=[NSString stringWithFormat:@"%ld",(long)codeCount2];
    
    [self.getBtnCodeBtn setTitle:numStr forState:UIControlStateNormal];
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
