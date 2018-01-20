//
//  YLDFYYSURUView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/18.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFYYSURUView.h"
#import "UIDefines.h"
@implementation YLDFYYSURUView
+(YLDFYYSURUView *)yldFYYSURUView
{
    YLDFYYSURUView *view=[[[NSBundle mainBundle]loadNibNamed:@"YLDFYYSURUView" owner:self options:nil] firstObject];
    view.YYSRBtn.layer.masksToBounds=YES;
    view.YYSRBtn.layer.cornerRadius=15;
    view.YYSRBtn.layer.borderWidth=1;
    view.YYSRBtn.layer.borderColor=kLineColor.CGColor;
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
