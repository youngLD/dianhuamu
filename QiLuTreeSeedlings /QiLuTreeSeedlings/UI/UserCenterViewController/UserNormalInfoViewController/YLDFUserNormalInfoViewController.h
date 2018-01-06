//
//  YLDFUserNormalInfoViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/12/26.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "ZIKArrowViewController.h"

@interface YLDFUserNormalInfoViewController : ZIKArrowViewController
@property (weak, nonatomic) IBOutlet UIImageView *heardImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UIButton *heardBtn;
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topC;

@end
