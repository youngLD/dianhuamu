//
//  YXMQHCVIew.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/9/12.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YXMQHCVIew.h"

@implementation YXMQHCVIew
+(YXMQHCVIew *)yxMQHCView
{
    YXMQHCVIew *view=[[[NSBundle mainBundle]loadNibNamed:@"YXMQHCVIew" owner:self options:nil] firstObject];
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
