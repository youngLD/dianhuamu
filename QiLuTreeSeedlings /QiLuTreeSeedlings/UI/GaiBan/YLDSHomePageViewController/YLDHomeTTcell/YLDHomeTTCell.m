//
//  YLDHomeTTCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/2/3.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDHomeTTCell.h"
#import "UIDefines.h"
#import "YLDZBLmodel.h"
#import "YLDZXLmodel.h"
@interface YLDHomeTTCell ()
@property (nonatomic,strong)UILabel *lab1;
@property (nonatomic,strong)UILabel *lab2;
@property (nonatomic,strong)UIView *zxView1;
@property (nonatomic,strong)UIView *zxView2;
@property (nonatomic,strong)NSArray *zbAry;
@property (nonatomic,assign)NSInteger zbi;
@property (nonatomic,strong)NSArray *zxAry;
@property (nonatomic,assign)NSInteger zxi;
@property (nonatomic,weak)UIButton *zxbtn1;
@property (nonatomic,weak)UIButton *zxbtn2;
@property (nonatomic,weak)UIButton *zxbtn3;
@property (nonatomic,weak)UIButton *zxbtn4;
@end
@implementation YLDHomeTTCell
+(YLDHomeTTCell *)yldHomeTTCell
{
    YLDHomeTTCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDHomeTTCell" owner:self options:nil] lastObject];
    UIImageView *iamgV=[[UIImageView alloc]initWithFrame:CGRectMake(23, 39, 42, 42)];
    [iamgV setImage:[UIImage imageNamed:@"苗商-头条"]];
    [cell addSubview:iamgV];
    UIButton *msnewsBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 120)];
    cell.msnewsBtn =msnewsBtn;
    [cell.contentView addSubview:msnewsBtn];
    return cell;
}
-(void)celllll
{
    UIImage *fenge1image=[self imageWithSize:self.fgImagV1.frame.size borderColor:kLineColor borderWidth:1];
    self.fgImagV1.image=fenge1image;
    UIImage *fenge2image=[self imageWithSize:self.fgImageV2.frame.size borderColor:kLineColor borderWidth:1];
    self.fgImageV2.image=fenge2image;
    UIView *zbMoveView=[[UIView alloc]initWithFrame:CGRectMake(55, 10, kWidth-70-90, 25)];
    zbMoveView.clipsToBounds=YES;
    [self.zhaobiaoV addSubview:zbMoveView];
    UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWidth-65-90, 25)];
    lab1.text=@"";
//    [lab1 setFont:[UIFont systemFontOfSize:19]];
    self.lab1=lab1;
    [lab1 setTextColor:MoreDarkTitleColor];
    [zbMoveView addSubview:lab1];
    UILabel *lab2=[[UILabel alloc]initWithFrame:CGRectMake(0, 25, kWidth-65-90, 25)];
    lab2.text=@"";
    self.lab2=lab2;
