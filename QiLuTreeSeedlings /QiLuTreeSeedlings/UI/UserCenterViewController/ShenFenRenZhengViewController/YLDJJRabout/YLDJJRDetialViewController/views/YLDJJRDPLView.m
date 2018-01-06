//
//  YLDJJRDPLView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/9.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDJJRDPLView.h"

@implementation YLDJJRDPLView
+(YLDJJRDPLView *)yldJJRDPLView
{
    YLDJJRDPLView *view=[[[NSBundle mainBundle]loadNibNamed:@"YLDJJRDPLView" owner:self options:nil] firstObject];
    view.moreBtn.layer.masksToBounds=YES;
    view.moreBtn.layer.cornerRadius=4;
    view.pinglunBtn.layer.masksToBounds=YES;
    view.pinglunBtn.layer.cornerRadius=4;
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
