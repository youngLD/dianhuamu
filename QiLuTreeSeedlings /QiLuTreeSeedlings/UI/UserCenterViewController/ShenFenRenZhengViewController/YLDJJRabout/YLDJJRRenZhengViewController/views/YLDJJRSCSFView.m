//
//  YLDJJRSCSFView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/5.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDJJRSCSFView.h"

@implementation YLDJJRSCSFView
+(YLDJJRSCSFView *)yldJJRSCSFView
{
    YLDJJRSCSFView *view=[[[NSBundle mainBundle]loadNibNamed:@"YLDJJRSCSFView" owner:self options:nil] firstObject];
    
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
