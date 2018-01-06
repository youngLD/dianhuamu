//
//  LoginViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/3/9.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "YLDLoginViewController.h"
#import "UIDefines.h"
#import "YLDFLoginView.h"
#import "HttpClient.h"
#import "YLDFregisteredViewController.h"
#import "YLDFForgetPassWordViewController.h"

#import "WXApi.h"
#import "NSString+Phone.h"
#import "ToastView.h"
@interface YLDLoginViewController ()
@property (nonatomic,strong)YLDFLoginView *loginView;
@end

@implementation YLDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    
    
    YLDFLoginView *loginView=[YLDFLoginView yldFLoginView];
    CGRect frame=loginView.frame;
    frame=CGRectMake(0, 0, kWidth, kHeight);
    loginView.frame=frame;
    [self.view addSubview:loginView];
    self.loginView=loginView;
    [loginView.registBtn addTarget:self action:@selector(registeredBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [loginView.fagertPassBtn addTarget:self action:@selector(forgetPassWordBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [loginView.backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [loginView.loginActionBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [loginView.changePassTypeBtn addTarget:self action:@selector(changePassTypeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [loginView.wxLoginActionBtn addTarget:self action:@selector(sendAuthRequest) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)changePassTypeBtnAction:(UIButton *)sender
{
    sender.selected=!sender.selected;
    if (sender.selected) {
       self.loginView.passWordTextField.secureTextEntry = NO;
    }else{
       self.loginView.passWordTextField.secureTextEntry = YES;
    }
}
-(void)sendAuthRequest
{
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo,snsapi_base";
    req.state = @"0744";
    [WXApi sendReq:req];
}
-(void)forgetPassWordBtnAction
{
    YLDFForgetPassWordViewController *registVC=[[YLDFForgetPassWordViewController alloc]init];
    [self.navigationController pushViewController:registVC animated:YES];
}
-(void)registeredBtnAction
{
    YLDFregisteredViewController *registVC=[[YLDFregisteredViewController alloc]init];
    [self.navigationController pushViewController:registVC animated:YES];
}
-(void)loginAction
{
    [self.loginView.passWordTextField resignFirstResponder];
    [self.loginView.userNameTextFiled resignFirstResponder];
    if (self.loginView.userNameTextFiled.text.length==0) {
        [ToastView showTopToast:@"用户名不能为空"];
        return;
    }
    if (self.loginView.passWordTextField.text==0) {
        [ToastView showTopToast:@"密码不能为空"];
        return;
    }
    
    if (self.loginView.passWordTextField.text.length<6) {
        [ToastView showTopToast:@"密码格式不正确"];
        return;
    }
    [self LoginbtnAction:self.loginView.userNameTextFiled.text andPassword:self.loginView.passWordTextField.text];
}
-(void)LoginbtnAction:(NSString *)phone andPassword:(NSString *)pasword
{
    [HTTPCLIENT loginInWithPhone:phone andPassWord:pasword Success:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
          [self loginSuccessAction];
            APPDELEGATE.userModel=[UserInfoModel userInfoCreatByDic:[responseObject objectForKey:@"data"]];
           APPDELEGATE.ChatHelper=[ChatDemoHelper shareHelper];


            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            NSString *token=APPDELEGATE.userModel.access_token;
//            NSString *uid=APPDELEGATE.userModel.access_id;
            [defaults setObject:token forKey:kACCESS_TOKEN];
            [defaults setObject:phone forKey:@"myphone"];
//            [defaults setObject:uid forKey:kACCESS_ID];
            [defaults synchronize];
//            [APPDELEGATE reloadCompanyInfo];
//            [APPDELEGATE getGchenggongsiInfo];
            //聊天自动登录
                EMError *error2 = [[EMClient sharedClient] loginWithUsername:phone password:@"123456"];
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

            
        }else
        {
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        //NSLog(@"%@",error);
    }];
}
-(void)loginSuccessAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)backBtnAction:(UIButton *)sender
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
