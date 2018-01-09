//
//  YLDFEngineeringMMEidtViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/9.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFEngineeringMMEidtViewController.h"

@interface YLDFEngineeringMMEidtViewController ()<YLDRangeTextViewDelegate>

@end

@implementation YLDFEngineeringMMEidtViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.topC.constant=44.f;
    }
    self.vcTitle=@"树种信息编辑";
    if (self.dic) {
        self.mmNameTextField.text=self.dic[@"itemName"];
        self.mmNumTextField.text = self.dic[@"quantity"];
        self.guigeshuomingTextView.text=self.dic[@"demand"];
        self.textNumLab.text=[NSString stringWithFormat:@"%ld/70",self.guigeshuomingTextView.text.length];
    }
    self.mmNumTextField.rangeNumber=17;
    self.mmNameTextField.rangeNumber=20;
    self.guigeshuomingTextView.rangeNumber=70;
    self.guigeshuomingTextView.Rdelegate=self;
    
    // Do any additional setup after loading the view from its nib.
}
-(void)textChangeNowLength:(NSInteger)length{
    self.textNumLab.text=[NSString stringWithFormat:@"%ld/70",length];
}
- (IBAction)fabuBtnAction:(UIButton *)sender {
    if (self.mmNameTextField.text.length==0) {
        [ToastView showTopToast:@"请输入苗木名称"];
        return;
    }
    if (self.mmNumTextField.text.length==0) {
        [ToastView showTopToast:@"请输入采购数量"];
        return;
    }
    if (self.guigeshuomingTextView.text.length==0) {
        [ToastView showTopToast:@"请输入苗木规格说明"];
        return;
    }
    self.dic[@"itemName"]=self.mmNameTextField.text;
    self.dic[@"quantity"]=self.mmNumTextField.text;
    self.dic[@"demand"]=self.guigeshuomingTextView.text;
    if (self.delegate) {
        [self.delegate mmEditSuccessWithDic:self.dic];
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
