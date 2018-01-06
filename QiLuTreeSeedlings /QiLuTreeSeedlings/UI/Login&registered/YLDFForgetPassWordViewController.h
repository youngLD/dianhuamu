//
//  YLDFForgetPassWordViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/12/5.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "ZIKArrowViewController.h"

@interface YLDFForgetPassWordViewController : ZIKArrowViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UIButton *getBtnCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *changePassTypeBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topC;

@end
