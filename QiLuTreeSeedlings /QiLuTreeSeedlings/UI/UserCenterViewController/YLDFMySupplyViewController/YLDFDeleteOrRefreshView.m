//
//  YLDFDeleteOrRefreshView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/2.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "YLDFDeleteOrRefreshView.h"
#import "UIDefines.h"
@implementation YLDFDeleteOrRefreshView
+(YLDFDeleteOrRefreshView *)yldFDeleteOrRefreshView
{
    YLDFDeleteOrRefreshView *view=[[[NSBundle mainBundle]loadNibNamed:@"YLDFDeleteOrRefreshView" owner:self options:nil] firstObject];
    return view;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.centerW.constant=kWidth/3;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
