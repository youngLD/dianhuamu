//
//  YLDSCommentAView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/2/21.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDSCommentAView.h"
#import "UIDefines.h"
@implementation YLDSCommentAView
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:BGColor];
        UIButton *shareBtn=[[UIButton alloc]initWithFrame:CGRectMake(frame.size.width-40, 12.5, 25, 25)];
        [shareBtn setImage:[UIImage imageNamed:@"浮动评论_分享"] forState:UIControlStateNormal];
        self.shareBtn=shareBtn;
        [self addSubview:shareBtn];
        UIButton *collectBtn=[[UIButton alloc]initWithFrame:CGRectMake(frame.size.width-80, 12.5, 25, 25)];
        self.collectBtn=collectBtn;
        [collectBtn setImage:[UIImage imageNamed:@"浮动评论_un收藏"] forState:UIControlStateNormal];
        [collectBtn setImage:[UIImage imageNamed:@"shouchangAction"] forState:UIControlStateSelected];
        [self addSubview:collectBtn];
        UIButton *commentBtn=[[UIButton alloc]initWithFrame:CGRectMake(frame.size.width-120, 12.5, 25, 25)];
        [commentBtn setImage:[UIImage imageNamed:@"浮动评论_评论"] forState:UIControlStateNormal];
        self.commentBtn = commentBtn;
        [self addSubview:commentBtn];
        UILabel *commentNumLab=[[UILabel alloc]initWithFrame:CGRectMake(frame.size.width-103, 11.5, 17, 15)];
        commentNumLab.userInteractionEnabled=YES;
        [commentNumLab setFont:[UIFont systemFontOfSize:12]];
        [commentNumLab setTextColor:[UIColor whiteColor]];
        [commentNumLab setTextAlignment:NSTextAlignmentCenter];
        commentNumLab.layer.masksToBounds=YES;
        commentNumLab.layer.cornerRadius=15/2;
        self.commentNumLab=commentNumLab;
        commentNumLab.hidden=YES;
        [commentNumLab setBackgroundColor:[UIColor redColor]];
        [self addSubview:commentNumLab];
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, kWidth-140, 40)];
        [lab setText:@" 我要发表评论"];
        [lab setTextColor:titleLabColor];
        [lab setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:lab];
        [lab setBackgroundColor:[UIColor whiteColor]];
        lab.layer.masksToBounds=YES;
        lab.layer.cornerRadius=4;
        lab.layer.borderWidth=0.5;
        lab.layer.borderColor=kLineColor.CGColor;
        self.commentLab=lab;
        self.fabiaoBtn=[[UIButton alloc]initWithFrame:lab.frame];
        [self addSubview:self.fabiaoBtn];
    }
    
    return self;
}
-(void)setCommentNum:(NSInteger)commentNum{
    _commentNum = commentNum;
    if (100>commentNum&&commentNum>0) {
        [self.commentNumLab setText:[NSString stringWithFormat:@"%ld",commentNum]];
        self.commentNumLab.hidden=NO;
    }else if(commentNum>99)
    {
        [self.commentNumLab setText:@"99"];
        self.commentNumLab.hidden=NO;
    }else{
        self.commentNumLab.hidden=YES;
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
