//
//  YLDFabuSuccessViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/12/23.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDFabuSuccessViewController.h"
#import "YLDSADViewController.h"
@interface YLDFabuSuccessViewController ()

@end

@implementation YLDFabuSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btn2W.constant=(kWidth-40)/3;
    self.fabuBtn.layer.masksToBounds=YES;
    self.fabuBtn.layer.cornerRadius=20;
    self.yulanBtn.layer.masksToBounds=YES;
    self.yulanBtn.layer.cornerRadius=20;
    self.guanliBtn.layer.masksToBounds=YES;
    self.guanliBtn.layer.cornerRadius=20;
    self.vcTitle=@"发布成功";
    [self.yulanBtn addTarget:self action:@selector(yulanAction) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
}
-(void)yulanAction
{
    YLDSADViewController *vc=[YLDSADViewController new];
    vc.urlString=@"http://m.wap.test.somiao.top:8888/dian/supplyDetails.html";
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)AdministrationBtnAction
{
    if (self.delegate) {
        NSInteger type=0;
        if (self.supplyDic) {
            type=1;
        }else if(self.buyDic) {
            type=2;
        }
        [self.delegate YLfabuSuccessWithAdministrationType:type];
    }
}
-(void)fabuBtnAction
{
    if (self.delegate) {
        NSInteger type=0;
        if (self.supplyDic) {
            type=1;
        }else if(self.buyDic) {
            type=2;
        }
        [self.delegate YLfabuSuccessWithContinueType:type];
    }
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
