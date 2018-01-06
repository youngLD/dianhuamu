//
//  YLDSPinDaoViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/4/11.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDSPinDaoViewController.h"
#import "UIDefines.h"
@interface YLDSPinDaoViewController ()

@end

@implementation YLDSPinDaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BGColor];
    
    UIButton *backBtn =[[UIButton alloc]initWithFrame:CGRectMake(kWidth-35, 32, 20, 20)];
    [backBtn setEnlargeEdgeWithTop:10 right:10 bottom:20 left:30];
    [backBtn setImage:[UIImage imageNamed:@"zidingyiguanbi"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(10, 90, 100, 20)];
    [lab setTextColor:DarkTitleColor];
    [lab setText:@"我的频道"];
    [self.view addSubview:lab];
    for (int i=0; i<self.classAry.count; i++) {
        int zz=i%4;
        int xx=i/4;
        NSDictionary *dic=self.classAry[i];
        CGFloat www=(kWidth-35)/4;
        UIButton *btn=[self btnWithTag:i WithX:10+(www+5)*zz withY:120+xx*40 WithTitle:dic[@"name"] withW:www];
        [self.view addSubview:btn];
    }
}

-(UIButton *)btnWithTag:(NSInteger)tag WithX:(CGFloat)x withY:(CGFloat)Y WithTitle:(NSString *)title withW:(CGFloat)width
{
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(x, Y, width, 35)];
    [btn setTitleColor:DarkTitleColor forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    btn.tag=tag;
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.layer.borderWidth=0.5;
    btn.layer.borderColor=kLineColor.CGColor;
    return btn;
}
-(void)backBtnAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
