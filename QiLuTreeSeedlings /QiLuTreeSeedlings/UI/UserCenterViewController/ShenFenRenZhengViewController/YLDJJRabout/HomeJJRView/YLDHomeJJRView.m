//
//  YLDHomeJJRView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/5/26.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDHomeJJRView.h"
#import "UIDefines.h"
@implementation YLDHomeJJRView
+(YLDHomeJJRView *)yldHomeJJRView
{
    YLDHomeJJRView *view=[[[NSBundle mainBundle]loadNibNamed:@"YLDHomeJJRView" owner:self options:nil] firstObject];
    view.llLab.layer.masksToBounds=YES;
    view.llLab.layer.cornerRadius=2;
    view.layer.masksToBounds=YES;

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
