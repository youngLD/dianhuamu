//
//  YLDJJRHSQView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/21.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDJJRHSQView.h"
#import "UIDefines.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
@implementation YLDJJRHSQView
+(YLDJJRHSQView *)yldJJRHSQView
{
    YLDJJRHSQView *view=[[[NSBundle mainBundle]loadNibNamed:@"YLDJJRHSQView" owner:self options:nil] firstObject];
    view.shenqingBtn.layer.masksToBounds=YES;
    view.shenqingBtn.layer.cornerRadius=4;
    view.shenqingBtn.layer.borderColor=kLineColor.CGColor;
    view.shenqingBtn.layer.borderWidth=0.5;
    view.youshiBtn.layer.masksToBounds=YES;
    view.youshiBtn.layer.cornerRadius=4;
    view.youshiBtn.layer.borderColor=kLineColor.CGColor;
    view.youshiBtn.layer.borderWidth=0.5;
    [view.youshiBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [view.shenqingBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    return view;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
