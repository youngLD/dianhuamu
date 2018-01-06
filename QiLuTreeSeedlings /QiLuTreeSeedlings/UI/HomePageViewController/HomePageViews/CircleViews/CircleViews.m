//
//  CircleViews.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/1/29.
//  Copyright © 2016年 guihuicaifu. All rights reserved.
//

#import "CircleViews.h"
#import "UIDefines.h"

@interface CircleViews ()<UIScrollViewDelegate>
@property (nonatomic,strong) NSArray *dataAry;
//@property (nonatomic,  strong) UIPageControl *pageController;
@end
@implementation CircleViews
@synthesize dataAry;
//@synthesize pageController = _pageController;
-(id)initWithFrame:(CGRect)frame
{
    
    
    self=[super initWithFrame:frame];
    
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:frame];
    [scrollView setContentSize:CGSizeMake(frame.size.width, 0)];
    scrollView.pagingEnabled=YES;
    scrollView.delegate=self;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.showsHorizontalScrollIndicator=NO;
    [self.contentView addSubview:scrollView];
    if (self) {
        
        dataAry =@[@"求购信息",@"供应信息",@"工程订单",@"更多…"];
        NSArray *imageAry=@[@"TB_QiuGouHome",@"TB_GongYingHome",@"TB_GongChengHome",@"TB_MoreHome"];
        [self setBackgroundColor:[UIColor whiteColor]];
        for (int i=0; i<dataAry.count; i++) {
            
            UIView *circV=[self makeCircleViewWtihName:dataAry[i] WithImagName:imageAry[i] WithNum:i];
            [scrollView addSubview:circV];
         }
        CGRect pageFrame = CGRectMake(0, 90, kWidth, 10);
        UIView *viewa = [[UIView alloc] initWithFrame:pageFrame];
        
        [viewa setBackgroundColor:BGColor];
        [self.contentView addSubview:viewa];
        

    }
    return self;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    NSInteger offset = scrollView.contentOffset.x/kWidth;
//    self.pageController.currentPage = offset;

}
-(UIView *)makeCircleViewWtihName:(NSString *)nameStr WithImagName:(NSString *)imagName WithNum:(int)i
{
    int CWith=kWidth/4;
//    int k=i/4;
//    int z=i%4;
    UIView *circleView=[[UIView alloc]initWithFrame:CGRectMake(i*CWith, 0, CWith, 100)];
    UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(circleView.frame.size.width/2-43/2,100/2-35, 43, 43)];
    [imageV setImage:[UIImage imageNamed:imagName]];
    imageV.layer.masksToBounds=YES;
    imageV.layer.cornerRadius=43/2;
    [circleView addSubview:imageV];
    UIButton *circBtn=[[UIButton alloc]initWithFrame:imageV.frame];
    circBtn.tag=i;
    [circBtn addTarget:self action:@selector(circleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [circleView addSubview:circBtn];
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageV.frame)+5, CWith, 20)];
    nameLab.textAlignment=NSTextAlignmentCenter;
    nameLab.text=nameStr;
    [nameLab setTextColor:MoreDarkTitleColor];
    [nameLab setFont:[UIFont systemFontOfSize:16]];
    [circleView addSubview:nameLab];

   

    return circleView;
}

-(void)circleBtnAction:(UIButton *)sender
{
    if (self.delegate) {
        [self.delegate circleViewsPush:sender.tag];
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
