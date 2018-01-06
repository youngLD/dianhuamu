//
//  YLDJJRMyViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/6/8.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "ZIKArrowViewController.h"
#import "YLDRangeTextField.h"
#import "YLDRangeTextView.h"
@interface YLDJJRMyViewController : ZIKArrowViewController
@property (weak, nonatomic) IBOutlet UIImageView *txImagV;
@property (weak, nonatomic) IBOutlet YLDRangeTextField *xingmingTextF;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet YLDRangeTextView *ziwojieshaoTextV;
@property (weak, nonatomic) IBOutlet UIButton *quyuBtn;
@property (weak, nonatomic) IBOutlet UIButton *pinzhongBtn;
@property (weak, nonatomic) IBOutlet UIButton *JieshaoBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *chageBtn;
@property (weak, nonatomic) IBOutlet UIView *areaView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *areaVH;
@property (weak, nonatomic) IBOutlet UIButton *bankerNameBtn;
@property (weak, nonatomic) IBOutlet UIButton *bankNumBtn;
@property (weak, nonatomic) IBOutlet UIButton *bankNameBtn;
@end
