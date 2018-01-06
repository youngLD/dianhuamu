//
//  YLDJJRTSView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/17.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDJJRTSView.h"

@implementation YLDJJRTSView
+(void)showAction
{
    YLDJJRTSView *actionBV=[[[NSBundle mainBundle] loadNibNamed:@"YLDJJRTSView" owner:self options:nil] firstObject];
    [actionBV setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    actionBV.frame=[UIScreen mainScreen].bounds;
    actionBV.tag=123456;
    actionBV.sureBtn.layer.masksToBounds=YES;
    actionBV.sureBtn.layer.cornerRadius=actionBV.sureBtn.frame.size.height/2;
    actionBV.alpha = 0;
    [[[UIApplication sharedApplication] keyWindow] addSubview:actionBV];
    [UIView animateWithDuration:0.3 animations:^{
        actionBV.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];

    
}
- (IBAction)sureBtn:(id)sender {
    NSArray *subViews = [[UIApplication sharedApplication] keyWindow].subviews;
    for (id object in subViews) {
        if ([[object class] isSubclassOfClass:[UIView class]]) {
            UIView *actionBView = (UIView *)object;
            if(actionBView.tag == 123456)
            {
                UIImageView *imageView=(UIImageView *)[actionBView viewWithTag:1];
                imageView.animationRepeatCount=1;
                [imageView stopAnimating];
                [UIView animateWithDuration:0.3 animations:^{
                    actionBView.alpha = 0;
                    
                } completion:^(BOOL finished) {
                    [actionBView removeFromSuperview];
                }];
                
            }
        }
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
