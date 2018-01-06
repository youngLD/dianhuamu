//
//  YLDSBuyADView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/2/18.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDSBuyADView.h"
#import "UIDefines.h"
@implementation YLDSBuyADView
+(YLDSBuyADView *)yldSBuyADView
{
    YLDSBuyADView *view=[[[NSBundle mainBundle]loadNibNamed:@"YLDSBuyADView" owner:self options:nil] lastObject];
//    [view setBackgroundColor:[UIColor redColor]];
    [view.typeLab setBackgroundColor:kRGB(188, 188, 188, 0.4)];
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
