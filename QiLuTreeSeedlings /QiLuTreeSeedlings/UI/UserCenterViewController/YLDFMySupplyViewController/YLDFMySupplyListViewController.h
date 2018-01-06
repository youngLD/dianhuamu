//
//  YLDFMySupplyListViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/12/27.
//  Copyright © 2017年 中亿科技. All rights reserved.
//

#import "ZIKRightBtnSringViewController.h"

@interface YLDFMySupplyListViewController : ZIKRightBtnSringViewController
@property (weak, nonatomic) IBOutlet UIButton *yishangjiaBtn;
@property (weak, nonatomic) IBOutlet UIButton *yixiajiaBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topC;
@property (weak, nonatomic) IBOutlet UIImageView *moveView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewB;
@property (weak, nonatomic) IBOutlet UIButton *supplyFabuBtn;

@end
