//
//  YLDFBuyListViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/2.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "ZIKRightBtnSringViewController.h"

@interface YLDFBuyListViewController : ZIKRightBtnSringViewController
@property (weak, nonatomic) IBOutlet UIButton *yishangjiBtn;
@property (weak, nonatomic) IBOutlet UIButton *yixiajiaBtn;
@property (weak, nonatomic) IBOutlet UIImageView *moveView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewB;
@property (weak, nonatomic) IBOutlet UIButton *qiugouFabuBtn;

@end
