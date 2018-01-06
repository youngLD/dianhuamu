//
//  YLDJJRhangePheonViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/16.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDJJRhangePheonViewController.h"

@interface YLDJJRhangePheonViewController ()

@end

@implementation YLDJJRhangePheonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.type==0) {
        self.vcTitle=@"修改手机号";
        //    self..placeholder=@"请输入自我介绍";
        self.phoneTextField.text=self.phone;
        self.phoneTextField.rangeNumber=11;
        self.phoneTextField.placeholder=@"修改手机号";
    }
    if (self.type==1) {
        self.vcTitle=@"修改开户人姓名";
        //    self..placeholder=@"请输入自我介绍";
        self.phoneTextField.text=self.phone;
        self.phoneTextField.rangeNumber=5;
        self.phoneTextField.keyboardType=UIKeyboardTypeDefault;
        self.phoneTextField.placeholder=@"请输入开户人姓名";
    }
    if (self.type==2) {
        self.vcTitle=@"修改银行卡号";
        //    self..placeholder=@"请输入自我介绍";
        self.phoneTextField.text=self.phone;
        self.phoneTextField.rangeNumber=19;
        self.phoneTextField.keyboardType=UIKeyboardTypeNumberPad;
        self.phoneTextField.placeholder=@"请输入银行卡号";
    }
    if (self.type==3) {
        self.vcTitle=@"修改开户行名称";
        //    self..placeholder=@"请输入自我介绍";
        self.phoneTextField.text=self.phone;
        self.phoneTextField.rangeNumber=250;
        self.phoneTextField.keyboardType=UIKeyboardTypeDefault;
        self.phoneTextField.placeholder=@"请输入开户行名称";
    }

    // Do any additional setup after loading the view from its nib.
}
- (IBAction)sureAction:(id)sender {
    if (self.phoneTextField.text.length==0) {
        [ToastView showTopToast:@"请输入手机号"];
        
        return;
    }
    if (self.delgete) {
        [self.delgete sureWithphoneStr:self.phoneTextField.text withType:self.type];
    }
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
