//
//  YLDFEOrderQuoteListViewController.h
//  QiLuTreeSeedlings
//
//  Created by 杨乐栋 on 2018/1/10.
//  Copyright © 2018年 中亿科技. All rights reserved.
//

#import "ZIKRightBtnSringViewController.h"
#import "YLDFMyOrderItemsModel.h"
@interface YLDFEOrderQuoteListViewController : ZIKRightBtnSringViewController
@property (weak, nonatomic) IBOutlet UILabel *mmNameLab;
@property (weak, nonatomic) IBOutlet UILabel *personNumLab;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topC;
@property (nonatomic,copy) NSString *orderStr;
@property (nonatomic,copy) NSString *quotesType;
@property (nonatomic,strong) YLDFMyOrderItemsModel *model;
@end
