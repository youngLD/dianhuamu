//
//  YLDHeZuoDetialGZZView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/22.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDHeZuoDetialGZZView.h"
#import "UIDefines.h"
@implementation YLDHeZuoDetialGZZView
+(YLDHeZuoDetialGZZView *)yldHeZuoDetialGZZView
{
    YLDHeZuoDetialGZZView *view=[[[NSBundle mainBundle]loadNibNamed:@"YLDHeZuoDetialGZZView" owner:self options:nil] lastObject];
    view.backImageV.layer.masksToBounds=YES;
    view.backImageV.layer.cornerRadius=4;
//    CGRect frame=view.frame;
//    frame.size.width=kWidth;
//    view.frame=frame;
//    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 80)];
//    [view setBackgroundColor:[UIColor redColor]];
    return view;
}
-(void)setDic:(NSDictionary *)dic
{
    _dic=dic;
    self.areaLab.text=[NSString stringWithFormat:@"供苗地:%@",dic[@"area"]];
    
//    NSArray *creatTime=[dic[@"createTime"] componentsSeparatedByString:@" "];
    self.numLab.text=[NSString stringWithFormat:@"%@棵(株)",dic[@"quantity"]];
    self.NameLab.text=dic[@"workstationName"];
    self.priceLab.text=[NSString stringWithFormat:@"¥%@",dic[@"price"]];

    self.userNameLab.text=dic[@"chargelPerson"];
    self.backImageV.image=[self imageWithSize:self.backImageV.frame.size borderColor:NavColor borderWidth:0.5];
    [self.callBtn addTarget:self action:@selector(callBtnAction) forControlEvents:UIControlEventTouchUpInside];
}
-(void)callBtnAction
{
    NSString *phoneStr=self.dic[@"phone"];
    if (phoneStr.length>0) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneStr];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else
    {
        [ToastView showTopToast:@"暂无联系方式"];
    }
    
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
