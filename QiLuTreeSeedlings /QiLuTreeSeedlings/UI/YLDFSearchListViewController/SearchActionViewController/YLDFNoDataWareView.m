//
//  YLDFNoDataWareView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/19.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFNoDataWareView.h"

@implementation YLDFNoDataWareView
+(YLDFNoDataWareView *)yldFNoDataWareView
{
    YLDFNoDataWareView *view=[[[NSBundle mainBundle]loadNibNamed:@"YLDFNoDataWareView" owner:self options:nil] firstObject];
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
