//
//  YLDJJRhangePheonViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/16.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "ZIKArrowViewController.h"
#import "YLDRangeTextView.h"
@protocol YLDJJRhangePheonViewControllerDelegate <NSObject>

@required

- (void)sureWithphoneStr:(NSString *)Str withType:(NSInteger )type;
@optional

@end
@interface YLDJJRhangePheonViewController : ZIKArrowViewController
@property (weak, nonatomic) IBOutlet YLDRangeTextView *phoneTextField;
@property (nonatomic,copy)NSString *phone;
@property (nonatomic,assign)NSInteger type;
@property (weak,nonatomic)id <YLDJJRhangePheonViewControllerDelegate> delgete;
@end
