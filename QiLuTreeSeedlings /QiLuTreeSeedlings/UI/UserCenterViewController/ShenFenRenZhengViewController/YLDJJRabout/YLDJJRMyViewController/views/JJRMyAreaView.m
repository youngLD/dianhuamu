//
//  JJRMyAreaView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/26.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "JJRMyAreaView.h"
#import "ZIKFunction.h"
@implementation JJRMyAreaView
+(JJRMyAreaView *)jjrMyAreaView
{
    JJRMyAreaView *view=[[[NSBundle mainBundle]loadNibNamed:@"JJRMyAreaView" owner:self options:nil] firstObject];
    view.bgImageV.layer.masksToBounds=YES;
    view.bgImageV.layer.cornerRadius=4;
    view.moLab.layer.masksToBounds=YES;
    view.moLab.layer.cornerRadius=4;
    view.layer.masksToBounds=YES;
    view.layer.cornerRadius=4;
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
