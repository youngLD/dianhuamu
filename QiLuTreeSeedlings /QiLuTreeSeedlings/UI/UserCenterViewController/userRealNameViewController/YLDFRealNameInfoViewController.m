//
//  YLDFRealNameInfoViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/6.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFRealNameInfoViewController.h"

@interface YLDFRealNameInfoViewController ()

@end

@implementation YLDFRealNameInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"实名认证";
    if (@available(iOS 11.0, *)) {
        _topC.constant=54.0;
    }
    [HTTPCLIENT getRealNameStateSuccess:^(id responseObject) {
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            NSDictionary *dic=[[responseObject objectForKey:@"data"] objectForKey:@"users"];
            NSString *name=dic[@"name"];
            if (name) {
                NSString *xing=[name substringToIndex:1];
                for (int i=0; i<name.length-1; i++) {
                    [xing stringByAppendingString:@"*"];
                }
                self.nameLab.text=[NSString stringWithFormat:@"真实姓名：%@",xing];
                NSString *idCard=dic[@"idCard"];
                
                if (idCard.length>17) {
                    NSString *fristN=[idCard substringToIndex:5];
                    NSString *lastN=[idCard substringFromIndex:idCard.length-  4];
                    NSString *lidCard=[NSString stringWithFormat:@"身份证号：%@*******%@",fristN,lastN];
                    self.idCardLab.text=lidCard;
                }else
                {
                    self.idCardLab.text=idCard;
                }

            }
            
            
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
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
