//
//  YLDHomeMoreView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/8/17.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDHomeMoreView.h"
#import "UIDefines.h"
@implementation YLDHomeMoreView
+(YLDHomeMoreView *)yldHomeMoreView
{
    YLDHomeMoreView *view=[[[NSBundle mainBundle]loadNibNamed:@"YLDHomeMoreView" owner:self options:nil] firstObject];
    
    return view;
    
}
-(id)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth/6-25, 25, 50, 50)];
        [self addSubview:imageV];
        self.ImagView=imageV;
        UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 80, kWidth/3, 22)];
        [titleLab setTextColor:MoreDarkTitleColor];
        [titleLab setTextAlignment:NSTextAlignmentCenter];
        [titleLab setFont:[UIFont systemFontOfSize:18]];
        self.titleLab=titleLab;
        [self addSubview:titleLab];
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, kWidth/3, 120)];
        self.btn=btn;
        [self addSubview:btn];
        UIImageView*imageV1=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth/3-0.5, 0, 0.5, 120)];
        [imageV1 setBackgroundColor:kLineColor];
        [self addSubview:imageV1];
        UIImageView*imageV2=[[UIImageView alloc]initWithFrame:CGRectMake(0, 119.5, kWidth/3, 0.5)];
        [imageV2 setBackgroundColor:kLineColor];
        [self addSubview:imageV2];
    }
    
    return self;
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
