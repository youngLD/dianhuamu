//
//  ZIKPayViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/30.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKPayViewController.h"
#import "ZIKVoucherCenterViewController.h"
#import "ZIKHintTableViewCell.h"
@interface ZIKPayViewController ()
{
    UITextField *nameTextField;
}
@property (nonatomic, strong) NSString *limitPrice;
@end

@implementation ZIKPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self requestLimit];
    self.vcTitle = @"充值";


    UIView *backView         = [[UIView alloc] init];
    backView.frame           = CGRectMake(0, 64+8, kWidth, 44);
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];

    UILabel *label              = [[UILabel alloc] init];
    label.frame                 = CGRectMake(15, 10, 80, 24);
    label.text                  = @"金额(元)";
    [backView addSubview:label];

    nameTextField               = [[UITextField alloc] init];
    nameTextField.frame         = CGRectMake(100, 7, kWidth-30, 30);
    nameTextField.textAlignment = NSTextAlignmentLeft;
    nameTextField.placeholder   = @"请输入充值金额";
    nameTextField.keyboardType = UIKeyboardTypeDecimalPad;
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(textFieldChanged:)
//                                                 name:UITextFieldTextDidChangeNotification
//                                               object:nameTextField];

    [backView addSubview:nameTextField];

    UIButton *button = [[UIButton alloc] init];
    button.frame     = CGRectMake(40, CGRectGetMaxY(backView.frame)+15, kWidth-80, 40);
    button.backgroundColor = yellowButtonColor;
    [button setTitle:@"充值" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    UIView *wareV=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(button.frame)+5, kWidth, 50)];
    UIImageView *iamgeV=[[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 20, 20)];
    [iamgeV setImage:[UIImage imageNamed:@"注意"]];
    [wareV addSubview:iamgeV];
    UILabel *wareLab=[[UILabel alloc]initWithFrame:CGRectMake(33, 0, kWidth-40, 50)];
    [wareLab setFont:[UIFont systemFontOfSize:15]];
    [wareLab setTextAlignment:NSTextAlignmentLeft];
    wareLab.numberOfLines=2;
    [wareLab setTextColor:NavYellowColor];
    wareLab.text=@"友情提示：个人充值和系统赠送的余额只可在APP上使用，不能提现和转账！";
    [wareV addSubview:wareLab];
    [self.view addSubview:wareV];
}

- (void)btnClick {
    [nameTextField resignFirstResponder];
    if ([ZIKFunction xfunc_check_strEmpty:nameTextField.text]) {
        [ToastView showTopToast:@"请输入充值金额"];
        return;
    }
    if (![ZIKFunction xfunc_isAmount:nameTextField.text]) {
        [ToastView showToast:@"充值金额非法,请重新输入" withOriginY:250 withSuperView:self.view];
        return;
    }
    if (nameTextField.text.floatValue <= 0) {
        [ToastView showToast:@"充值金额不能小于零" withOriginY:250 withSuperView:self.view];
        return;
    }
    ZIKVoucherCenterViewController *voucherVC = [[ZIKVoucherCenterViewController alloc] init];
    if (self.type!=0) {
        voucherVC.infoType=self.type;
    }
    voucherVC.price = [NSString stringWithFormat:@"%.2f",nameTextField.text.floatValue];
    
    [self.navigationController pushViewController:voucherVC animated:YES];

}

- (void)requestIsFirstRecharge {

    [HTTPCLIENT isFirstRecharge:nil Success:^(id responseObject) {
        if ([responseObject[@"success"] integerValue] == 1) {
            self.limitPrice = [NSString stringWithFormat:@"%@",responseObject[@"result"]];
            if ( nameTextField.text.floatValue < self.limitPrice.floatValue) {
                [ToastView showTopToast:[NSString stringWithFormat:@"第一次充值金额不能低于%.2f元",self.limitPrice.floatValue]];
                return;
            }
            else {
                ZIKVoucherCenterViewController *voucherVC = [[ZIKVoucherCenterViewController alloc] init];
                voucherVC.price = [NSString stringWithFormat:@"%.2f",nameTextField.text.floatValue];
                
                [self.navigationController pushViewController:voucherVC animated:YES];

            }
        }
        else if ([responseObject[@"success"] integerValue] == 0) {
            [ToastView showToast:[NSString stringWithFormat:@"%@",responseObject[@"msg"]] withOriginY:250 withSuperView:self.view];
        }

    } failure:^(NSError *error) {

    }];
}

- (void)textFieldChanged:(NSNotification *)obj {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
