//
//  MyEngineeringOrderDetialViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/10.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "ZIKRightBtnSringViewController.h"

@interface MyEngineeringOrderDetialViewController : ZIKRightBtnSringViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,copy)NSString *orderId;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topC;
@end
