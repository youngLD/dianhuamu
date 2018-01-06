//
//  YLDFLoginView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/12/5.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDFLoginView.h"

@implementation YLDFLoginView
+(YLDFLoginView *)yldFLoginView
{
    YLDFLoginView *view=[[[NSBundle mainBundle]loadNibNamed:@"YLDFLoginView" owner:self options:nil] firstObject];
    return view;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.userNameTextFiled resignFirstResponder];
    [self.passWordTextField resignFirstResponder];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
