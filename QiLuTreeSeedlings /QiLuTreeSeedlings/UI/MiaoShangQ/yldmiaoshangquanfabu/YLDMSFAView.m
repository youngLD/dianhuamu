//
//  YLDMSFAView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/5/22.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDMSFAView.h"

@implementation YLDMSFAView
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [imageV setContentMode:UIViewContentModeScaleAspectFill];
        
        imageV.clipsToBounds = YES;
        [self addSubview:imageV];
        self.imageV=imageV;
        UIButton *deleteBtn=[[UIButton alloc]initWithFrame:CGRectMake(frame.size.width-30, 5, 25, 25)];
        [deleteBtn setImage:[UIImage imageNamed:@"delectLiteBtn"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deletebtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteBtn];
    }
    return self;
}
-(void)deletebtnAction
{
    if ([self.delegate respondsToSelector:@selector(deleteimagewithindex:)]) {
        [self.delegate deleteimagewithindex:self.tag];
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
