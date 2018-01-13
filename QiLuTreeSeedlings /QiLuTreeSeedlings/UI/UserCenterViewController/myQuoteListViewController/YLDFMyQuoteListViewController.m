//
//  YLDFMyQuoteListViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/13.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFMyQuoteListViewController.h"

@interface YLDFMyQuoteListViewController ()
@property (nonatomic,strong)UIButton *nowBtn;
@end

@implementation YLDFMyQuoteListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.topC.constant=44.f;
    }
    self.vcTitle =@"我的报价";
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)baoJiaBtnAction:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    self.nowBtn.selected=NO;
    sender.selected=YES;
    self.nowBtn=sender;
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