//    [lab1 setFont:[UIFont systemFontOfSize:19]];
    [lab2 setTextColor:MoreDarkTitleColor];
    [zbMoveView addSubview:lab2];
    UIButton *zbBtn=[[UIButton alloc]initWithFrame:zbMoveView.bounds];
    [zbBtn addTarget:self action:@selector(zbBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [zbMoveView addSubview:zbBtn];
    
    UIView *zxMoveView=[[UIView alloc]initWithFrame:CGRectMake(10, 5.5, kWidth-25-90, 64)];
    zxMoveView.clipsToBounds=YES;
    [self.newsV addSubview:zxMoveView];
    self.zxView1 =[[UIView alloc]initWithFrame:zxMoveView.bounds];
    self.zxView2 =[[UIView alloc]initWithFrame:CGRectMake(0, 64,zxMoveView.bounds.size.width, zxMoveView.bounds.size.height)];
    UILabel *zxlabx1=[[UILabel alloc]initWithFrame:CGRectMake(3.5, 9, 36, 18)];
    [zxlabx1 setTextColor:[UIColor whiteColor]];
    zxlabx1.tag=11;
    [zxlabx1 setFont:[UIFont systemFontOfSize:14]];
    [zxlabx1 setTextAlignment:NSTextAlignmentCenter];
    [zxlabx1 setBackgroundColor:kRGB(254, 192, 86, 1)];
    [self.zxView1 addSubview:zxlabx1];
    
    UILabel *zxlab1=[[UILabel alloc]initWithFrame:CGRectMake(45, 9, kWidth-65-90, 18)];
    zxlab1.tag=1;
    
    [zxlab1 setTextColor:MoreDarkTitleColor];
    [self.zxView1 addSubview:zxlab1];
    UIButton *zxbtn1=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, kWidth-25-90, 32)];
    self.zxbtn1=zxbtn1;
    [zxbtn1 addTarget:self action:@selector(zxBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.zxView1 addSubview:zxbtn1];
    
    UILabel *zxlabx2=[[UILabel alloc]initWithFrame:CGRectMake(3.5, 36, 36, 18)];
    [zxlabx2 setTextColor:[UIColor whiteColor]];
    zxlabx2.tag=22;
    [zxlabx2 setBackgroundColor:kRGB(49, 186, 233, 1)];
    [zxlabx2 setFont:[UIFont systemFontOfSize:14]];
    [zxlabx2 setTextAlignment:NSTextAlignmentCenter];
    [self.zxView1 addSubview:zxlabx2];
    UILabel *zxlab2=[[UILabel alloc]initWithFrame:CGRectMake(45, 36, kWidth-65-90, 18)];
    zxlab2.tag=2;
    zxlab2.userInteractionEnabled=YES;
    [zxlab2 setTextColor:MoreDarkTitleColor];
    [self.zxView1 addSubview:zxlab2];
    UIButton *zxbtn2=[[UIButton alloc]initWithFrame:CGRectMake(0, 32, kWidth-25-90, 32)];
    self.zxbtn2=zxbtn2;
    [zxbtn2 addTarget:self action:@selector(zxBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.zxView1 addSubview:zxbtn2];
    UILabel *zxlabx3=[[UILabel alloc]initWithFrame:CGRectMake(3.5, 9, 36, 18)];
    [zxlabx3 setTextColor:[UIColor whiteColor]];
    [zxlabx3 setFont:[UIFont systemFontOfSize:14]];
    [zxlabx3 setTextAlignment:NSTextAlignmentCenter];
    [zxlabx3 setBackgroundColor:kRGB(254, 192, 86, 1)];
    zxlabx3.tag=33;
    [self.zxView2 addSubview:zxlabx3];
    UILabel *zxlab3=[[UILabel alloc]initWithFrame:CGRectMake(45, 9, kWidth-65-90, 18)];
    zxlab3.tag=3;
    
    [zxlab3 setTextColor:MoreDarkTitleColor];
    [self.zxView2 addSubview:zxlab3];
//    UIButton *zxbtn3=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, kWidth-25-90, 32)];
//    self.zxbtn3=zxbtn3;
//    [zxbtn3 addTarget:self action:@selector(zxBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.zxView2 addSubview:zxbtn3];
    
    UILabel *zxlabx4=[[UILabel alloc]initWithFrame:CGRectMake(3.5, 36, 36, 18)];
    [zxlabx4 setTextColor:[UIColor whiteColor]];
    zxlabx4.tag=44;
    [zxlabx4 setBackgroundColor:kRGB(49, 186, 233, 1)];
    [zxlabx4 setFont:[UIFont systemFontOfSize:14]];
    [zxlabx4 setTextAlignment:NSTextAlignmentCenter];
    [self.zxView2 addSubview:zxlabx4];
    UILabel *zxlab4=[[UILabel alloc]initWithFrame:CGRectMake(45, 36, kWidth-65-90, 18)];
    zxlab4.tag=4;
    
    [zxlab4 setTextColor:MoreDarkTitleColor];
    [self.zxView2 addSubview:zxlab4];
//    UIButton *zxbtn4=[[UIButton alloc]initWithFrame:CGRectMake(0, 32, kWidth-25-90, 32)];
//    self.zxbtn4=zxbtn4;
//    [zxbtn4 addTarget:self action:@selector(zxBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.zxView2 addSubview:zxbtn4];
    [zxMoveView addSubview:self.zxView1];
    [zxMoveView addSubview:self.zxView2];
}
-(void)cellActionWithZBAry:(NSArray *)zbary withZXAry:(NSArray *)zxary
{
    self.zbAry=zbary;
    self.zbi=1;
    self.zxAry=zxary;
    self.zxi=0;
    [_timer invalidate];
    _timer=nil;
    [_timer2 invalidate];
    _timer2=nil;
    if (zbary.count>1) {
        
        if (!_timer) {
            YLDZBLmodel *model1=self.zbAry[_zbi-1];
            YLDZBLmodel *model2=self.zbAry[_zbi];
            self.lab1.text=model1.title;
            self.lab2.text=model2.title;
            _timer =  [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(function) userInfo:nil repeats:YES];
        }
     
    }
    if (_zxAry.count>2) {
        
        if (!_timer2) {
            YLDZXLmodel *model1=self.zxAry[_zxAry.count-2];
            
            self.zxbtn1.tag=100;
            UILabel *lab1=[self.zxView1 viewWithTag:1];
            lab1.text=model1.title;
            UILabel *labx1=[self.zxView1 viewWithTag:11];
            labx1.text=model1.articleCategoryShortName;
            YLDZXLmodel *model2=[self.zxAry lastObject];
            self.zxbtn2.tag=1+100;
            UILabel *lab2=[self.zxView1 viewWithTag:2];
            lab2.text=model2.title;
            UILabel *labx2=[self.zxView1 viewWithTag:22];
            labx2.text=model2.articleCategoryShortName;
            if (_zxAry.count>=4) {
                YLDZXLmodel *model3=self.zxAry[0];
                self.zxbtn3.tag=_zxi+100;
                UILabel *lab3=[self.zxView2 viewWithTag:3];
                lab3.text=model3.title;
                UILabel *labx3=[self.zxView2 viewWithTag:33];
                labx3.text=model3.articleCategoryShortName;
                YLDZXLmodel *model4=self.zxAry[1];
                self.zxbtn4.tag=_zxi+1+100;
                UILabel *lab4=[self.zxView2 viewWithTag:4];
                lab4.text=model4.title;
                UILabel *labx4=[self.zxView2 viewWithTag:44];
                labx4.text=model4.articleCategoryShortName;
                _zxi=2;
            }
           
            _timer2 =  [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(function2) userInfo:nil repeats:YES];
        }
        
    }
    if (zbary.count==1) {
        YLDZBLmodel *model=[self.zbAry firstObject];
        self.lab1.text=model.title;
    }
    
}
-(void)function
{
    if (self.zbi+2>self.zbAry.count) {
        self.zbi=0;
    }
    [UIView animateWithDuration:0.4 animations:^{
        CGRect r1=self.lab1.frame;
        CGRect r2=self.lab2.frame;
        r1.origin.y=-25;
        r2.origin.y=0;
        self.lab1.frame=r1;
        self.lab2.frame=r2;
    } completion:^(BOOL finished) {
        self.zbi++;
//        NSLog(@"zbi  %ld",self.zbi);
        YLDZBLmodel *model1=self.zbAry[_zbi-1];
        
        self.lab1.text=model1.title;
        if (self.zbi+2>self.zbAry.count) {
            YLDZBLmodel *model2=self.zbAry[0];
            
            self.lab2.text=model2.title;
        }else{
            YLDZBLmodel *model2=self.zbAry[_zbi];
            self.lab2.text=model2.title;
        }
        CGRect r1=self.lab1.frame;
        CGRect r2=self.lab2.frame;
        r1.origin.y=0;
        r2.origin.y=25;
        self.lab1.frame=r1;
        self.lab2.frame=r2;
    }];

}
-(void)function2
{
    if (self.zxi+3>self.zxAry.count) {
        self.zxi=0;
    }
    [UIView animateWithDuration:0.4 animations:^{
        CGRect r1=self.zxView1.frame;
        CGRect r2=self.zxView2.frame;
        r1.origin.y=-64;
        r2.origin.y=0;
        self.zxView1.frame=r1;
        self.zxView2.frame=r2;
    } completion:^(BOOL finished) {
        self.zxi+=2;
        YLDZXLmodel *model1=self.zxAry[self.zxi-2];
//        NSLog(@"zxi  %ld",self.zxi);
        self.zxbtn1.tag=self.zxi-2+100;
        UILabel *lab1=[self.zxView1 viewWithTag:1];
        lab1.text=model1.title;
        UILabel *labx1=[self.zxView1 viewWithTag:11];
        labx1.text=model1.articleCategoryShortName;
        YLDZXLmodel *model2=self.zxAry[self.zxi-1];
        self.zxbtn2.tag=_zxi-1+100;
        UILabel *lab2=[self.zxView1 viewWithTag:2];
        lab2.text=model2.title;
        UILabel *labx2=[self.zxView1 viewWithTag:22];
        labx2.text=model2.articleCategoryShortName;
        if (self.zxi+3>self.zxAry.count) {
            YLDZXLmodel *model3=self.zxAry[0];
            self.zxbtn3.tag=100;
            UILabel *lab3=[self.zxView2 viewWithTag:3];
            lab3.text=model3.title;
            UILabel *labx3=[self.zxView2 viewWithTag:33];
            labx3.text=model3.articleCategoryShortName;
            YLDZXLmodel *model4=self.zxAry[1];
            self.zxbtn4.tag=101;
            UILabel *lab4=[self.zxView2 viewWithTag:4];
            lab4.text=model4.title;
            UILabel *labx4=[self.zxView2 viewWithTag:44];
            labx4.text=model4.articleCategoryShortName;
        }else{
            YLDZXLmodel *model3=self.zxAry[_zxi];
            self.zxbtn3.tag=_zxi+100;
            UILabel *lab3=[self.zxView2 viewWithTag:3];
            lab3.text=model3.title;
            UILabel *labx3=[self.zxView2 viewWithTag:33];
            labx3.text=model3.articleCategoryShortName;
            YLDZXLmodel *model4=self.zxAry[_zxi+1];
            self.zxbtn4.tag=_zxi+1+100;
            UILabel *lab4=[self.zxView2 viewWithTag:4];
            lab4.text=model4.title;
            UILabel *labx4=[self.zxView2 viewWithTag:44];
            labx4.text=model4.articleCategoryShortName;
        }

        CGRect r1=self.zxView1.frame;
        CGRect r2=self.zxView1.frame;
        r1.origin.y=0;
        r2.origin.y=64;
        self.zxView1.frame=r1;
        self.zxView2.frame=r2;
    }];
    
}
- (UIImage*)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [[UIColor clearColor] set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGFloat lengths[] = {1, 0.2};
    CGContextSetLineDash(context, 0, lengths, 1);
    CGContextMoveToPoint(context, 0.0, 0.0);
    CGContextAddLineToPoint(context, size.width, 0.0);
    CGContextAddLineToPoint(context, size.width, size.height);
    CGContextAddLineToPoint(context, 0, size.height);
    CGContextAddLineToPoint(context, 0.0, 0.0);
    CGContextStrokePath(context);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)zbBtnAction
{
    if (_zbAry.count==0) {
        return;
    }
    YLDZBLmodel *model;
    if (self.zbi==0) {
        model=[self.zbAry lastObject];
    }else{
        model=self.zbAry[self.zbi-1];
    }
    if (self.delegate) {
        [self.delegate zbActionWithzbModel:model];
    }
}
-(void)zxBtnAction:(UIButton *)sender
{
    NSInteger i=sender.tag-100;
    YLDZXLmodel *model =self.zxAry[i];
    if (self.delegate) {
        [self.delegate zxActionWithzxModel:model];
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
