//
//  YLDTYXMQHomeView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/9/12.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDTYXMQHomeView.h"
#import "UIDefines.h"
#import "YXMQHCVIew.h"
@implementation YLDTYXMQHomeView
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:BGColor];
        NSArray *imageAry=@[@"yxmqHome",@"yxgcgsHome",@"hzdwHome"];
        NSArray *titleAry=@[@"优秀苗企",@"优秀工程公司",@"合作单位"];
        NSArray *colorAry=@[NgreenColor,NavYellowColor,NblueColor];
        
        for (int i=0; i<titleAry.count; i++) {
            YXMQHCVIew *view=[YXMQHCVIew yxMQHCView];
            CGRect frame=view.frame;
            if (i==0) {
                frame.size.width=kWidth/3-10;
                frame.origin.y=5;
                frame.origin.x=kWidth/3*i;
            }
            if (i==2) {
                frame.size.width=kWidth/3-10;
                frame.origin.y=5;
                frame.origin.x=kWidth/3*i+10;
            }
            if (i==1) {
                frame.size.width=kWidth/3+20;
                frame.origin.y=5;
                frame.origin.x=kWidth/3*i-10;
            }
            view.frame=frame;
            [self addSubview:view];
            view.titleLab.text=titleAry[i];
            if (kWidth>320) {
                [view.titleLab setFont:[UIFont systemFontOfSize:16]];
            }
            view.imageV.image=[UIImage imageNamed:imageAry[i]];
            [view.titleLab setTextColor:colorAry[i]];
            view.actionBtn.tag=i+1;
            [view.actionBtn addTarget:self action:@selector(actionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        }
        UIImageView *line1=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth/3-10, 5, 0.5, frame.size.height-10)];
        [line1 setBackgroundColor:kLineColor];
        [self addSubview:line1];
        UIImageView *line2=[[UIImageView alloc]initWithFrame:CGRectMake(kWidth/3*2+10, 5, 0.5, frame.size.height-10)];
        [line2 setBackgroundColor:kLineColor];
        [self addSubview:line2];
        UIImageView *view=[[UIImageView alloc]initWithFrame:CGRectMake(0, frame.size.height-5, kWidth, 5)];
        [view setBackgroundColor:BGColor];
        [self addSubview:view];
        
    }
    return self;
}
-(void)actionWithSender:(UIButton *)sender
{
    if (self.delegate) {
        [self.delegate actionWithTag:sender.tag];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
