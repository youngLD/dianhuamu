//
//  YLDJJRSRView.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/2.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLDRangeTextField.h"
@interface YLDJJRSRView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet YLDRangeTextField *textField;

+(YLDJJRSRView *)yldJJRSRView;
@end
