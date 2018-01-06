//
//  YLDFQYInfoEditViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/6.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "ZIKRightBtnSringViewController.h"
#import "YLDRangeTextField.h"
@interface YLDFQYInfoEditViewController : ZIKRightBtnSringViewController
@property (weak, nonatomic) IBOutlet YLDRangeTextField *textField;
@property (nonatomic,assign) NSInteger type;
@end
