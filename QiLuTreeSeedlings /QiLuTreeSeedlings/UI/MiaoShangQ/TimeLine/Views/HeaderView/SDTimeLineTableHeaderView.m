//
//  SDTimeLineTableHeaderView.m
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/25.
//  Copyright © 2016年 GSD. All rights reserved.
//

/*
 
 *********************************************************************************
 *
 * GSD_WeiXin
 *
 * QQ交流群: 362419100(2群) 459274049（1群已满）
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios/GSD_WeiXin
 * 新浪微博:GSD_iOS
 *
 * 此“高仿微信”用到了很高效方便的自动布局库SDAutoLayout（一行代码搞定自动布局）
 * SDAutoLayout地址：https://github.com/gsdios/SDAutoLayout
 * SDAutoLayout视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * SDAutoLayout用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 *
 *********************************************************************************
 
 */

#import "SDTimeLineTableHeaderView.h"

#import "UIView+SDAutoLayout.h"
#import "UIDefines.h"
@implementation SDTimeLineTableHeaderView

{
    UIImageView *_backgroundImageView;
    UIImageView *_iconView;
    UILabel *_nameLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
//    _backgroundImageView = [UIImageView alloc]initWithFrame:<#(CGRect)#>;
//    [_backgroundImageView setBackgroundColor:NavColor];
////    _backgroundImageView.image = [UIImage imageNamed:@"pbg.jpg"];
//    [self addSubview:_backgroundImageView];
    [self setBackgroundColor:NavSColor];
    _iconView = [UIImageView new];
    _iconView.image = [UIImage imageNamed:@"picon.jpg"];
    _iconView.layer.borderColor = [UIColor whiteColor].CGColor;
    _iconView.layer.borderWidth = 3;
    [self addSubview:_iconView];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-100, 20, 200, 44)];
    _nameLabel.text = @"微苗商";
    _nameLabel.textColor = NavTitleColor;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont boldSystemFontOfSize:NavTitleSize];
    [self addSubview:_nameLabel];
    
    
//    _backgroundImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 40, 0));
//    
//    _iconView.sd_layout
//    .widthIs(70)
//    .heightIs(70)
//    .rightSpaceToView(self, 15)
//    .bottomSpaceToView(self, 20);
//    
//    
//    _nameLabel.tag = 1000;
//    [_nameLabel setSingleLineAutoResizeWithMaxWidth:200];
//    _nameLabel.sd_layout
//    .rightSpaceToView(_iconView, 20)
//    .bottomSpaceToView(_iconView, -35)
//    .heightIs(20);
}


@end
