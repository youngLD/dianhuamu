//
//  YLDFAddressListViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2017/12/12.
//  Copyright © 2017年 中亿科技. All rights reserved.
//
#import "ZIKArrowViewController.h"
#import "YLDFAddressModel.h"
@protocol YLDFAddressListViewControllerDelegate
-(void)selectWithYLDFAddressModel:(YLDFAddressModel *)model;
-(void)deleteWithYLDFAddressModel:(YLDFAddressModel *)model;
@end
@interface YLDFAddressListViewController : ZIKArrowViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) id <YLDFAddressListViewControllerDelegate> delegate;
@end
