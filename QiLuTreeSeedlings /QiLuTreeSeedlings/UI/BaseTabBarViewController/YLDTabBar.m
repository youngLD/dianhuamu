//
//  YLDTabBar.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/8/7.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "YLDTabBar.h"
#import "UIDefines.h"
#import "GBArcView.h"
@interface YLDTabBar()

@property (nonatomic,strong) UIButton *addButton;//自定义圆形图片按钮
@property (nonatomic,strong)UIImageView *view;
@property(assign,nonatomic)int index;//UITabBar子view的索引
@end
@implementation YLDTabBar
//绘制横线
- (void)drawRect:(CGRect)rect {
    
    
    //中间的按钮宽度是UItabBar的高度，其他按钮的宽度就是，(self.width-self.height)/4.0
    
    CGFloat buttonW = 0.1;
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, titleLabColor.CGColor);
    
    
    CGContextSetLineWidth(context, SINGLE_LINE_WIDTH);
    CGContextBeginPath(context);
    CGFloat lineMargin =0;
    
    //1PX线，像素偏移
    CGFloat pixelAdjustOffset = 0;
    if (((int)(1 * [UIScreen mainScreen].scale) + 1) % 2 == 0) {
        pixelAdjustOffset = SINGLE_LINE_ADJUST_OFFSET;
    }
    
    
    CGFloat yPos = lineMargin - pixelAdjustOffset;
    
    //第一段线
    CGContextMoveToPoint(context, 0, yPos);
    CGContextAddLineToPoint(context, buttonW*2+SINGLE_LINE_WIDTH*2, yPos);
    CGContextStrokePath(context);
    
    //第二段线
    
    CGContextMoveToPoint(context, 0, yPos);
    CGContextAddLineToPoint(context, self.bounds.size.width, yPos);
    
    CGContextSetStrokeColorWithColor(context, titleLabColor.CGColor);
    CGContextStrokePath(context);
    
    
}

//自定义的按钮点击事件处理，如果点击的点在自定义的按钮中，就返回自定义按钮处理事件。如果不处理，那么按钮只有在UITabrBar 中的 一半可以被点击，有点击事件响应。
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    //判断点是否在按钮上，如果是就让按钮处理事件
    if(CGRectContainsPoint(self.addButton.frame, point)){
        return self.addButton ;
    }
    
    
    
    return  [super hitTest:point withEvent:event];
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds=NO;//不裁剪子控件
        self.index=0;//初始化索引
        [self setBackgroundColor:[UIColor whiteColor]];
        
    }
    return self;
}

//重新初始化方法，从stroyboard 中加载，会调用
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    
    
    if (self = [super initWithCoder:aDecoder]) {
        
        self.backgroundColor=[UIColor whiteColor];
        self.clipsToBounds=NO;//不裁剪子控件
        self.index=0;//初始化索引
        

        
    }
    return self;
}
//自定义按钮的懒加载
-(UIButton *)addButton{
    
    
    if(!_addButton){
        
        
        UIButton *button=[[UIButton alloc] init];
        self.addButton = button;
        [self.addButton setImage:[UIImage imageNamed:@"weimiaoshangY"] forState:UIControlStateNormal];
        [self.addButton addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.addButton];
    }
    
    
    return _addButton;
}
//自定义半圆View的懒加载
-(UIImageView *)view{
    
    
    if(!_view){
        
        CGFloat buttonW = (self.frame.size.width-self.frame.size.height)/4.0;
        
        
        UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(buttonW*2,-7, self.frame.size.height, self.frame.size.height+7)];
        
        
        
        [view setImage:[UIImage imageNamed:@"weimiaoshangBK"]];
   
        
        _view=view;
        
        [self addSubview:view];
        
        
        
    }
    
    
    return _view;
    
}
//重写layoutSubviews，重新排布子View

-(void)layoutSubviews{
    
    self.index=0;
    [super layoutSubviews];
    
    
    
    CGFloat buttonW = kWidth * 0.2 ;//SCREEN_WIDTH * 0.2
    
    for (int i = 0; i < self.subviews.count; i ++) {
        UIView *view = self.subviews[i];
        
        
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            
            CGRect rect=view.frame;
            rect.size.width=buttonW;
            
            rect.size.height=self.frame.size.height;
            rect.origin.y=0;
            if(self.index<2){
                
                rect.origin.x=self.index*buttonW;
                
            }else if(self.index>=2){
                
                rect.origin.x=self.index*buttonW+buttonW;
                
            }
            view.frame =rect;
            
            self.index++;
            
        }
    }
    
    
    
    //懒加载 等所有控件排布后，然后 设置自定义的view，这里注意顺序，先设置背景的半圆view的Frame，然后设置按钮的Frame，否则半圆view会挡住按钮。
    CGRect Vframe=self.view.frame;
    Vframe.size.width = self.frame.size.height;
    Vframe.size.height = self.frame.size.height;
    Vframe.origin.y = -8;
    Vframe.origin.x=2 * (self.frame.size.width-self.frame.size.height)/4.0;
    self.view.frame =Vframe;
    CGRect frame=self.addButton.frame;
    frame.size.width = self.frame.size.height;
    frame.size.height = self.frame.size.height;
    frame.origin.y = -5;
    frame.origin.x = 2 * (self.frame.size.width-self.frame.size.height)/4.0;
    
    self.addButton.frame=frame;
    
}



-(void)setHidden:(BOOL)hidden{
    
    
    [super setHidden:hidden];
    
    
    //手动设置UITabBar 隐藏时，我们要将自定义的按钮和背景隐藏
    [self.view setHidden:hidden];
    
    [self.addButton setHidden:hidden];
    self.addButton.enabled=NO;
    
}
//******核心部分******
//当配置  hidesBottomBarWhenPushed 的viewController ,隐藏UITabBar时，会改变其frame，就是将UITabBar 的Y值设为屏幕最大的y值，就不可见。我们重写这个方法，判断当frame的y小于屏幕的高度 ，那么UITabBar就是被隐藏了，这时候我们将自定的控件隐藏。相反的，我们就显示我们的自定义控件。
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    if(frame.origin.y>=[UIScreen mainScreen].bounds.size.height){
        
        [self.view setHidden:YES];
        
        [self.addButton setHidden:YES];
        self.addButton.enabled=NO;
    }else{
        [self.view setHidden:NO];
        [self.addButton setHidden:NO];
        self.addButton.enabled=YES;
        
    }
}


- (void)addClick
{
    
    //代理点击事件
    if ([self.tabbarDelegate respondsToSelector:@selector(mainTabBarViewDidClick:)]) {
        [self.tabbarDelegate mainTabBarViewDidClick:self];
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
