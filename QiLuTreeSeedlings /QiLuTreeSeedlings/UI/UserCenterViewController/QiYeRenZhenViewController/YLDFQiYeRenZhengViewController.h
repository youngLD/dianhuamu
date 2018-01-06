//
//  YLDFQiYeRenZhengViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/4.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "ZIKRightBtnSringViewController.h"

@interface YLDFQiYeRenZhengViewController : ZIKRightBtnSringViewController
@property (weak, nonatomic) IBOutlet UIButton *zhizhaoIamgeVBtn;
@property (weak, nonatomic) IBOutlet UITextField *qiyeNameTexfField;
@property (weak, nonatomic) IBOutlet UITextField *qiyeAddressTexfField;
@property (weak, nonatomic) IBOutlet UITextField *qiyePersonTexfField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topC;
@property (weak, nonatomic) IBOutlet UILabel *resonLab;
@property (nonatomic,copy) NSDictionary *dic;
@end
