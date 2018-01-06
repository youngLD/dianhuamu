//
//  YLDFQiYeInfoViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/6.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFQiYeInfoViewController.h"
#import "YLDFQYInfoEditViewController.h"
@interface YLDFQiYeInfoViewController ()

@end

@implementation YLDFQiYeInfoViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.nameLab.text =APPDELEGATE.qyModel.name;
    self.addressLab.text=APPDELEGATE.qyModel.address;
    self.personLab.text=APPDELEGATE.qyModel.linkman;
    self.phoneLab.text=APPDELEGATE.qyModel.contactInformation;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle = @"企业资料";
    if (@available(iOS 11.0, *)) {
        _topC.constant=44.0;
    }

    // Do any additional setup after loading the view from its nib.
}
- (IBAction)selectBtnAction:(UIButton *)sender {
    YLDFQYInfoEditViewController *vc=[YLDFQYInfoEditViewController new];
    vc.type=sender.tag;
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
