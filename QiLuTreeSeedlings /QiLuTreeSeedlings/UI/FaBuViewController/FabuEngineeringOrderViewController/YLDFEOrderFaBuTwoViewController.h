//
//  YLDFEOrderFaBuTwoViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/8.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "ZIKRightBtnSringViewController.h"
#import "YLDRangeTextView.h"
#import "YLDRangeTextField.h"
@interface YLDFEOrderFaBuTwoViewController : ZIKRightBtnSringViewController
@property (weak, nonatomic) IBOutlet YLDRangeTextField *miaoMuNameTextField;
@property (weak, nonatomic) IBOutlet YLDRangeTextField *miaomuNumTextField;
@property (weak, nonatomic) IBOutlet YLDRangeTextView *shuomingTextView;
@property (weak, nonatomic) IBOutlet UILabel *textNumLab;
@property (weak, nonatomic) IBOutlet UIButton *addMMBtn;
@property (weak, nonatomic) IBOutlet UIView *addMMBGV;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,copy)NSDictionary *dic;
@property (weak, nonatomic) IBOutlet UIButton *shangyibuBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topC;
@end
