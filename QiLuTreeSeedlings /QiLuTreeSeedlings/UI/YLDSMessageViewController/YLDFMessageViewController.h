//
//  YLDFMessageViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/5.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "ZIKRightBtnSringViewController.h"

@interface YLDFMessageViewController : ZIKRightBtnSringViewController

@property (weak, nonatomic) IBOutlet UIButton *buyMessageBtn;
@property (weak, nonatomic) IBOutlet UIButton *talkMessageBtn;
@property (weak, nonatomic) IBOutlet UIButton *systemBtn;
@property (weak, nonatomic) IBOutlet UITableView *talbeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topC;
@property (weak, nonatomic) IBOutlet UIView *moveView;

@end
