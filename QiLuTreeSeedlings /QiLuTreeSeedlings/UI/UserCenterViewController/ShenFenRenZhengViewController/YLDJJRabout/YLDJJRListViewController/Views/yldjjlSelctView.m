//
//  yldjjlSelctView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/8.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "yldjjlSelctView.h"

@implementation yldjjlSelctView
+(yldjjlSelctView *)yldjjlSelctView
{
    yldjjlSelctView *view=[[[NSBundle mainBundle]loadNibNamed:@"yldjjlSelctView" owner:self options:nil] firstObject];
    view.layer.shadowColor = [UIColor grayColor].CGColor;//shadowColor阴影颜色
    view.layer.shadowOffset = CGSizeMake(2,2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    view.layer.shadowOpacity = 0.3;//阴影透明度，默认0
    view.layer.shadowRadius =1.5;
    UIImage *image =view.shuzhongBtn.imageView.image;
    
    UILabel *titleLabel =view.shuzhongBtn.titleLabel;
    
    [view.shuzhongBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, image.size.width)];
    
    [view.shuzhongBtn setImageEdgeInsets:UIEdgeInsetsMake(0, titleLabel.bounds.size.width, 0, -titleLabel.bounds.size.width)];
    UIImage *image2 =view.quyuBtn.imageView.image;
    
    UILabel *titleLabel2 =view.quyuBtn.titleLabel;
    
    [view.quyuBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -image2.size.width, 0, image2.size.width)];
    
    [view.quyuBtn setImageEdgeInsets:UIEdgeInsetsMake(0, titleLabel2.bounds.size.width, 0, -titleLabel2.bounds.size.width)];


    return view;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
