//
//  yYLDSPingLunSrView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/2/21.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDSPingLunSrView.h"
#import "UIDefines.h"
#define klenght 200
@implementation YLDSPingLunSrView
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
        
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, kHeight-260, kWidth, 260)];
    [self addSubview:backView];
    self.suruBackView=backView;
    BWTextView *textView=[[BWTextView alloc]initWithFrame:CGRectMake(10, 10, kWidth-20, 250)];
        [textView setFont:[UIFont systemFontOfSize:15]];
    [backView addSubview:textView];
    textView.placeholder=@"我要发表评论";
  
    self.textView=textView;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textViewChanged:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:textView];
    [backView setBackgroundColor:BGColor];
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0,backView.frame.size.height-40, kWidth, 40)];
        [bottomView setBackgroundColor:BGColor];
        [backView addSubview:bottomView];
        UILabel *lengthLab=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, 40, 20)];
        [bottomView addSubview:lengthLab];
        [lengthLab setTextColor:[UIColor redColor]];
        [lengthLab setText:[NSString stringWithFormat:@"%d",klenght]];
        self.strLengthLab=lengthLab;
    UIButton *fabiaoBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-95, backView.frame.size.height-35, 80, 30)];
    [backView addSubview:fabiaoBtn];
    [fabiaoBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [fabiaoBtn setBackgroundColor:NavColor];
    [fabiaoBtn setTitle:@"发表评论" forState:UIControlStateNormal];
    [fabiaoBtn addTarget:self action:@selector(fabiaoBtnAcion) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
    }
    return self;
}
-(void)showAction
{
    CGRect r=self.frame;
    r.origin.y=0;
    [UIView animateWithDuration:0.2 animations:^{
        self.frame=r;
    } completion:^(BOOL finished) {
        [self.textView becomeFirstResponder];
    }];
}
-(void)fabiaoBtnAcion
{
 
    if (self.textView.text.length<=0) {
        [ToastView showTopToast:@"请输入评论内容"];
        return;
    }
    if (self.delegate) {
        [self.delegate fabiaoActionWithStr:self.textView.text];
    }
    
}
-(void)clearAvtion
{
    [self tapAction];
    [self.strLengthLab setText:[NSString stringWithFormat:@"%d",klenght]];
    self.textView.text=nil;
    self.huifumodel=nil;
}
- (void)textViewChanged:(NSNotification *)obj {
    BWTextView *textField = (BWTextView *)obj.object;
    NSInteger kssss=klenght;
   
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            
            if (toBeString.length > kssss) {
                // NSLog(@"最多%d个字符!!!",kMaxLength);
                
                //[XtomFunction openIntervalHUD:[NSString stringWithFormat:@"最多%d个字符",kMaxLength] view:nil];
                textField.text = [toBeString substringToIndex:kssss];
                return;
            }else{
               [self.strLengthLab setText:[NSString stringWithFormat:@"%lu",klenght- toBeString.length]];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        
        if (toBeString.length > kssss) {
            //[XtomFunction openIntervalHUD:[NSString stringWithFormat:@"最多%ld个字符",(long)kMaxLength] view:nil];
            //NSLog(@"最多%d个字符!!!",kMaxLength);
          
            textField.text = [toBeString substringToIndex:kssss];
            return;
        }else{
          [self.strLengthLab setText:[NSString stringWithFormat:@"%lu",klenght- toBeString.length]];
        }
    }
}
-(void)tapAction
{
    CGRect r=self.frame;
    r.origin.y = kHeight;
    [UIView animateWithDuration:0.2 animations:^{
        self.frame=r;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
////当键退出时调用
//- (void)keyboardWillHide:(NSNotification *)aNotification{
// CGRect r=self.suruBackView.frame;
//    r.origin.y = kHeight-220;
//    self.suruBackView.frame=r;
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
