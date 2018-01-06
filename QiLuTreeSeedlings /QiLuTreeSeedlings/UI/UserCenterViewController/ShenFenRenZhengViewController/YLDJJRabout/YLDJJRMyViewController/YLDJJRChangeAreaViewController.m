//
//  YLDJJRChangeAreaViewController.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/17.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDJJRChangeAreaViewController.h"

@interface YLDJJRChangeAreaViewController ()<UITextViewDelegate>

@end

@implementation YLDJJRChangeAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vcTitle=@"主营品种";

    self.textView.text=self.pzStr;
    self.textView.delegate=self;
    self.textView.placeholder=@"品种可输入多个，以逗号隔开。";
    [self.textView setFont:[UIFont systemFontOfSize:19]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textViewChanged:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self.textView];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(textViewChanged:)
//                                                 name:UITextViewTextDidChangeNotification
//                                               object:self];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)sureAction:(id)sender {
    if (self.textView.text.length==0) {
        [ToastView showTopToast:@"请输入主营品种"];
        return;
    }
    if (self.delgete) {
        [self.delgete sureWithpzStr:self.textView.text];
    }
    [self.navigationController popViewControllerAnimated:YES];

}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
 
    NSString *lang = [textView.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if ([text isEqualToString:@"，"]||[text isEqualToString:@","])
            {
                NSString *a=textView.text;
                if (a.length>0) {
                    NSString *b = [a substringWithRange:NSMakeRange(a.length-2, 1)];
                    if ([b isEqualToString:@"，"]||[b isEqualToString:@","]) {
                        [ToastView showTopToast:@"不能连续输入，"];
                        
                        return NO;
                        
                    }
                }
                return YES;
                
            }else if([self matchStringFormat:text withRegex:@"^[➋➌➍➎➏➐➑➒a-z\u4e00-\u9fa5]*$"])
            {
                return YES;
                
            }else{
                [ToastView showTopToast:@"只能输入中文和，"];
                return NO;
            }
            
        }else{
            return YES;
        }
    }else{
        [ToastView showTopToast:@"只能输入中文和，"];
        return NO;
    }

    return YES;
}
- (void)textViewChanged:(NSNotification *)obj {
//    BWTextView *textView = (BWTextView *)obj.object;
}

#pragma mark - 正则判断
- (BOOL)matchStringFormat:(NSString *)matchedStr withRegex:(NSString *)regex
{
    //SELF MATCHES一定是大写
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:matchedStr];
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
