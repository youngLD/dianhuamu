//
//  YLDJJRNotPassViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/22.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDJJRNotPassViewController.h"
#import "YLDJJRenShenQing1ViewController.h"
@interface YLDJJRNotPassViewController ()

@end

@implementation YLDJJRNotPassViewController
- (IBAction)bianjiBtnAction:(id)sender {
    YLDJJRenShenQing1ViewController *vc=[YLDJJRenShenQing1ViewController new];
    
    vc.type=2;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"经纪人认证";
    NSMutableAttributedString *textStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"未通过原因：%@",self.wareStr]];
    
    [textStr addAttribute:NSForegroundColorAttributeName value:NavYellowColor range:NSMakeRange(6, self.wareStr.length)];//从0位置开始的长度为2的红色

    self.notPassLab.attributedText = textStr;
    // Do any additional setup after loading the view from its nib.
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
