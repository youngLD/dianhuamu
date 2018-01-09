//
//  YLDPickTimeView.m
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 16/6/15.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "YLDPickTimeView.h"
#import "UIDefines.h"
@implementation YLDPickTimeView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7]];
        [self createAddressToolBar:CGRectMake(0, frame.size.height-216-44,
                                              frame.size.width, 44)];
        
        UIDatePicker *datePicker = [ [ UIDatePicker alloc] initWithFrame:CGRectMake(0,frame.size.height-216,frame.size.width,216)];
        self.pickerView=datePicker;
            datePicker.datePickerMode = UIDatePickerModeDate;
        NSDate *mindata=[NSDate new];
        [datePicker setBackgroundColor:[UIColor whiteColor]];
        self.selectDate=mindata;
        [self addSubview:datePicker];
        [ datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
        UITapGestureRecognizer *tapGestureR=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pickerCancel:)];
        [self addGestureRecognizer:tapGestureR];

        self.type = @"0";
        
    }
    return self;
}
-(void)setType:(NSString *)type {
    _type = type;
    if ([type isEqualToString:@"1"]) {
        self.pickerView.datePickerMode  = UIDatePickerModeDateAndTime;
    }
}

- (void)pickerDone:(id)sender
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    if ([self.type isEqualToString:@"1"]) {
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    }
    NSString *timeStr=[formatter stringFromDate:self.selectDate];
    
    if ([self.delegate respondsToSelector:@selector(timeDate:andTimeStr:)]) {
        [self.delegate timeDate:self.selectDate andTimeStr:timeStr];
    }
    [UIView animateWithDuration:0.3f
                     animations:^{
                         [self setAlpha:0];
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
    // APPDELEGATE.showPickerV=nil;
}
-(void)dateChanged:(id)sender{
    UIDatePicker* control = (UIDatePicker*)sender;
    NSDate* _date = control.date;
    self.selectDate=_date;
    /*添加你自己响应代码*/
}
- (void)pickerCancel:(id)sender
{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         [self setAlpha:0];
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
    //  APPDELEGATE.showPickerV=nil;
}
- (void)createAddressToolBar:(CGRect)rect
{
    UIView *pickerDateToolbar = [[UIView alloc] initWithFrame:rect];
   
    [pickerDateToolbar setBackgroundColor:NavColor];
    UIButton *quxiaoBtn=[[UIButton alloc]initWithFrame:CGRectMake(15, 0, 70, rect.size.height)];
    [quxiaoBtn setTitle:@"取消" forState:UIControlStateNormal];
    [quxiaoBtn addTarget:self action:@selector(pickerCancel:) forControlEvents:UIControlEventTouchUpInside];
    [pickerDateToolbar addSubview:quxiaoBtn];
    UIButton *doneBtn=[[UIButton alloc]initWithFrame:CGRectMake(kWidth-85, 0, 70, rect.size.height)];
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(pickerDone:) forControlEvents:UIControlEventTouchUpInside];
    [pickerDateToolbar addSubview:doneBtn];
    [self addSubview:pickerDateToolbar];
}

- (void)showInView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         [self setAlpha:1];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}
-(void)dismiss
{
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
