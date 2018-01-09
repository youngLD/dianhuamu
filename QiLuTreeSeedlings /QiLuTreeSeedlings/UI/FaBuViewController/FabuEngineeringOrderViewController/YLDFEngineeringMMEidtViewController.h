//
//  YLDFEngineeringMMEidtViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/9.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "ZIKRightBtnSringViewController.h"
#import "YLDRangeTextField.h"
#import "YLDRangeTextView.h"
@protocol YLDFEngineeringMMEidtViewControllerDelegate
@optional
-(void)mmEditSuccessWithDic:(NSDictionary *)dic;

@end
@interface YLDFEngineeringMMEidtViewController : ZIKRightBtnSringViewController
@property (weak, nonatomic) IBOutlet YLDRangeTextField *mmNameTextField;
@property (weak, nonatomic) IBOutlet YLDRangeTextField *mmNumTextField;
@property (weak, nonatomic) IBOutlet YLDRangeTextView *guigeshuomingTextView;
@property (weak, nonatomic) IBOutlet UILabel *textNumLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topC;
@property (strong,nonatomic)NSMutableDictionary *dic;
@property (nonatomic,weak)id <YLDFEngineeringMMEidtViewControllerDelegate>delegate;
@end
