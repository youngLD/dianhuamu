//
//  YLDFRealNameViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/4.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "ZIKRightBtnSringViewController.h"
#import "YLDRangeTextField.h"
@interface YLDFRealNameViewController : ZIKRightBtnSringViewController
@property (weak, nonatomic) IBOutlet YLDRangeTextField *nameTextField;
@property (weak, nonatomic) IBOutlet YLDRangeTextField *CareIDTextField;
@property (weak, nonatomic) IBOutlet UIButton *backImageBtn;
@property (weak, nonatomic) IBOutlet UIButton *zhengmianImageBtn;
@property (weak, nonatomic) IBOutlet UIImageView *zhengmianImageV;
@property (weak, nonatomic) IBOutlet UIImageView *beimiamImageV;
@property (weak, nonatomic) IBOutlet UIButton *tijiaoBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topC;
@property (weak, nonatomic) IBOutlet UILabel *resonLab;
@property (nonatomic,copy) NSDictionary *dic;
@end
