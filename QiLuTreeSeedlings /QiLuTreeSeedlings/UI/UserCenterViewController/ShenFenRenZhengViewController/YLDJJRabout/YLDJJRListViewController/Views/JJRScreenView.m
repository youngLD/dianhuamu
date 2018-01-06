//
//  JJRScreenView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/27.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "JJRScreenView.h"
#import "UIDefines.h"
#import "UIButton+ZIKEnlargeTouchArea.h"
@interface JJRScreenView ()<YLDPickLocationDelegate>
@property (nonatomic,copy)NSString *areaCode;
@end
@implementation JJRScreenView
+(JJRScreenView *)jjrScreenView
{
    JJRScreenView *view=[[[NSBundle mainBundle]loadNibNamed:@"JJRScreenView" owner:self options:nil] firstObject];
    CGRect tempframe=view.frame;
    tempframe.origin.x=kWidth;
    tempframe.origin.y=0;
    tempframe.size.width=kWidth;
    tempframe.size.height=kHeight;
    view.frame=tempframe;
    [view.backBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:40];    return view;
}
-(void)showView
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect tempframe=self.frame;
        tempframe.origin.x=0;
        self.frame=tempframe;
    }];
}
-(void)dismissView
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect tempframe=self.frame;
        tempframe.origin.x=kWidth;
        self.frame=tempframe;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (IBAction)backBtnAction:(UIButton *)sender {
    [self dismissView];
}
- (IBAction)areaBtnAction:(UIButton *)sender {
    YLDPickLocationView *pickLocationV=[[YLDPickLocationView alloc]initWithFrame:[UIScreen mainScreen].bounds CityLeve:CityLeveShi];
    pickLocationV.delegate=self;
    [self.nameTextField resignFirstResponder];
    [pickLocationV showPickView];
}
- (IBAction)cleanBtnAction:(id)sender {
    self.areaCode=nil;
    self.nameTextField.text=nil;
    [self.areaBtn setTitle:@"请选择地区" forState:UIControlStateNormal];
}
- (IBAction)actionBtnAction:(id)sender {
    if (self.delegate) {
        [self.delegate screenActionWithAreaCode:self.areaCode WithName:self.nameTextField.text];
        [self dismissView];
    }
}

-(void)selectSheng:(CityModel *)sheng shi:(CityModel *)shi xian:(CityModel *)xian zhen:(CityModel *)zhen
{
    NSString *namestr=nil;
    if (sheng.code) {
        namestr=sheng.cityName;
        self.areaCode=sheng.code;
    }else{
        return;
    }
    
    if (shi.code) {
        namestr=shi.cityName;
        self.areaCode=shi.code;
    }
    [self.areaBtn setTitle:namestr forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
