//
//  YLDSbuyBaseView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 17/1/12.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDSbuyBaseView.h"
#import "UIDefines.h"
@implementation YLDSbuyBaseView
+(YLDSbuyBaseView *)yldSbuyBaseView
{
    YLDSbuyBaseView *view=[[[NSBundle mainBundle]loadNibNamed:@"YLDSbuyBaseView" owner:self options:nil] lastObject];
    UIImage *fenge1image=[YLDSbuyBaseView imageWithSize:view.fengeI.frame.size borderColor:kLineColor borderWidth:1];
    view.fengeI.image=fenge1image;
    return view;
}
+(UIImage*)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth
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
