//
//  YLDjjrJieShaoChangViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/9.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDjjrJieShaoChangViewController.h"

@interface YLDjjrJieShaoChangViewController ()

@end

@implementation YLDjjrJieShaoChangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"自我介绍";
    self.jieshaoTextView.placeholder=@"请输入自我介绍";
    self.jieshaoTextView.text=self.jsstr;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)sureAction:(id)sender {
    if (self.jieshaoTextView.text.length==0) {
        [ToastView showTopToast:@"请输入自我介绍"];
    
        return;
    }
    if (self.delgete) {
        [self.delgete sureWithJieShaoStr:self.jieshaoTextView.text];
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
