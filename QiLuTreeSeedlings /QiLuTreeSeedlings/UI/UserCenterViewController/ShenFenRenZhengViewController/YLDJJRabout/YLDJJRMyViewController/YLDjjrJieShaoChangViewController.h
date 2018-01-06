//
//  YLDjjrJieShaoChangViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/9.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "ZIKArrowViewController.h"
#import "YLDRangeTextView.h"
@protocol YLDjjrJieShaoChangViewControllerDelegate <NSObject>

@required

- (void)sureWithJieShaoStr:(NSString *)Str;
@optional

@end

@interface YLDjjrJieShaoChangViewController : ZIKArrowViewController
@property (weak, nonatomic) IBOutlet YLDRangeTextView *jieshaoTextView;
@property (weak,nonatomic)id <YLDjjrJieShaoChangViewControllerDelegate> delgete;
@property (nonatomic,copy) NSString *jsstr;
@end
