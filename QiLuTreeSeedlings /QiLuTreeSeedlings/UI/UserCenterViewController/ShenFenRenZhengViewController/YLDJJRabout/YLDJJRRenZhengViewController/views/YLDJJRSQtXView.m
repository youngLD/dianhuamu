//
//  YLDJJRSQtXView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/1.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDJJRSQtXView.h"

@implementation YLDJJRSQtXView
+(YLDJJRSQtXView *)yldJJRSQtXView
{
    YLDJJRSQtXView *view=[[[NSBundle mainBundle]loadNibNamed:@"YLDJJRSQtXView" owner:self options:nil] firstObject];
    view.txImageV.layer.masksToBounds=YES;
    view.txImageV.layer.cornerRadius=25;
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
