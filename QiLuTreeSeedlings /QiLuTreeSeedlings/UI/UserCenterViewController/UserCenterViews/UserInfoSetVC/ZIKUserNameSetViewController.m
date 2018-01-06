//
//  ZIKUserNameSetViewController.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/3/29.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "ZIKUserNameSetViewController.h"
#define kMaxLength 20
#import "YLDRangeTextField.h"
@interface ZIKUserNameSetViewController ()
{
    YLDRangeTextField *nameTextField;
}
@end

@implementation ZIKUserNameSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.vcTitle  = @"修改姓名";

    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, 64+8, kWidth, 44);
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];

    nameTextField = [[YLDRangeTextField alloc] init];
    nameTextField.rangeNumber=8;
    nameTextField.frame = CGRectMake(15, 7, kWidth-30, 30);
    nameTextField.textAlignment = NSTextAlignmentLeft;
    nameTextField.text = APPDELEGATE.userModel.nickname;
    nameTextField.placeholder=@"请输入修改后的姓名";
    [backView addSubview:nameTextField];

    self.rightBarBtnTitleString=@"保存";
    __weak typeof(self) weakSelf = self;
    self.rightBarBtnBlock = ^{
        [weakSelf btnClick];
    };
}
- (void)btnClick {
    [nameTextField resignFirstResponder];
    if ([ZIKFunction xfunc_check_strEmpty:nameTextField.text]) {
       [ToastView showTopToast:@"姓名为空!!!"];
        return;
    }
    else {
        if([nameTextField.text rangeOfString:@" "].location !=NSNotFound)//_roaldSearchText
        {
            [ToastView showTopToast:@"姓名不能包含空格!!!"];
            return;
        }
        
        [HTTPCLIENT updataUserNormalInfoWithKey:@"nickname" WithValue:nameTextField.text Success:^(id responseObject) {
            if ([[responseObject objectForKey:@"success"] integerValue]) {
                [ToastView showTopToast:@"保存成功"];
                NSDictionary *data=[responseObject objectForKey:@"data"];
                APPDELEGATE.userModel.nickname=data[@"nickname"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)textFieldChanged:(NSNotification *)obj {
    UITextField *textField = (UITextField *)obj.object;

    NSString *toBeString = textField.text;
    //NSString *mylant = [UITextInputMode activeInputModes];
    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxLength) {
                NSLog(@"最多%d个字符!!!",kMaxLength);
                //[XtomFunction openIntervalHUD:[NSString stringWithFormat:@"最多%d个字符",kMaxLength] view:nil];
                textField.text = [toBeString substringToIndex:kMaxLength];
                return;
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{

        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > kMaxLength) {
            //[XtomFunction openIntervalHUD:[NSString stringWithFormat:@"最多%ld个字符",(long)kMaxLength] view:nil];
            NSLog(@"最多%d个字符!!!",kMaxLength);
            textField.text = [toBeString substringToIndex:kMaxLength];
            return;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
