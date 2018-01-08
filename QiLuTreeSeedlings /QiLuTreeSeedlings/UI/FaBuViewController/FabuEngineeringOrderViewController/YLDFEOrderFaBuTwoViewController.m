//
//  YLDFEOrderFaBuTwoViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/8.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFEOrderFaBuTwoViewController.h"

@interface YLDFEOrderFaBuTwoViewController ()<YLDRangeTextViewDelegate>

@end

@implementation YLDFEOrderFaBuTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.miaoMuNameTextField.rangeNumber=20;
    self.miaomuNumTextField.rangeNumber=16;
    self.shuomingTextView.rangeNumber=70;
    self.shuomingTextView.placeholder=@"请输入苗木规格要求（不超过70字）";
    self.shuomingTextView.Rdelegate=self;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)addBtnAction:(UIButton *)sender {
    
}
-(void)textChangeNowLength:(NSInteger)length{
    self.textNumLab.text=[NSString stringWithFormat:@"%ld/70",length];
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
