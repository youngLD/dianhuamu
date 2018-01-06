//
//  YLDFOpenOrDeleteView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/2.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFOpenOrDeleteView.h"
@implementation YLDFOpenOrDeleteView
+(YLDFOpenOrDeleteView *)yldFOpenOrDeleteView
{
    YLDFOpenOrDeleteView *view=[[[NSBundle mainBundle]loadNibNamed:@"YLDFOpenOrDeleteView" owner:self options:nil] firstObject];
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
