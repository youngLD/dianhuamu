//
//  YLDShengjiMMBViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/10/21.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDShengjiMMBViewController.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
#import "ZIKVoucherCenterViewController.h"
#import "MiaoXiaoErXieyiViewController.h"
@interface YLDShengjiMMBViewController ()
@property (nonatomic,strong) UIButton *nextBtn;
@end

@implementation YLDShengjiMMBViewController
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BGColor];
    self.vcTitle=@"升级苗木帮";
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 64, kWidth, 20)];
    [titleLab setFont:[UIFont systemFontOfSize:15]];
    [titleLab setTextColor:MoreDarkTitleColor];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    [titleLab setText:@"苗木帮开通协议"];
    [self.view addSubview:titleLab];
    UITextView *textView=[[UITextView alloc]initWithFrame:CGRectMake(10, 90, kWidth-20, kHeight-90-170)];
    [self.view addSubview:textView];
    [textView setText:@"苗木帮\n\n苗木帮诚信机制（只需缴纳2000元诚信保证金），轻松化解苗木行业信任危机\n与平台客户成交后只缴纳成交额3%的交易佣金\n\n 原来担心宣传花钱没有效果，现在没有效果不花钱！\n我们的宗旨：让苗木生产企业从传统的“宣传模式”转变成“成交模式”\n\n苗木帮用户申请成功，获赠求购信息定制费500元，第一时间查看真实求购信息\n\n大量苗帮订单轻松报价，或直接电话联系采购商\n申请流程\n1、安装点花木点花木成功注册用户，点击苗木帮身份升级，自助支付诚信保证金后，系统显示苗木帮用户诚信保证金金额2000元；\n2、苗木帮用户申请成功后，平台联合诚信保证金2000元一同显示在用户系统上；\n3、苗木帮用户拥有4000元诚信保证金，让苗木帮用户更具诚信力！\n4、苗木帮用户申请成功后，平台赠送500元求购信息定制费马上显示在用户系统上；\n5、申请通过后用户身份马上成为苗木帮，可直接进入苗木帮聊天群和查看苗帮工程订单。"];
    [textView setFont:[UIFont systemFontOfSize:15]];
    [textView setBackgroundColor:[UIColor whiteColor]];
//    textView.userInteractionEnabled=YES;
    textView.editable = NO;
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, kHeight-160, kWidth, 50)];
    [view setBackgroundColor:[UIColor whiteColor]];
    UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 20, 20)];
    [imageV setImage:[UIImage imageNamed:@"支付订单48x48"]];
    [view addSubview:imageV];
    UILabel *xxLab=[[UILabel alloc]initWithFrame:CGRectMake(40, 15, 60, 20)];
    [xxLab setFont:[UIFont systemFontOfSize:14]];
    [xxLab setTextColor:DarkTitleColor];
    [xxLab setText:@"保证金 "];
    [view addSubview:xxLab];
    UILabel *unitLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth-40, 10, 24, 30)];
    [unitLab setTextColor:NavYellowColor];
    [unitLab setText:@"¥"];
    [unitLab setFont:[UIFont systemFontOfSize:22]];
    [view addSubview:unitLab];
    
    UILabel *numLab=[[UILabel alloc]initWithFrame:CGRectMake(kWidth-100, 10, 60, 30)];
    [numLab setText:@"2000"];
    [numLab setTextColor:NavYellowColor];
    [view addSubview:numLab];
    [self.view addSubview:view];
    UILabel *textlab2=[[UILabel alloc]initWithFrame:CGRectMake(40, kHeight-95, 260, 20)];
    [textlab2 setFont:[UIFont systemFontOfSize:13]];
    [self.view addSubview:textlab2];
    [textlab2 setTextColor:MoreDarkTitleColor];
    NSMutableAttributedString *strs = [[NSMutableAttributedString alloc] initWithString:@"我已阅读并同意《苗木帮服务协议》"];
     	[strs addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(7,9)];
    [strs addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(8,7)];
    textlab2.attributedText = strs;
    UIButton *xieyiBtn=[[UIButton alloc]initWithFrame:textlab2.frame];
    [xieyiBtn addTarget:self action:@selector(xieyishowAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:xieyiBtn];
    UIButton *tongyiBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, kHeight-95, 20, 20)];
    [tongyiBtn setImage:[UIImage imageNamed:@"苗圃基地已选择框"] forState:UIControlStateNormal];
    [tongyiBtn setImage:[UIImage imageNamed:@"苗圃基地选择框"] forState:UIControlStateSelected];
    
    [tongyiBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [tongyiBtn addTarget:self
                  action:@selector(tongyiBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tongyiBtn];
    
    UIButton *nextBtn=[[UIButton alloc]initWithFrame:CGRectMake(50, kHeight-60, kWidth-100, 40)];
    [nextBtn setBackgroundColor:NavColor];
    self.nextBtn=nextBtn;
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.view addSubview:nextBtn];
    [nextBtn addTarget:self action:@selector(netxBtnAcion:) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadselfData) name:@"PaySuccessNotification" object:nil];
    [self tongyiBtnAction:tongyiBtn];
//    [self.backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}
//-(void)backAction
//{
//    [self.navigationController popViewControllerAnimated:YES];
//    
//}
-(void)reloadselfData
{
    ShowActionV();
    [APPDELEGATE reloadUserInfoSuccess:^(id responseObject) {
        RemoveActionV();
        if ([[responseObject objectForKey:@"success"] integerValue]) {
            [ToastView showTopToast:@"苗木帮开通成功，即将返回上一页"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
        }
        
    } failure:^(NSError *error) {
        RemoveActionV();
    }];
    
}
-(void)tongyiBtnAction:(UIButton *)sender
{
    sender.selected=!sender.selected;
    if (sender.selected) {
        self.nextBtn.userInteractionEnabled=NO;
        [self.nextBtn setBackgroundColor:[UIColor lightGrayColor]];
    }else{
        self.nextBtn.userInteractionEnabled=YES;
        [self.nextBtn setBackgroundColor:NavColor];
    }
}
-(void)netxBtnAcion:(UIButton *)sender
{
    ZIKVoucherCenterViewController *voucherVC = [[ZIKVoucherCenterViewController alloc] init];
    voucherVC.price = @"2000";
    voucherVC.infoType=3;
    [self.navigationController pushViewController:voucherVC animated:YES];
}
-(void)xieyishowAction
{
    MiaoXiaoErXieyiViewController *vc=[[MiaoXiaoErXieyiViewController alloc]init];
    
    [self presentViewController:vc animated:YES completion:^{
        
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
