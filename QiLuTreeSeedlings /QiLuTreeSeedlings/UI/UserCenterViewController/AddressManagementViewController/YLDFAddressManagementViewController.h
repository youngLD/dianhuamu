//
//  YLDFAddressManagementViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/12/12.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "ZIKRightBtnSringViewController.h"
#import "YLDFAddressModel.h"
#import "YLDRangeTextField.h"
@protocol YLDFAddressManagementDelegate
-(void)addSuccessWithaddressDic:(NSDictionary *)addressdic;
@end
@interface YLDFAddressManagementViewController : ZIKRightBtnSringViewController
@property (weak, nonatomic) IBOutlet YLDRangeTextField *personTextField;
@property (weak, nonatomic) IBOutlet YLDRangeTextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
@property (weak, nonatomic) IBOutlet UISwitch *morenSWBtn;
@property (assign,nonatomic)BOOL isDefault;
@property (nonatomic,strong) YLDFAddressModel *model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topC;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIView *deleteView;
@property (weak,nonatomic)id <YLDFAddressManagementDelegate>delegate;
@end
