//
//  YLDHomeJJRCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/5/31.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDHomeJJRCell.h"
#import "YLDHomeJJRView.h"
#import "UIDefines.h"
#import "UIImageView+AFNetworking.h"

@implementation YLDHomeJJRCell 
-(id)init
{
    self=[super init];
    if (self) {
        double  kkk = kWidth*(12/40.f-0.0417);
        
        double  fff = kWidth*0.0417;
        self.hearView=[[UIView alloc]initWithFrame:CGRectMake(kWidth-50, 5, 50, kkk+70)];

        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(10, 20, 20, kkk+20)];
        lab.textAlignment=NSTextAlignmentCenter;
;
        [lab setFont:[UIFont systemFontOfSize:12]];
        lab.tag=11;
        lab.numberOfLines=0;
        lab.text=@"左滑进入列表";
        [lab setTextColor:MoreDarkTitleColor];
        [self.hearView addSubview:lab];
        
        [self addSubview:self.hearView];
        self.viewAry=[NSMutableArray arrayWithCapacity:10];
        self.frame=CGRectMake(0, 0, kkk, kkk+70);
        self.backscrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 5, kWidth,kkk+70)];
//        [self.backscrollview setBackgroundColor:[UIColor whiteColor]];
        self.backscrollview.delegate=self;
        [self addSubview:self.backscrollview];
        for (int i=0; i<10; i++) {
            UIView *vvvv=[[UIView alloc]initWithFrame:CGRectMake(10+fff*(i-1)+i*kkk, 0, fff, kkk+60)];
            [vvvv setBackgroundColor:[UIColor whiteColor]];
            [self.backscrollview addSubview:vvvv];
            YLDHomeJJRView *view=[YLDHomeJJRView yldHomeJJRView];
            view.frame=CGRectMake(10+fff*i+i*kkk, 0, kkk, kkk+60);
            [_viewAry addObject:view];
            [self.backscrollview addSubview:view];
            view.hidden=YES;
            
        }
        UIView *vvvv=[[UIView alloc]initWithFrame:CGRectMake(10+fff*9+10*kkk, 0, fff, kkk+60)];
        [vvvv setBackgroundColor:[UIColor whiteColor]];
        [self.backscrollview addSubview:vvvv];
        
        [self.backscrollview setContentSize:CGSizeMake(kkk*10+fff*10+10, 0)];
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-10, kWidth, 10)];
        [lineView setBackgroundColor:BGColor];
        [self addSubview:lineView];

        
    }
    
    return self;
}
-(void)actionWithTag:(NSInteger)tag
{
    if (self.delegate) {
        [self.delegate yxmqActionWithTag:tag];
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.x+scrollView.frame.size.width-scrollView.contentSize.width>60) {
        if (self.delegate) {
            [self.delegate jjrListMoreAction];
        }
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x+kWidth-scrollView.contentSize.width>0&&scrollView.contentOffset.x+kWidth-scrollView.contentSize.width<60) {
        self.hearlab.text=@"左滑进入列表";
    }
    if (scrollView.contentOffset.x+kWidth-scrollView.contentSize.width>60) {
        self.hearlab.text=@"松手进入列表";
    }
}
-(void)setModelAry:(NSArray *)modelAry{
    _modelAry=modelAry;
//    [self.backscrollview setContentSize:CGSizeMake(150*modelAry.count+15, 0)];
    for (int i=0; i<modelAry.count; i++) {
        YLDJJrModel *model=modelAry[i];
        if (i<10) {
            YLDHomeJJRView *view=self.viewAry[i];
            view.hidden=NO;
            view.nameLab.text=model.name;

            
            if (model.productNames) {
                 view.zhuyingLab.text=[NSString stringWithFormat:@"主营:%@",model.productNames];
            }else
            {
                view.zhuyingLab.text=@"主营:";
            }
            
           
            view.actionBtn.tag=i;
            [view.actionBtn addTarget:self action:@selector(actionBtn:) forControlEvents:UIControlEventTouchUpInside];
            [view.hicImageV setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"jjrmorenTu.png"]];
        }
    }
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    double  kkk = ([UIScreen mainScreen].bounds.size.width-60)/2.7;
    CGRect tempFrame=self.sqV.frame;
    tempFrame.origin.y=kkk+60+5;
    tempFrame.size.width=kWidth;
    tempFrame.size.height=60;
    self.sqV.frame=tempFrame;
    
}
-(void)actionBtn:(UIButton *)sender
{
    YLDJJrModel *model=_modelAry[sender.tag];
    if (self.delegate) {
        [self.delegate jjrActionWithModel:model];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


@end
