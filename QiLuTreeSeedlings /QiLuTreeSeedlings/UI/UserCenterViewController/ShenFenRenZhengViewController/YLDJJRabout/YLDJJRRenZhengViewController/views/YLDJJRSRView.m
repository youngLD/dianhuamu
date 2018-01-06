//
//  YLDJJRSRView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/2.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDJJRSRView.h"

@implementation YLDJJRSRView
+(YLDJJRSRView *)yldJJRSRView
{
    YLDJJRSRView *view=[[[NSBundle mainBundle]loadNibNamed:@"YLDJJRSRView" owner:self options:nil] firstObject];
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
