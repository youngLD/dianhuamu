//
//  GBArcView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/8/7.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "GBArcView.h"
#import "UIDefines.h"
@implementation GBArcView
//绘制半圆
- (void)drawRect:(CGRect)rect {
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, kLineColor.CGColor);
    
    
    CGContextSetLineWidth(context, SINGLE_LINE_WIDTH);
    CGContextBeginPath(context);
//    CGFloat lineMargin =self.frame.size.width*0.5f;
    
    //1px线，偏移像素点
    CGFloat pixelAdjustOffset = 0;
    if (((int)(1 * [UIScreen mainScreen].scale) + 1) % 2 == 0) {
        pixelAdjustOffset = SINGLE_LINE_ADJUST_OFFSET;
    }
    
    
    
    
    CGFloat yPos = self.frame.size.width*0.5f - pixelAdjustOffset;
    
    CGFloat xPos = self.frame.size.width*0.5f - pixelAdjustOffset;
    
    CGContextAddArc(context, xPos, yPos, self.frame.size.width*0.5f, M_PI, 0, 0);
    
    
    CGContextStrokePath(context);
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
