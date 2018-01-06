//
//  YLDJJRChangeAreaViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/17.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "ZIKArrowViewController.h"
#import "BWTextView.h"
@protocol YLDJJRChangeAreaViewControllerDelegate <NSObject>

@required

- (void)sureWithpzStr:(NSString *)Str;
@optional

@end
@interface YLDJJRChangeAreaViewController : ZIKArrowViewController
@property (weak, nonatomic) IBOutlet BWTextView *textView;
@property (nonatomic,copy)NSString *pzStr;
@property (weak,nonatomic)id <YLDJJRChangeAreaViewControllerDelegate> delgete;
@end
