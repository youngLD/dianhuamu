//
//  YLDFTopSearchView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/2.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFTopSearchView.h"
#import "UIDefines.h"
@implementation YLDFTopSearchView
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
+(YLDFTopSearchView *)yldFTopSearchView
{
    YLDFTopSearchView *view=[[[NSBundle mainBundle] loadNibNamed:@"YLDFTopSearchView" owner:self options:nil] firstObject];
    view.layer.masksToBounds=YES;
    view.layer.cornerRadius=33/2;
//    view.textField.clearButtonMode=UITextFieldViewModeWhileEditing;
    return view;
}
-(void)setobss
{
        [self.textField addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
}
-(void)valueChanged:(UITextField *)textField
{
    
    BOOL teBool = [textField isFirstResponder];
    if (!teBool) {
        return;
    }
    NSString *toBeString = textField.text;
    NSInteger kssss=20;
    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            
            if (toBeString.length > kssss) {
                // NSLog(@"最多%d个字符!!!",kMaxLength);
                [ToastView showToast:[NSString stringWithFormat:@"最多%ld个字符",(long)kssss] withOriginY:250 withSuperView:self];
                //[XtomFunction openIntervalHUD:[NSString stringWithFormat:@"最多%d个字符",kMaxLength] view:nil];
                textField.text = [toBeString substringToIndex:kssss];
                if ([self.delegate respondsToSelector:@selector(textFieldChangeVVWithStr:)]) {
                    [self.delegate textFieldChangeVVWithStr:textField.text];
                }
                return;
            }
            if ([self.delegate respondsToSelector:@selector(textFieldChangeVVWithStr:)]) {
                [self.delegate textFieldChangeVVWithStr:textField.text];
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
            [ToastView showToast:[NSString stringWithFormat:@"最多%ld个字符",(long)kssss] withOriginY:250 withSuperView:self];
            textField.text = [toBeString substringToIndex:kssss];
            if ([self.delegate respondsToSelector:@selector(textFieldChangeVVWithStr:)]) {
                [self.delegate textFieldChangeVVWithStr:textField.text];
            }
            return;
        }
        if ([self.delegate respondsToSelector:@selector(textFieldChangeVVWithStr:)]) {
            [self.delegate textFieldChangeVVWithStr:textField.text];
        }
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
