//
//  YLDFKeFuViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/9.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFKeFuViewController.h"
#import "YLDFeedbackViewController.h"
@interface YLDFKeFuViewController ()
@property (nonatomic,copy)NSString *phoneStr;
@end

@implementation YLDFKeFuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"客服系统";
    if (@available(iOS 11.0, *)) {
        _topC.constant=64.0;
    }
    [HTTPCLIENT kefuXiTongSuccess:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSDictionary *data=[responseObject objectForKey:@"data"];
            self.nameLab.text=data[@"name"];
            self.phoneLab.text=data[@"phone"];
            self.wxLab.text=data[@"wx"];
            self.phoneStr=data[@"phone"];
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)callBtnAction:(UIButton *)sender {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.phoneStr];
    //NSLog(@"str======%@",[[self.infoDic objectForKey:@"detail"] objectForKey:@"phone"]);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
- (IBAction)yijianBtnAction:(id)sender {
    YLDFeedbackViewController *vc=[YLDFeedbackViewController new];
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
