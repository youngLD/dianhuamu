//
//  YLDFEOrderDetialViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/12.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZIKRightBtnSringViewController.h"
@interface YLDFEOrderDetialViewController : ZIKRightBtnSringViewController
@property (weak, nonatomic) IBOutlet UITableView *talbeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topC;
@property (nonatomic,copy)NSString *orderId;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
