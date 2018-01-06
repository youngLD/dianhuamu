//
//  ZIKQiugouMoreShareView.m
//  QiLuTreeSeedlings
//
//  Created by kong on 16/8/3.
//  Copyright © 2016年 中亿科技. All rights reserved.
//

#import "ZIKQiugouMoreShareView.h"
#import "UIDefines.h"
#import "YLDPickTimeView.h"

@interface ZIKQiugouMoreShareView ()<YLDPickTimeDelegate>
@property (nonatomic, strong) NSString *timeInfo;
@end

@implementation ZIKQiugouMoreShareView

+(ZIKQiugouMoreShareView *)instanceShowShareView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"ZIKQiugouMoreShareView" owner:nil options:nil];
    ZIKQiugouMoreShareView *showShareView = [nibView objectAtIndex:0];
    [showShareView initView];
    return showShareView;
}

- (void)initView {
    self.backgroundColor = [UIColor whiteColor];
    self.selectTimeButton.layer.cornerRadius  = 1;
    self.selectTimeButton.layer.masksToBounds = YES;
    self.selectTimeButton.layer.borderWidth   = 0.5;
    self.selectTimeButton.layer.borderColor   = [kLineColor CGColor];
}

- (IBAction)selectTimeButtonClick:(UIButton *)sender {
    YLDPickTimeView *pickTimeView = [[YLDPickTimeView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    pickTimeView.type = @"1";
    pickTimeView.delegate = self;
    pickTimeView.pickerView.maximumDate = [NSDate new];
    pickTimeView.pickerView.minimumDate = nil;
    [pickTimeView showInView];

}

- (IBAction)shareButtonClick:(UIButton *)sender {
    //CLog(@"分享");
    if ([self.delegate respondsToSelector:@selector(sendTimeInfo:)]) {
        [self.delegate sendTimeInfo:self.timeInfo];
    }
}
-(void)timeDate:(NSDate *)selectDate andTimeStr:(NSString *)timeStr
{
    self.timeInfo = timeStr;
    [self.selectTimeButton setTitle:timeStr forState:UIControlStateNormal];
}

@end
