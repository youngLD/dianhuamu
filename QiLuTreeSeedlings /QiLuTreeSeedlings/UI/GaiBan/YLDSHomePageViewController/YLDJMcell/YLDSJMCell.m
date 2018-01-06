//
//  YLDSJMCell.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/2/14.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDSJMCell.h"
#import "UIDefines.h"
@interface YLDSJMCell ()
@property (nonatomic,strong)UILabel *lab1;
@property (nonatomic,strong)UILabel *lab2;
@property (nonatomic,assign)NSInteger i;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,strong)NSArray *ary;
@end
@implementation YLDSJMCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(YLDSJMCell *)yldSJMCell
{
    YLDSJMCell *cell=[[[NSBundle mainBundle]loadNibNamed:@"YLDSJMCell" owner:self options:nil] lastObject];
    UIImage *imageV=[ZIKFunction imageWithSize:cell.fengeV.frame.size borderColor:kLineColor borderWidth:1];
    cell.fengeV.image=imageV;
    
    UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(140,5, kWidth-160, 50)];
    [lab1 setTextColor:MoreDarkTitleColor];
    [lab1 setBackgroundColor:[UIColor whiteColor]];
    cell.lab1=lab1;
    lab1.userInteractionEnabled=YES;
   
    [cell.contentView addSubview:lab1];
    UILabel *lab2=[[UILabel alloc]initWithFrame:CGRectMake(kWidth,5, kWidth-160, 50)];

    [lab2 setTextColor:MoreDarkTitleColor];
    [lab2 setBackgroundColor:[UIColor whiteColor]];
    cell.lab2=lab2;
    lab2.userInteractionEnabled=YES;
    [cell.contentView addSubview:lab2];
    return cell;
}
-(void)cellActionWithAry:(NSArray *)ary
{
    self.ary=ary;
    self.i=1;
    [_timer invalidate];
    _timer=nil;
    
    if (self.lab1.gestureRecognizers.count<=0) {
        UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnAction:)];
        [self.lab1 addGestureRecognizer:tap1];
        UITapGestureRecognizer *tap2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnAction:)];
            [self.lab2 addGestureRecognizer:tap2];
    }
    if (ary.count>1) {
        NSDictionary *dic1=[self.ary lastObject];
        [self.lab1 setText:dic1[@"company_name"]];
        self.lab1.tag=self.ary.count-1;
        NSDictionary *dic2=self.ary[0];
        [self.lab2 setText:dic2[@"company_name"]];
        self.lab2.tag=0;
        CGRect r2=self.lab2.frame;
        r2.origin.x=kWidth;
        self.lab2.frame=r2;
        if (!_timer) {
           _timer =  [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(function) userInfo:nil repeats:YES];
        }
    }
   
}
-(void)function
{
    if (self.i+2>self.ary.count) {
        self.i=-1;
    }
    [UIView animateWithDuration:0.4 animations:^{
        CGRect r2=self.lab2.frame;
        r2.origin.x=140;
        self.lab2.frame=r2;
    } completion:^(BOOL finished) {
        self.i+=1;
        if (self.i<self.ary.count) {
            NSDictionary *dic1=self.ary[self.i];
            [self.lab1 setText:dic1[@"company_name"]];
            self.lab1.tag=self.i;
        }
        
        if (self.i+2>self.ary.count) {
            NSDictionary *dic2=self.ary[0];
            [self.lab2 setText:dic2[@"company_name"]];
            self.lab2.tag=0;
            CGRect r2=self.lab2.frame;
            r2.origin.x=kWidth;
            self.lab2.frame=r2;
        }else{
            NSDictionary *dic2=self.ary[self.i+1];
            [self.lab2 setText:dic2[@"company_name"]];
            self.lab2.tag=self.i+1;
            CGRect r2=self.lab2.frame;
            r2.origin.x=kWidth;
            self.lab2.frame=r2;
        }
       
    }];
   
}
-(void)btnAction:(UIGestureRecognizer *)sender
{
    if (sender.view.tag <self.ary.count) {
        if (self.delegate) {
            [self.delegate JMActionWithDic:self.ary[sender.view.tag]];
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
