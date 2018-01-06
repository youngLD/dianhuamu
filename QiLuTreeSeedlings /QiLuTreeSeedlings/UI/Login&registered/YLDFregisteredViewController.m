//
//  YLDFregisteredViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/12/5.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDFregisteredViewController.h"
#import "NSString+Phone.h"
@interface YLDFregisteredViewController ()
@property (assign,nonatomic)NSInteger codeCount2;
@property (strong,nonatomic)NSTimer *timer2;
@end

@implementation YLDFregisteredViewController
@synthesize codeCount2,timer2;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"用户注册";
    [self.registBtn addTarget:self action:@selector(registbtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.changePassTypeBtn addTarget:self action:@selector(changePassTypeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.sureBtn addTarget:self action:@selector(selcetXieyiBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    if (@available(iOS 11.0, *)) {
        self.topC.constant=60.f;
    }
    [self.getCodeBtn addTarget:self action:@selector(getcodeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
}
- (void)registbtnAction:(UIButton *)sender
{
    [self.passWordTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    [self.userNameTextField resignFirstResponder];
    if (!self.userNameTextField.text) {
        [ToastView showTopToast:@"用户名不能为空"];
        return;
    }
    if (!self.passWordTextField.text) {
        [ToastView showTopToast:@"密码不能为空"];
        return;
    }
    if (self.codeTextField.text.length==0) {
        [ToastView showTopToast:@"验证码不能为空"];
        return;
    }
    if (self.passWordTextField.text.length<6||self.passWordTextField.text.length>20) {
        [ToastView showTopToast:@"密码格式不正确"];
        return;
    }
    if(self.userNameTextField.text.length!=11)
    {
        [ToastView showTopToast:@"手机号必须是11位"];
        return;
    }
    if (![self.userNameTextField.text checkPhoneNumInput]) {
        [ToastView showTopToast:@"手机号格式不正确"];
        return;
    }
    if (self.passWordTextField.text.length<6||self.passWordTextField.text.length>20) {
        [ToastView showTopToast:@"密码不得小于6位或大于20位"];
        return;
    }
    if ([self bijiaoWeiCWithStr:self.passWordTextField.text]) {
        
    }else{
        [ToastView showTopToast:@"密码只能包含数字，字母和下划线"];
        return;
    }
    
    if (_sureBtn.selected==NO) {
        [ToastView showTopToast:@"您还未同意用户协议"];
        return;
    }
    [HTTPCLIENT registeredUserWithPhone:[NSString stringWithFormat:@"%@",self.userNameTextField.text] withPassWord:[NSString stringWithFormat:@"%@",self.passWordTextField.text] withRepassWord:nil withCode:self.codeTextField.text Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            
            [ToastView showTopToast:@"注册成功"];
            [self loginSuccessAction];
            APPDELEGATE.userModel=[UserInfoModel userInfoCreatByDic:[responseObject objectForKey:@"data"]];
            APPDELEGATE.ChatHelper=[ChatDemoHelper shareHelper];
           
            
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            NSString *token=APPDELEGATE.userModel.access_token;
   ;
            [defaults setObject:token forKey:kACCESS_TOKEN];
            [defaults setObject:_userNameTextField.text forKey:@"myphone"];
            [defaults synchronize];
       
            //聊天自动登录
            EMError *error2 = [[EMClient sharedClient] loginWithUsername:_userNameTextField.text password:@"123456"];
            if (!error2) {
                //                    NSLog(@"登录成功");
                [[EMClient sharedClient].options setIsAutoLogin:YES];
            }else
            {
                NSLog(@"%@",error2.errorDescription);
            }
            [APPDELEGATE  reloadUserInfoSuccess:^(id responseObject) {
                
            } failure:^(NSError *error) {
                
            }];
            
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)getcodeBtnAction:(UIButton *)sender
{
    if(_userNameTextField.text.length!=11)
    {
        [ToastView showTopToast:@"请输入正确的手机号"];
        return;
    }
    [self.passWordTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    [self.userNameTextField resignFirstResponder];
    [HTTPCLIENT getregisterCodeWithPhone:_userNameTextField.text Success:^(id responseObject) {
        if([[responseObject objectForKey:@"success"] integerValue])
        {
            [ToastView showTopToast:@"验证码发送成功，请稍候"];
            self.codeTextField.text=[responseObject objectForKey:@"msg"];
            codeCount2=60;
            self.getCodeBtn.enabled=NO;
            [self.getCodeBtn setTitle:@"60" forState:UIControlStateNormal];
            [self.getCodeBtn setImage:nil forState:UIControlStateNormal];
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
            self.getCodeBtn.enabled=YES;
            [self.getCodeBtn setImage:[UIImage imageNamed:@"rejistedGetCode.png"] forState:UIControlStateNormal];
            [self.getCodeBtn setTitle:nil forState:UIControlStateNormal];
            return;
        }
    }
    codeCount2--;
    NSString *numStr=[NSString stringWithFormat:@"%ld",(long)codeCount2];
    
    [self.getCodeBtn setTitle:numStr forState:UIControlStateNormal];
}
-(BOOL)bijiaoWeiCWithStr:(NSString *)string
{
    // 1、准备正则式
    NSString *regex = @"^[a-zA-Z_0-9]+$"; // 只能是字母，不区分大小写
    // 2、拼接谓词
    NSPredicate *predicateRe1 = [NSPredicate predicateWithFormat:@"self matches %@", regex];
    // 3、匹配字符串
    BOOL resualt = [predicateRe1 evaluateWithObject:string];
    return resualt;
}
- (void)changePassTypeBtnAction:(UIButton *)sender
{
    sender.selected=!sender.selected;
    if (sender.selected) {
        self.passWordTextField.secureTextEntry = NO;
    }else{
        self.passWordTextField.secureTextEntry = YES;
    }
}
-(void)selcetXieyiBtnAction:(UIButton *)sender
{
    sender.selected=!sender.selected;
}
-(void)loginSuccessAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    [self.navigationController popViewControllerAnimated:YES];
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
