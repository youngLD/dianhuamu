//
//  YLDFEOrderFaBuOneViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/8.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "ZIKRightBtnSringViewController.h"
#import "YLDRangeTextField.h"
#import "YLDRangeTextView.h"
@interface YLDFEOrderFaBuOneViewController : ZIKRightBtnSringViewController
@property (weak, nonatomic) IBOutlet YLDRangeTextField *nameTextField;
@property (weak, nonatomic) IBOutlet YLDRangeTextView *shuomingTextView;
@property (weak, nonatomic) IBOutlet UILabel *textNumLab;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLab;
@property (weak, nonatomic) IBOutlet UIButton *pickTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *shangchejiaBtn;
@property (weak, nonatomic) IBOutlet UIButton *daohuajiaBtn;
@property (weak, nonatomic) IBOutlet UIImageView *LineImageV;
@property (weak, nonatomic) IBOutlet UIButton *miaomiaojiaBtn;
@property (weak, nonatomic) IBOutlet UILabel *personLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIButton *selectAddressBtn;
@property (weak, nonatomic) IBOutlet UIView *addBGV;
@property (weak, nonatomic) IBOutlet UIImageView *addAddImageV;
@property (weak, nonatomic) IBOutlet UIButton *addAdressBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topC;

@end
